context("Test that validators are correctly appended to all kinds of inputs.")
library(shiny)
library(shinyreforms)


# Dummy validator for testing
.testValidator = function(val) NULL


test_that("Validate shiny::textInput", {
    testInput <- shiny::textInput("text_input", label="Test")

    newInput <- validatedInput(
        testInput,
        helpText="dummy",
        validators=c(.testValidator)
    )

    expect_equal(length(attr(newInput, "validators")), 1)
    expect_true(grepl("dummy", toString(newInput)))
    expect_true(grepl("shinyreforms-validation", toString(newInput)))
})


test_that("Validate shiny::checkboxInput", {
    testInput <- shiny::checkboxInput("input_checkbox", label="Test")

    newInput <- validatedInput(
        testInput,
        helpText="dummy",
        validators=c(.testValidator)
    )

    expect_equal(length(attr(newInput, "validators")), 1)
    expect_true(grepl("dummy", toString(newInput)))
    expect_true(grepl("shinyreforms-validation", toString(newInput)))
})
 
 
test_that("Validate shiny::checkboxGroupInput", {
    testInput <- shiny::checkboxGroupInput(
        "input_checkbox_group",
        label="Test",
        choices=list("A"=1, "B"=2, "C"=3)
    )

    newInput <- validatedInput(
        testInput,
        helpText="dummy",
        validators=c(.testValidator)
    )

    expect_equal(length(attr(newInput, "validators")), 1)
    expect_true(grepl("dummy", toString(newInput)))
    expect_true(grepl("shinyreforms-validation", toString(newInput)))
})


test_that("Validate shiny::numericInput", {
    testInput <- shiny::numericInput(
        "input_numeric",
        label="Test",
        10
    )

    newInput <- validatedInput(
        testInput,
        helpText="dummy",
        validators=c(.testValidator)
    )

    expect_equal(length(attr(newInput, "validators")), 1)
    expect_true(grepl("dummy", toString(newInput)))
    expect_true(grepl("shinyreforms-validation", toString(newInput)))
})