#' @keywords internal
"_PACKAGE"

#' @title The Countries dataset: Static country-level information
#' @name countries
#' @docType data
#' @author CEPII, adapted from the World Bank and other sources
#' @format A data frame with 257 rows and 8 columns:
#' |variable             |description                         |
#' |:--------------------|:-----------------------------------|
#' |iso3                 |ISO3 alphabetic                     |
#' |iso3num              |ISO3 numeric                        |
#' |country              |Country name                        |
#' |countrylong          |Country official name               |
#' |first_year           |First year of territorial existence |
#' |last_year            |Last year of territorial existence  |
#' |countrygroup_iso3    |Country group (ISO3 alphabetic)     |
#' |countrygroup_iso3num |Country group (ISO3 numeric)        |
#' @description Countries is the dataset that includes static country-level
#'  variables, allowing for a full identification of each country included in
#'  Gravity and, if relevant, for a tracking of its territorial changes (splits
#'  and merges). Some of the variables provided in Countries are also included
#'  in the main Gravity dataset.
#'  Countries includes one observation for each territorial configuration,
#'  mapping the full set of territorial changes that are accounted for in
#'  Gravity. For example, Countries includes one observation for West Germany,
#'  one for East Germany and one for the unified Germany. Similarly, it includes
#'  one observation for Sudan before the split of South Sudan, one observation
#'  for South Sudan, and one observation for Sudan after the split of South
#'  Sudan.
#' @details There are differences with respect to the original Stata version.
#'  ISO3 alphabetic codes of length zero were converted to NAs and the
#'  attributes (i.e., column descriptions), when missing, were added after
#'  reading the original documentation.
#'  The universe of Countries (and of the Gravity dataset) is based on
#'  CEPII's GeoDist dataset (Mayer and Zignago 2011). This dataset is augmented
#'  with some countries and territories that either appear in the World Bank's
#'  World Integrated Trade Solution (WITS) or that are necessary to construct
#'  the full chain of territorial changes that have led to the creation of
#'  countries appearing in the GeoDist dataset. In addition, some names are
#'  updated, as well as ISO3 alphabetic numeric codes, by comparing the GeoDist
#'  dataset with the WITS dataset and with the official source for ISO country
#'  codes. Countries' official names also come from the WITS dataset, augmented
#'  by Wikipedia for countries or territories that are not present in the WITS
#'  dataset but that appear in GeoDist.
#'  Countries (and the Gravity dataset) carefully tracks territorial changes,
#'  i.e. the country's previous membership (in case of a split) and the
#'  country's new membership (in case of a unification of two territories). We
#'  only take into account the modifications that occurred over the time span
#'  of the database, i.e 1948-2019. This is done using the CIA World Factbook
#'  and Wikipedia.
#' @keywords data
NULL

#' @title The Gravity dataset
#' @name gravity
#' @docType data
#' @author CEPII, adapted from the World Bank and other sources
#' @format A data frame with 4,428,288 rows and 79 columns:
#' |variable               |description                                                                      |
#' |:----------------------|:--------------------------------------------------------------------------------|
#' |year                   |Year                                                                             |
#' |iso3_o                 |Origin ISO3 alphabetic                                                           |
#' |iso3_d                 |Destination ISO3 alphabetic                                                      |
#' |iso3num_o              |Origin ISO3 numeric                                                              |
#' |iso3num_d              |Destination ISO3 numeric                                                         |
#' |country_exists_o       |1 = Origin country exists                                                        |
#' |country_exists_d       |1 = Destination country exists                                                   |
#' |gmt_offset_2020_o      |Origin GMT offset (hours)                                                        |
#' |gmt_offset_2020_d      |Destination GMT offset (hours)                                                   |
#' |contig                 |1 = Contiguity                                                                   |
#' |dist                   |Distance between most populated cities, in km                                    |
#' |distw                  |Population-weighted distance between most populated cities, in km                |
#' |distcap                |Distance between capitals, in km                                                 |
#' |distwces               |Population-weighted distance between most populated cities, in km, using CES for |
#' |dist_source            |Distance source                                                                  |
#' |comlang_off            |1 = Common official or primary language                                          |
#' |comlang_ethno          |1 = Language is spoken by at least 9% of the population                          |
#' |comcol                 |1 = Common colonizer post 1945                                                   |
#' |comrelig               |Common religion index                                                            |
#' |col45                  |1 = Pair in colonial relationship post 1945                                      |
#' |legal_old_o            |Origin legal system before transition                                            |
#' |legal_old_d            |Destination legal system before transition                                       |
#' |legal_new_o            |Origin legal system after transition                                             |
#' |legal_new_d            |Destination legal system after transition                                        |
#' |comleg_pretrans        |1 = Common legal origins before transition                                       |
#' |comleg_posttrans       |1 = Common legal origins after transition                                        |
#' |transition_legalchange |1 = Common legal origin changed since transition                                 |
#' |heg_o                  |1 = Origin is current or former hegemon of destination                           |
#' |heg_d                  |1 = Destination is current or former hegemon of origin                           |
#' |col_dep_ever           |1 = Pair ever in colonial or dependency relationship                             |
#' |col_dep                |1 = Pair currently in colonial or dependency relationship                        |
#' |col_dep_end_year       |Independence date, if col_dep = 1                                                |
#' |col_dep_end_conflict   |1 = Independence involved conflict, if col_dep_ever = 1                          |
#' |empire                 |Hegemon if sibling = 1 and year < sever_year                                     |
#' |sibling_ever           |1 = Pair ever in sibling relationship                                            |
#' |sibling                |1 = Pair currently in sibling relationship                                       |
#' |sever_year             |Severance year for pairs if sibling == 1                                         |
#' |sib_conflict           |1 = Pair ever in sibling relationship and conflict with hegemon                  |
#' |pop_o                  |Origin Population, total in thousands                                            |
#' |pop_d                  |Destination Population, total in thousands                                       |
#' |gdp_o                  |Origin GDP (current thousands US$)                                               |
#' |gdp_d                  |Destination GDP (current thousands US$)                                          |
#' |gdpcap_o               |Origin GDP per cap (current thousands US$)                                       |
#' |gdpcap_d               |Destination GDP per cap (current thousands US$)                                  |
#' |pop_source_o           |Origin Population source                                                         |
#' |pop_source_d           |Destination Population source                                                    |
#' |gdp_source_o           |Origin GDP source                                                                |
#' |gdp_source_d           |Destination GDP source                                                           |
#' |gdp_ppp_o              |Origin GDP, PPP (current thousands international $)                              |
#' |gdp_ppp_d              |Destination GDP, PPP (current thousands international $)                         |
#' |gdpcap_ppp_o           |Origin GDP per cap, PPP (current thousands international $)                      |
#' |gdpcap_ppp_d           |Destination GDP per cap, PPP (current thousands international $)                 |
#' |pop_pwt_o              |Origin Population, total in thousands (PWT)                                      |
#' |pop_pwt_d              |Destination Population, total in thousands (PWT)                                 |
#' |gdp_ppp_pwt_o          |Origin GDP, current PPP (2011 thousands US$) (PWT)                               |
#' |gdp_ppp_pwt_d          |Destination GDP, current PPP (2011 thousands US$) (PWT)                          |
#' |gatt_o                 |Origin GATT membership                                                           |
#' |gatt_d                 |Destination GATT membership                                                      |
#' |wto_o                  |Origin WTO membership                                                            |
#' |wto_d                  |Destination WTO membership                                                       |
#' |eu_o                   |1 = Origin is a EU member                                                        |
#' |eu_d                   |1 = Destination is a EU member                                                   |
#' |rta                    |1 = RTA (source: WTO)                                                            |
#' |rta_coverage           |Coverage of RTA (source: WTO)                                                    |
#' |rta_type               |Type of RTA (source: WTO)                                                        |
#' |entry_cost_o           |Origin Cost of business start-up procedures (% of GNI per capita)                |
#' |entry_cost_d           |Destination Cost of business start-up procedures (% of GNI per capita)           |
#' |entry_proc_o           |Origin Start-up procedures to register a business (number)                       |
#' |entry_proc_d           |Destination Start-up procedures to register a business (number)                  |
#' |entry_time_o           |Origin Time required to start a business (days)                                  |
#' |entry_time_d           |Destination Time required to start a business (days)                             |
#' |entry_tp_o             |Origin Days + procedures to start a business                                     |
#' |entry_tp_d             |Destination Days + procedures to start a business                                |
#' |tradeflow_comtrade_o   |Trade flows as reported by the origin, 1000 Current USD (source: UNSD)           |
#' |tradeflow_comtrade_d   |Trade flows as reported by the destination, 1000 Current USD (source: UNSD)      |
#' |tradeflow_baci         |Trade flow, 1000 USD (source: BACI)                                              |
#' |manuf_tradeflow_baci   |Trade flow of manufactured goods, 1000 USD (source: BACI)                        |
#' |tradeflow_imf_o        |Trade flows as reported by the origin, 1000 Current USD (source: IMF)            |
#' |tradeflow_imf_d        |Trade flows as reported by the destination, 1000 Current USD (source: IMF)       |
#' @description In Gravity, each observation is uniquely identified by the
#'  combination of the country_id of the origin country, the country_id of the
#'  destination country and the year. Gravity is “squared”, meaning that each
#'  country pair appears every year, even if one of the countries actually does
#'  not exist. However, based on the territorial changes tracked in the
#'  Countries dataset, we set to missing all variables for country pairs in
#'  which at least one of the countries does not exist in a given year.
#'  Furthermore, we provide two dummy variables indicating whether the origin
#'  and the destination countries exist. These dummies allow users wishing drop
#'  non-existing country pairs from the dataset to do so easily. Users looking
#'  for a more detailed account of country existence should turn to the
#'  Countries dataset.
#'  A few caveats on the identification of countries through country_id must be
#'  noted. Firstly, when countries merge, it is the new country or territorial
#'  configuration that exists during transition year but not the old country or
#'  territorial configuration. As an example DEU.1 (West Germany) has 1989 as
#'  last year, not 1990, while DEU.2 (the unified Germany) has 1990 as first
#'  year. This is consistent with the construction of underlying variables that
#'  varies over time, such as GDP, population, trade. Secondly, since the
#'  dataset is square in terms of country_id, there exist cases in which two
#'  configurations of the same alphabetic ISO3 code appear bilaterally, e.g.
#'  DEU.1 and DEU.2. While DEU.1 and DEU.2 never existed simultaneously, we
#'  still keep these null observations to ensure that the final dataset is
#'  square.
#' @details The details are the same as for the Countries dataset.
#' @keywords data
NULL
