#' Blend colours and palettes using soft light mode
#'
#' @description
#' A softer version of hard light. Darkens or lightens depending on the first
#' colour, but with a gentler effect than hard light.
#'
#' @inheritParams multiply
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' soft_light("#FFA600FF", "#8991A1FF")
soft_light <- function(...) {
  args <- .parse_blend_dots(list(...))
  col  <- args$col
  col2 <- args$col2

  D <- function(x) ifelse(x <= 0.25, ((16 * x - 12) * x + 4) * x, sqrt(x))

  blend_fn <- function(c1, c2) {
    ifelse(c1 <= 0.5,
           c2 - (1 - 2 * c1) * c2 * (1 - c2),
           c2 + (2 * c1 - 1) * (D(c2) - c2))
  }

  if (is.function(col) || is.function(col2)) {
    function(x) .composite(.resolve_pal(col, x), .resolve_pal(col2, x), blend_fn)
  } else {
    .composite(col, col2, blend_fn)
  }
}
