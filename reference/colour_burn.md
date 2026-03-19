# Blend colours and palettes using colour burn mode

Darkens the destination colour to reflect the source by increasing
contrast. Produces deep, saturated results.

## Usage

``` r
colour_burn(...)
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
colour_burn("#FFA600FF", "#8991A1FF")
#> [1] "#895600FF"
```
