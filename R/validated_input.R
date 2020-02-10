#' Add validator to a Shiny input.
#' 
#' @description
#' Use to create shiny input tags with validation.
#' This should only be used in ShinyForm constructor.
#' 
#' @details
#' The Shiny tag receives an additional attribute `validators`
#' which is a vector of `Validator` objects.
#' 
#' @param tag Tag to be modified.
#' @param helpText Tooltip text. If NULL, no tooltip will be added.
#' @param validators A vector of `Validator` objects.
#' 
#' @return A modified shiny input tag with attached validators
#'   and an optional tooltip div.
#' 
#' @examples
#' shinyreforms::validatedInput(
#'     shiny::textInput("text_input", label="Username"),
#'     helpText="Username must have length between 4 and 12 characters.",
#'     validators=c(
#'         shinyreforms::ValidatorMinLength(4),
#'         shinyreforms::ValidatorMaxLength(12)
#'     )
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
        tag <- addHelpText(tag, helpText)
    }

    # Set validators for an input
    attr(tag, "validators") <- validators
    return(tag)
}


#' Adds a help icon to an input.
#' 
#' @description
#' Internal function which adds a shinyreforms pop-up
#' with help text to a shiny inputTag. The helptext
#' is a div which gets appended to the label for the
#' given input.
#' 
#' @param tag A tag to be modified.
#' @param helpText Help text to be added.
#' @param updated An internal parameter which is used in
#'   recurrent calls to the function.
#' 
#' @examples
#' addHelpText(
#'   shiny::textInput("text_input", label="Label"),
#'   helpText="Tooltip"
#' )
#' 
#' @return A modified Shiny tag with a shinyreforms help icon.
#' @export
addHelpText <- function(tag, helpText, updated=FALSE) {
    if (updated) {
        return (tag)
    }

    to_search = paste0("^<label")
    isLabelForInput <- grepl(to_search, toString(tag))

    if (isLabelForInput) {
        nChildren <- length(tag$children)
        tag$children[[nChildren + 1]] <- createHelpIcon(helpText)
        return(tag)
    }

    nChildren <- length(tag$children)

    if (nChildren == 0){
        return(tag)  
    }

    for (i in 1:nChildren) {
        tag$children[[i]] <- addHelpText(
            tag$children[[i]], helpText, updated
        )

        has_validation <- grepl(
            "class=\"shinyreforms-validation", toString(tag$children[[i]])
        )

        updated <- updated | has_validation
    }

    return(tag)
}


#' Creates a shinyreforms help icon and pop-up.
#' 
#' @param helpText A tooltip to be displayed.
#' 
#' @return A shiny div with an icon and pop-up tooltip.
#' 
#' @export
createHelpIcon <- function(helpText) {
    shiny::tags$div(class="shinyreforms-tooltip",
        shiny::icon("question-sign", lib="glyphicon"),
        shiny::tags$div(class="shinyreforms-tooltip-text",
            helpText
        )
    )
}

