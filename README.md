
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nadaverse

<!-- badges: start -->

<!-- badges: end -->

Welcome to `nadaverse`, the essential R package for researchers, policy
analysts, and data enthusiasts seeking streamlined, programmatic access
to vast collections of global microdata.

Many national and international organizations—including the World Bank,
FAO, and ILO—use the National Data Archive (NADA) software to manage and
disseminate their survey and census data. While these catalogs are rich
sources of information, interacting with them often requires tedious
manual browsing or complex API construction.

`nadaverse` cuts through that complexity. It provides a unified,
reliable, and user-friendly interface to search, filter, and retrieve
crucial metadata and documentation (such as file lists and data
dictionaries) directly into your R environment.

- **Motivation:** Stop clicking, start coding. Unlock the world’s
  microdata resources faster than ever before.

## Installation

You can install the development version of nadaverse like so:

``` r
# devtools::install_github("guturago/nadaverse")
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
#library(nadaverse)
# x <- search_catalog("unhcr", "FIES", ps = 10000) |> 
#   dplyr::filter(grepl("Food Insecurity Experience Scale", title, TRUE)) |> 
#   dplyr::select(nation, year_start) |> 
#   dplyr::arrange(nation, year_start)
# 
# y <- mutate(x,
#             value = "Yes") |> 
#   pivot_wider(id_cols = nation, 
#               names_from = year_start, 
#               values_from = value,
#               values_fill = "-") |> 
#   gt::gt()
# y
```
