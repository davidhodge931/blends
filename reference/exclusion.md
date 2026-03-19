# Blend colours and palettes using exclusion mode

Similar to difference but with lower contrast. Identical colours produce
grey rather than black.

## Usage

``` r
exclusion(...)
```

## Arguments

- ...:

  Either one or two colour/palette arguments:

  - If one argument: the colour or palette is blended with itself

  - If two arguments: the first is blended with the second Each argument
    can be a character vector of colours or a `scales::pal_*()` function

## Value

Character vector of blended colours or a blending function.

## Examples

``` r
exclusion("#FFA600FF", "#8991A1FF")
#> [1] "#767AA1FF"
```
