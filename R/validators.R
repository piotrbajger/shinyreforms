#' Validator requiring non-emptiness.
#'
#' @description
#' The validator will return FALSE if the input is NULL, an empty
#' vector, or an empty string ("") and FALSE otherwise.
#'
#' @return A `Validator` to check if an input is non-empty.
#' @export
ValidatorNonEmpty <- function() {
  Validator$new(function(value) {
    return(value != "")
  }, "Field can not be empty.")
}


#' Validator requiring minimum length.
#'
#' @description
#' Will return TRUE for strings longer than the minimum value.
#'
#' @return A `Validator` checking that the input value is of length at
#'  least \code{minLength}.
#' @param minLength Minimum length of the input.
#'
#' @export
ValidatorMinLength <- function(minLength) {
  Validator$new(function(value) {
    return(nchar(value) >= minLength)
  }, paste0("Input too short (<", minLength, ")."))
}


#' Validator enforcing maximum length.
#'
#' @description
#' Will return TRUE for strings longer than the maximum value.
#'
#' @return A `Validator` checking that the input value does not exceed
#'  \code{maxLength}.
#' @param maxLength Maximum length of the input.
#'
#' @export
ValidatorMaxLength <- function(maxLength) {
  Validator$new(function(value) {
    return(nchar(value) <= maxLength)
  }, paste0("Input too long (>", maxLength, ")."))
}


#' Validator requiring a input (e.g. checked checkbox).
#'
#' @description
#' Will return FALSE if the input value is FALSE (e.g. like
#' for an unchecked textbox.)
#' @return A validator which checks that the value is present.
#' @export
ValidatorRequired <- function() {
  Validator$new(function(value) {
    return(value)
  }, "Field required.")
}
