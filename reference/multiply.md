# Blend colours and palettes using multiply mode

Darkens colours by multiplying them together. Creates darker, more
saturated results. Useful for creating shadows, darkening backgrounds,
or adding depth.

## Usage

``` r
multiply(...)
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
multiply("#F0F0F0", "#808080")
#> [1] "#787878FF"
multiply("#FF6B6B")
#> [1] "#FF2D2DFF"
```
