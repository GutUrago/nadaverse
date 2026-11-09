# Searching catalogs

[`search_catalog()`](https://guturago.github.io/nadaverse/reference/search_catalog.md)
is the main way to find studies. This guide goes through its arguments
one at a time. The examples use the World Bank catalog unless a section
says otherwise, and the output comes from saved responses.

``` r

library(nadaverse)
```

Every search returns one row per study. To keep the output short, this
guide prints only a few columns of the first five rows with a small
helper:

``` r

brief <- function(x) head(x[, c("idno", "nation", "year_start")], 5)
```

## Keywords

`keyword` searches titles, descriptions and keywords. `ps` is the number
of studies returned per page.

``` r

res <- search_catalog("wb", keyword = "poverty", ps = 5)
brief(res)
#>                        idno     nation year_start
#> 1   ARM_2010-2015_MPI_v01_M    Armenia       2010
#> 2 IDN_2008_SUSETI-BPS_v01_M  Indonesia       2008
#> 3       BGD_2016_PGSS_v01_M Bangladesh       2016
#> 4 JOR_2017-2018_HV-V8_v01_M     Jordan       2017
#> 5    JOR_2018_HV-V8V2_v01_M     Jordan       2018
```

## Years

`from` and `to` take four-digit years and select studies by the period
their data cover.

``` r

res <- search_catalog("wb", from = 2015, to = 2020, ps = 5)
brief(res)
#>                              idno                           nation year_start
#> 1  IND_2015_DHS_v01_M_v02_A_IPUMS                            India       2015
#> 2 USA_2015_PHC_v01_M_v7.6_A_IPUMS         United States of America       2011
#> 3 LAO_2015_PHC_v01_M_v7.6_A_IPUMS Lao People's Democratic Republic       2015
#> 4 SLE_2015_PHC_v01_M_v7.6_A_IPUMS                     Sierra Leone       2015
#> 5 PRI_2015_PHC_v01_M_v7.6_A_IPUMS                      Puerto Rico       2011
```

## Countries

`country` takes country names or ISO3 codes, and you can give several at
once.
[`country_codes()`](https://guturago.github.io/nadaverse/reference/catalogs.md)
lists the valid values for a catalog.

``` r

res <- search_catalog("wb", country = c("ETH", "UGA"), ps = 5)
brief(res)
#>                              idno                                      nation
#> 1 ETH_1984_PHC_v01_M_v7.6_A_IPUMS                                    Ethiopia
#> 2 UGA_1991_PHC_v01_M_v7.6_A_IPUMS                                      Uganda
#> 3 UGA_2002_PHC_v01_M_v7.6_A_IPUMS                                      Uganda
#> 4             WLD_2007_TWRI_v01_M Argentina, Australia, Austria...and 71 more
#> 5             ETH_1993_AAIS_v01_M                                    Ethiopia
#>   year_start
#> 1       1984
#> 2       1991
#> 3       2002
#> 4       1955
#> 5       1993
```

## Collections and access types

Many catalogs group their studies into collections.
[`collections()`](https://guturago.github.io/nadaverse/reference/catalogs.md)
lists them, and the `repositoryid` column is the value that `collection`
expects.

``` r

cl <- collections("wb")
head(cl[, c("repositoryid", "title")], 5)
#>         repositoryid                                             title
#> 1      afrobarometer                                     Afrobarometer
#> 2          datafirst DataFirst , University of Cape Town, South Africa
#> 3               dime              Development Impact Evaluation (DIME)
#> 4       microdata_rg                    Development Research Microdata
#> 5 enterprise_surveys                                Enterprise Surveys
```

``` r

res <- search_catalog("wb", collection = "LSMS", ps = 5)
brief(res)
#>                              idno   nation year_start
#> 1 ETH_2020_HFPS_v01_M_v01_A_COVID Ethiopia       2018
#> 2 NGA_2020_NLPS_v01_M_v02_A_COVID  Nigeria       2018
#> 3             NGA_2020_NLPS_v12_M  Nigeria       2020
#> 4             MLI_2020_HFPS_v05_M     Mali       2020
#> 5      ETH_2022_COVID19-Vax_v01_M Ethiopia       2022
```

Studies also differ in how you can get the data.
[`access_codes()`](https://guturago.github.io/nadaverse/reference/catalogs.md)
lists the access types, and `dtype` filters by them.

``` r

access <- access_codes("wb")
head(access[, c("type", "title")], 5)
#>           type                                   title
#> 1       direct                           Direct access
#> 2       public                        Public use files
#> 3     licensed                     Licensed data files
#> 4 data_enclave    Data accessible only in data enclave
#> 5       remote Data available from external repository
```

``` r

res <- search_catalog("wb", dtype = access$type[1], ps = 5)
brief(res)
#>                        idno                                      nation
#> 1       WLD_2007_TWRI_v01_M Argentina, Australia, Austria...and 71 more
#> 2       IDN_2008_ARLS_v01_M                                   Indonesia
#> 3 NER_2018-2022_ASPPS_v01_M                                       Niger
#> 4 NER_2017-2020_ASPIE_v01_M                                       Niger
#> 5 ZAF_2015-2018_SAGIE_v01_M                                South Africa
#>   year_start
#> 1       1955
#> 2       2008
#> 3       2018
#> 4       2017
#> 5       2012
```

## Sorting and pages

`sort_by` accepts `"rank"`, `"title"`, `"nation"` and `"year"`. The word
`"country"` also works and is treated as `"nation"`. `sort_order` is
`"asc"` or `"desc"`, and `page` moves through the results.

``` r

res <- search_catalog(
  "wb",
  country = "ETH",
  sort_by = "year",
  sort_order = "desc",
  ps = 5
)
brief(res)
#>                       idno                                       nation
#> 1      ETH_2025_WBES_v01_M                                     Ethiopia
#> 2        WLD_2024_WC_v01_M Afghanistan, Albania, Algeria...and 190 more
#> 3    WLD_2024_FINDEX_v02_M   Albania, Algeria, Argentina...and 137 more
#> 4       ETH_2024_DHS_v01_M                                     Ethiopia
#> 5 ETH_2024_LRRPIE-BL_v01_M                                     Ethiopia
#>   year_start
#> 1       2025
#> 2       2024
#> 3       2024
#> 4       2024
#> 5       2024
```

``` r

res2 <- search_catalog(
  "wb",
  country = "ETH",
  sort_by = "year",
  sort_order = "desc",
  ps = 5,
  page = 2
)
brief(res2)
#>                    idno                                       nation year_start
#> 1    ETH_2024_LIS_v01_M                                     Ethiopia       2024
#> 2   ETH_2024_SENS_v01_M                                     Ethiopia       2024
#> 3 ETH_2024_FINDEX_v02_M                                     Ethiopia       2024
#> 4   ETH_2025_WBCS_v01_M                                     Ethiopia       2024
#> 5   WLD_2023_WCML_v01_M Afghanistan, Albania, Algeria...and 190 more       2023
```

The `created` argument filters by the date a study was added to the
catalog. Give one date, or a range, in `YYYY/MM/DD` form:

``` r

search_catalog("wb", created = "2023/01/01-2023/12/31")
```

## Search information

By default you get only the table of studies. With `rows = FALSE` you
get the full result list, which also says how many studies matched.

``` r

info <- search_catalog("wb", keyword = "poverty", ps = 5, rows = FALSE)
info$found
#> [1] 1412
info$total
#> [1] 7151
names(info)
#> [1] "rows"                  "found"                 "total"                
#> [4] "limit"                 "offset"                "search_counts_by_type"
#> [7] "page"
```

`found` is the number of studies that match your search and `total` is
the number of studies in the whole catalog. The table of studies is
still there as `info$rows`.

`inc_iso = TRUE` adds country codes to the results:

``` r

res <- search_catalog("wb", country = "ETH", inc_iso = TRUE, ps = 5)
names(res)
#>  [1] "id"               "idno"             "doi"              "type"            
#>  [5] "title"            "nation"           "authoring_entity" "form_model"      
#>  [9] "data_class_id"    "year_start"       "year_end"         "repositoryid"    
#> [13] "repo_title"       "created"          "changed"          "total_views"     
#> [17] "total_downloads"  "varcount"         "thumbnail"        "ts_dimensions"   
#> [21] "ts_frequency"     "ts_data_count"    "ts_db_study_id"   "ts_db_title"     
#> [25] "abstract"         "url"              "iso3"
```

## When nothing matches

A search with no matches gives a warning and returns `NULL`, not an
empty table. Check for it before you use the result.

``` r

none <- suppressWarnings(search_catalog("fao", keyword = "novalidsk"))
is.null(none)
#> [1] TRUE
```

## Comparing catalogs

The same arguments work on every catalog, so a short loop can compare
them. Here `ps = 1` keeps each download small, because only the count is
needed.

``` r

codes <- c("wb", "fao", "ihsn")
found <- vapply(
  codes,
  function(code) {
    info <- suppressWarnings(
      search_catalog(code, keyword = "household", ps = 1, rows = FALSE)
    )
    if (is.null(info)) 0 else as.numeric(info$found)
  },
  numeric(1)
)
found
#>   wb  fao ihsn 
#> 5436 1626 9719
```

Once you have a study,
[`vignette("studies", package = "nadaverse")`](https://guturago.github.io/nadaverse/articles/studies.md)
shows how to read its description, files and variables.
