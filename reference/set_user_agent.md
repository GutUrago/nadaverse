# Set the user agent used for NADA requests

Sets the `User-Agent` header sent with every request to the NADA
catalogs for the rest of the R session. By default nadaverse sends a
browser user agent, because some catalogs, such as UNHCR, reject
requests from other clients. Use this function to send a different
agent, for example one that identifies your project. If a catalog starts
rejecting requests after you change the agent, call
`set_user_agent(NULL)` to go back to the default.

## Usage

``` r
set_user_agent(user_agent = NULL)
```

## Arguments

- user_agent:

  A single non-empty string to send as the user agent, or `NULL` to
  restore the default browser user agent.

## Value

Invisibly, the previous setting: `NULL` when the default was in use.
Pass it back to `set_user_agent()` to restore it.

## Details

The setting is stored in the `nadaverse.user_agent` option.

## See also

[`catalogs`](https://guturago.github.io/nadaverse/reference/catalogs.md)

## Examples

``` r
# Send a custom user agent for this session
old <- set_user_agent("My research project (nadaverse)")

# Restore the default browser user agent
set_user_agent(NULL)
```
