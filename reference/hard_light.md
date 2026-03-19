# Blend colours and palettes using hard light mode

Combines multiply and screen depending on the lightness of the first
colour. Like overlay but the first colour controls whether darkening or
lightening is applied.

## Usage

``` r
hard_light(...)
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
hard_light("#FFA600FF", "#8991A1FF")
#> [1] "#FFB200FF"
```
