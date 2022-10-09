.onAttach <- function(...) {
  msg(cli::rule(crayon::bold("CEPII Gravity")))
  msg(" ")
  msg("The package documentation and usage examples can be found at https://pacha.dev/cepiigravity/.")
  msg("Visit https://buymeacoffee.com/pacha if you wish to donate to contribute to the development of this software.")
  msg("This library needs 2.0 GB free to create the database locally. Once the database is created, it occupies 500 MB of disk space.")
  msg(" ")
  if (interactive() && Sys.getenv("RSTUDIO") == "1"  && !in_chk()) {
    cepiigravity_pane()
  }
  if (interactive()) cepiigravity_status()
}
