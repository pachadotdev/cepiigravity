cepiigravity_path <- function() {
  sys_gravity_path <- Sys.getenv("GRAVITY_DIR")
  sys_gravity_path <- gsub("\\\\", "/", sys_gravity_path)
  if (sys_gravity_path == "") {
    return(gsub("\\\\", "/", tools::R_user_dir("cepiigravity")))
  } else {
    return(gsub("\\\\", "/", sys_gravity_path))
  }
}

cepiigravity_check_status <- function() {
  if (!cepiigravity_status(FALSE)) {
    stop("The gravity database is empty or damaged.
         Download it with gravity_download().")
  }
}

#' Connect to the gravity database
#'
#' Returns a local database connection. This corresponds to a DBI-compatible
#' DuckDB database.
#'
#' @param dir Database location on disk. Defaults to the `cepiigravity`
#' directory inside the R user folder or the `GRAVITY_DIR` environment variable
#' if specified.
#'
#' @export
#'
#' @examples
#' \dontrun{
#'  DBI::dbListTables(gravity_connect())
#'
#'  DBI::dbGetQuery(
#'   gravity_connect(),
#'   'SELECT * FROM gravity WHERE year = 2010'
#'  )
#' }
cepiigravity_connect <- function(dir = cepiigravity_path()) {
  duckdb_version <- utils::packageVersion("duckdb")
  db_file <- paste0(dir, "/cepiigravity_duckdb_v", gsub("\\.", "", duckdb_version), ".sql")

  db <- mget("cepiigravity_connect", envir = cepiigravity_cache, ifnotfound = NA)[[1]]

  if (inherits(db, "DBIConnection")) {
    if (DBI::dbIsValid(db)) {
      return(db)
    }
  }

  try(dir.create(dir, showWarnings = FALSE, recursive = TRUE))

  drv <- duckdb::duckdb(db_file, read_only = FALSE)

  tryCatch({
    con <- DBI::dbConnect(drv)
  },
  error = function(e) {
    if (grepl("Failed to open database", e)) {
      stop(
        "The local gravity database is being used by another process. Try
        closing other R sessions or disconnecting the database using
        cepiigravity_disconnect() in the other sessions.",
        call. = FALSE
      )
    } else {
      stop(e)
    }
  },
  finally = NULL
  )

  assign("cepiigravity_connect", con, envir = cepiigravity_cache)
  con
}

#' Disconnect the gravity database
#'
#' An auxiliary function to disconnect from the database.
#'
#' @examples
#' cepiigravity_disconnect()
#' @export
#'
cepiigravity_disconnect <- function() {
  cepiigravity_disconnect_()
}

cepiigravity_disconnect_ <- function(environment = cepiigravity_cache) {
  db <- mget("cepiigravity_connect", envir = cepiigravity_cache, ifnotfound = NA)[[1]]
  if (inherits(db, "DBIConnection")) {
    DBI::dbDisconnect(db, shutdown = TRUE)
  }
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionClosed("CEPII Gravity", "cepiigravity")
  }
}

cepiigravity_status <- function(msg = TRUE) {
  expected_tables <- sort(cepiigravity_tables())
  existing_tables <- sort(DBI::dbListTables(cepiigravity_connect()))

  if (isTRUE(all.equal(expected_tables, existing_tables))) {
    status_msg <- crayon::green(paste(cli::symbol$tick,
    "The local gravity database is OK."))
    out <- TRUE
  } else {
    status_msg <- crayon::red(paste(cli::symbol$cross,
    "The local gravity database is empty, damaged or not compatible with your duckdb version. Download it with gravity_download()."))
    out <- FALSE
  }
  if (msg) msg(status_msg)
  invisible(out)
}

cepiigravity_tables <- function() {
  c("countries", "gravity", "metadata")
}

cepiigravity_cache <- new.env()
reg.finalizer(cepiigravity_cache, cepiigravity_disconnect_, onexit = TRUE)
