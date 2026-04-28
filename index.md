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
library(dplyr)
library(jumble)

scales::show_col(c(teal, orange, blends::multiply(teal, orange)), ncol = 3)
```

![](reference/figures/README-setup-1.png)

![](reference/figures/README-unnamed-chunk-3-1.png)![](reference/figures/README-unnamed-chunk-4-1.png)
