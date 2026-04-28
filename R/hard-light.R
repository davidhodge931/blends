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
hard_light <- function(...) {
  args <- .parse_blend_dots(list(...))
  col  <- args$col
  col2 <- args$col2

  blend_fn <- function(c1, c2) {
    ifelse(c1 <= 0.5,
           2 * c1 * c2,
           1 - 2 * (1 - c1) * (1 - c2))
  }

  if (is.function(col) || is.function(col2)) {
    function(x) .composite(.resolve_pal(col, x), .resolve_pal(col2, x), blend_fn)
  } else {
    .composite(col, col2, blend_fn)
  }
}
