
<!-- README.md is generated from README.Rmd. Please edit that file -->

# blends <a href="https://davidhodge931.github.io/blends/"><img src="man/figures/logo.png" align="right" height="139" alt="blends website" /></a>

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/blends)](https://CRAN.R-project.org/package=blends)
<!-- badges: end -->

The objective of blends is to blend colour palettes using blend modes,
such as multiply and screen.

## Installation

Install from CRAN, or development version from
[GitHub](https://github.com/).

``` r
install.packages("blends") 
pak::pak("davidhodge931/blends")
```

## Example

``` r
library(dplyr)
library(jumble)

scales::show_col(c(teal, orange, blends::multiply(teal, orange)), ncol = 3)
```

<img src="man/figures/README-setup-1.png" alt="" width="100%" />

<img src="man/figures/README-unnamed-chunk-3-1.png" alt="" width="100%" />
<img src="man/figures/README-unnamed-chunk-4-1.png" alt="" width="100%" />
