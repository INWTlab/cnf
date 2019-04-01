#' Register a configuration
#'
#' Register a configuration.
#'
#' @param ... (character|list) named arguments. Character are interpreted as
#'   files. List objects are used as they are.
#' @param maybe (logical) If TRUE then loading a config file can fail. A warning
#'   is raised.
#' @param warn (logical) If FALSE convert all warnings into messages.
#' @param quiet (logical) Suppress all warnings and messages.
#' @param where (environment) The environment used to store the configs.
#'
#' @examples
#' file <- tempfile(fileext = "R")
#' writeLines("x<-2\ny<-1", file)
#' cnf::register(config = list(x = 1))
#' cnf::getcnf("config")
#' cnf::register(config = file, warn = FALSE)
#' cnf::getcnf("config")
#'
#' @export
register <- function(..., maybe = FALSE, warn = TRUE, quiet = FALSE, where = NULL) {
  store <- if (is.null(where)) store else Storage(where)
  warn <- if (warn) lwarn(match.call()) else function(msg, ...) message(sprintf(msg, ...))
  warn <- if (quiet) function(...) invisible(NULL) else warn
  entries <- list(...)
  entries <- lapply(entries, processEntry, maybe = maybe, warn = warn)
  entries[unlist(lapply(entries, is.null))] <- NULL
  store(entries, warn)
  invisible(NULL)
}

processEntry <- function(x, maybe, warn) {
  if (is.list(x)) return(x)
  if (!is.character(x) && length(x) != 1) stop(
    "Expected a character of length one as file")
  if (!file.exists(normalizePath(x, mustWork = !maybe))) {
    warn("No such file: '%s'", x)
    return(NULL)
  }
  source(x, e <- new.env())
  as.list(e, all.names = TRUE)
}

lwarn <- function(call) {
  function(msg, ...) {
    msg <- sprintf(msg, ...)
    warning(simpleWarning(msg, call))
  }
}
