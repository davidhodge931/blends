# Blend colours and palettes using screen mode

Lightens colours by inverting, multiplying, then inverting again.
Creates brighter results. Useful for creating highlights, lightening
backgrounds, or adding luminosity.

## Usage

``` r
screen(...)
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
screen("#2C2C2C", "#808080")
#> [1] "#969696FF"
screen("#4A4A4A")
#> [1] "#7F7F7FFF"
```
