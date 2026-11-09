# Catalog differences and troubleshooting

All the catalogs use the same NADA software, but they are run by
different organizations on different servers. This guide covers where
they differ and what to do when a request fails. The output comes from
saved responses.

``` r

library(nadaverse)
```

[`catalogs()`](https://guturago.github.io/nadaverse/reference/catalogs.md)
lists the supported catalogs with their names and links. The codes are
`df`, `erf`, `fao`, `ihsn`, `kenya`, `unhcr`, `wb`, `who` and `zambia`.

## Size and columns

Catalogs differ a lot in size. A search with `ps = 1` and `rows = FALSE`
is a cheap way to see how many studies a catalog holds. Here it is run
on four catalogs:

``` r

codes <- c("wb", "fao", "ihsn", "kenya")
info <- lapply(codes, search_catalog, ps = 1, rows = FALSE)
names(info) <- codes
total <- function(x) if (is.null(x$total)) NA_real_ else as.numeric(x$total)
vapply(info, total, numeric(1))
#>    wb   fao  ihsn kenya 
#>  7151  1793 13097   131
```

The columns can also differ, because each catalog decides what to
publish. These are the columns that all four have in common:

``` r

cols <- lapply(info, function(x) names(x$rows))
Reduce(intersect, cols)
#>  [1] "id"               "idno"             "title"            "nation"          
#>  [5] "authoring_entity" "form_model"       "year_start"       "year_end"        
#>  [9] "repositoryid"     "repo_title"       "created"          "changed"         
#> [13] "total_views"      "total_downloads"  "url"
```

If your code runs across several catalogs, rely on columns from a list
like this one, and check [`names()`](https://rdrr.io/r/base/names.html)
before you use any other column.

## Missing features

Some catalogs do not use every feature. IHSN, for example, has no
collections. `collections("ihsn")` warns that it returned 0 collections
and gives an empty result:

``` r

length(suppressWarnings(collections("ihsn")))
#> [1] 0
```

## Slow or unavailable catalogs

Every request waits up to 30 seconds and is attempted up to three times
before it fails, including after connection errors. A catalog that is
down can therefore take about 90 seconds to give up. The error that
follows comes from the connection and names the host.

Some catalogs answer with a web page instead of data, for example a
block page for automated clients. nadaverse notices this and stops with
a message like:

    Error: The catalog did not return JSON from <url>.
    i Got content type "text/html" (HTTP 200).
    i The catalog may be down or blocking automated requests.

When you see an error like this, open the address in a browser to check
that the site is up, wait a while, and try again. If a catalog keeps
failing for a long time, try another catalog or report it at the
package’s issue tracker.

## The user agent

Every request sends a user agent, a short text that tells the server
what kind of program is asking. By default nadaverse sends a
browser-style user agent. In our checks, UNHCR returned an error when
the request did not look like it came from a browser, while the other
catalogs accepted both.

If you want to identify your own project instead, use
[`set_user_agent()`](https://guturago.github.io/nadaverse/reference/set_user_agent.md).
It returns the previous setting invisibly, so you can put it back:

``` r

old <- set_user_agent("My research project (nadaverse)")
getOption("nadaverse.user_agent")
#> [1] "My research project (nadaverse)"
set_user_agent(old)
getOption("nadaverse.user_agent")
#> NULL
```

`NULL` means the default browser user agent is in use. If a catalog
starts rejecting requests after you change the setting, go back to the
default with `set_user_agent(NULL)`.

## Using catalogs considerately

The catalogs are public services. Keep `ps` small when you are
exploring, save results you will need again, and avoid loops that send
thousands of requests. Each catalog also has its own terms for using the
data, which you can read on its website.
