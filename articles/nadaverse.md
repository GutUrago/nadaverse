# Getting started with nadaverse

Many statistical agencies and international organizations publish survey
and census microdata through catalogs built with the NADA software. All
of these catalogs share the same web API, so one package can search them
all. nadaverse wraps that API in a few functions that return data frames
and lists.

This guide follows one example from start to finish. You will find a
study in the World Bank catalog, read its description, and look at its
files and variables. Then you will run the same search on a second
catalog.

The output shown here comes from saved responses, so the guide builds
without an internet connection. When you run the code yourself, the
functions call the live catalogs.

``` r

library(nadaverse)
```

## Choose a catalog

Every function takes a catalog code as its first argument.
[`catalogs()`](https://guturago.github.io/nadaverse/reference/catalogs.md)
lists the codes and prints a short summary. Use `show = FALSE` to get
the table without the printout.

``` r

cats <- catalogs(show = FALSE)
cats[, c("catalog", "name")]
#>        catalog                                                 name
#> df          df                                           Data First
#> erf        erf                              Economic Research Forum
#> fao        fao                    Food and Agriculture Organization
#> ihsn      ihsn               International Household Survey Network
#> kenya    kenya                  Kenya National Bureau of Statistics
#> unhcr    unhcr        United Nations High Commissioner for Refugees
#> wb          wb                                       The World Bank
#> who        who World Health Organization Health Information Systems
#> zambia  zambia                             Zambia Statistics Agency
```

Codes are not case sensitive, so `"wb"` and `"WB"` mean the same
catalog. This guide uses `"wb"` for the World Bank and `"fao"` for the
Food and Agriculture Organization.

## Search for studies

[`search_catalog()`](https://guturago.github.io/nadaverse/reference/search_catalog.md)
returns one row per study. The `ps` argument sets how many studies come
back on a page.

``` r

res <- search_catalog(
  "wb",
  keyword = "Ethiopia Socioeconomic Survey",
  ps = 5
)
head(res[, c("idno", "nation", "year_start")], 5)
#>                              idno   nation year_start
#> 1 ETH_2020_HFPS_v01_M_v01_A_COVID Ethiopia       2018
#> 2      ETH_2022_COVID19-Vax_v01_M Ethiopia       2022
#> 3              ETH_2013_ESS_v03_M Ethiopia       2013
#> 4        ETH_2020-2024_HFPS_v15_M Ethiopia       2020
#> 5              ETH_2018_ESS_v04_M Ethiopia       2018
```

Two columns identify a study. `id` is a number and `idno` is a text ID.
Every function that takes a study accepts either one. The table also has
columns such as `title`, which this guide leaves out to keep the output
narrow.

If nothing matches,
[`search_catalog()`](https://guturago.github.io/nadaverse/reference/search_catalog.md)
gives a warning and returns `NULL` instead of an empty table.

## Read a study description

[`metadata()`](https://guturago.github.io/nadaverse/reference/catalogs.md)
returns the full description of one study as a nested list.

``` r

study <- "ETH_2015_ESS_v03_M"
md <- metadata("wb", study)
names(md)
#> [1] "doc_desc"   "study_desc" "schematype" "tags"
```

The `doc_desc` part describes the documentation itself, such as who
prepared it and when. The `study_desc` part describes the study:

``` r

names(md$study_desc)
#> [1] "title_statement"        "authoring_entity"       "production_statement"  
#> [4] "distribution_statement" "series_statement"       "version_statement"     
#> [7] "study_info"             "method"                 "data_access"
```

You can follow the list down to a single item with `$`, for example
`md$study_desc$title_statement`.

## List the data files

A study is usually split into several data files.
[`data_files()`](https://guturago.github.io/nadaverse/reference/data_files.md)
shows them.

``` r

files <- data_files("wb", study)
head(files[, c("file_id", "file_name", "case_count")], 5)
#>    file_id        file_name case_count
#> F2      F2    Food_CF_Wave3       1269
#> F3      F3 sect_cover_hh_w3       4954
#> F4      F4      sect1_hh_w3      27990
#> F5      F5      sect2_hh_w3      23393
#> F6      F6      sect3_hh_w3      23393
```

`case_count` is the number of rows in a file. The table has more
columns, such as `var_count` (the number of variables) and
`description`; the guide shows only a few so the rows stay short. The
`file_id` column is what you pass to
[`data_dictionary()`](https://guturago.github.io/nadaverse/reference/data_files.md)
to look at one file.

## Look up the variables

[`data_dictionary()`](https://guturago.github.io/nadaverse/reference/data_files.md)
lists the variables, with a name and a label for each.

``` r

dict <- data_dictionary("wb", study)
head(dict[, c("vid", "name", "labl")], 5)
#>   vid          name                                labl
#> 1 V26  household_id              Unique HH ID in wave 1
#> 2 V27 household_id2              Unique HH ID in wave 2
#> 3 V28         rural            EA rural urban indicator
#> 4 V29         pw_w3        Final adjusted wave 3 weight
#> 5 V30         ea_id Unique Enumeration Area Indentifier
```

To see only one file, pass its ID:

``` r

data_dictionary("wb", study, file_id = files$file_id[[1]])
```

Large studies have thousands of variables, so it often pays to start
with one file.

## Try another catalog

The functions work the same way on every catalog. Only the catalog code
changes.

``` r

fao <- search_catalog("fao", keyword = "food insecurity", ps = 5)
head(fao[, c("idno", "nation", "year_start")], 5)
#>                                     idno      nation year_start
#> 1    AFG_2024_DIEM_HS_R8_v01_M_v01_A_ESS Afghanistan       2024
#> 2          AFG_2024_RIMA_v01_M_v01_A_ESS Afghanistan       2024
#> 3    AFG_2023_DIEM_HS_R7_v01_M_v01_A_ESS Afghanistan       2023
#> 4 AFG_2023_DIEM_HS_R6_v01_EN_M_v01_A_ESS Afghanistan       2023
#> 5       AFG_2023_FIES_v01_EN_M_v01_A_ESS Afghanistan       2023
```

Column names come from each catalog’s API, so a column that exists in
one catalog can be missing in another. Check
[`names()`](https://rdrr.io/r/base/names.html) before you rely on a
column in code that runs across catalogs.

## Where to go next

- [`vignette("searching", package = "nadaverse")`](https://guturago.github.io/nadaverse/articles/searching.md)
  covers every
  [`search_catalog()`](https://guturago.github.io/nadaverse/reference/search_catalog.md)
  argument, with examples.
- [`vignette("studies", package = "nadaverse")`](https://guturago.github.io/nadaverse/articles/studies.md)
  goes deeper into metadata, files and dictionaries.
- [`vignette("catalogs", package = "nadaverse")`](https://guturago.github.io/nadaverse/articles/catalogs.md)
  explains how the catalogs differ, what to do when one fails, and the
  user agent setting.
