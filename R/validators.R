#' Validator requiring non-emptiness.
#' 
#' Will return FASLE if the input is NULL, an empty vector,
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
#' Will return TRUE for strings longer than the minimum value.
#' 
#' @export
ValidatorMinLength <- function(minLength) {
    Validator$new(function(value) {
        return (nchar(value) >= minLength)
    }, paste0("Input too short (<", minLength, ")."))
}


#' Validator requiring maximum length.
#' 
#' Will return TRUE for strings longer than the maximum value.
#' 
#' @export
ValidatorMaxLength <- function(maxLength) {
    Validator$new(function(value) {
        return (nchar(value) <= maxLength)
    }, paste0("Input too long (>", maxLength, ")."))
}


#' Validator requiring a input (e.g. checkbox).
#' 
#' Will return FALSE if the input value is FALSE (e.g. like
#' for an unchecked textbox.)
#' @export
ValidatorRequired <- function() {
    Validator$new(function(value) {
        return(value)
    }, "Field required.")
}