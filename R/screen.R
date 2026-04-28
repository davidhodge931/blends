#' Blend colours and palettes using screen mode
#'
#' @description
#' Lightens colours by inverting, multiplying, then inverting again. Creates
#' brighter results. Useful for creating highlights, lightening backgrounds, or
#' adding luminosity.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' screen("#2C2C2C", "#808080")
#' screen("#4A4A4A")
screen <- function(...) {
  args <- .parse_blend_dots(list(...))
  col  <- args$col
  col2 <- args$col2

  blend_fn <- function(c1, c2) c1 + c2 - c1 * c2

  if (is.function(col) || is.function(col2)) {
    function(x) .composite(.resolve_pal(col, x), .resolve_pal(col2, x), blend_fn)
  } else {
    .composite(col, col2, blend_fn)
  }
}
