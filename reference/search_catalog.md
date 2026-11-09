# Search Catalogs

Performs a comprehensive search in the specified catalog's API endpoint,
utilizing a full range of available searching, filtering, and sorting
parameters.

## Usage

``` r
search_catalog(
  catalog,
  keyword = NULL,
  from = NULL,
  to = NULL,
  country = NULL,
  inc_iso = NULL,
  collection = NULL,
  created = NULL,
  dtype = NULL,
  sort_by = NULL,
  sort_order = NULL,
  ps = NULL,
  page = NULL,
  rows = TRUE
)
```

## Arguments

- catalog:

  A required character string specifying the name of the data catalog
  (e.g., `"fao"`, `"wb"`). Valid codes are listed by
  [`catalogs()`](https://guturago.github.io/nadaverse/reference/catalogs.md).

- keyword:

  A character string used to search data titles, descriptions, and
  keywords (e.g., `"lsms"`).

- from:

  An integer indicating the **start year** for the data collection's
  coverage period (e.g., `2000`).

- to:

  An integer indicating the **end year** for the data collection's
  coverage period (e.g., `2010`).

- country:

  A character vector. Provide one or more **country names** or **ISO 3
  codes** (case-insensitive). For valid codes, see
  [`country_codes()`](https://guturago.github.io/nadaverse/reference/catalogs.md).
  Multiple values should be passed as a vector, e.g.,
  `c("afg", "Indonesia", "bra")`.

- inc_iso:

  A logical value. If `TRUE`, the results data frame will include the
  ISO3 country codes; otherwise, it will contain only country names.
  **Default:** `NULL`.

- collection:

  A character vector. Filters results by the data collection repository
  ID, which is returned in the `repo_id` column by
  [`collections()`](https://guturago.github.io/nadaverse/reference/catalogs.md).
  Multiple IDs can be searched by passing a vector.

- created:

  A character string used to filter results by the **date of creation**
  or update within the catalog. Use the date format `YYYY/MM/DD`.

  - Single date: `"2020/04/01"` (returns records created on or after
    this date).

  - Date range: `"2020/04/01-2020/04/20"` (returns records within the
    range).

- dtype:

  A character vector. Filters results by one or more data access types.
  Valid values include: `"open"`, `"direct"`, `"public"`, `"licensed"`,
  `"enclave"`, `"remote"`, and `"other"`. See
  [`access_codes()`](https://guturago.github.io/nadaverse/reference/catalogs.md)
  for a list of available types by catalog. Example:
  `c("open", "licensed")`.

- sort_by:

  A character string used to specify the column by which to sort the
  results. Valid values are: `"rank"`, `"title"`, `"nation"` (for
  country), or `"year"`. Note that "country" is automatically mapped to
  the API field "nation".

- sort_order:

  A character string indicating the sort direction. Must be either
  `"asc"` (ascending) or `"desc"` (descending).

- ps:

  An integer indicating the number of records to display **per page** of
  results. **Default:** `15` records.

- page:

  An integer specifying the **page number** of the search results to
  return.

- rows:

  A logical value. If `TRUE`, the function returns only a data frame of
  the matching studies. If `FALSE`, it returns the full result list,
  which adds search information (such as `found`, `total`, `limit` and
  `offset`) to the `rows` data frame. **Default:** `TRUE`.

## Value

If `rows = TRUE` (default), a **data frame** where each row is a study
matching the search criteria. If `rows = FALSE`, a **list** with the
number of studies found (`found`), the catalog total (`total`), the page
size and offset (`limit`, `offset`), and the `rows` data frame. If
nothing matches, a warning is issued and `NULL` is returned. Network
failures, HTTP errors and non-JSON replies raise an error.

## Details

This function constructs a complex API query based on the provided
arguments (such as keywords, temporal range, geography, and access
types) and returns the matching data entries. The function automatically
handles URL encoding and JSON parsing.

All parameters correspond directly to the search options available on
the NADA (National Data Archive) platform used by organizations like the
World Bank and FAO.

## See also

[`access_codes`](https://guturago.github.io/nadaverse/reference/catalogs.md),
[`collections`](https://guturago.github.io/nadaverse/reference/catalogs.md),
[`country_codes`](https://guturago.github.io/nadaverse/reference/catalogs.md),
[`latest_entries`](https://guturago.github.io/nadaverse/reference/catalogs.md)

## Author

Gutama Girja Urago

## Examples

``` r
if (FALSE) { # interactive()
# Example 1: Basic search for a keyword in the World Bank catalog
wb_search <- search_catalog(
  catalog = "wb",
  keyword = "LSMS",
  ps = 5, # 5 records per page
  page = 1
)
head(wb_search)

# Example 2: Search by country and year range
fao_search <- search_catalog(
  catalog = "fao",
  country = c("Kenya", "UGA"),
  from = 2010,
  to = 2020,
  sort_by = "year",
  sort_order = "desc"
)

# Example 3: Filter by access type and get search information
wb_info <- search_catalog(
  catalog = "wb",
  keyword = "labor",
  dtype = "public",
  rows = FALSE
)
print(wb_info$found) # Check total number of records found

# Example 4: Include ISO codes in results
ihsn_results <- search_catalog(
  catalog = "ihsn",
  inc_iso = TRUE
)
head(ihsn_results)
}
```
