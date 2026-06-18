# Blend colours and palettes using soft light mode

Gently darkens or lightens depending on the first colour, producing a
softer effect than hard light.

## Usage

``` r
soft_light(...)
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
soft_light("#FFA600FF", "#8991A1FF")
#> [1] "#BB9F66FF"
```
