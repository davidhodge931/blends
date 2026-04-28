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
overlay <- function(...) {
  args <- .parse_blend_dots(list(...))
  col  <- args$col
  col2 <- args$col2

  blend_fn <- function(c1, c2) {
    ifelse(c2 <= 0.5,
           2 * c1 * c2,
           1 - 2 * (1 - c1) * (1 - c2))
  }

  if (is.function(col) || is.function(col2)) {
    function(x) .composite(.resolve_pal(col, x), .resolve_pal(col2, x), blend_fn)
  } else {
    .composite(col, col2, blend_fn)
  }
}
