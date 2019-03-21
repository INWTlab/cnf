#' Get configuration
#'
#' @export
getcnf <- function(name, where = NULL) {
  store <- if (is.null(where)) store else Storage(where)
  store(name)
}
