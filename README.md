
<!-- README.md is generated from README.Rmd. Please edit that file -->

# nadaverse: Browse Microdata Catalogs Using NADA REST API

<!-- badges: start -->

[![R-CMD-check](https://github.com/GutUrago/nadaverse/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/GutUrago/nadaverse/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/GutUrago/nadaverse/graph/badge.svg)](https://app.codecov.io/gh/GutUrago/nadaverse)
<!-- badges: end -->

`nadaverse` is the essential R package for researchers, policy analysts,
and data enthusiasts seeking streamlined, programmatic access to vast
collections of global microdata.

Many national and international organizations—including the World Bank,
IHSN, FAO, UNHCR, and ILO—use the National Data Archive (NADA) software
to manage and disseminate their survey and census data. While these
catalogs are rich sources of information, interacting with them often
requires tedious manual browsing or complex API construction.

`nadaverse` cuts through that complexity. It provides a unified,
reliable, and user-friendly interface to search, filter, and retrieve
crucial metadata and documentation (such as file lists and data
dictionaries) directly into your R environment.

## Features

- **Search across 8 major NADA catalogs** using a unified interface  
- Retrieve **study metadata**, **file inventories**, and **data
  dictionaries**  
- Filter by year, keywords, country, catalog, and more  
- Built on **httr2**, ensuring fast and reliable API calls  
- Tidy-friendly: outputs are clean data frames ready for immediate use  
- Includes convenient helper functions for codes, catalogs, and recent
  entries

## Installation

Install the **CRAN** release:

``` r
install.packages("nadaverse")
```

Or install the development version from GitHub:

``` r
devtools::install_github("guturago/nadaverse")
```

## Searching

### 1. Catalog Discovery

The `catalogs()` function is the starting point, providing a complete,
current list of the supported NADA repositories, along with their unique
identifiers required for subsequent queries.

``` r
library(nadaverse)
library(tidyverse)
library(knitr)
```

``` r
catalogs()
#> 
#> ── List of Supported Catalogs ──
#> 
#> ℹ name: Link to the catalog
#> • df: Data First (<https://www.datafirst.uct.ac.za>)
#> • erf: Economic Research Forum (<https://erfdataportal.com>)
#> • fao: Food and Agriculture Organization (<https://microdata.fao.org>)
#> • ihsn: International Household Survey Network (<https://catalog.ihsn.org>)
#> • ilo: International Labour Organization (<https://www.ilo.org/surveyLib>)
#> • india: Government of India (<https://microdata.gov.in>)
#> • unhcr: United Nations High Commissioner for Refugees
#> (<https://microdata.unhcr.org>)
#> • wb: The World Bank (<https://microdata.worldbank.org>)
```

### 2. Targeted Metadata Search

The `search_catalog()` function allows for granular control over the
search space. Instead of relying on the catalog’s often limited web
interface, users can programmatically search by catalog ID, keywords,
publication date ranges, and more.

The output is a standardized data frame, simplifying cross-catalog
comparisons. Here, we search the World Bank catalog (wb) for recently
published studies:

``` r
search_catalog(
  catalog = "ihsn",
  from = 2023, 
  to = 2025,
  ps = 5
)
```

### 3. Deep Dive: File and Variable Metadata

Once a specific study is identified via its unique ID (e.g., 3110),
`nadaverse` enables the retrieval of documentation critical for data
preparation.

File Inventory (data_files): This function retrieves the list of data
file assets, their size, and descriptions, allowing users to determine
the exact resources needed for download.

``` r
c <- "wb"
data_files(c, 3110) |> 
  select(where(~ !all(. == "NULL"))) |> 
  kable(format = "pipe")
```

|     | id     | sid  | file_id | file_name     | description              | case_count |
|:----|:-------|:-----|:--------|:--------------|:-------------------------|:-----------|
| B   | 114450 | 3110 | B       | IND2015-B.dat | Birth records            | 1315617    |
| C   | 114451 | 3110 | C       | IND2015-C.dat | Child records            | 259627     |
| H   | 114453 | 3110 | H       | IND2015-H.dat | Household member records | 2869043    |
| M   | 114452 | 3110 | M       | IND2015-M.dat | Man records              | 112122     |
| W   | 114449 | 3110 | W       | IND2015-W.dat | Woman records            | 699686     |

**Data Dictionary** (`data_dictionary`): Access to variable-level
metadata is paramount for data quality checks and ethical use. This
function retrieves the complete data dictionary, including variable
names, labels, and value ranges, enabling preparation work before
downloading large datasets.

``` r
data_dictionary(c, 3110) |>
  head(10) |> 
  select(where(~ !all(. == "NULL"))) |> 
  kable(format = "pipe")
```

| uid | sid | fid | vid | name | labl |
|---:|---:|:---|:---|:---|:---|
| 2609913 | 3110 | W | W_SAMPLE | W_SAMPLE | IPUMS-DHS sample identifier |
| 2609914 | 3110 | W | W_SAMPLESTR | W_SAMPLESTR | IPUMS-DHS sample identifier (string) |
| 2609915 | 3110 | W | W_COUNTRY | W_COUNTRY | Country |
| 2609916 | 3110 | W | W_YEAR | W_YEAR | Year of sample |
| 2609917 | 3110 | W | W_IDHSPID | W_IDHSPID | Unique cross-sample respondent identifier |
| 2609918 | 3110 | W | W_IDHSHID | W_IDHSHID | Unique cross-sample household identifier |
| 2609919 | 3110 | W | W_DHSID | W_DHSID | Key to link DHS clusters to context data (string) |
| 2609920 | 3110 | W | W_IDHSPSU | W_IDHSPSU | Unique sample-case PSU identifier |
| 2609921 | 3110 | W | W_IDHSSTRATA | W_IDHSSTRATA | Unique cross-sample sampling strata |
| 2609922 | 3110 | W | W_CASEID | W_CASEID | Sample-specific respondent identifier |

## Advanced Wrangling and Analysis Preparation

The design goal of nadaverse is to ensure its outputs are immediately
“tidy” and ready for integration into analytical pipelines. This means
the results can be piped directly into `dplyr` verbs for filtering,
reshaping, and analysis preparation, as demonstrated by this example.

This transformation searches the FAO catalog, filters studies by keyword
(“Food Insecurity”), and reshapes the resulting metadata into a concise
matrix showing which countries conducted the survey in which years—a
common preparatory step for cross-country comparative research.

``` r
search_catalog("fao", "Food Insecurity", ps = 10000) |>
  filter(grepl("Food Insecurity Experience Scale", title, TRUE)) |>
  select(nation, year_start) |>
  arrange(nation, year_start) |> 
  mutate(value = "Yes") |>
  pivot_wider(id_cols = nation,
              names_from = year_start,
              values_from = value,
              values_fill = "-") |>
  head(5) |> 
  kable(format = "pipe")
```

| nation              | 2014 | 2015 | 2016 | 2017 | 2018 | 2019 | 2020 | 2021 | 2022 | 2023 | 2024 |
|:--------------------|:-----|:-----|:-----|:-----|:-----|:-----|:-----|:-----|:-----|:-----|:-----|
| Afghanistan         | Yes  | Yes  | Yes  | Yes  | Yes  | Yes  | Yes  | Yes  | Yes  | Yes  | \-   |
| Albania             | Yes  | Yes  | Yes  | Yes  | \-   | Yes  | Yes  | Yes  | Yes  | Yes  | \-   |
| Algeria             | Yes  | \-   | Yes  | Yes  | Yes  | Yes  | Yes  | Yes  | \-   | \-   | \-   |
| Angola              | Yes  | \-   | \-   | \-   | \-   | \-   | \-   | \-   | \-   | \-   | \-   |
| Antigua and Barbuda | \-   | \-   | \-   | \-   | \-   | \-   | \-   | Yes  | \-   | \-   | \-   |

## Helper Functions for Workflow Efficiency

To further streamline the research process, nadaverse includes several
helper functions that provide necessary IDs and codes used as query
parameters in NADA systems.

These utility functions assist in identifying necessary access codes,
collection names, and country codes for specific, authenticated queries.

``` r
access_codes("fao")
collections("wb")
country_codes("wb")
latest_entries("ihsn")
```
