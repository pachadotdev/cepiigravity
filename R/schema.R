#' Crea el esquema SQL
#' @noRd
create_schema <- function() {
  con <- gravity_connect()

  # comunas ----

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS countries")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE countries (
  	iso3 VARCHAR,
  	iso3num DOUBLE,
  	country VARCHAR,
  	countrylong VARCHAR,
  	first_year DOUBLE,
  	last_year DOUBLE,
  	countrygroup_iso3 VARCHAR,
  	countrygroup_iso3num DOUBLE)"
  )

  DBI::dbSendQuery(con, "DROP TABLE IF EXISTS gravity")

  DBI::dbSendQuery(
    con,
    "CREATE TABLE gravity (
  	year DOUBLE,
  	iso3_o VARCHAR,
  	iso3_d VARCHAR,
  	iso3num_o DOUBLE,
  	iso3num_d DOUBLE,
  	country_exists_o INTEGER,
  	country_exists_d INTEGER,
  	gmt_offset_2020_o DOUBLE,
  	gmt_offset_2020_d DOUBLE,
  	contig INTEGER,
  	dist DOUBLE,
  	distw DOUBLE,
  	distcap DOUBLE,
  	distwces DOUBLE,
  	dist_source DOUBLE,
  	comlang_off INTEGER,
  	comlang_ethno INTEGER,
  	comcol INTEGER,
  	comrelig DOUBLE,
  	col45 INTEGER,
  	legal_old_o DOUBLE,
  	legal_old_d DOUBLE,
  	legal_new_o DOUBLE,
  	legal_new_d DOUBLE,
  	comleg_pretrans INTEGER,
  	comleg_posttrans INTEGER,
  	transition_legalchange INTEGER,
  	heg_o INTEGER,
  	heg_d INTEGER,
  	col_dep_ever INTEGER,
  	col_dep INTEGER,
  	col_dep_end_year DOUBLE,
  	col_dep_end_conflict INTEGER,
  	empire VARCHAR,
  	sibling_ever INTEGER,
  	sibling INTEGER,
  	sever_year INTEGER,
  	sib_conflict INTEGER,
  	pop_o DOUBLE,
  	pop_d DOUBLE,
  	gdp_o DOUBLE,
  	gdp_d DOUBLE,
  	gdpcap_o DOUBLE,
  	gdpcap_d DOUBLE,
  	pop_source_o DOUBLE,
  	pop_source_d DOUBLE,
  	gdp_source_o DOUBLE,
  	gdp_source_d DOUBLE,
  	gdp_ppp_o DOUBLE,
  	gdp_ppp_d DOUBLE,
  	gdpcap_ppp_o DOUBLE,
  	gdpcap_ppp_d DOUBLE,
  	pop_pwt_o DOUBLE,
  	pop_pwt_d DOUBLE,
  	gdp_ppp_pwt_o DOUBLE,
  	gdp_ppp_pwt_d DOUBLE,
  	gatt_o DOUBLE,
  	gatt_d DOUBLE,
  	wto_o DOUBLE,
  	wto_d DOUBLE,
  	eu_o INTEGER,
  	eu_d INTEGER,
  	rta INTEGER,
  	rta_coverage DOUBLE,
  	rta_type DOUBLE,
  	entry_cost_o DOUBLE,
  	entry_cost_d DOUBLE,
  	entry_proc_o DOUBLE,
  	entry_proc_d DOUBLE,
  	entry_time_o DOUBLE,
  	entry_time_d DOUBLE,
  	entry_tp_o DOUBLE,
  	entry_tp_d DOUBLE,
  	tradeflow_comtrade_o DOUBLE,
  	tradeflow_comtrade_d DOUBLE,
  	tradeflow_baci DOUBLE,
  	manuf_tradeflow_baci DOUBLE,
  	tradeflow_imf_o DOUBLE,
  	tradeflow_imf_d DOUBLE)"
  )

  # disconnect ----

  DBI::dbDisconnect(con, shutdown = TRUE)
  gc()
}
