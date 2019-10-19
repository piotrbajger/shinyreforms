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
#'  \item{ui Returns a list of shiny tags corresponding to the form.}
#'  \item{validate Returns TRUE or FALSE based on from validation.}
#'  \item{submission A form submission event to be used with shiny::observeEvent.}
#' }
#' 
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
            shiny::reactive({
                valid <- TRUE
                for (tagId in names(self$elements)) {
                    value <- input[[tagId]]
                    output[[addValidationSuffix(tagId)]] <- renderText("")

                    for (validator in self$validators[[tagId]]) {
                        if (!validator$check(value)) {
                            output[[addValidationSuffix(tagId)]] <- renderText(validator$failMessage)
                            valid <- FALSE
                            break
                        }
                    }
                }

                return(valid)
            })
        },

        submission = function(input) {
            input[[self$submit$attribs$id]]
        }
    ),

    private = list(
    )
)



#' Use to create shiny input tags with validation.
#' This should only be used in ShinyForm constructor.
#' 
#' @example 
#' my_form <- shinyforms::ShinyForm$new(
#'     "my_form", 
#'     shinyforms::validatedInput(
#'         shiny::textInput("text_input", label="Username"),
#'         shinyforms::ValidatorMinLength(4),
#'         shinyforms::ValidatorMaxLength(12)
#'     ),
#'     submit=shiny::actionButton("submit", "Submit")
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
    return(paste0(tagId, "-shinyforms-validation"))
}


#' Returns an id of an input tag.
getInputId <- function(input_tag) {
    if ("id" %in% names(input_tag$attribs)) {
        return(input_tag$attribs[["id"]])
    }

    return(input_tag$children[[1]]$attribs[["for"]])
}
