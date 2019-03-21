Storage <- function(store = new.env(parent = emptyenv())) {
  ## initialize a configuration store: the place where we store configurations
  force(store)
  getEntry <- function(x) {
    allEntries <- ls(envir = store, all.names = TRUE)
    if (!is.character(x) || length(x) != 1) stop(
      "Expected a character of length one")
    if (!is.element(x, allEntries)) stop(sprintf(
      "'%s' is not a registered configuration. Registered entries are: %s",
      x, paste0(allEntries, collapse = ", ")))
    get(x, envir = store)
  }
  setEntry <- function(x, warn) {
    if (!is.list(x)) stop("Expected a named list.")
    if (is.null(names(x)) || any(names(x) == "")) stop("Entries are not named")
    appendEntry <- function(name, value) {
      if (is.null(names(value)) || any(names(x) == "")) stop(
        "Configuration entries are not named")
      allEntries <- ls(envir = store, all.names = TRUE)
      val <- if (is.element(name, allEntries)) getEntry(name) else list()
      if (!identical(val, list())) warn(
        "Overriding/Appending configuration '%s'", name)
      val[names(value)] <- value
      assign(name, val, envir = store)
      NULL
    }
    mapply(appendEntry, name = names(x), value = x)
  }
  function(x, warn = function(msg, ...) warning(sprintf(msg, ...))) {
    if (is.character(x)) getEntry(x)
    else setEntry(x, warn)
  }
}

store <- Storage()
