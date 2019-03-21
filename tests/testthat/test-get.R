testthat::context("getcnf")

testthat::test_that("basics", {
  cnf::register(
    test = list(a = 1, b = "b"),
    where = e <- new.env(parent = emptyenv())
  )
  testthat::expect_equal(getcnf("test", where = e), list(a = 1, b = "b"))
})

testthat::test_that("error when config is missing", {
  testthat::expect_error(
    getcnf("test", where = new.env(parent = emptyenv())),
    "'test' is not a registered configuration"
  )
})
