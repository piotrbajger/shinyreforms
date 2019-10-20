library(shiny)
library(R6)

#' Class representing a ShinyForm form.
#' 
#' @field id Unique form id which can be used with Shiny input.
#' @field elements A list of ShinyForm input elements.
#' @field validators A list of Validators used to validate each field.
#' @field submit A submit Action button/link.
#' 
#' @section Methods:
#' \describe{
#' \item{ui():}{Returns a list of shiny tags corresponding to the form.}
#' \item{validate(input, output):}{Returns TRUE or FALSE based on from
#'      validation. Displays error messages for fields which did not pass
#'      validation.}
#' \item{submissionEvent(input):}{A form submission event to be used with shiny::observeEvent.}
#' \item{getValue(input, inputId):}{Returns the value of a form element with a given id.}
#' }
#' 
#' @name ShinyForm
NULL


#' @importFrom R6 R6Class
#' @export
ShinyForm <- R6Class(
    "ShinyForm",

    public = list(
        id = character(0),
        elements = list(),
        validators = list(),
        submit = NULL,

        initialize = function(id, ..., submit) {
            self$id <- id
            self$submit <- submit

            elems <- list(...)

            for (elem in elems) {
                if (inherits(elem, "shiny.tag")) {
                    tag <- elem
                } else if (inherits(elem$tag, "shiny.tag")) {
                    tag <- elem$tag
                } else {
                    stop(paste0("Element ", elem, " is not a shiny.tag!"))
                }

                tagId <- getInputId(tag)
                self$elements[[tagId]] <- tag
                self$validators[[tagId]] <- elem$validators 
            }
        },

        ui = function() {
            shiny::tagList(
                self$elements,
                self$submit
            )
        },

        validate = function(input, output) {
            valid <- TRUE
            for (.tagId in names(self$elements)) {
                local({
                    tagId <- .tagId
                    value <- self$getValue(input, tagId)
                    output[[addValidationSuffix(tagId)]] <- renderText("")

                    for (validator in self$validators[[tagId]]) {
                        if (!validator$check(value)) {
                            output[[addValidationSuffix(tagId)]] <- renderText(validator$failMessage)
                            valid <- FALSE
                            break
                        }
                    }
                })
            }

            return(valid)
        },

        submissionEvent = function(input) {
            input[[self$submit$attribs$id]]
        },

        getValue = function(input, inputId) {
            if ( !(inputId %in% names(self$elements)) ) {
                shiny::safeError(paste0("Id ", inputId, " is not a valid Id for ", self$id, "."))
            }
            shiny::isolate(input[[inputId]])
        }
    )
)



#' Use to create shiny input tags with validation.
#' This should only be used in ShinyForm constructor.
#' 
#' @examples
#' shinyreforms::validatedInput(
#'     shiny::textInput("text_input", label="Username"),
#'     shinyreforms::ValidatorMinLength(4),
#'     shinyreforms::ValidatorMaxLength(12)
#' )
#' @export
validatedInput <- function(tag, ...) {
    validators <- list(...)

    tagId <- getInputId(tag)
    validationResult <- shiny::tags$div(
        id=addValidationSuffix(tagId),
        class="shiny-text-output text-danger"
    )

    tag$children[[length(tag$children) + 1]] <- validationResult

    result <- list()
    result$tag <- tag
    result$validators <- validators

    return(result)
}


#' Appends a validation suffix to a string.
addValidationSuffix <- function(tagId) {
    return(paste0(tagId, "-shinyreforms-validation"))
}


#' Returns an id of an input tag.
getInputId <- function(input_tag) {
    if (!inherits(input_tag, "shiny.tag")) {
        return(NULL)
    }

    if ("id" %in% names(input_tag$attribs)) {
        return(input_tag$attribs[["id"]])
    }

    for (child in input_tag$children) {
        tagId <- getInputId(child)

        if (!is.null(tagId)) return(tagId)
    }

    return(NULL)
}

