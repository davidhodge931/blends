#' Blend discrete fill and colour scales
#'
#' @description
#' Creates matching discrete `fill` and `colour` scales, where one aesthetic
#' is treated as the "base" palette and the other is derived from it by
#' applying a blend mode. If no `blend` function is supplied, the blend mode
#' is chosen automatically: `screen()` is used when the set theme panel
#' background is dark, and `multiply()` is used otherwise. This function
#' is intended for polygons.
#'
#' @param palette A discrete colour palette function or vector of colours
#'   used for the *base* aesthetic (i.e. whichever of `colour`/`fill` is not
#'   named in `aesthetic`). Defaults to the current theme's
#'   `palette.colour.discrete` or `palette.fill.discrete` (matching the base
#'   aesthetic), falling back to `scales::pal_hue()`.
#' @param blend A function that takes a palette and returns a blended
#'   palette (e.g. `multiply`, `screen`, `overlay`). If `NULL`
#'   (the default), the blend mode is chosen automatically based on
#'   whether the panel background is dark or light (see `blend()`).
#'
#'   The blended palette is always derived from the base palette blended
#'   with itself, so blend modes whose output is identity or constant when
#'   both inputs are equal (namely `darken`, `lighten`, and `difference`)
#'   are not useful here and should be avoided.
#' @param aesthetic Which aesthetic ("colour" or "fill") receives the
#'   blended palette. The other aesthetic receives the base `palette`.
#'   Defaults to `"colour"`, i.e. fill is the base and colour is blended
#'   from it. `"color"` is accepted as an alias for `"colour"`.
#' @param ... Additional arguments passed on to `ggplot2::scale_fill_discrete()`
#'   and `ggplot2::scale_colour_discrete()`.
#'
#' @returns A list of two ggplot2 scales: a fill scale and a colour scale.
#' @export
#'
#' @examples
#' \dontrun{
#' ggplot(mpg, aes(displ, hwy, colour = class, fill = class)) +
#'   geom_point(shape = 21, size = 3) +
#'   scale_blend_discrete()
#'
#' # blend the fill from the colour palette instead
#' ggplot(mpg, aes(displ, hwy, colour = class, fill = class)) +
#'   geom_point(shape = 21, size = 3) +
#'   scale_blend_discrete(aesthetic = "fill")
#'
#' # use a specific blend mode
#' ggplot(mpg, aes(displ, hwy, colour = class, fill = class)) +
#'   geom_point(shape = 21, size = 3) +
#'   scale_blend_discrete(blend = overlay)
#' }
scale_blend_discrete <- function(palette = NULL, blend = NULL, aesthetic = "colour", ...) {
  .scale_blend_impl(
    palette = palette,
    blend = blend,
    aesthetic = aesthetic,
    type = "discrete",
    fill_fn = ggplot2::scale_fill_discrete,
    colour_fn = ggplot2::scale_colour_discrete,
    default_palette = scales::pal_hue(),
    ...
  )
}

#' Blend continuous fill and colour scales
#'
#' @description
#' Creates matching continuous `fill` and `colour` scales, where one
#' aesthetic is treated as the "base" palette and the other is derived from
#' it by applying a blend mode. If no `blend` function is supplied, the
#' blend mode is chosen automatically: `screen()` is used when the
#' set theme panel background is dark, and `multiply()` is used
#' otherwise.
#'
#' @param palette A continuous colour palette function used for the *base*
#'   aesthetic (i.e. whichever of `colour`/`fill` is not named in
#'   `aesthetic`). Defaults to the current theme's
#'   `palette.colour.continuous` or `palette.fill.continuous` (matching the
#'   base aesthetic), falling back to `scales::pal_seq_gradient()`.
#' @param blend A function that takes a palette and returns a blended
#'   palette (e.g. `multiply`, `screen`, `overlay`). If `NULL`
#'   (the default), the blend mode is chosen automatically based on
#'   whether the panel background is dark or light (see `blend()`).
#'
#'   The blended palette is always derived from the base palette blended
#'   with itself, so blend modes whose output is identity or constant when
#'   both inputs are equal (namely `darken`, `lighten`, and `difference`)
#'   are not useful here and should be avoided.
#' @param aesthetic Which aesthetic ("colour" or "fill") receives the
#'   blended palette. The other aesthetic receives the base `palette`.
#'   Defaults to `"colour"`, i.e. fill is the base and colour is blended
#'   from it. `"color"` is accepted as an alias for `"colour"`.
#' @param ... Additional arguments passed on to `ggplot2::scale_fill_continuous()`
#'   and `ggplot2::scale_colour_continuous()`.
#'
#' @returns A list of two ggplot2 scales: a fill scale and a colour scale.
#' @export
#'
#' @examples
#' \dontrun{
#' ggplot(faithfuld, aes(waiting, eruptions, colour = density, fill = density)) +
#'   geom_point(shape = 21, size = 3) +
#'   scale_blend_continuous()
#'
#' ggplot(faithfuld, aes(waiting, eruptions, colour = density, fill = density)) +
#'   geom_point(shape = 21, size = 3) +
#'   scale_blend_continuous(blend = overlay)
#' }
scale_blend_continuous <- function(palette = NULL, blend = NULL, aesthetic = "colour", ...) {
list(
  .scale_blend_impl(
    palette = palette,
    blend = blend,
    aesthetic = aesthetic,
    type = "continuous",
    fill_fn = ggplot2::scale_fill_continuous,
    colour_fn = ggplot2::scale_colour_continuous,
    default_palette = scales::pal_seq_gradient(),
    ...
  ),
  ggplot2::guides(colour = ggplot2::guide_none())
)
}

#' Shared implementation for the scale_blend_* family
#'
#' @description
#' Resolves the base palette, computes the blended palette, and builds the
#' fill/colour scale pair. `scale_blend_discrete()` and `scale_blend_continuous()`
#' both delegate to this so the underlying logic lives in exactly one place.
#'
#' @param palette The base palette, or `NULL` to resolve from the theme.
#' @param blend A blend function, or `NULL` to auto-select based on
#'   background darkness.
#' @param aesthetic Which aesthetic ("colour"/"color"/"fill") receives the
#'   blended palette.
#' @param type Scale type suffix used to look up the matching theme
#'   element, e.g. `"discrete"` or `"continuous"`.
#' @param fill_fn The `scale_fill_*()` function to use, e.g.
#'   `ggplot2::scale_fill_discrete`.
#' @param colour_fn The `scale_colour_*()` function to use, e.g.
#'   `ggplot2::scale_colour_discrete`.
#' @param default_palette The fallback palette used when neither `palette`
#'   nor a matching theme element is available.
#' @param ... Additional arguments passed on to `fill_fn` and `colour_fn`.
#'
#' @return A list of two ggplot2 scales: a fill scale and a colour scale.
#'
#' @noRd
.scale_blend_impl <- function(palette, blend, aesthetic, type, fill_fn, colour_fn, default_palette, ...) {
  aesthetic <- .resolve_aesthetic(aesthetic)
  base_aesthetic <- setdiff(c("colour", "fill"), aesthetic)

  base_palette <- .resolve_base_palette(palette, base_aesthetic, type, default_palette)
  blended_palette <- .resolve_blended_palette(base_palette, blend)

  .build_blend_scales(base_palette, blended_palette, aesthetic, fill_fn, colour_fn, ...)
}

#' Validate and normalize an aesthetic argument
#'
#' @description
#' Ensures `aesthetic` is one of `"colour"` or `"fill"`, treating `"color"`
#' as an alias for `"colour"`.
#'
#' @param aesthetic A character scalar: `"colour"`, `"color"`, or `"fill"`.
#'
#' @return Either `"colour"` or `"fill"`.
#'
#' @noRd
.resolve_aesthetic <- function(aesthetic) {
  aesthetic <- match.arg(aesthetic, c("colour", "color", "fill"))
  if (aesthetic == "color") "colour" else aesthetic
}

#' Resolve the base (non-blended) palette for a given aesthetic
#'
#' @description
#' Falls back through an explicit `palette`, the matching theme palette for
#' `base_aesthetic`/`type`, and finally `default_palette`.
#'
#' @param palette A colour palette function or vector of colours, or `NULL`.
#' @param base_aesthetic Either `"colour"` or `"fill"`; used to look up the
#'   matching theme element.
#' @param type Scale type suffix used to look up the matching theme
#'   element, e.g. `"discrete"` or `"continuous"`.
#' @param default_palette The fallback palette used when neither `palette`
#'   nor a matching theme element is available.
#'
#' @return A colour palette function or vector of colours.
#'
#' @noRd
.resolve_base_palette <- function(palette, base_aesthetic, type, default_palette) {
  theme_key <- paste0("palette.", base_aesthetic, ".", type)
  palette %||%
    ggplot2::get_theme()[[theme_key]] %||%
    default_palette
}

#' Resolve the blended palette
#'
#' @description
#' Applies `blend` to `base_palette` if supplied; otherwise delegates to
#' `blend()`, which auto-selects `screen()` or `multiply()` based
#' on whether the current theme's panel background is dark or light.
#'
#' @param base_palette The unblended palette.
#' @param blend A blend function, or `NULL` to auto-select via `blend()`.
#'
#' @return The blended palette.
#'
#' @noRd
.resolve_blended_palette <- function(base_palette, blend) {
  blend_fn <- blend %||% .blend_default
  blend_fn(base_palette)
}

#' Build fill and colour scales from a base and blended palette
#'
#' @description
#' Assigns the base palette to whichever aesthetic is not named in
#' `aesthetic`, and the blended palette to the aesthetic named in
#' `aesthetic`, using the supplied scale constructor functions.
#'
#' @param base_palette The unblended palette.
#' @param blended_palette The blended palette.
#' @param aesthetic Either `"colour"` or `"fill"`; the aesthetic that
#'   receives `blended_palette`.
#' @param fill_fn The `scale_fill_*()` function to use.
#' @param colour_fn The `scale_colour_*()` function to use.
#' @param ... Additional arguments passed on to `fill_fn` and `colour_fn`.
#'
#' @return A list of two ggplot2 scales: a fill scale and a colour scale.
#'
#' @noRd
.build_blend_scales <- function(base_palette, blended_palette, aesthetic, fill_fn, colour_fn, ...) {
  if (aesthetic == "colour") {
    list(
      fill_fn(palette = base_palette, ...),
      colour_fn(palette = blended_palette, ...)
    )
  } else {
    list(
      fill_fn(palette = blended_palette, ...),
      colour_fn(palette = base_palette, ...)
    )
  }
}
