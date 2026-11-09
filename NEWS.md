# nadaverse 0.2.0

## New features

* Added three catalogs: the Kenya National Bureau of Statistics (`"kenya"`),
  the World Health Organization Health Information Systems survey catalog
  (`"who"`), and the Zambia Statistics Agency (`"zambia"`).
* New `set_user_agent()` sets the user agent sent with requests. The default
  is a browser user agent, which UNHCR requires.
* Requests now time out after 30 seconds and are attempted up to three times,
  including after connection errors.
* A catalog that replies with something other than JSON, such as a block page,
  now stops with a clear error message.

## Breaking changes

* Removed the `"ilo"` and `"india"` catalogs. The ILO survey catalog has been
  retired, and the Government of India catalog could not be reached when
  testing.

# nadaverse 0.1.0

* Initial CRAN submission.
