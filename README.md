# ShinyForms
[![Build Status](https://travis-ci.com/piotrbajger/shinyforms.svg?token=f2fdroCWHHtzKnXccRgX&branch=master)](https://travis-ci.com/piotrbajger/shinyforms)

ShinyForms package lets you add and validate Forms in your
Shiny application with an object-oriented interface.

## Instalation

```r
# Install current version from GitHub:
# install.packages("devtools")
devtools::install_github("piotrbajger/shinyforms")
```

## Examples

A minimum example app:

```r
library(shiny)
library(shinyforms)


# Create a form
myForm <- shinyforms::ShinyForm$new(
    "myForm", 
    shinyforms::validatedInput(
        shiny::textInput("name_input", label="Username"),
        shinyforms::ValidatorMinLength(4),
        shinyforms::ValidatorMaxLength(12)
    ),
    submit=shiny::actionButton("submit", "Submit")
)


ui <- shiny::bootstrapPage(
    shiny::fluidPage(
        shiny::tags$h2("Here's a shinyforms::ShinyForm!"),
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


shiny::shinyApp(ui=ui, server=server
```