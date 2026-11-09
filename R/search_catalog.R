


#' Search Catalogs
#'
#' @description
#' Performs a comprehensive search in the specified catalog's API
#' endpoint, utilizing a full range of available searching, filtering, and sorting parameters.
#'
#' @details
#' This function constructs a complex API query based on the provided arguments (such
#' as keywords, temporal range, geography, and access types) and returns the matching
#' data entries. The function automatically handles URL encoding and JSON parsing.
#'
#' All parameters correspond directly to the search options available on the NADA
#' (National Data Archive) platform used by organizations like the World Bank and FAO.
#'
#' @param catalog A required character string specifying the name of the data
#'   catalog (e.g., \code{"fao"}, \code{"wb"}). Valid codes are listed by
#'   \code{catalogs()}.
#' @param keyword A character string used to search data titles, descriptions,
#'   and keywords (e.g., \code{"lsms"}).
#' @param from An integer indicating the **start year** for the data collection's
#'   coverage period (e.g., \code{2000}).
#' @param to An integer indicating the **end year** for the data collection's
#'   coverage period (e.g., \code{2010}).
#' @param country A character vector. Provide one or more **country names** or
#'   **ISO 3 codes** (case-insensitive). For valid codes, see \code{country_codes()}.
#'   Multiple values should be passed as a vector, e.g., \code{c("afg", "Indonesia", "bra")}.
#' @param inc_iso A logical value. If \code{TRUE}, the results data frame will
#'   include the ISO3 country codes; otherwise, it will contain only country names.
#'   **Default:** \code{NULL}.
#' @param collection A character vector. Filters results by the data collection
#'   repository ID, which is returned in the \code{repo_id} column by \code{collections()}.
#'   Multiple IDs can be searched by passing a vector.
#' @param created A character string used to filter results by the **date of creation**
#'   or update within the catalog. Use the date format \code{YYYY/MM/DD}.
#'   \itemize{
#'     \item Single date: \code{"2020/04/01"} (returns records created on or after this date).
#'     \item Date range: \code{"2020/04/01-2020/04/20"} (returns records within the range).
#'   }
#' @param dtype A character vector. Filters results by one or more data access types.
#'   Valid values include: \code{"open"}, \code{"direct"}, \code{"public"},
#'   \code{"licensed"}, \code{"enclave"}, \code{"remote"}, and \code{"other"}.
#'   See \code{access_codes()} for a list of available types by catalog.
#'   Example: \code{c("open", "licensed")}.
#' @param sort_by A character string used to specify the column by which to sort the
#'   results. Valid values are: \code{"rank"}, \code{"title"}, \code{"nation"} (for country),
#'   or \code{"year"}. Note that "country" is automatically mapped to the API field "nation".
#' @param sort_order A character string indicating the sort direction.
#'   Must be either \code{"asc"} (ascending) or \code{"desc"} (descending).
#' @param ps An integer indicating the number of records to display **per page**
#'   of results. **Default:** \code{15} records.
#' @param page An integer specifying the **page number** of the search results to return.
#' @param rows A logical value. If \code{TRUE}, the function returns only a
#'   data frame of the matching studies. If \code{FALSE}, it returns the full
#'   result list, which adds search information (such as \code{found},
#'   \code{total}, \code{limit} and \code{offset}) to the \code{rows} data
#'   frame. **Default:** \code{TRUE}.
#'
#' @return
#' If \code{rows = TRUE} (default), a **data frame** where each row is a study
#' matching the search criteria. If \code{rows = FALSE}, a **list** with the
#' number of studies found (\code{found}), the catalog total (\code{total}),
#' the page size and offset (\code{limit}, \code{offset}), and the
#' \code{rows} data frame. If nothing matches, a warning is issued and
#' \code{NULL} is returned. Network failures, HTTP errors and non-JSON
#' replies raise an error.
#'
#' @export
#'
#' @author Gutama Girja Urago
#'
#' @seealso
#' \code{\link{access_codes}}, \code{\link{collections}},
#' \code{\link{country_codes}}, \code{\link{latest_entries}}
#'
#' @examplesIf interactive()
#' # Example 1: Basic search for a keyword in the World Bank catalog
#' wb_search <- search_catalog(
#'   catalog = "wb",
#'   keyword = "LSMS",
#'   ps = 5, # 5 records per page
#'   page = 1
#' )
#' head(wb_search)
#'
#' # Example 2: Search by country and year range
#' fao_search <- search_catalog(
#'   catalog = "fao",
#'   country = c("Kenya", "UGA"),
#'   from = 2010,
#'   to = 2020,
#'   sort_by = "year",
#'   sort_order = "desc"
#' )
#'
#' # Example 3: Filter by access type and get search information
#' wb_info <- search_catalog(
#'   catalog = "wb",
#'   keyword = "labor",
#'   dtype = "public",
#'   rows = FALSE
#' )
#' print(wb_info$found) # Check total number of records found
#'
#' # Example 4: Include ISO codes in results
#' ihsn_results <- search_catalog(
#'   catalog = "ihsn",
#'   inc_iso = TRUE
#' )
#' head(ihsn_results)
search_catalog <- function(catalog,
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
                           rows = TRUE) {

  # --- Base request setup ---
  base_url <- base_url(catalog)
  req <- nada_request(base_url, "search")

  # --- Pre-process parameters ---
  if (!is.null(sort_by) && tolower(sort_by) == "country") sort_by <- "nation"
  assert_logical(rows, "rows")
  params <- mget(c("keyword", "from", "to", "country", "inc_iso", "collection",
                   "created", "dtype", "sort_by", "sort_order", "ps", "page"),
                 envir = environment(), ifnotfound = list(NULL))

  # --- Validators for each argument ---
  validators <- list(
    from = function(x) assert_digits(x, 4, "from"),
    to = function(x) assert_digits(x, 4, "to"),
    ps = function(x) assert_digits(x, NULL, "ps"),
    page = function(x) assert_digits(x, NULL, "page"),
    keyword = function(x) assert_strings(x, 1, NULL, "keyword"),
    created = function(x) assert_strings(x, 1, NULL, "created"),
    sort_by = function(x) assert_strings(x, 1, NULL, "sort_by"),
    sort_order = function(x) assert_strings(x, 1, NULL, "sort_order"),
    inc_iso = function(x) assert_logical(x, "inc_iso"),
    country = function(x) assert_strings(x, NULL, NULL, "country"),
    collection = function(x) assert_strings(x, NULL, NULL, "collection"),
    dtype = function(x) assert_strings(x, NULL, NULL, "dtype")
  )

  # --- Build query parameters ---
  for (arg_name in names(params)) {
    val <- params[[arg_name]]
    if (!is.null(val)) {
      if (!is.null(validators[[arg_name]])) validators[[arg_name]](val)
      query_name <- if (arg_name == "keyword") "sk" else arg_name
      multi <- if (arg_name == "country") "pipe" else "comma"
      param <- set_names(list(val), query_name)
      req <- httr2::req_url_query(req, !!!param, .multi = multi)
    }
  }

  # --- Perform request ---
  req <- httr2::req_url_query(req, format = "json")
  resp <- nada_perform(req)
  resp <- httr2::resp_body_json(resp, simplifyVector = TRUE, flatten = TRUE)
  resp <- resp$result
  if (resp$found == 0L) {
    cli::cli_warn("No results found.")
    return(NULL)
  }
  if (rows) return(resp$rows)
  resp
}
