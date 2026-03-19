# Blend colours and palettes using colour dodge mode

Brightens the destination colour to reflect the source by decreasing
contrast. Produces bright, washed-out results.

## Usage

``` r
colour_dodge(...)
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
colour_dodge("#FFA600FF", "#8991A1FF")
#> [1] "#FFFFA1FF"
```
