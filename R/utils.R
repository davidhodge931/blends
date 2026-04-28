# Shared internal: parse and validate ... into col, col2
.parse_blend_dots <- function(dots) {
  if (length(dots) > 0 &&
      requireNamespace("ggplot2", quietly = TRUE) &&
      ggplot2::is_layer(dots[[1]])) {
    rlang::abort("paletteblend cannot blend ggplot2 layers")
  }

  if (length(dots) == 0) {
    rlang::abort("At least one colour argument is required")
  } else if (length(dots) == 1) {
    col  <- dots[[1]]
    col2 <- col
  } else if (length(dots) == 2) {
    col  <- dots[[1]]
    col2 <- dots[[2]]
  } else {
    rlang::abort("blend functions accept at most 2 colour/palette arguments")
  }

  if (is.null(col) || is.null(col2)) {
    rlang::abort("colour/palette arguments cannot be NULL")
  }

  list(col = col, col2 = col2)
}

# Shared internal: apply Porter-Duff alpha compositing given a blend formula
#
# col1 = source (A), col2 = destination (B)
# aR = aA + aB·(1−aA)
# xR = [ (1−aB)·xaA + (1−aA)·xaB + aA·aB·f(xA,xB) ] / aR
#
# Reference: https://www.cairographics.org/operators/
.composite <- function(col1, col2, blend_fn) {
  len  <- max(length(col1), length(col2))
  col1 <- rep_len(col1, len)
  col2 <- rep_len(col2, len)

  rgb1 <- grDevices::col2rgb(col1, alpha = TRUE) / 255
  rgb2 <- grDevices::col2rgb(col2, alpha = TRUE) / 255

  alpha1  <- rgb1[4, ]
  alpha2  <- rgb2[4, ]
  alpha_r <- alpha1 + alpha2 * (1 - alpha1)

  idx <- alpha_r > 0

  rgb_r <- matrix(0, nrow = 3, ncol = len)
  for (i in 1:3) {
    c1 <- rgb1[i, ]
    c2 <- rgb2[i, ]
    f  <- blend_fn(c1, c2)

    result <- numeric(len)
    result[idx] <- (
      c1[idx] * alpha1[idx] * (1 - alpha2[idx]) +
        c2[idx] * alpha2[idx] * (1 - alpha1[idx]) +
        f[idx]  * alpha1[idx] * alpha2[idx]
    ) / alpha_r[idx]

    rgb_r[i, ] <- pmax(0, pmin(1, result))
  }

  alpha_r <- pmax(0, pmin(1, alpha_r))
  grDevices::rgb(rgb_r[1, ], rgb_r[2, ], rgb_r[3, ], alpha_r)
}

# Shared internal: resolve a palette function or character vector to colours
.resolve_pal <- function(pal, x) {
  if (!is.function(pal)) return(rep_len(pal, length(x)))
  tryCatch(
    pal(x),
    error = function(e) {
      if (length(x) > 1 && inherits(pal, "pal_discrete")) {
        n_colours <- attr(pal, "nlevels") %||% 256
        colours   <- pal(min(n_colours, 256))
        scales::pal_gradient_n(colours = colours)(x)
      } else if (length(x) == 1 && is.numeric(x)) {
        pal(seq(0, 1, length.out = x))
      } else {
        stop(e)
      }
    }
  )
}
