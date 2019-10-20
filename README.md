# shinyreforms
[![Build Status](https://travis-ci.com/piotrbajger/shinyreforms.svg?token=f2fdroCWHHtzKnXccRgX&branch=master)](https://travis-ci.com/piotrbajger/shinyreforms)

shinyreforms package lets you add and validate Forms in your
Shiny application with an object-oriented interface.

## Installation

```r
# Install current version from GitHub:
# install.packages("devtools")
devtools::install_github("piotrbajger/shinyreforms")
```

## Examples

A minimum example app:

```r
library(shiny)
library(shinyreforms)


# Create a form
myForm <- shinyreforms::ShinyForm$new(
    "myForm", 
    # Wrap the shiny input widgets in validatedInput.
    shinyreforms::validatedInput(
        shiny::textInput("name_input", label="Username"),
        shinyreforms::ValidatorMinLength(4),  # You can use built-in validators, or define your own.
        shinyreforms::ValidatorMaxLength(12)
    ),
    submit=shiny::actionButton("submit", "Submit")
)


ui <- shiny::bootstrapPage(
    shiny::fluidPage(
        shiny::tags$h2("Here's a shinyreforms::ShinyForm!"),
        # Include form in the ui
        myForm$ui(),
        shiny::tags$h2("Validation result"),
        shiny::textOutput("result")
    )
)


server <- function(input, output, session) {
    # Form submission can be captured through myForm$submissionEvent.
    shiny::observeEvent(myForm$submissionEvent(input), {
        # Then the input can be validated...
        if (myForm$validate(input, output)) {
            output$result <- shiny::renderText({
                # ... and the fields can be accessed by their id.
                yourName <- myForm$getValue(input, "name_input")
                paste0("Your name is '", yourName, "'.")
            })
        } else {
            output$result <- shiny::renderText("Form is not valid!")
        }
    })
}


shiny::shinyApp(ui=ui, server=server)
```