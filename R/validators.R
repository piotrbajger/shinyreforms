#' Validator requiring non-emptiness.
#' 
#' Will return FASLE if the input is NULL, an empty vector,
#' or an empty string ("") and FALSE otherwise.
#' 
#' @export
ValidatorNonEmpty <- function() {
    Validator$new(function(value) {
        if (is.null(value)) return(FALSE)
        if (length(value) == 0) return(FALSE)

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
        if (is.null(value)) return(FALSE)
        if (length(value) == 0) return(FALSE)

        return (nchar(value) >= minLength)
    }, paste0("Input too short (<", minLength, ")."))
}


#' Validator requiring minimum length.
#' 
#' Will return TRUE for strings longer than the minimum value.
#' 
#' @export
ValidatorMaxLength <- function(maxLength) {
    Validator$new(function(value) {
        if (is.null(value)) return(FALSE)
        if (length(value) == 0) return(FALSE)

        return (nchar(value) <= maxLength)
    }, paste0("Input too long (>", maxLength, ")."))
}