#' Delete the gravity database from your computer
#'
#' Deletes the `cepiigravity` directory and all of its contents, including
#' all versions of the gravity database created with any DuckDB version.
#'
#' @param ask If so, a menu will be displayed to confirm the action to
#' delete any existing census database. By default it is true.
#' @return NULL
#' @export
#'
#' @examples
#' \dontrun{ gravity_delete() }
gravity_delete <- function(ask = TRUE) {
  if (isTRUE(ask)) {
    answer <- utils::menu(c("Agree", "Cancel"),
                   title = "This will eliminate all gravity databases",
                   graphics = FALSE)
    if (answer == 2) {
       return(invisible())
    }
  }

  suppressWarnings(gravity_disconnect())
  try(unlink(gravity_path(), recursive = TRUE))
  update_gravity_pane()
  return(invisible())
}
