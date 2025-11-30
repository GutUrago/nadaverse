# -------------------------------------------------------------------
# Helper: detect numeric ID
# -------------------------------------------------------------------
is_digits <- function(x) {
  x <- trimws(x)
  grepl("^\\d+$", x)
}

# -------------------------------------------------------------------
# Helper: Assert digits
# -------------------------------------------------------------------
assert_digits <- function(x, dig = NULL, varname = "x") {
  x <- trimws(x)
  if (!is_digits(x)) {
    cli::cli_abort("{.var {varname}} must contain only digits, not '{class(x)}'")
  }
  if (!is.null(dig) && (nchar(x) != dig)) {
    cli::cli_abort("{.var {varname}} must contain exactly {.field {dig}} digit{?s}.")
  }
  invisible(TRUE)
}

# -------------------------------------------------------------------
# Helper: Assert strings
# -------------------------------------------------------------------
assert_strings <- function(x, len = NULL, nchar = NULL, varname = "x") {
  if (!is.character(x)) {
    cli::cli_abort("{.var {varname}} must be 'character', not '{class(x)}'")
  }
  if (!is.null(len) && (length(x) != len)) {
    cli::cli_abort("{.var {varname}} must be a vector of length {.field {len}}.")
  }
  if (!is.null(nchar) && (nchar(x) != nchar)) {
    cli::cli_abort("{.var {varname}} must be a string of {.field {nchar}} character{?s}.")
  }
  invisible(TRUE)
}

# -------------------------------------------------------------------
# Helper: Assert logical
# -------------------------------------------------------------------
assert_logical <- function(x, varname = "x") {
  if (!is.logical(x)) {
    cli::cli_abort("{.var {varname}} must be 'logical', not '{class(x)}.")
  }
  invisible(TRUE)
}

# -------------------------------------------------------------------
# Helper: safely convert list of records to data frame
# -------------------------------------------------------------------
list_to_df <- function(x) {
  if (is.null(x) || length(x) == 0) return(NULL)
  if (is.data.frame(x)) return(x)
  if (is.list(x)) {
    x <- lapply(x, function(item) as.data.frame(t(item), stringsAsFactors = FALSE))
    x <- do.call(rbind, x)
    return(x)
  }
  NULL
}

# -------------------------------------------------------------------
# Internal helper to reduce repetition
# -------------------------------------------------------------------
fetch_field <- function(catalog, path, field, ...) {
  base <- base_url(catalog)
  resp <- get_response(base, path = path, ...)
  resp <- resp[[field]]
  if (length(resp) == 0L) cli::cli_warn("{.field {catalog}} returned 0 {field}.")
  resp
}


# -------------------------------------------------------------------
# Helper: replace setNames
# -------------------------------------------------------------------
set_names <- function(object = nm, nm) {
  names(object) <- nm
  object
}
