#' Validator requiring non-emptiness.
#' 
#' @description
#' Will return FALSE if the input is NULL, an empty vector,
#' or an empty string ("") and FALSE otherwise.
#' 
#' @export
ValidatorNonEmpty <- function() {
    Validator$new(function(value) {
        return (value != "")
    }, "Field can not be empty.")
}


#' Validator requiring minimum length.
#' 
#' @description
#' Will return TRUE for strings longer than the minimum value.
#' 
#' @param minLength Minimum length of the input.
#'
#' @export
ValidatorMinLength <- function(minLength) {
    Validator$new(function(value) {
        return (nchar(value) >= minLength)
    }, paste0("Input too short (<", minLength, ")."))
}


#' Validator requiring maximum length.
#' 
#' @description 
#' Will return TRUE for strings longer than the maximum value.
#' 
#' @param maxLength Maximum length of the input.
#'
#' @export
ValidatorMaxLength <- function(maxLength) {
    Validator$new(function(value) {
        return (nchar(value) <= maxLength)
    }, paste0("Input too long (>", maxLength, ")."))
}


#' Validator requiring a input (e.g. checkbox).
#' 
#' @description
#' Will return FALSE if the input value is FALSE (e.g. like
#' for an unchecked textbox.)
#' @export
ValidatorRequired <- function() {
    Validator$new(function(value) {
        return(value)
    }, "Field required.")
}