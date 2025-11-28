
#' Get Study Data Files List and Data Dictionary
#'
#' @description
#' Retrieves information about the files included in a study, or the detailed
#' **data dictionary** (variables) for the entire study or a specific data file.
#'
#' @aliases data_dictionary
#'
#' @param catalog A required character string specifying the name of the data
#' catalog (e.g., \code{"wb"}, \code{"fao"}). Valid codes can be found in the
#' documentation for \code{catalogs()}.
#' @param id A required study identifier. Accepts either the numeric **Study ID**
#' (integer, e.g., \code{101}) or the character **Study ID Number** (string,
#' e.g., \code{"ALB_2012_LSMS_v01_M_v01_A_PUF"}). These values are typically
#' returned in the search results from \code{search_catalog()},
#' \code{latest_entries()} or \code{data_files()}.
#' @param file_id An optional character identifier, applicable only to
#'   \code{data_dictionary()}. This is the ID of a specific data file within the study,
#'   typically found in the \code{file_id} column returned by \code{data_files()}.
#'   If \code{NULL} (default), \code{data_dictionary()} attempts to fetch variables
#'   for the entire study.
#'
#' @details
#' \code{data_files()} returns the list of files available for a study, along with metadata
#' like file name, size, and ID.
#'
#' \code{data_dictionary()} retrieves the variable-level metadata, including variable names,
#' labels, and definitions. If \code{file_id} is provided, it retrieves the dictionary
#' for that specific file; otherwise, it attempts to fetch the dictionary for the entire study.
#' The function automatically detects whether the provided study identifier (`id`) is numeric or character.
#'
#' @return
#' The return value depends on the function called:
#' \itemize{
#'   \item \code{data_files()}: A **data frame** detailing the files associated with the study.
#'     Typical columns include \code{file_name}, \code{dfile_id}, \code{file_type}, and \code{file_size}.
#'   \item \code{data_dictionary()}: A **data frame** containing the variable-level
#'     metadata (the data dictionary). Typical columns include \code{name}, \code{label},
#'     and \code{var_id}.
#' }
#' If the API returns no files or variables, a warning message is issued.
#'
#' @export
#'
#' @author Gutama Girja Urago
#'
#' @seealso
#' \code{\link{search_catalog}}, \code{\link{latest_entries}}
#'
#' @examples
#' \dontrun{
#' # Example 1: Get the list of files for a World Bank study (using idno)
#' study_idno <- "ALB_2012_LSMS_v01_M_v01_A_PUF"
#' files_wb <- data_files(catalog = "wb", id = study_idno)
#' print(files_wb)
#'
#' # Example 2: Get the data dictionary for the entire study (using idno)
#' dictionary_all <- data_dictionary(catalog = "wb", id = study_idno)
#' head(dictionary_all)
#'
#' # Example 3: Get the data dictionary for a specific file
#' # First, retrieve the files to find a file_id (dfile_id)
#' file_id_to_use <- files_wb$file_id[1] # Use the ID of the first file
#' dictionary_file <- data_dictionary(
#'   catalog = "wb",
#'   id = study_idno,
#'   file_id = file_id_to_use
#' )
#' head(dictionary_file)
#' }
data_files <- function(catalog, id) {
  base <- base_url(catalog)
  path <- paste0(id, "/data_files")
  resp <- if (is_digits(id)) {
    get_response(base, path = path, id_format = "id")
  } else {
    get_response(base, path = path)
  }
  df <- list_to_df(resp$datafiles)
  if (is.null(df)) {
    cli::cli_warn("No data files were found for this study.")
  }
  df
}


#' @rdname data_files
#' @export
data_dictionary <- function(catalog, id, file_id = NULL) {
  base <- base_url(catalog)
  path <- if (is.null(file_id)) {
    paste0(id, "/variables")
  } else {
    paste0(id, "/data_files/", file_id, "/variables")
  }
  response <- if (is_digits(id)) {
    get_response(base, path = path, id_format = "id")
  } else {
    get_response(base, path = path)
  }
  response$variables
}
