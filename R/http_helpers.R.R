
# -------------------------------------------------------------------
# CATALOG DEFINITIONS (single source of truth)
# -------------------------------------------------------------------
#' @noRd
catalog_list <- list(
  df = list(
    name = "Data First",
    home = "https://www.datafirst.uct.ac.za",
    api  = "https://www.datafirst.uct.ac.za/dataportal/index.php/api/catalog"
  ),
  erf = list(
    name = "Economic Research Forum",
    home = "https://erfdataportal.com",
    api  = "https://erfdataportal.com/index.php/api/catalog"
  ),
  fao = list(
    name = "Food and Agriculture Organization",
    home = "https://microdata.fao.org",
    api  = "https://microdata.fao.org/index.php/api/catalog"
  ),
  ihsn = list(
    name = "International Household Survey Network",
    home = "https://catalog.ihsn.org",
    api  = "https://datacatalog.ihsn.org/index.php/api/catalog"
  ),
  ilo = list(
    name = "International Labour Organization",
    home = "https://www.ilo.org/surveyLib",
    api = "https://webapps.ilo.org/surveyLib/index.php/api/catalog"
    #api  = "https://www.ilo.org/surveyLib/index.php/api/catalog" #-> old
  ),
  india = list(
    name = "Government of India",
    home = "https://microdata.gov.in",
    api  = "https://microdata.gov.in/NADA/index.php/api/catalog"
  ),
  unhcr = list(
    name = "United Nations High Commissioner for Refugees",
    home = "https://microdata.unhcr.org",
    api  = "https://microdata.unhcr.org/index.php/api/catalog"
  ),
  wb = list(
    name = "The World Bank",
    home = "https://microdata.worldbank.org",
    api  = "https://microdata.worldbank.org/index.php/api/catalog"
  )
)

# -------------------------------------------------------------------
# ASSERT CATALOG
# -------------------------------------------------------------------
#' @noRd
assert_catalog <- function(catalog) {
  if (!is.character(catalog) && length(catalog) != 1) {
    cli::cli_abort(c(
      "{.var catalog} must be a single character string.",
      "i" = "You provided: class {.cls {class(catalog)}}, length {length(catalog)}"
    ))
  }
  catalog <- tolower(catalog)
  catalog <- trimws(catalog)
  supported <- names(catalog_list)
  if (!catalog %in% supported) {
    cli::cli_h1("Invalid catalog")
    cli::cli_alert_danger("{.var {catalog}} is not supported!")
    catalogs()
    cli::cli_abort("Invalid catalog supplied: {.var {catalog}}")
  }
  catalog
}


# -------------------------------------------------------------------
# BASE URL
# -------------------------------------------------------------------
#' @noRd
base_url <- function(catalog) {
  catalog <- assert_catalog(catalog)
  catalog_list[[catalog]]$api
}


# -------------------------------------------------------------------
# GET API RESPONSE
# -------------------------------------------------------------------
#' @noRd
get_response <- function(base_url, path = NULL, ...) {

  req <- httr2::request(base_url)

  if (!is.null(path)) {
    req <- httr2::req_url_path_append(req, path)
  }

  if (...length() > 0) {
    req <- httr2::req_url_query(req, ...)
  }

  # UNHCR blocks custom user agent such as "R nadaverse package" X-API-KEY`
  browser_agent <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36"
  req <- httr2::req_headers(
    req,
    `User-Agent` = browser_agent,
    Accept = "application/json")
  req <- httr2::req_retry(req, max_tries = 3)
  resp <- httr2::req_perform(req)
  httr2::resp_body_json(resp, simplifyVector = TRUE, flatten = TRUE)
}
