library(R6)


#' Class representing a Validator.
#' 
#' @description 
#' Validators are used to validate input fields in a ShinyForm.
#' Validators are to be used with the validatedInput function.
#' A single input field can have several validators.
#' 
#' @usage
#' Validator(function(value) {...}, "Validation failed!")
#' 
#' @field test Function returning a boolean value which will be used
#'   to validate input.
#' @field failMessage Error message to display when validation fails.
#' 
#' @details
#' Package shinyformss defines a set of commonly used pre-defined
#' Validators. These include:
#' \describe{
#'  \item{ValidatorMinLength(minLength):}{Will fail if string is shorter than minLength.}
#'  \item{ValidatorMaxLength(maxLength):}{Will fail if string is longer than maxLength.}
#'  \item{ValidatorNonEmpty():}{Will fail if string is empty.}
#' }
#' 
#' @name Validator
NULL

#' @importFrom R6 R6Class
#' @export
Validator <- R6Class(
    "Validator",

    public = list(
        test = NULL,
        failMessage = "",

        initialize = function(test, failMessage) {
            # Wrap the test function up to check for emptyness first
            self$test <- function(value) {
                if (is.null(value)) return(FALSE)
                if (length(value) == 0) return(FALSE)

                return(test(value))
            }

            self$failMessage <- failMessage
        },

        check = function(value) {
            return(self$test(value))
        }
    )
)