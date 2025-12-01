
set_redactor(function (x) {
  gsub_response(x, "index.php/api/catalog/", "")
})

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
            search_catalog(
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
            )
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
