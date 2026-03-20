# blends

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

![](reference/figures/README-setup-1.png)

![](reference/figures/README-unnamed-chunk-3-1.png)![](reference/figures/README-unnamed-chunk-4-1.png)

## Other packages

This package is part of a group of related packages built to extend
[ggplot2](https://ggplot2.tidyverse.org).

|                                                                                                                                                 |                                                                                                                                              |                                                                                                                                              |
|:-----------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------:|
| [![ggblanket](https://raw.githubusercontent.com/davidhodge931/ggblanket/main/man/figures/logo.svg)](https://davidhodge931.github.io/ggblanket/) | [![ggrefine](https://raw.githubusercontent.com/davidhodge931/ggrefine/main/man/figures/logo.svg)](https://davidhodge931.github.io/ggrefine/) | [![ggscribe](https://raw.githubusercontent.com/davidhodge931/ggscribe/main/man/figures/logo.svg)](https://davidhodge931.github.io/ggscribe/) |
|    [![ggwidth](https://raw.githubusercontent.com/davidhodge931/ggwidth/main/man/figures/logo.svg)](https://davidhodge931.github.io/ggwidth/)    |    [![blends](https://raw.githubusercontent.com/davidhodge931/blends/main/man/figures/logo.svg)](https://davidhodge931.github.io/blends/)    |    [![jumble](https://raw.githubusercontent.com/davidhodge931/jumble/main/man/figures/logo.svg)](https://davidhodge931.github.io/jumble/)    |
