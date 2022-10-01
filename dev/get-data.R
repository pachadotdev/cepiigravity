library(purrr)
library(haven)
library(janitor)
library(dplyr)

# download ----

# http://www.cepii.fr/DATA_DOWNLOAD/gravity/legacy/202102/Gravity_rds_V202102.zip
# doesn't work :(
url_data <- "http://www.cepii.fr/DATA_DOWNLOAD/gravity/legacy/202102/Gravity_dta_V202102.zip"
url_docs <- "http://www.cepii.fr/DATA_DOWNLOAD/gravity/legacy/202102/Gravity_documentation.pdf"

zip_data <- gsub(".*/", "dev/", url_data)
pdf_docs <- gsub(".*/", "dev/", url_docs)

map2(
  c(url_data, url_docs),
  c(zip_data, pdf_docs),
  function(x,y) {
    if (!file.exists(y)) {
      try(
        download.file(x, y)
      )
    }
  }
)

finp <- list.files("dev", pattern = "\\.dta", full.names = T)

if (length(finp) == 0L) {
  unzip(zip_data, exdir = "dev")
}

# tidy ----

finp <- list.files("dev", pattern = "\\.dta", full.names = T)

countries <- read_stata(finp[1]) %>%
  clean_names() %>%
  mutate(iso3 = tolower(iso3)) %>%
  mutate(iso3 = ifelse(nchar(iso3) == 0L, NA, iso3))

unique(nchar(countries$iso3))

gravity <- read_stata(finp[2]) %>%
  clean_names() %>%
  mutate(
    iso3_o = tolower(iso3_o),
    iso3_d = tolower(iso3_d)
  ) %>%
  mutate(
    iso3_o = ifelse(nchar(iso3_o) == 0L, NA, iso3_o),
    iso3_d = ifelse(nchar(iso3_d) == 0L, NA, iso3_d)
  )

unique(nchar(gravity$iso3_o))
unique(nchar(gravity$iso3_d))

# descriptions -----

attr(countries[[1]], "label") <- "ISO3 alphabetic"

countries_desc <- tibble(
  variable = colnames(countries),
  description = map_chr(
    seq_along(colnames(countries)),
    function(x) {
      y <- attr(countries[[x]], "label")
      if (is.null(y)) y <- NA
      return(y)
    }
  )
)

attr(gravity[[2]], "label") <- "Origin ISO3 alphabetic"
attr(gravity[[3]], "label") <- "Destination ISO3 alphabetic"

gravity_desc <- tibble(
  variable = colnames(gravity),
  description = map_chr(
    seq_along(colnames(gravity)),
    function(x) {
      y <- attr(gravity[[x]], "label")
      if (is.null(y)) y <- NA
      return(y)
    }
  )
)

knitr::kable(countries_desc)

knitr::kable(gravity_desc)

# export ----

usethis::use_data(countries, compress = "xz", overwrite = T)

usethis::use_data(gravity, compress = "xz", overwrite = T)
