library(shiny)
library(R6)

#' Class representing a ShinyForm form.
#' 
#' @field id Unique form id which can be used with Shiny input.
#' @field elements A list of ShinyForm input elements.
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
        submit = NULL,

        initialize = function(id, submit, ...) {
            self$id <- id
            submit_id <- paste0(self$id, "-submit")
            self$submit <- shiny::actionButton(submit_id, label=submit)

            elems <- list(...)

            for (elem in elems) {
                if (inherits(elem, "shiny.tag")) {
                    tag <- elem
                } else {
                    stop(paste0("Element ", elem, " is not a shiny.tag!"))
                }

                tagId <- getInputId(tag)
                self$elements[[tagId]] <- tag
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
            for (tagId in names(self$elements)) {
                valid <- valid & local({
                    .valid <- TRUE
                    .tagId <- tagId
                    value <- self$getValue(input, .tagId)
                    output[[addValidationSuffix(.tagId)]] <- renderText("")

                    for (validator in attr(self$elements[[.tagId]], "validators")) {
                        if (!validator$check(value)) {
                            output[[addValidationSuffix(.tagId)]] <- renderText(validator$failMessage)
                            .valid <- FALSE
                            break
                        }
                    }
                    .valid
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


#' Appends a validation suffix to a string.
#' @param tagId ID of the tag.
#' @return A string `"{tagId}-shinyreforms-validation"`.
addValidationSuffix <- function(tagId) {
    return(paste0(tagId, "-shinyreforms-validation"))
}


#' Returns an ID of an input tag.
#' @param inputTag A shiny tag to retrieve the ID from.
getInputId <- function(inputTag) {
    if (!inherits(inputTag, "shiny.tag")) {
        return(NULL)
    }

    if ("id" %in% names(inputTag$attribs)) {
        return(inputTag$attribs[["id"]])
    }

    for (child in inputTag$children) {
        tagId <- getInputId(child)

        if (!is.null(tagId)) return(tagId)
    }

    return(NULL)
}
