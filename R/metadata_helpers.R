

#' Small Helper Functions for Data Catalog Access
#' @name catalogs
#'
#' @description
#' A suite of small **helper functions** designed to interact with and retrieve
#' essential metadata from various international organization data repositories
#' (catalogs). These functions standardize the process of obtaining lists of
#' available **data access codes**, **collections**, **country codes**, and
#' **latest entries** from specified sources.
#'
#' @details
#' All functions require a valid \code{catalog} code (see the
#' \emph{Supported Catalogs} section) and return their results in a
#' standardized format. An unknown code stops with an error that lists the
#' supported catalogs.
#'
#' Each request waits up to 30 seconds and is attempted up to three times
#' before it fails. If a catalog replies with something other than JSON, for
#' example a block page for automated clients, the function stops with a
#' clear message. Use \code{\link{set_user_agent}} to change the user agent
#' sent with requests.
#'
#' Catalogs differ in what they publish. For example, \code{ihsn} has no
#' collections, so \code{collections("ihsn")} warns that it returned 0
#' collections and gives an empty result.
#'
#' @aliases access_codes collections country_codes latest_entries metadata
#'
#' @param catalog A required character string specifying the name of the data
#' catalog (e.g., \code{"fao"}, \code{"wb"}) from which to retrieve metadata.
#' @param id A required **study identifier**. Accepts either the numeric **Study ID**
#' (integer, e.g., \code{101}) or the character **Study ID Number** (string,
#' e.g., \code{"ALB_2012_LSMS_v01_M_v01_A_PUF"}). These values are typically
#' returned in the search results from \code{\link[=search_catalog]{search_catalog()}},
#' \code{\link[=latest_entries]{latest_entries()}} or \code{\link[=data_files]{data_files()}}.
#' @param limit A positive integer number, applicable only to \code{latest_entries},
#' indicating the **maximum number of results** (data entries) to return. If
#' \code{NULL} or omitted, a default limit set by the API will be used.
#' @param show Logical. If \code{TRUE} (default), prints the supported
#' catalogs to the console. The catalog table is returned invisibly either
#' way.
#'
#' @return
#' \itemize{
#' \item \code{catalogs}: Invisibly, a data frame with one row per supported
#' catalog and the columns \code{catalog}, \code{name}, \code{home} and
#' \code{api}.
#' \item \code{access_codes}: A data frame of the data access types, with
#' columns such as \code{id}, \code{type} and \code{title}.
#' \item \code{collections}: A data frame of collections, with columns such as
#' \code{id}, \code{repositoryid} and \code{title}.
#' \item \code{country_codes}: A data frame of country codes, with columns such
#' as \code{countryid}, \code{name} and \code{iso}.
#' \item \code{latest_entries}: A data frame of the most recently added
#' studies, with columns such as \code{id}, \code{idno}, \code{title},
#' \code{nation}, \code{created}, \code{changed} and \code{url}.
#' \item \code{metadata}: A \code{list} with the study description. Its main
#' parts are \code{doc_desc} (about the documentation) and \code{study_desc}
#' (about the study itself).
#' }
#' Column names come from each catalog's API, so they can differ slightly
#' between catalogs. If a catalog returns no records, a warning is issued
#' and the result is empty. Network failures, HTTP errors and non-JSON
#' replies raise an error.
#'
#' @section Supported Catalogs:
#' The \code{catalog} argument must be one of the following short codes (case-insensitive)
#' corresponding to the respective microdata repository. **The list is sorted alphabetically by code.**
#'
#' \itemize{
#' \item \code{"df"}: **Data First** (\href{https://www.datafirst.uct.ac.za}{https://www.datafirst.uct.ac.za})
#' \item \code{"erf"}: **Economic Research Forum** (\href{https://erfdataportal.com}{https://erfdataportal.com})
#' \item \code{"fao"}: **Food and Agriculture Organization** (\href{https://microdata.fao.org}{https://microdata.fao.org})
#' \item \code{"ihsn"}: **International Household Survey Network** (\href{https://catalog.ihsn.org}{https://catalog.ihsn.org})
#' \item \code{"kenya"}: **Kenya National Bureau of Statistics** (\href{https://statistics.knbs.or.ke/nada/index.php}{https://statistics.knbs.or.ke/nada/index.php})
#' \item \code{"unhcr"}: **United Nations High Commissioner for Refugees** (\href{https://microdata.unhcr.org}{https://microdata.unhcr.org})
#' \item \code{"wb"}: **The World Bank** (\href{https://microdata.worldbank.org}{https://microdata.worldbank.org})
#' \item \code{"who"}: **World Health Organization Health Information Systems** (\href{https://apps.who.int/healthinfo/systems/surveydata/index.php/catalog}{https://apps.who.int/healthinfo/systems/surveydata/index.php/catalog})
#' \item \code{"zambia"}: **Zambia Statistics Agency** (\href{https://nada.zamstats.gov.zm}{https://nada.zamstats.gov.zm})
#' }
#'
#' @export
#'
#' @author Gutama Girja Urago
#'
#' @seealso
#' The main search function: \code{\link{search_catalog}}; study files and
#' variables: \code{\link{data_files}}; the user agent setting:
#' \code{\link{set_user_agent}}
#'
#'
#' @examplesIf interactive()
#' # --- Examples for Supported Catalogs ---
#'
#' # 1. Data First (df): Get available access codes.
#' df_codes <- access_codes("df")
#'
#' # 2. Economic Research Forum (erf): Get latest data entries (limited to 5).
#' erf_latest <- latest_entries("erf", limit = 5)
#'
#' # 3. Food and Agriculture Organization (fao): Get available collections.
#' fao_collections <- collections("fao")
#'
#' # 4. International Household Survey Network (ihsn): Get supported country codes.
#' ihsn_countries <- country_codes("ihsn")
#'
#' # 5. Kenya National Bureau of Statistics (kenya): Get available collections.
#' kenya_collections <- collections("kenya")
#'
#' # 6. United Nations High Commissioner for Refugees (unhcr): Get available collections.
#' unhcr_collections <- collections("unhcr")
#'
#' # 7. The World Bank (wb): Get supported country codes.
#' wb_countries <- country_codes("wb")
#'
#' # 8. World Health Organization HIS (who): Get available access codes.
#' who_codes <- access_codes("who")
#'
#' # 9. Zambia Statistics Agency (zambia): Get latest entries (limit 10).
#' zambia_latest <- latest_entries("zambia", limit = 10)
#'
#' # Example for the metadata function (requires a study ID)
#' wb_study_metadata <- metadata("wb", id = 8098)
#' str(wb_study_metadata)
catalogs <- function(show = TRUE) {
  assert_logical(show)
  if (show) {
    cli::cli_h2("List of Supported Catalogs")
    cli::cli_alert_info("{.strong name}: Link to the catalog")
    cli::cli_ul(
      lapply(
        names(catalog_list),
        function(k) {
          sprintf(
            "{.strong %s}: {.href [%s](%s)}",
            k, catalog_list[[k]]$name, catalog_list[[k]]$home
          )
        }
      )
    )
  }
  df <- list_to_df(catalog_list)
  cats <- data.frame(catalog = rownames(df))
  invisible(
    cbind(cats, df)
    )
}

#' @rdname catalogs
#' @export
access_codes <- function(catalog) {
  fetch_field(catalog, "data_access_codes", "codes")
}


#' @rdname catalogs
#' @export
collections <- function(catalog) {
  fetch_field(catalog, "collections", "collections")
}


#' @rdname catalogs
#' @export
country_codes <- function(catalog) {
  fetch_field(catalog, "country_codes", "country_codes")
}


#' @rdname catalogs
#' @export
latest_entries <- function(catalog, limit = NULL) {
  fetch_field(catalog, "latest", "result", limit = limit)
}

#' @rdname catalogs
#' @export
metadata <- function(catalog, id) {
  resp <- if (is_digits(id)) {
    fetch_field(catalog, id, "dataset", id_format = "id")
  } else {
    fetch_field(catalog, id, "dataset")
  }
  resp[["metadata"]]
}


