<!-- README.md is generated from README.Rmd. Please edit that file -->
config
======

Tools to manage configuration files for R projects.

Examples
--------

Assume you have a configuration file located at `~/.config.R`. It may
look something like:

**~/.config.R**

``` r
user <- "user"
password <- "pwd"
...
```

Now the question is, how do you make these settings to your R project.
`config` provides the following mechanisms:

-   `register`: Register a configuration file. It adds to a list of
    config files.
-   `get`: get the value of a config. It is always a `list` returned
    with the values in the config as elements.
-   `store`: a *store* of all registered configurations.

``` r
config::register("~/.config.R")
config::get("config")
config::store$config(user = "test-user")
```

As we can see, we have two options to access values in the
configuration: `get` and `store`. `get` is easy to understand: we get
the config for a given name. `store` is an environment. When we register
a new configuration, a function is added to the store to ‘generate’ the
config. Using this function we can override or add elements in the
config, or just retrieve the values as they are. This can be useful in
development and debugging sessions.

One more things you may have recognised: The name *config* has been
deduced from the filepath. By default we use the filename provided
without the file extension and after stripping the leading dot. If you
name all your configuration files `~/.project/config.R`, this is a bit
ambiguous. Instead you can and should give project specific names:

``` r
config::register(
  projA = "pathA/config.R",
  projB = "pathB/config.R"
)
```

We now have access to these configs using:

``` r
config::get("projA")
config::get("projB")
config::store$projA()
config::store$projB()
```

Note that we can override configurations using this approach; simply by
using the same name twice. A warning is raised, however this may be
entirely by intention. Consider that you have projects A and B. A has
its own config and loads it. B depends on A but needs to reconfigure
project A. Think of the number of cores, database credentials, and the
like. Using this approach we will inherit the configuration but can
override what needs to be overridden.

To make this work the order of registering is important. Thus the
registration goes into the `.onLoad` hook of your package. If you do not
have a package: you are doomed, go and write a package!

``` r
.onLoad <- function(libname, pkgname) {
  config::register(
    projA = "pathA/config.R",
    projB = "pathB/config.R",
    maybe = TRUE,
    envOverride = TRUE,
    quite = TRUE,
    warn = FALSE
  )
}
```

-   `maybe` allows this call to fail, but will print a message. This is
    important when we install a package and have no configuration, yet.
-   `envOverride` allows all values to be overridden by the environment.
    -   First we check if an environment variable `CONFIG_PROJA` exists.
        Then we use that variable.
    -   Then we check for a config file named `CONFIG_PROJA.R` in the
        current working directory.
    -   Only then do we check “pathA/config.R”.
-   `quite` suppresses all warnings and messages.
-   `warn` turns warnings into messages.

For some reason we sometimes have configuration in our packages, as R
code and in version control. We can register them as configuration,
preferably as load hook:

``` r
.onLoad <- function(libname, pkgname) {
  config::register(
    config = configObject
  )
}
```

In this case `configObject` is a list. We can go wild and provide a
fallback/default configuration and allow for override by a file:

``` r
.onLoad <- function(libname, pkgname) {
  config::register(
    config = configObject,
    config = "~/.config.R",
    maybe = TRUE
  )
}
```

Hope you see some benefits in this list of features.

Happy coding…
