# Blend colours and palettes using difference mode

Subtracts the darker colour from the lighter. Identical colours produce
black; white inverts the other colour.

## Usage

``` r
difference(...)
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
difference("#FFA600FF", "#8991A1FF")
#> [1] "#7615A1FF"
```
