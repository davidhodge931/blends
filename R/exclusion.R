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
exclusion <- function(...) {
  args <- .parse_blend_dots(list(...))
  col  <- args$col
  col2 <- args$col2

  blend_fn <- function(c1, c2) c1 + c2 - 2 * c1 * c2

  if (is.function(col) || is.function(col2)) {
    function(x) .composite(.resolve_pal(col, x), .resolve_pal(col2, x), blend_fn)
  } else {
    .composite(col, col2, blend_fn)
  }
}
