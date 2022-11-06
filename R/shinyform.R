#' Class representing a ShinyForm form.
#'
#' @description
#' ShinyForm can be used to include forms in your website. Create
#' a \code{ShinyForm} object anywhere in your application by
#' defining all the inputs (possibly adding validators) and by
#' specifying callback \code{onSuccess} and \code{onError} functions.
#'
#' @field id Unique form id which can be used with Shiny input.
#' @field elements A list of ShinyForm input elements.
#' @field onSuccess A function with to be run on valid submission,
#'  see details.
#' @field onError A function with to be run on invalid submission,
#'  see details.
#' @field submit A submit Action button/link.
#'
#' @details
#' Parameters \code{onSuccess} and \code{onError} passed to the constructor
#' should be functions with signatures \code{function(self, input, output)},
#' where `self` will refer to the form itself, while \code{input} and
#' \code{output} will be the usual Shiny objects.
#'
#' @name ShinyForm
#' @importFrom R6 R6Class
#' @import shiny
#' @export
ShinyForm <- R6Class(
  "ShinyForm",
  public = list(
    id = character(0),
    onSuccess = NULL,
    onError = NULL,
    elements = list(),
    submit = NULL,

    #' @description
    #' Initialises a ShinyForm.
    #' @param id Unique form identifier.
    #' @param submit Submit button label.
    #' @param onSuccess Function to be ran on successful validation.
    #' @param onError Function to be ran on unsuccesful validation.
    #' @param ... A list of validated Shiny inputs.
    initialize = function(id, submit, onSuccess, onError, ...) {
      self$id <- id
      submit_id <- paste0(self$id, "-submit")
      self$submit <- shiny::actionButton(submit_id, label = submit)

      self$onSuccess <- onSuccess
      self$onError <- onError

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

    #' @description
    #' Returns the form's UI. To be used inside your
    #' App's UI.
    ui = function() {
      shiny::tagList(
        self$elements,
        self$submit
      )
    },

    #' @description
    #' Form logic. To be inserted into your App's server function.
    #'
    #' Will validate form upon hitting the "Submit" button
    #' and run the `onSuccess` or `onError` function depending
    #' on whether the form is valid.
    #'
    #' @param input Shiny input.
    #' @param output Shiny output.
    server = function(input, output) {
      shiny::observeEvent(input[[self$submit$attribs$id]], {
        if (private$validate(input, output)) {
          self$onSuccess(self, input, output)
        } else {
          self$onError(self, input, output)
        }
      })
    },

    #' @description
    #' Returns value of the input element with a given ID.
    #' @param input Shiny input.
    #' @param inputId ID of the input whose value is to be returned.
    getValue = function(input, inputId) {
      if (!(inputId %in% names(self$elements))) {
        shiny::safeError(paste0("Id ", inputId, " is not a valid Id for ", self$id, "."))
      }
      shiny::isolate(input[[inputId]])
    }
  ),

  private = list(
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
#' @return ID of an input tag.
#' @param inputTag A shiny tag to retrieve the ID from.
getInputId <- function(inputTag) {
  if (!inherits(inputTag, "shiny.tag")) {
    return(NULL)
  }

  if (inputTag$name == "input") {
    return(inputTag$attribs[["id"]])
  }

  for (child in inputTag$children) {
    tagId <- getInputId(child)

    if (!is.null(tagId)) {
      return(tagId)
    }
  }

  return(NULL)
}
