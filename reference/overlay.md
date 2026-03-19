# Blend colours and palettes using overlay mode

Combines multiply and screen depending on the lightness of the second
colour. Values below 50% grey are multiplied (darkened); values above
are screened (lightened).

## Usage

``` r
overlay(...)
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
overlay("#FFA600FF", "#8991A1FF")
#> [1] "#FFB243FF"
```
