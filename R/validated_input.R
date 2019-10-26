library(R6)

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
validatedInput <- function(tag, helpText=NULL, validators=c()) {
    tagId <- getInputId(tag)

    # Appends a div to do display validation result
    validationResultDiv <- shiny::tags$div(
        id=addValidationSuffix(tagId),
        class="shiny-text-output text-danger"
    )
    tag$children[[length(tag$children) + 1]] <- validationResultDiv

    # If helpIcon is not NULL, append an icon to the label.
    if (!is.null(helpText)) {
        nChildren = length(tag$children[[1]]$children)
        tag$children[[1]]$children[[nChildren + 1]] <- createHelpIcon(helpText)
    }

    # Set validators for an input
    attr(tag, "validators") <- validators

    return(tag)
}


createHelpIcon <- function(helpText) {
    shiny::tags$div(class="shinyreforms-tooltip",
        shiny::icon("question-sign", lib="glyphicon"),
        shiny::tags$div(class="shinyreforms-tooltip-text",
            helpText
        )
    )
}