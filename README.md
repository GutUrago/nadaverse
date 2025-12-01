
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

## Installation

You can install the stable version of this package by running:

``` r
install.packages("nadaverse")
```

or development version like so:

``` r
devtools::install_github("guturago/nadaverse")
```

## Searching

``` r
library(nadaverse)
search_catalog("fao")
#>      id   type                                   idno doi
#> 1  2550 survey AFG_2023_DIEM_HS_R6_v01_EN_M_v01_A_ESS  NA
#> 2  2606 survey       AFG_2023_FIES_v01_EN_M_v01_A_ESS  NA
#> 3  2696 survey       AFG_2023_RIMA_v01_EN_M_v01_A_ESS  NA
#> 4  2333 survey AFG_2022_DIEM_HS_R4_v01_EN_M_v01_A_OCS  NA
#> 5  2432 survey AFG_2022_DIEM_HS_R5_v01_EN_M_v01_A_OCS  NA
#> 6  2437 survey       AFG_2022_FIES_v01_EN_M_v01_A_OCS  NA
#> 7  2082 survey AFG_2021_DIEM_HS_R3_v01_EN_M_v01_A_OCS  NA
#> 8  2283 survey       AFG_2021_FIES_v01_EN_M_v01_A_OCS  NA
#> 9  1988 survey       AFG_2020_FIES_v01_EN_M_v01_A_OCS  NA
#> 10 1174 survey       AFG_2019_FIES_v01_EN_M_v01_A_OCS  NA
#> 11  534 survey       AFG_2018_FIES_v01_EN_M_v01_A_OCS  NA
#> 12  532 survey       AFG_2017_FIES_v01_EN_M_v01_A_OCS  NA
#> 13  533 survey       AFG_2016_FIES_v01_EN_M_v01_A_OCS  NA
#> 14  531 survey       AFG_2015_FIES_v01_EN_M_v01_A_OCS  NA
#> 15  535 survey       AFG_2014_FIES_v01_EN_M_v01_A_OCS  NA
#>                                                                                           title
#> 1  Data in Emergencies (DIEM) Monitoring System – Household Survey – Round 6, Afghanistan, 2023
#> 2                                                       Food Insecurity Experience Scale (FIES)
#> 3     Resilience Index Measurement and Analysis (RIMA) Survey in Afghanistan, First Round, 2023
#> 4  Data in Emergencies (DIEM) Monitoring System – Household Survey – Round 4, Afghanistan, 2022
#> 5  Data in Emergencies (DIEM) Monitoring System – Household Survey – Round 5, Afghanistan, 2022
#> 6                                                       Food Insecurity Experience Scale (FIES)
#> 7  Data in Emergencies (DIEM) Monitoring System - Household Survey - Round 3, Afghanistan, 2021
#> 8                                                       Food Insecurity Experience Scale (FIES)
#> 9                                                       Food Insecurity Experience Scale (FIES)
#> 10                                                      Food Insecurity Experience Scale (FIES)
#> 11                                                      Food Insecurity Experience Scale (FIES)
#> 12                                                      Food Insecurity Experience Scale (FIES)
#> 13                                                      Food Insecurity Experience Scale (FIES)
#> 14                                                      Food Insecurity Experience Scale (FIES)
#> 15                                                      Food Insecurity Experience Scale (FIES)
#>    subtitle      nation
#> 1        NA Afghanistan
#> 2        NA Afghanistan
#> 3        NA Afghanistan
#> 4        NA Afghanistan
#> 5        NA Afghanistan
#> 6        NA Afghanistan
#> 7        NA Afghanistan
#> 8        NA Afghanistan
#> 9        NA Afghanistan
#> 10       NA Afghanistan
#> 11       NA Afghanistan
#> 12       NA Afghanistan
#> 13       NA Afghanistan
#> 14       NA Afghanistan
#> 15       NA Afghanistan
#>                                                                                                                                              authoring_entity
#> 1                                      Food and Agriculture Organization of the United Nations, Data in Emergencies Hub, Office of Emergencies and Resilience
#> 2                                                                                                                                     FAO Statistics Division
#> 3                                                                                                     Food and Agriculture Organization of the United Nations
#> 4  Food and Agriculture Organization of the United Nations, Data in Emergencies Hub, Office of Emergencies and Resilience, United Nations, World Food Program
#> 5                                      Food and Agriculture Organization of the United Nations, Data in Emergencies Hub, Office of Emergencies and Resilience
#> 6                                                                                                                                     FAO Statistics Division
#> 7                                      Food and Agriculture Organization of the United Nations, Data in Emergencies Hub, Office of Emergencies and Resilience
#> 8                                                                                                                                     FAO Statistics Division
#> 9                                                                                                                                     FAO Statistics Division
#> 10                                                                                                                                    FAO Statistics Division
#> 11                                                                                                                                    FAO Statistics Division
#> 12                                                                                                                                    FAO Statistics Division
#> 13                                                                                                                                    FAO Statistics Division
#> 14                                                                                                                                    FAO Statistics Division
#> 15                                                                                                                                    FAO Statistics Division
#>    form_model data_class_id year_start year_end thumbnail
#> 1    licensed            NA       2023     2023        NA
#> 2    licensed            NA       2023     2023        NA
#> 3    licensed            NA       2023     2023        NA
#> 4    licensed            NA       2022     2022        NA
#> 5    licensed            NA       2022     2022        NA
#> 6    licensed            NA       2022     2022        NA
#> 7    licensed            NA       2021     2021        NA
#> 8    licensed            NA       2021     2021        NA
#> 9    licensed            NA       2020     2021        NA
#> 10   licensed            NA       2019     2019        NA
#> 11   licensed            NA       2018     2018        NA
#> 12   licensed            NA       2017     2017        NA
#> 13   licensed            NA       2016     2016        NA
#> 14   licensed            NA       2015     2015        NA
#> 15   licensed            NA       2014     2014        NA
#>                      repositoryid link_da
#> 1  Emergencies-Monitoring-Surveys        
#> 2                   Food-Security        
#> 3                   Food-Security        
#> 4  Emergencies-Monitoring-Surveys        
#> 5  Emergencies-Monitoring-Surveys        
#> 6                   Food-Security        
#> 7  Emergencies-Monitoring-Surveys    <NA>
#> 8                   Food-Security    <NA>
#> 9                   Food-Security    <NA>
#> 10                  Food-Security    <NA>
#> 11                  Food-Security    <NA>
#> 12                  Food-Security    <NA>
#> 13                  Food-Security    <NA>
#> 14                  Food-Security    <NA>
#> 15                  Food-Security    <NA>
#>                                repo_title                   created
#> 1  Data in Emergencies Monitoring Surveys 2024-04-09T11:46:19+02:00
#> 2                           Food Security 2024-07-08T10:40:59+02:00
#> 3                           Food Security 2024-12-12T09:24:34+01:00
#> 4  Data in Emergencies Monitoring Surveys 2022-10-28T09:23:26+02:00
#> 5  Data in Emergencies Monitoring Surveys 2023-06-22T12:58:22+02:00
#> 6                           Food Security 2023-07-05T12:11:33+02:00
#> 7  Data in Emergencies Monitoring Surveys 2022-03-18T14:00:51+01:00
#> 8                           Food Security 2022-07-05T16:13:29+02:00
#> 9                           Food Security 2021-07-12T12:40:58+02:00
#> 10                          Food Security 2020-06-30T18:35:24+02:00
#> 11                          Food Security 2019-07-03T11:18:55+02:00
#> 12                          Food Security 2019-07-03T11:18:54+02:00
#> 13                          Food Security 2019-07-03T11:18:55+02:00
#> 14                          Food Security 2019-07-03T11:18:54+02:00
#> 15                          Food Security 2019-07-03T11:18:55+02:00
#>                      changed total_views total_downloads varcount
#> 1  2025-11-17T11:11:37+01:00       14829               0      288
#> 2  2024-07-18T17:27:33+02:00        3697             455       24
#> 3  2025-07-22T09:20:14+02:00       16214             348      329
#> 4  2025-11-17T10:31:31+01:00       29821               0      287
#> 5  2025-11-17T11:09:43+01:00       23747               0      292
#> 6  2023-07-10T12:10:11+02:00        4733             441       24
#> 7  2025-11-17T10:29:21+01:00       20344             136      236
#> 8  2022-07-05T16:30:14+02:00        4399             524       23
#> 9  2021-07-12T13:15:03+02:00        4215             742       22
#> 10 2023-03-29T15:02:14+02:00        5784             312       23
#> 11 2023-03-29T15:02:15+02:00       21727            1540       23
#> 12 2023-03-29T15:02:14+02:00        9782            1194       23
#> 13 2023-03-29T15:02:14+02:00        8214            1086       23
#> 14 2023-03-29T15:02:14+02:00        8199            1178       23
#> 15 2023-03-29T15:02:15+02:00        8076            1147       23
#>                                                 url
#> 1  https://microdata.fao.org/index.php/catalog/2550
#> 2  https://microdata.fao.org/index.php/catalog/2606
#> 3  https://microdata.fao.org/index.php/catalog/2696
#> 4  https://microdata.fao.org/index.php/catalog/2333
#> 5  https://microdata.fao.org/index.php/catalog/2432
#> 6  https://microdata.fao.org/index.php/catalog/2437
#> 7  https://microdata.fao.org/index.php/catalog/2082
#> 8  https://microdata.fao.org/index.php/catalog/2283
#> 9  https://microdata.fao.org/index.php/catalog/1988
#> 10 https://microdata.fao.org/index.php/catalog/1174
#> 11  https://microdata.fao.org/index.php/catalog/534
#> 12  https://microdata.fao.org/index.php/catalog/532
#> 13  https://microdata.fao.org/index.php/catalog/533
#> 14  https://microdata.fao.org/index.php/catalog/531
#> 15  https://microdata.fao.org/index.php/catalog/535
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
