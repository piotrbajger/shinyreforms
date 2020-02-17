context("Test user-defined Validators.")
library(shinyreforms)


test_that("ValidatorNonEmpty works", {
  anythingButTestValidator <- Validator$new(function(value) {
    return(value != "test")
  }, "Please input *anything* but test!")

  expect_true(anythingButTestValidator$check("Some value!"))
  expect_false(anythingButTestValidator$check("test"))
})
