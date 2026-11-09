
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
  kenya = list(
    name = "Kenya National Bureau of Statistics",
    home = "https://statistics.knbs.or.ke/nada/index.php",
    api = "https://statistics.knbs.or.ke/nada/index.php/api/catalog"
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
  ),
  who = list(
    name = "World Health Organization Health Information Systems",
    home = "https://apps.who.int/healthinfo/systems/surveydata/index.php/catalog",
    api = "https://apps.who.int/healthinfo/systems/surveydata/index.php/api/catalog"
  ),
  zambia = list(
    name = "Zambia Statistics Agency",
    home = "https://nada.zamstats.gov.zm",
    api = "https://nada.zamstats.gov.zm/index.php/api/catalog"
  )
)

# -------------------------------------------------------------------
# ASSERT CATALOG
# -------------------------------------------------------------------
#' @noRd
assert_catalog <- function(catalog) {
  if (!is.character(catalog) || length(catalog) != 1) {
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
# USER AGENT
# -------------------------------------------------------------------
# UNHCR blocks custom user agents such as "R nadaverse package", so the
# browser string is the default. Users can change it with set_user_agent().
#' @noRd
browser_user_agent <- "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36"

#' @noRd
nada_user_agent <- function() {
  getOption("nadaverse.user_agent", default = browser_user_agent)
}

#' Set the user agent used for NADA requests
#'
#' Sets the \code{User-Agent} header sent with every request to the NADA
#' catalogs for the rest of the R session. By default nadaverse sends a
#' browser user agent, because some catalogs, such as UNHCR, reject
#' requests from other clients. Use this function to send a different
#' agent, for example one that identifies your project. If a catalog
#' starts rejecting requests after you change the agent, call
#' \code{set_user_agent(NULL)} to go back to the default.
#'
#' @param user_agent A single non-empty string to send as the user agent,
#'   or \code{NULL} to restore the default browser user agent.
#'
#' @return Invisibly, the previous setting: \code{NULL} when the default
#'   was in use. Pass it back to \code{set_user_agent()} to restore it.
#' @export
#'
#' @examples
#' # Send a custom user agent for this session
#' old <- set_user_agent("My research project (nadaverse)")
#'
#' # Restore the default browser user agent
#' set_user_agent(NULL)
set_user_agent <- function(user_agent = NULL) {
  if (!is.null(user_agent)) {
    valid <- is.character(user_agent) &&
      length(user_agent) == 1 &&
      !is.na(user_agent) &&
      nzchar(trimws(user_agent))
    if (!valid) {
      cli::cli_abort(c(
        "{.arg user_agent} must be a single non-empty string or {.code NULL}.",
        "i" = "You provided: class {.cls {class(user_agent)}}, length {length(user_agent)}"
      ))
    }
  }
  old <- getOption("nadaverse.user_agent")
  options(nadaverse.user_agent = user_agent)
  invisible(old)
}


# -------------------------------------------------------------------
# BASE REQUEST (shared by every NADA API call)
# -------------------------------------------------------------------
#' @noRd
nada_request <- function(base_url, path = NULL, ...) {
  req <- httr2::request(base_url)
  if (!is.null(path)) {
    req <- httr2::req_url_path_append(req, path)
  }
  if (...length() > 0) {
    req <- httr2::req_url_query(req, ...)
  }
  req <- httr2::req_headers(
    req,
    `User-Agent` = nada_user_agent(),
    Accept = "application/json")
  # 30 seconds per attempt, three attempts in total. Retries also cover
  # connection errors and timeouts, not just HTTP status errors.
  req <- httr2::req_timeout(req, 30)
  httr2::req_retry(req, max_tries = 3, retry_on_failure = TRUE)
}


# -------------------------------------------------------------------
# PERFORM A NADA REQUEST
# -------------------------------------------------------------------
#' @noRd
nada_perform <- function(req) {
  resp <- httr2::req_perform(req)
  type <- httr2::resp_content_type(resp)
  if (!grepl("json", type, fixed = TRUE)) {
    cli::cli_abort(c(
      "The catalog did not return JSON from {.url {httr2::resp_url(resp)}}.",
      "i" = "Got content type {.val {type}} (HTTP {httr2::resp_status(resp)}).",
      "i" = "The catalog may be down or blocking automated requests."
    ))
  }
  resp
}


# -------------------------------------------------------------------
# GET API RESPONSE
# -------------------------------------------------------------------
#' @noRd
get_response <- function(base_url, path = NULL, ...) {
  req <- nada_request(base_url, path, ...)
  resp <- nada_perform(req)
  httr2::resp_body_json(resp, simplifyVector = TRUE, flatten = TRUE)
}
