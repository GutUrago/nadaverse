# assert_* functions raise meaningful errors

    `x` must contain only digits, not 'character'

---

    `dig3` must contain exactly 3 digits.

---

    `x` must be 'character', not 'numeric'

---

    `x` must be a vector of length 2.

---

    `x` must be a string of 2 characters.

---

    `x` must be 'logical', not 'character.

# catalogs() contain a list of all supported catalogs

    Code
      catalogs()
    Message
      
      -- List of Supported Catalogs --
      
      i name: Link to the catalog
      * df: Data First (<https://www.datafirst.uct.ac.za>)
      * erf: Economic Research Forum (<https://erfdataportal.com>)
      * fao: Food and Agriculture Organization (<https://microdata.fao.org>)
      * ihsn: International Household Survey Network (<https://catalog.ihsn.org>)
      * ilo: International Labour Organization (<https://www.ilo.org/surveyLib>)
      * india: Government of India (<https://microdata.gov.in>)
      * unhcr: United Nations High Commissioner for Refugees
      (<https://microdata.unhcr.org>)
      * wb: The World Bank (<https://microdata.worldbank.org>)

# assert_catalog() returns validated character or prints supported catalogs

    Invalid catalog supplied: `invaid`

---

    `catalog` must be a single character string.
    i You provided: class <character>, length 2

# collections() returns a data frame of collections

    ihsn returned 0 collections.

