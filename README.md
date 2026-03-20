
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
library(blends)
library(jumble)
scales::show_col(c(teal, orange, multiply(teal, orange)), ncol = 3)
```

<img src="man/figures/README-setup-1.png" alt="" width="100%" />

<img src="man/figures/README-unnamed-chunk-3-1.png" alt="" width="100%" />
<img src="man/figures/README-unnamed-chunk-4-1.png" alt="" width="100%" />

## Other packages

This package is part of a group of related packages built to extend
[ggplot2](https://ggplot2.tidyverse.org).

<table>

<tr>

<td align="center" valign="top">

<a href="https://davidhodge931.github.io/ggblanket">
<img src="https://raw.githubusercontent.com/davidhodge931/ggblanket/main/man/figures/logo.svg" width="120" alt="ggblanket"/>
</a>
</td>

<td align="center" valign="top">

<a href="https://davidhodge931.github.io/ggrefine">
<img src="https://raw.githubusercontent.com/davidhodge931/ggrefine/main/man/figures/logo.svg" width="120" alt="ggrefine"/>
</a>
</td>

<td align="center" valign="top">

<a href="https://davidhodge931.github.io/ggscribe">
<img src="https://raw.githubusercontent.com/davidhodge931/ggscribe/main/man/figures/logo.svg" width="120" alt="ggscribe"/>
</a>
</td>

</tr>

<tr>

<td align="center" valign="top">

<a href="https://davidhodge931.github.io/ggwidth">
<img src="https://raw.githubusercontent.com/davidhodge931/ggwidth/main/man/figures/logo.svg" width="120" alt="ggwidth"/>
</a>
</td>

<td align="center" valign="top">

<a href="https://davidhodge931.github.io/blends">
<img src="https://raw.githubusercontent.com/davidhodge931/blends/main/man/figures/logo.svg" width="120" alt="blends"/>
</a>
</td>

<td align="center" valign="top">

<a href="https://davidhodge931.github.io/jumble">
<img src="https://raw.githubusercontent.com/davidhodge931/jumble/main/man/figures/logo.svg" width="120" alt="jumble"/>
</a>
</td>

</tr>

</table>
