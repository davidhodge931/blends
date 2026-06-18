# .parse_blend_dots -------------------------------------------------------------
.parse_blend_dots <- function(dots) {
  if (length(dots) == 0) {
    rlang::abort("At least one colour argument is required.")
  }

  if (rlang::is_installed("ggplot2")) {
    is_layer <- vapply(dots, ggplot2::is_layer, logical(1))
    if (any(is_layer)) {
      rlang::abort("`paletteblend` cannot blend ggplot2 layers.")
    }
  }

  if (length(dots) == 1) {
    col <- dots[[1]]
    col2 <- col
  } else if (length(dots) == 2) {
    col <- dots[[1]]
    col2 <- dots[[2]]
  } else {
    rlang::abort("Blend functions accept at most 2 colour/palette arguments.")
  }

  if (is.null(col) || is.null(col2)) {
    rlang::abort("Colour/palette arguments cannot be `NULL`.")
  }

  list(col = col, col2 = col2)
}

# .composite -------------------------------------------------------------
# Apply Porter-Duff source-over alpha compositing with a separable blend formula.
#
# col1 = source (A), col2 = destination (B)
# aR = aA + aB * (1 - aA)
# xR = [ xA*aA*(1-aB) + xB*aB*(1-aA) + f(xA, xB)*aA*aB ] / aR
#
# Reference: https://www.cairographics.org/operators/
.composite <- function(col1, col2, blend_fn) {
  cols <- tryCatch(
    vctrs::vec_recycle_common(col1 = col1, col2 = col2),
    vctrs_error_incompatible_size = function(e) {
      rlang::abort(
        "Colour inputs must have the same size, or one input must have size 1.",
        parent = e
      )
    }
  )

  col1 <- cols$col1
  col2 <- cols$col2
  len <- vctrs::vec_size(col1)

  rgb1 <- grDevices::col2rgb(col1, alpha = TRUE) / 255
  rgb2 <- grDevices::col2rgb(col2, alpha = TRUE) / 255

  alpha1 <- rgb1[4, ]
  alpha2 <- rgb2[4, ]
  alpha_r <- alpha1 + alpha2 * (1 - alpha1)

  idx <- alpha_r > 0
  rgb_r <- matrix(0, nrow = 3, ncol = len)

  for (i in seq_len(3)) {
    c1 <- rgb1[i, ]
    c2 <- rgb2[i, ]
    f <- blend_fn(c1, c2)

    result <- numeric(len)
    result[idx] <- (
      c1[idx] * alpha1[idx] * (1 - alpha2[idx]) +
        c2[idx] * alpha2[idx] * (1 - alpha1[idx]) +
        f[idx]  * alpha1[idx] * alpha2[idx]
    ) / alpha_r[idx]

    rgb_r[i, ] <- pmax(0, pmin(1, result))
  }

  alpha_r <- pmax(0, pmin(1, alpha_r))
  grDevices::rgb(rgb_r[1, ], rgb_r[2, ], rgb_r[3, ], alpha_r)
}

# .resolve_pal -------------------------------------------------------------
# Resolve a palette function or character vector to colours.
#
# Supported behaviour:
# - If `pal` is a colour vector, recycle it with vctrs semantics to size(x)
# - If `pal(x)` works, use it directly
# - If `pal` is discrete and `x` is a numeric vector, interpolate across a
#   dense sample of the palette
# - If `x` is a single positive integer and `pal(x)` fails, interpret it as
#   "generate n colours" via pal(seq(0, 1, length.out = n))
.resolve_pal <- function(pal, x) {
  if (!is.function(pal)) {
    return(vctrs::vec_recycle(pal, size = vctrs::vec_size(x)))
  }

  tryCatch(
    pal(x),
    error = function(e) {
      if (inherits(pal, "pal_discrete") && is.numeric(x) && length(x) > 1) {
        if (!rlang::is_installed("scales")) {
          rlang::abort(
            "Using a discrete palette with numeric `x` requires the `scales` package.",
            parent = e
          )
        }

        attr_n <- attr(pal, "nlevels")
        n_cols <- if (!is.null(attr_n)) attr_n else 256L
        n_cols <- max(2L, min(as.integer(n_cols), 256L))

        cols <- pal(n_cols)

        rng <- range(x, na.rm = TRUE, finite = TRUE)
        if (!all(is.finite(rng))) {
          rlang::abort(
            "`x` must contain at least one finite numeric value.",
            parent = e
          )
        }

        x01 <- if (rng[1] == rng[2]) {
          rep(0.5, length(x))
        } else {
          (x - rng[1]) / diff(rng)
        }

        return(scales::pal_gradient_n(cols)(x01))
      }

      if (length(x) == 1L &&
          is.numeric(x) &&
          !is.na(x) &&
          x >= 1 &&
          x == as.integer(x)) {
        return(pal(seq(0, 1, length.out = as.integer(x))))
      }

      rlang::abort(
        "Could not resolve palette for the supplied `x`.",
        parent = e
      )
    }
  )
}

# .new_blend -------------------------------------------------------------
.new_blend <- function(blend_fn) {
  force(blend_fn)

  function(...) {
    args <- .parse_blend_dots(list(...))
    col <- args$col
    col2 <- args$col2

    if (is.function(col) || is.function(col2)) {
      function(x) {
        .composite(
          .resolve_pal(col, x),
          .resolve_pal(col2, x),
          blend_fn
        )
      }
    } else {
      .composite(col, col2, blend_fn)
    }
  }
}

# multiply -------------------------------------------------------------
#' Blend colours and palettes using multiply mode
#'
#' @description
#' Darkens colours by multiplying them together. Creates darker, more saturated
#' results. Useful for creating shadows, darkening backgrounds, or adding depth.
#'
#' @param ... Either one or two colour/palette arguments:
#'   - If one argument: the colour or palette is blended with itself
#'   - If two arguments: the first is blended with the second
#'   Each argument can be a character vector of colours or a `scales::pal_*()`
#'   function.
#'
#'   Recycling for direct colour vectors follows `vctrs` semantics: inputs must
#'   either have the same size, or one input must have size 1.
#'
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' multiply("#F0F0F0", "#808080")
#' multiply("#FF6B6B")
multiply <- .new_blend(function(c1, c2) c1 * c2)

# screen -------------------------------------------------------------
#' Blend colours and palettes using screen mode
#'
#' @description
#' Lightens colours by inverting, multiplying, and inverting again. Produces
#' brighter results and is the inverse of multiply.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' screen("#FFA600FF", "#8991A1FF")
screen <- .new_blend(function(c1, c2) {
  1 - (1 - c1) * (1 - c2)
})

# overlay -------------------------------------------------------------
#' Blend colours and palettes using overlay mode
#'
#' @description
#' Combines multiply and screen depending on the lightness of the second colour.
#' Values below 50% grey are multiplied (darkened); values above are screened
#' (lightened).
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' overlay("#FFA600FF", "#8991A1FF")
overlay <- .new_blend(function(c1, c2) {
  ifelse(
    c2 <= 0.5,
    2 * c1 * c2,
    1 - 2 * (1 - c1) * (1 - c2)
  )
})

# hard_light -------------------------------------------------------------
#' Blend colours and palettes using hard light mode
#'
#' @description
#' Combines multiply and screen depending on the lightness of the first colour.
#' Like overlay but the first colour controls whether darkening or lightening
#' is applied.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' hard_light("#FFA600FF", "#8991A1FF")
hard_light <- .new_blend(function(c1, c2) {
  ifelse(
    c1 <= 0.5,
    2 * c1 * c2,
    1 - 2 * (1 - c1) * (1 - c2)
  )
})

# soft_light -------------------------------------------------------------
#' Blend colours and palettes using soft light mode
#'
#' @description
#' Gently darkens or lightens depending on the first colour, producing a softer
#' effect than hard light.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' soft_light("#FFA600FF", "#8991A1FF")
soft_light <- .new_blend(function(c1, c2) {
  d <- ifelse(
    c2 <= 0.25,
    ((16 * c2 - 12) * c2 + 4) * c2,
    sqrt(c2)
  )

  ifelse(
    c1 <= 0.5,
    c2 - (1 - 2 * c1) * c2 * (1 - c2),
    c2 + (2 * c1 - 1) * (d - c2)
  )
})

# colour_burn -------------------------------------------------------------
#' Blend colours and palettes using colour burn mode
#'
#' @description
#' Darkens the destination colour to reflect the source by increasing contrast.
#' Produces deep, saturated results.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' colour_burn("#FFA600FF", "#8991A1FF")
colour_burn <- .new_blend(function(c1, c2) {
  ifelse(c1 == 0, 0, 1 - pmin(1, (1 - c2) / c1))
})

# colour_dodge -------------------------------------------------------------
#' Blend colours and palettes using colour dodge mode
#'
#' @description
#' Brightens the destination colour to reflect the source by decreasing
#' contrast. Produces bright, washed-out results.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' colour_dodge("#FFA600FF", "#8991A1FF")
colour_dodge <- .new_blend(function(c1, c2) {
  ifelse(c1 >= 1, 1, pmin(1, c2 / (1 - c1)))
})

# darken -------------------------------------------------------------
#' Blend colours and palettes using darken mode
#'
#' @description
#' Darkens colours by selecting the darker of two colour values for each RGB
#' channel. Useful for creating shadows or combining dark elements.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' darken("#FFA600FF", "#8991A1FF")
darken <- .new_blend(function(c1, c2) pmin(c1, c2))

# lighten -------------------------------------------------------------
#' Blend colours and palettes using lighten mode
#'
#' @description
#' Lightens colours by selecting the lighter of two colour values for each RGB
#' channel. Useful for creating highlights or combining light elements.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' lighten("#FFA600FF", "#8991A1FF")
lighten <- .new_blend(function(c1, c2) pmax(c1, c2))

# difference -------------------------------------------------------------
#' Blend colours and palettes using difference mode
#'
#' @description
#' Subtracts the darker colour from the lighter. Identical colours produce
#' black; white inverts the other colour.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' difference("#FFA600FF", "#8991A1FF")
difference <- .new_blend(function(c1, c2) abs(c1 - c2))

# exclusion -------------------------------------------------------------
#' Blend colours and palettes using exclusion mode
#'
#' @description
#' Similar to difference but with lower contrast. Identical colours produce
#' grey rather than black.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' exclusion("#FFA600FF", "#8991A1FF")
exclusion <- .new_blend(function(c1, c2) c1 + c2 - 2 * c1 * c2)
