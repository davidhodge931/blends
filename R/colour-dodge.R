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
colour_dodge <- function(...) {
  args <- .parse_blend_dots(list(...))
  col  <- args$col
  col2 <- args$col2

  blend_fn <- function(c1, c2) {
    ifelse(c1 >= 1, 1, pmin(1, c2 / (1 - c1)))
  }

  if (is.function(col) || is.function(col2)) {
    function(x) .composite(.resolve_pal(col, x), .resolve_pal(col2, x), blend_fn)
  } else {
    .composite(col, col2, blend_fn)
  }
}
