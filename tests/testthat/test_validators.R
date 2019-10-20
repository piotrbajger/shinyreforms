context("Test built-in Validators.")
library(shinyforms)


test_that("ValidatorNonEmpty works", {
    validator <- ValidatorNonEmpty()

    expect_true(validator$check("Some value!"))
    expect_false(validator$check(NULL))
    expect_false(validator$check(character(0)))
})


test_that("ValidatorMinLength works", {
    validator <- ValidatorMinLength(5)

    expect_true(validator$check("12345"))
    expect_false(validator$check("1234"))
    expect_false(validator$check(""))
    expect_false(validator$check(NULL))
    expect_false(validator$check(character(0)))
})


test_that("ValidatorMaxLength works", {
    validator <- ValidatorMaxLength(5)

    expect_true(validator$check("12345"))
    expect_true(validator$check(""))
    expect_false(validator$check("123456"))
    expect_false(validator$check(NULL))
    expect_false(validator$check(character(0)))
})
