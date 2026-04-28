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
colour_burn <- function(...) {
  args <- .parse_blend_dots(list(...))
  col  <- args$col
  col2 <- args$col2

  blend_fn <- function(c1, c2) {
    ifelse(c1 == 0, 0, 1 - pmin(1, (1 - c2) / c1))
  }

  if (is.function(col) || is.function(col2)) {
    function(x) .composite(.resolve_pal(col, x), .resolve_pal(col2, x), blend_fn)
  } else {
    .composite(col, col2, blend_fn)
  }
}
