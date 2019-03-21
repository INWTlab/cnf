testthat::context("register")

testthat::test_that("basics", {
  cnf::register(
    test = list(a = 1, b = "b"),
    where = e <- new.env(parent = emptyenv())
  )
  testthat::expect_equal(getcnf("test", e)$a, 1)
  testthat::expect_equal(getcnf("test", e)$b, "b")
})

testthat::test_that("config override", {
  testthat::expect_warning(cnf::register(
    test = list(a = 1, b = "b"),
    test = list(c = 3, a = 2),
    where = e <- new.env(parent = emptyenv())
  ))
  testthat::expect_equal(getcnf("test", e)$a, 2)
  testthat::expect_equal(getcnf("test", e)$b, "b")
  testthat::expect_equal(getcnf("test", e)$c, 3)
  ## warn = FALSE
  testthat::expect_message(cnf::register(
    test = list(a = 1, b = "b"),
    test = list(c = 3, a = 2),
    where = new.env(parent = emptyenv()),
    warn = FALSE
  ))
  ## quiet = TRUE
  testthat::expect_silent(cnf::register(
    test = list(a = 1, b = "b"),
    test = list(c = 3, a = 2),
    where = new.env(parent = emptyenv()),
    quiet = TRUE
  ))
})

testthat::test_that("use a file", {
  fileName <- system.file("test-cnf.R", package = "cnf", mustWork = TRUE)
  cnf::register(
    test = fileName,
    where = e <- new.env(parent = emptyenv())
  )
  testthat::expect_equal(getcnf("test", e)$a, 1)
  testthat::expect_equal(getcnf("test", e)$b, "b")
})

testthat::test_that("maybe: can fail", {
  testthat::expect_error(
    cnf::register(
      test = list(a = 1),
      test = "", # fails
      where = new.env(parent = emptyenv()),
      maybe = FALSE
    ),
    "No such file"
  )
  testthat::expect_warning(
    cnf::register(
      test = list(a = 1),
      test = "", # fails
      where = e <- new.env(parent = emptyenv()),
      maybe = TRUE,
      warn = TRUE
    ),
    "No such file"
  )
  testthat::expect_equal(getcnf("test", e)$a, 1)
  testthat::expect_message(
    cnf::register(
      test = list(a = 1),
      test = "", # fails
      where = e <- new.env(parent = emptyenv()),
      maybe = TRUE,
      warn = FALSE
    ),
    "No such file"
  )
  testthat::expect_equal(getcnf("test", e)$a, 1)
  testthat::expect_silent(cnf::register(
    test = list(a = 1),
    test = "", # fails
    where = e <- new.env(parent = emptyenv()),
    maybe = TRUE,
    quiet = TRUE
  ))
  testthat::expect_equal(getcnf("test", e)$a, 1)
})

