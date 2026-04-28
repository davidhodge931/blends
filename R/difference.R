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
difference <- function(...) {
  args <- .parse_blend_dots(list(...))
  col  <- args$col
  col2 <- args$col2

  blend_fn <- function(c1, c2) abs(c1 - c2)

  if (is.function(col) || is.function(col2)) {
    function(x) .composite(.resolve_pal(col, x), .resolve_pal(col2, x), blend_fn)
  } else {
    .composite(col, col2, blend_fn)
  }
}
