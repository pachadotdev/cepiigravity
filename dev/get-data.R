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
  mutate_if(is.character, function(x) ifelse(x == "", NA, x))

unique(nchar(countries$iso3))

gravity <- read_stata(finp[2]) %>%
  clean_names() %>%
  mutate(
    iso3_o = tolower(iso3_o),
    iso3_d = tolower(iso3_d)
  ) %>%
  mutate_if(is.character, function(x) ifelse(x == "", NA, x))

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
attr(gravity[[34]], "label") <- "Common colonizer"

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

# usethis::use_data(countries, compress = "xz", overwrite = T)
# usethis::use_data(gravity, compress = "xz", overwrite = T)

fix_0s <- gravity_desc %>%
  filter(grepl("1", description)) %>%
  select(variable) %>%
  pull()

fix_0s <- fix_0s[!fix_0s %in% c("gdp_ppp_pwt_d", "col_dep_end_year",
                                "gdp_ppp_pwt_o", "manuf_tradeflow_baci",
                                "tradeflow_baci", "tradeflow_imf_d",
                                "tradeflow_comtrade_d", "tradeflow_imf_o",
                                "tradeflow_comtrade_o")]

gravity_0s <- gravity %>%
  select(fix_0s)

col_names <- colnames(gravity)

gravity <- gravity %>%
  select(col_names[!col_names %in% fix_0s]) %>%
  bind_cols(
    gravity_0s %>%
      mutate_if(is.numeric, function(x) as.integer(ifelse(is.na(x), 0L, x)))
  )

gravity <- gravity %>%
  select(all_of(col_names))

readr::write_tsv(gravity, "dev/gravity.tsv", na = "")
readr::write_tsv(countries, "dev/countries.tsv", na = "")
