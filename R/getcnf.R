#' Get configuration
#'
#' Get a registered configuration.
#'
#' @param name (character) the name of the config
#' @param where (NULL|environment) where to look for the configuration
#'
#' @examples
#' cnf::register(config = list(x = 1))
#' cnf::getcnf("config")
#' @export
getcnf <- function(name, where = NULL) {
  store <- if (is.null(where)) store else Storage(where)
  store(name)
}
