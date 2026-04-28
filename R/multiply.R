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
#'   function
#' @return Character vector of blended colours or a blending function.
#' @export
#'
#' @examples
#' multiply("#F0F0F0", "#808080")
#' multiply("#FF6B6B")
multiply <- function(...) {
  args <- .parse_blend_dots(list(...))
  col  <- args$col
  col2 <- args$col2

  blend_fn <- function(c1, c2) c1 * c2

  if (is.function(col) || is.function(col2)) {
    function(x) .composite(.resolve_pal(col, x), .resolve_pal(col2, x), blend_fn)
  } else {
    .composite(col, col2, blend_fn)
  }
}
