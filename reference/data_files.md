# Get Study Data Files List and Data Dictionary

Retrieves information about the files included in a study, or the
detailed **data dictionary** (variables) for the entire study or a
specific data file.

## Usage

``` r
data_files(catalog, id)

data_dictionary(catalog, id, file_id = NULL)
```

## Arguments

- catalog:

  A required character string specifying the name of the data catalog
  (e.g., `"wb"`, `"fao"`). Valid codes can be found in the documentation
  for
  [`catalogs()`](https://guturago.github.io/nadaverse/reference/catalogs.md).

- id:

  A required study identifier. Accepts either the numeric **Study ID**
  (integer, e.g., `101`) or the character **Study ID Number** (string,
  e.g., `"ALB_2012_LSMS_v01_M_v01_A_PUF"`). These values are typically
  returned by
  [`search_catalog()`](https://guturago.github.io/nadaverse/reference/search_catalog.md)
  and
  [`latest_entries()`](https://guturago.github.io/nadaverse/reference/catalogs.md)
  (columns `id` and `idno`).

- file_id:

  An optional character identifier, applicable only to
  `data_dictionary()`. This is the ID of a specific data file within the
  study, typically found in the `file_id` column returned by
  `data_files()`. If `NULL` (default), `data_dictionary()` attempts to
  fetch variables for the entire study.

## Value

The return value depends on the function called:

- `data_files()`: A **data frame** with one row per data file. Typical
  columns include `file_id`, `file_name`, `description`, `case_count`
  and `var_count`.

- `data_dictionary()`: A **data frame** with one row per variable.
  Typical columns include `vid`, `name` and `labl` (the variable label).

If the study has no files or variables, an empty result is returned
without a warning. Column names come from each catalog's API and can
differ between catalogs.

## Details

`data_files()` returns the list of files available for a study, along
with metadata like file name, size, and ID.

`data_dictionary()` retrieves the variable-level metadata, including
variable names, labels, and definitions. If `file_id` is provided, it
retrieves the dictionary for that specific file; otherwise, it attempts
to fetch the dictionary for the entire study. The function automatically
detects whether the provided study identifier (`id`) is numeric or
character.

## See also

[`search_catalog`](https://guturago.github.io/nadaverse/reference/search_catalog.md),
[`latest_entries`](https://guturago.github.io/nadaverse/reference/catalogs.md)

## Author

Gutama Girja Urago

## Examples

``` r
if (FALSE) { # interactive()
# Example 1: Get the list of files for a World Bank study (using idno)
study_idno <- "ALB_2012_LSMS_v01_M_v01_A_PUF"
files_wb <- data_files(catalog = "wb", id = study_idno)
print(files_wb)

# Example 2: Get the data dictionary for the entire study (using idno)
dictionary_all <- data_dictionary(catalog = "wb", id = study_idno)
head(dictionary_all)

# Example 3: Get the data dictionary for a specific file
# First, retrieve the files to find a file_id
file_id_to_use <- files_wb$file_id[1] # Use the ID of the first file
dictionary_file <- data_dictionary(
  catalog = "wb",
  id = study_idno,
  file_id = file_id_to_use
)
head(dictionary_file)
}
```
