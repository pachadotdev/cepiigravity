gravity_path <- function() {
  sys_gravity_path <- Sys.getenv("GRAVITY_DIR")
  sys_gravity_path <- gsub("\\\\", "/", sys_gravity_path)
  if (sys_gravity_path == "") {
    return(gsub("\\\\", "/", tools::R_user_dir("cepiigravity")))
  } else {
    return(gsub("\\\\", "/", sys_gravity_path))
  }
}

gravity_check_status <- function() {
  if (!gravity_status(FALSE)) {
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
gravity_connect <- function(dir = gravity_path()) {
  duckdb_version <- utils::packageVersion("duckdb")
  db_file <- paste0(dir, "/cepiigravity_duckdb_v", gsub("\\.", "", duckdb_version), ".sql")

  db <- mget("gravity_connect", envir = gravity_cache, ifnotfound = NA)[[1]]

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
        gravity_disconnect() in the other sessions.",
        call. = FALSE
      )
    } else {
      stop(e)
    }
  },
  finally = NULL
  )

  assign("gravity_connect", con, envir = gravity_cache)
  con
}

#' Disconnect the gravity database
#'
#' An auxiliary function to disconnect from the database.
#'
#' @examples
#' gravity_disconnect()
#' @export
#'
gravity_disconnect <- function() {
  gravity_disconnect_()
}

gravity_disconnect_ <- function(environment = gravity_cache) {
  db <- mget("gravity_connect", envir = gravity_cache, ifnotfound = NA)[[1]]
  if (inherits(db, "DBIConnection")) {
    DBI::dbDisconnect(db, shutdown = TRUE)
  }
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionClosed("CEPII Gravity", "cepiigravity")
  }
}

gravity_status <- function(msg = TRUE) {
  expected_tables <- sort(gravity_tables())
  existing_tables <- sort(DBI::dbListTables(gravity_connect()))

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

gravity_tables <- function() {
  c("countries", "gravity", "metadata")
}

gravity_cache <- new.env()
reg.finalizer(gravity_cache, gravity_disconnect_, onexit = TRUE)
