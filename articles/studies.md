# Working with studies

After a search, four functions let you look closely at a study before
you download anything.
[`metadata()`](https://guturago.github.io/nadaverse/reference/catalogs.md)
gives the description,
[`data_files()`](https://guturago.github.io/nadaverse/reference/data_files.md)
lists the data files, and
[`data_dictionary()`](https://guturago.github.io/nadaverse/reference/data_files.md)
lists the variables. This guide uses World Bank studies, and the output
comes from saved responses.

``` r

library(nadaverse)
```

## Two ways to name a study

A study can be given as the number in the `id` column of a search or as
the text in the `idno` column. Both work in every function that takes a
study.

``` r

md_num <- metadata("wb", 8098)
md_txt <- metadata("wb", "ALB_2012_LSMS_v01_M_v01_A_PUF")
md_num$study_desc$title_statement$title
#> [1] "Regional Mixed Movements Monitoring 2025"
md_txt$study_desc$title_statement$title
#> [1] "Living Standards Measurement Survey 2012"
```

These are two different studies, one named by number and one by text.
For a single study, both forms return the same result.

## What the metadata contains

[`metadata()`](https://guturago.github.io/nadaverse/reference/catalogs.md)
returns a nested list. The top level separates the description of the
documentation from the description of the study.

``` r

names(md_txt)
#> [1] "doc_desc"   "study_desc" "schematype" "tags"
names(md_txt$study_desc)
#> [1] "title_statement"        "authoring_entity"       "production_statement"  
#> [4] "distribution_statement" "series_statement"       "version_statement"     
#> [7] "study_info"             "method"                 "data_access"
```

Inside `study_desc`, `study_info` holds the scope and coverage of the
study, `method` describes the design and data collection, and
`data_access` gives the terms of use. You can follow the list down with
`$`, or use [`str()`](https://rdrr.io/r/utils/str.html) to look at one
part:

``` r

str(md_txt$study_desc$title_statement)
#> List of 3
#>  $ idno     : chr "ALB_2012_LSMS_v01_M_v01_A_PUF"
#>  $ title    : chr "Living Standards Measurement Survey 2012"
#>  $ alt_title: chr "LSMS 2012"
```

``` r

names(md_txt$study_desc$study_info)
#> [1] "abstract"      "coll_dates"    "nation"        "geog_coverage"
#> [5] "analysis_unit" "data_kind"     "notes"
```

## Data files

[`data_files()`](https://guturago.github.io/nadaverse/reference/data_files.md)
has one row per file in the study. This section uses the Ethiopia
Socioeconomic Survey from 2015.

``` r

study <- "ETH_2015_ESS_v03_M"
files <- data_files("wb", study)
nrow(files)
#> [1] 73
```

Some columns of the table can hold lists, which print in an awkward way.
If that happens, [`unlist()`](https://rdrr.io/r/base/unlist.html) each
column you need:

``` r

files_tidy <- data.frame(
  file_id = unlist(files$file_id),
  file_name = unlist(files$file_name),
  vars = as.numeric(unlist(files$var_count))
)
head(files_tidy, 5)
#>   file_id        file_name vars
#> 1      F2    Food_CF_Wave3   13
#> 2      F3 sect_cover_hh_w3  119
#> 3      F4      sect1_hh_w3   66
#> 4      F5      sect2_hh_w3   38
#> 5      F6      sect3_hh_w3   70
```

## Data dictionaries

Without a `file_id`,
[`data_dictionary()`](https://guturago.github.io/nadaverse/reference/data_files.md)
returns the variables of the whole study.

``` r

dict <- data_dictionary("wb", study)
nrow(dict)
#> [1] 100
head(dict[, c("vid", "name", "labl")], 5)
#>   vid          name                                labl
#> 1 V26  household_id              Unique HH ID in wave 1
#> 2 V27 household_id2              Unique HH ID in wave 2
#> 3 V28         rural            EA rural urban indicator
#> 4 V29         pw_w3        Final adjusted wave 3 weight
#> 5 V30         ea_id Unique Enumeration Area Indentifier
```

Large studies can have thousands of variables, so it often pays to ask
for one file at a time. Here the smallest file is chosen by its number
of variables:

``` r

smallest <- files_tidy$file_id[which.min(files_tidy$vars)]
dict_file <- data_dictionary("wb", study, file_id = smallest)
nrow(dict_file)
#> [1] 7
```

## Finding variables

A dictionary is an ordinary data frame, so you can search it with base
R. This finds variables whose label mentions households:

``` r

hits <- dict[grepl("household", dict$labl, ignore.case = TRUE), ]
head(hits[, c("vid", "name", "labl")], 5)
#>    vid     name                labl
#> 14 V39    saq08        Household ID
#> 15 V40 hh_saq09      Household Size
#> 16 V41 hh_saq11 Household Head Name
```

Dictionaries can be large and slow to download. Fetch one once, keep it
in an object, and use [`saveRDS()`](https://rdrr.io/r/base/readRDS.html)
if you want to reuse it in a later session.
