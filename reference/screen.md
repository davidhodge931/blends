# Blend colours and palettes using screen mode

Lightens colours by inverting, multiplying, and inverting again.
Produces brighter results and is the inverse of multiply.

## Usage

``` r
screen(...)
```

## Arguments

- ...:

  Either one or two colour/palette arguments:

  - If one argument: the colour or palette is blended with itself

  - If two arguments: the first is blended with the second Each argument
    can be a character vector of colours or a `scales::pal_*()`
    function.

  Recycling for direct colour vectors follows `vctrs` semantics: inputs
  must either have the same size, or one input must have size 1.

## Value

Character vector of blended colours or a blending function.

## Examples

``` r
screen("#FFA600FF", "#8991A1FF")
#> [1] "#FFD9A1FF"
```
