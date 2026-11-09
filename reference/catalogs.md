# Small Helper Functions for Data Catalog Access

A suite of small **helper functions** designed to interact with and
retrieve essential metadata from various international organization data
repositories (catalogs). These functions standardize the process of
obtaining lists of available **data access codes**, **collections**,
**country codes**, and **latest entries** from specified sources.

## Usage

``` r
catalogs(show = TRUE)

access_codes(catalog)

collections(catalog)

country_codes(catalog)

latest_entries(catalog, limit = NULL)

metadata(catalog, id)
```

## Arguments

- show:

  Logical. If `TRUE` (default), prints the supported catalogs to the
  console. The catalog table is returned invisibly either way.

- catalog:

  A required character string specifying the name of the data catalog
  (e.g., `"fao"`, `"wb"`) from which to retrieve metadata.

- limit:

  A positive integer number, applicable only to `latest_entries`,
  indicating the **maximum number of results** (data entries) to return.
  If `NULL` or omitted, a default limit set by the API will be used.

- id:

  A required **study identifier**. Accepts either the numeric **Study
  ID** (integer, e.g., `101`) or the character **Study ID Number**
  (string, e.g., `"ALB_2012_LSMS_v01_M_v01_A_PUF"`). These values are
  typically returned in the search results from
  [`search_catalog()`](https://guturago.github.io/nadaverse/reference/search_catalog.md),
  `latest_entries()` or
  [`data_files()`](https://guturago.github.io/nadaverse/reference/data_files.md).

## Value

- `catalogs`: Invisibly, a data frame with one row per supported catalog
  and the columns `catalog`, `name`, `home` and `api`.

- `access_codes`: A data frame of the data access types, with columns
  such as `id`, `type` and `title`.

- `collections`: A data frame of collections, with columns such as `id`,
  `repositoryid` and `title`.

- `country_codes`: A data frame of country codes, with columns such as
  `countryid`, `name` and `iso`.

- `latest_entries`: A data frame of the most recently added studies,
  with columns such as `id`, `idno`, `title`, `nation`, `created`,
  `changed` and `url`.

- `metadata`: A `list` with the study description. Its main parts are
  `doc_desc` (about the documentation) and `study_desc` (about the study
  itself).

Column names come from each catalog's API, so they can differ slightly
between catalogs. If a catalog returns no records, a warning is issued
and the result is empty. Network failures, HTTP errors and non-JSON
replies raise an error.

## Details

All functions require a valid `catalog` code (see the *Supported
Catalogs* section) and return their results in a standardized format. An
unknown code stops with an error that lists the supported catalogs.

Each request waits up to 30 seconds and is attempted up to three times
before it fails. If a catalog replies with something other than JSON,
for example a block page for automated clients, the function stops with
a clear message. Use
[`set_user_agent`](https://guturago.github.io/nadaverse/reference/set_user_agent.md)
to change the user agent sent with requests.

Catalogs differ in what they publish. For example, `ihsn` has no
collections, so `collections("ihsn")` warns that it returned 0
collections and gives an empty result.

## Supported Catalogs

The `catalog` argument must be one of the following short codes
(case-insensitive) corresponding to the respective microdata repository.
**The list is sorted alphabetically by code.**

- `"df"`: **Data First** (<https://www.datafirst.uct.ac.za>)

- `"erf"`: **Economic Research Forum** (<https://erfdataportal.com>)

- `"fao"`: **Food and Agriculture Organization**
  (<https://microdata.fao.org>)

- `"ihsn"`: **International Household Survey Network**
  (<https://catalog.ihsn.org>)

- `"kenya"`: **Kenya National Bureau of Statistics**
  (<https://statistics.knbs.or.ke/nada/index.php>)

- `"unhcr"`: **United Nations High Commissioner for Refugees**
  (<https://microdata.unhcr.org>)

- `"wb"`: **The World Bank** (<https://microdata.worldbank.org>)

- `"who"`: **World Health Organization Health Information Systems**
  (<https://apps.who.int/healthinfo/systems/surveydata/index.php/catalog>)

- `"zambia"`: **Zambia Statistics Agency**
  (<https://nada.zamstats.gov.zm>)

## See also

The main search function:
[`search_catalog`](https://guturago.github.io/nadaverse/reference/search_catalog.md);
study files and variables:
[`data_files`](https://guturago.github.io/nadaverse/reference/data_files.md);
the user agent setting:
[`set_user_agent`](https://guturago.github.io/nadaverse/reference/set_user_agent.md)

## Author

Gutama Girja Urago

## Examples

``` r
if (FALSE) { # interactive()
# --- Examples for Supported Catalogs ---

# 1. Data First (df): Get available access codes.
df_codes <- access_codes("df")

# 2. Economic Research Forum (erf): Get latest data entries (limited to 5).
erf_latest <- latest_entries("erf", limit = 5)

# 3. Food and Agriculture Organization (fao): Get available collections.
fao_collections <- collections("fao")

# 4. International Household Survey Network (ihsn): Get supported country codes.
ihsn_countries <- country_codes("ihsn")

# 5. Kenya National Bureau of Statistics (kenya): Get available collections.
kenya_collections <- collections("kenya")

# 6. United Nations High Commissioner for Refugees (unhcr): Get available collections.
unhcr_collections <- collections("unhcr")

# 7. The World Bank (wb): Get supported country codes.
wb_countries <- country_codes("wb")

# 8. World Health Organization HIS (who): Get available access codes.
who_codes <- access_codes("who")

# 9. Zambia Statistics Agency (zambia): Get latest entries (limit 10).
zambia_latest <- latest_entries("zambia", limit = 10)

# Example for the metadata function (requires a study ID)
wb_study_metadata <- metadata("wb", id = 8098)
str(wb_study_metadata)
}
```
