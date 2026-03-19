# Blend colours and palettes using darken mode

Darkens colours by selecting the darker of two colour values for each
RGB channel. Useful for creating shadows or combining dark elements.

## Usage

``` r
darken(...)
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
darken("#FFA600FF", "#8991A1FF")
#> [1] "#899100FF"
```
