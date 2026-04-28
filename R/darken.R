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
darken <- function(...) {
  args <- .parse_blend_dots(list(...))
  col  <- args$col
  col2 <- args$col2

  blend_fn <- function(c1, c2) pmin(c1, c2)

  if (is.function(col) || is.function(col2)) {
    function(x) .composite(.resolve_pal(col, x), .resolve_pal(col2, x), blend_fn)
  } else {
    .composite(col, col2, blend_fn)
  }
}
