
set_redactor(function (x) {
  gsub_response(x, "index.php/api/catalog/", "")
})

# ---- Shared catalog list ----

all_catalogs <- c(
  "df", "erf", "fao", "ihsn", "kenya", "unhcr", "wb", "who", "zambia"
)


# ---- Metadata Functions ----

test_that(
  "assert_* functions raise meaningful errors",
  {
    expect_snapshot_error(assert_digits("nondigit"))
    expect_snapshot_error(assert_digits(22, dig = 3, varname = "dig3"))
    expect_snapshot_error(assert_strings(2))
    expect_snapshot_error(assert_strings("str", 2))
    expect_snapshot_error(assert_strings("str", NULL, 2))
    expect_snapshot_error(assert_logical("str"))
    expect_null(list_to_df(NULL))
    expect_null(list_to_df("str"))
    expect_s3_class(list_to_df(data.frame(x = 1)), "data.frame")
  }
)



test_that(
  "catalogs() contain a list of all supported catalogs",
  {
    expect_s3_class(catalogs(FALSE), "data.frame")
    expect_snapshot(catalogs())
    }
  )


test_that(
  "assert_catalog() returns validated character or prints supported catalogs",
  {
    expect_equal(assert_catalog("WB"), "wb")
    expect_snapshot_error(assert_catalog("invaid"))
    expect_snapshot_error(assert_catalog(c("ccc", "wb")))
  }
)

test_that(
  "catalogs() lists all 9 catalogs in alphabetical order",
  {
    cats <- catalogs(FALSE)
    expect_equal(nrow(cats), 9)
    expect_equal(cats$catalog, sort(cats$catalog))
    expect_setequal(cats$catalog, all_catalogs)
  }
)


test_that(
  "assert_catalog() accepts every code in any letter case",
  {
    for (code in all_catalogs) {
      expect_equal(assert_catalog(code), code)
      expect_equal(assert_catalog(toupper(code)), code)
    }
  }
)


test_that(
  "each catalog has a distinct API base under index.php/api/catalog",
  {
    expect_setequal(names(catalog_list), all_catalogs)
    apis <- vapply(catalog_list, function(x) x$api, character(1))
    expect_length(unique(apis), length(all_catalogs))
    expect_true(all(grepl("/index.php/api/catalog$", apis)))
  }
)


test_that(
  "Kenya name matches the catalog definition",
  {
    expect_equal(
      catalog_list$kenya$name,
      "Kenya National Bureau of Statistics"
    )
  }
)


with_mock_dir(
  "_access_codes",
  {
    test_that(
      "access_codes() returns a data frame of data access types",
      {
        ac <- access_codes("fao")
        expect_s3_class(ac, "data.frame")
        expect_true("open" %in% ac$type)
        }
      )
    }
  )


with_mock_dir(
  "_collections",
  {
    test_that(
      "collections() returns a data frame of collections",
      {
        cl <- collections("wb")
        expect_s3_class(cl, "data.frame")
        expect_true(any(grepl("id", names(cl))))
        expect_snapshot_warning(collections("ihsn"))
      }
    )
  }
)


with_mock_dir(
  "_country_codes",
  {
    test_that(
      "country_codes() returns a data frame of country codes",
      {
        cc <- country_codes("fao")
        expect_s3_class(cc, "data.frame")
        expect_true(any(grepl("iso", names(cc))))

      }
    )
  }
)

with_mock_dir(
  "_latest_entries",
  {
    test_that(
      "latest_entries() returns a data frame of nrow = limit",
      {
        limit <- 2
        le <- latest_entries("wb", limit)
        expect_s3_class(le, "data.frame")
        expect_equal(nrow(le), limit)
      }
    )
  }
)

with_mock_dir(
  "_metadata",
  {
    test_that(
      "metadata() returns a detailed list",
      {
        md <- metadata("wb", 8098)
        expect_equal(class(md), "list")
        expect_true(all(c("doc_desc", "study_desc") %in% names(md)))
        expect_no_error(metadata("wb", "ALB_2012_LSMS_v01_M_v01_A_PUF"))
      }
    )
  }
)


# ---- Search Functions ----

with_mock_dir(
  "_search_auto",
  {
    test_that(
      "automated flow from search to dictionary",
      {
        expect_no_error({
          c <- "fao"
          res <- search_catalog(c)
          id <- res$id[2]
          df <- data_files(c, id)
          fd <- data_dictionary(c, id)
          fid <- df$file_id[1]
          dd <- data_dictionary(c, id, fid)
          wb_df <- data_files("wb", "ETH_2015_ESS_v03_M")
          wb_dd <- data_dictionary("wb", "ETH_2015_ESS_v03_M")
        })
      }
    )
  }
)


with_mock_dir(
  "_search_all",
  {
    test_that(
      "Test search parameters",
      {
        expect_no_error(
          {
            suppressWarnings(search_catalog(
              catalog = "wb",
              from = 2015,
              to = 2025,
              country = c("ETH", "UGA"),
              inc_iso = TRUE,
              collection = "LSMS",
              created = "2015/04/01-2025/04/20",
              dtype = c("open", "direct"),
              sort_by = "year",
              sort_order = "asc",
              ps = 15,
              page = 1,
              rows = TRUE
            ))
            search_catalog(
              catalog = "fao",
              sort_by = "country",
              rows = FALSE
            )
          }
        )
        expect_warning(search_catalog("fao", "novalidsk"))
      }
    )
  }
)


# ---- Per-catalog coverage (offline stubs) ----
# Requests are answered with canned NADA-shaped JSON, so these tests need
# no network and no recorded files. The stub also keeps every requested URL.

local_nada_stub <- function(env = parent.frame()) {
  seen <- new.env()
  seen$urls <- character()
  bodies <- list(
    data_access_codes = '{"codes":[{"type":"open","title":"Open"}]}',
    collections = '{"collections":[{"repo_id":"r1","title":"Repo"}]}',
    country_codes = '{"country_codes":[{"iso":"ETH","name":"Ethiopia"}]}',
    latest = '{"result":[{"id":1,"idno":"A"},{"id":2,"idno":"B"}]}',
    search = paste0(
      '{"result":{"found":2,"rows":',
      '[{"id":1,"idno":"A"},{"id":2,"idno":"B"}]}}'
    ),
    data_files = '{"datafiles":[{"file_id":"F1","file_name":"one"}]}',
    variables = '{"variables":[{"name":"v1","label":"Variable one"}]}',
    study = paste0(
      '{"dataset":{"metadata":',
      '{"doc_desc":{"x":1},"study_desc":{"y":2}}}}'
    )
  )
  local_mocked_bindings(
    req_perform = function(req, ...) {
      seen$urls <- c(seen$urls, req$url)
      key <- basename(sub("\\?.*$", "", req$url))
      if (!key %in% names(bodies)) key <- "study"
      httr2::response(
        status_code = 200,
        url = req$url,
        headers = list(`Content-Type` = "application/json"),
        body = charToRaw(bodies[[key]])
      )
    },
    .package = "httr2",
    .env = env
  )
  seen
}

hit_own_api <- function(seen, code) {
  length(seen$urls) > 0 &&
    all(startsWith(seen$urls, catalog_list[[code]]$api))
}


test_that(
  "access_codes() returns a data frame for every catalog",
  {
    seen <- local_nada_stub()
    for (code in all_catalogs) {
      seen$urls <- character()
      ac <- access_codes(code)
      expect_true(is.data.frame(ac), info = code)
      expect_true(hit_own_api(seen, code), info = code)
    }
  }
)


test_that(
  "collections() returns a data frame for every catalog except ihsn",
  {
    seen <- local_nada_stub()
    for (code in setdiff(all_catalogs, "ihsn")) {
      seen$urls <- character()
      cl <- collections(code)
      expect_true(is.data.frame(cl), info = code)
      expect_true(hit_own_api(seen, code), info = code)
    }
  }
)


test_that(
  "country_codes() returns a data frame for every catalog",
  {
    seen <- local_nada_stub()
    for (code in all_catalogs) {
      seen$urls <- character()
      cc <- country_codes(code)
      expect_true(is.data.frame(cc), info = code)
      expect_true(hit_own_api(seen, code), info = code)
    }
  }
)


test_that(
  "latest_entries() returns at most `limit` rows for every catalog",
  {
    seen <- local_nada_stub()
    for (code in all_catalogs) {
      seen$urls <- character()
      le <- latest_entries(code, limit = 2)
      expect_true(is.data.frame(le) && nrow(le) <= 2, info = code)
      expect_true(hit_own_api(seen, code), info = code)
    }
  }
)


test_that(
  "search_catalog() returns a data frame for every catalog",
  {
    seen <- local_nada_stub()
    for (code in all_catalogs) {
      seen$urls <- character()
      res <- search_catalog(code, ps = 5)
      expect_true(is.data.frame(res), info = code)
      expect_true(hit_own_api(seen, code), info = code)
    }
  }
)


test_that(
  "search, files, dictionary and metadata work for every catalog",
  {
    seen <- local_nada_stub()
    for (code in all_catalogs) {
      seen$urls <- character()
      res <- search_catalog(code, ps = 5)
      id <- res$id[1]
      files <- data_files(code, id)
      expect_true(is.data.frame(files), info = code)
      expect_true(is.data.frame(data_dictionary(code, id)), info = code)
      dd <- data_dictionary(code, id, files$file_id[1])
      expect_true(is.data.frame(dd), info = code)
      md <- metadata(code, id)
      expect_true(is.list(md), info = code)
      expect_true(hit_own_api(seen, code), info = code)
    }
  }
)


# ---- Recorded responses for the newer catalogs ----
# The first run with internet access records into _new_catalogs/. Later
# runs replay it offline. Delete that folder to record again.

with_mock_dir(
  "_new_catalogs",
  {
    test_that(
      "kenya, who and zambia answer the core endpoints",
      {
        for (code in c("kenya", "who", "zambia")) {
          le <- latest_entries(code, limit = 2)
          expect_true(is.data.frame(le), info = code)
          res <- search_catalog(code, ps = 5)
          expect_true(is.data.frame(res), info = code)
          expect_no_error(data_files(code, res$id[1]))
          md <- metadata(code, res$id[1])
          expect_true(is.list(md), info = code)
        }
      }
    )
  }
)


# ---- Shared request settings (offline) ----

test_that(
  "nada_request() sets a 30 second timeout and three attempts",
  {
    req <- nada_request("https://example.org/index.php/api/catalog")
    expect_equal(req$options$timeout_ms, 30000)
    expect_equal(req$policies$retry_max_tries, 3)
    expect_true(req$policies$retry_on_failure)
  }
)


test_that(
  "search_catalog() and get_response() use the shared request builder",
  {
    expect_true(
      any(grepl("nada_request(", deparse(body(search_catalog)), fixed = TRUE))
    )
    expect_true(
      any(grepl("nada_request(", deparse(body(get_response)), fixed = TRUE))
    )
  }
)


test_that(
  "a non-JSON response gives a clear error",
  {
    local_mocked_bindings(
      req_perform = function(req, ...) {
        httr2::response(
          status_code = 200,
          url = "https://example.org/index.php/api/catalog",
          headers = list(`Content-Type` = "text/html"),
          body = charToRaw("<html></html>")
        )
      },
      .package = "httr2"
    )
    req <- nada_request("https://example.org/index.php/api/catalog")
    expect_error(nada_perform(req), "did not return JSON")
  }
)


# ---- User agent (offline) ----

test_that(
  "the default user agent is the browser string",
  {
    old <- set_user_agent(NULL)
    on.exit(set_user_agent(old), add = TRUE)
    req <- nada_request("https://example.org/index.php/api/catalog")
    expect_equal(
      httr2::req_get_headers(req)[["User-Agent"]],
      browser_user_agent
    )
  }
)


test_that(
  "set_user_agent() changes the agent sent with requests",
  {
    old <- set_user_agent("nadaverse test agent")
    on.exit(set_user_agent(old), add = TRUE)
    req <- nada_request("https://example.org/index.php/api/catalog")
    expect_equal(
      httr2::req_get_headers(req)[["User-Agent"]],
      "nadaverse test agent"
    )
  }
)


test_that(
  "set_user_agent(NULL) restores the browser default",
  {
    old <- set_user_agent("temporary agent")
    on.exit(set_user_agent(old), add = TRUE)
    set_user_agent(NULL)
    expect_null(getOption("nadaverse.user_agent"))
    req <- nada_request("https://example.org/index.php/api/catalog")
    expect_equal(
      httr2::req_get_headers(req)[["User-Agent"]],
      browser_user_agent
    )
  }
)


test_that(
  "set_user_agent() returns the previous setting invisibly",
  {
    old <- set_user_agent("first agent")
    on.exit(set_user_agent(old), add = TRUE)
    expect_invisible(set_user_agent("second agent"))
    expect_equal(set_user_agent("third agent"), "second agent")
  }
)


test_that(
  "set_user_agent() rejects empty and non-string input",
  {
    old <- set_user_agent(NULL)
    on.exit(set_user_agent(old), add = TRUE)
    expect_error(set_user_agent(""), "single non-empty string")
    expect_error(set_user_agent(c("a", "b")), "single non-empty string")
    expect_error(set_user_agent(NA_character_), "single non-empty string")
    expect_error(set_user_agent(42), "single non-empty string")
    expect_null(getOption("nadaverse.user_agent"))
  }
)
