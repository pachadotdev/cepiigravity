sql_action <- function() {
  if (requireNamespace("rstudioapi", quietly = TRUE) &&
      exists("documentNew", asNamespace("rstudioapi"))) {
    contents <- paste(
      "-- !preview conn=cepiigravity::cepiigravity_connect()",
      "",
      "SELECT * FROM gravity WHERE year = 2010",
      "",
      sep = "\n"
    )

    rstudioapi::documentNew(
      text = contents, type = "sql",
      position = rstudioapi::document_position(2, 40),
      execute = FALSE
    )
  }
}

cepiigravity_pane <- function() {
  observer <- getOption("connectionObserver")
  if (!is.null(observer) && interactive()) {
    observer$connectionOpened(
      type = "CEPII Gravity",
      host = "cepiigravity",
      displayName = "CEPII Gravity Tables",
      icon = system.file("img", "edit-sql.png", package = "cepiigravity"),
      connectCode = "cepiigravity::gravity_pane()",
      disconnect = cepiigravity::cepiigravity_disconnect,
      listObjectTypes = function() {
        list(
          table = list(contains = "data")
        )
      },
      listObjects = function(type = "datasets") {
        tbls <- DBI::dbListTables(cepiigravity_connect())
        data.frame(
          name = tbls,
          type = rep("table", length(tbls)),
          stringsAsFactors = FALSE
        )
      },
      listColumns = function(table) {
        res <- DBI::dbGetQuery(cepiigravity_connect(),
                               paste("SELECT * FROM", table, "LIMIT 1"))
        data.frame(
          name = names(res), type = vapply(res, function(x) class(x)[1],
                                           character(1)),
          stringsAsFactors = FALSE
        )
      },
      previewObject = function(rowLimit, table) {
        DBI::dbGetQuery(cepiigravity_connect(),
                        paste("SELECT * FROM", table, "LIMIT", rowLimit))
      },
      actions = list(
        Status = list(
          icon = system.file("img", "edit-sql.png", package = "cepiigravity"),
          callback = cepiigravity_status
        ),
        SQL = list(
          icon = system.file("img", "edit-sql.png", package = "cepiigravity"),
          callback = sql_action
        )
      ),
      connectionObject = cepiigravity_connect()
    )
  }
}

update_cepiigravity_pane <- function() {
  observer <- getOption("connectionObserver")
  if (!is.null(observer)) {
    observer$connectionUpdated("CEPII Gravity", "cepiigravity", "")
  }
}
