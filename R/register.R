#' Register new configuration
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
