# Blend colours and palettes using lighten mode

Lightens colours by selecting the lighter of two colour values for each
RGB channel. Useful for creating highlights or combining light elements.

## Usage

``` r
lighten(...)
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
lighten("#FFA600FF", "#8991A1FF")
#> [1] "#FFA6A1FF"
```
