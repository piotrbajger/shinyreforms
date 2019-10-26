# ShinyReforms
[![Build Status](https://travis-ci.com/piotrbajger/shinyreforms.svg?token=f2fdroCWHHtzKnXccRgX&branch=master)](https://travis-ci.com/piotrbajger/shinyreforms)

ShinyReforms package lets you add and validate Forms in your
Shiny application with an object-oriented interface.

## Installation

```r
# Install current version from GitHub:
# install.packages("devtools")
devtools::install_github("piotrbajger/shinyreforms")
```

## Examples

A minimum example app:

![ShinyReforms Example](https://i.imgur.com/bdC7joB.png "ShinyReforms Example")

```r
library(shiny)
library(shinyreforms)


# Define a form
myForm <- shinyreforms::ShinyForm$new(
    "myForm", 
    # Wrap a shiny input tag around validatedInput to add validators
    shinyreforms::validatedInput(
        shiny::textInput("name_input", label="Username"),
        helpText="Username length is between 4 and 12 characters.",  # Include a tooltip
        validators=c(
            shinyreforms::ValidatorMinLength(4),  # You can add pre-defined validators...
            shinyreforms::ValidatorMaxLength(12),
            shinyreforms::Validator$new(          # ... or define your own
                test=function(value) value != "test",
                failMessage="Username can't be 'test'!"
            )
        )
    ),
    # You can work with other inputs (e.g. checkboxInput)
    shinyreforms::validatedInput(
        shiny::checkboxInput("checkbox", label="I accept!"),
        validators=c(
            shinyreforms::ValidatorRequired()
        )
    ),
    submit=shiny::actionButton("submit", "Submit")
)


ui <- shiny::bootstrapPage(
    shinyreforms::shinyReformsPage(  # This adds a dependency on shinyreforms .css
        shiny::fluidPage(
            shiny::tags$h2("Here's a shinyreforms::ShinyForm!"),
            # You can include your form UI wherever inside your page!
            myForm$ui(),
            shiny::tags$h2("Validation result"),
            shiny::textOutput("result"),
        )
    )
)


server <- function(input, output, session) {
    # Submitting a form can be detected through submissionEvent
    shiny::observeEvent(myForm$submissionEvent(input), {
        # The form can then be validated
        if (myForm$validate(input, output)) {
            # And values can be retrieved from the form
            yourName <- myForm$getValue(input, "name_input")

            output$result <- shiny::renderText({
                paste0("Your name is '", yourName, "'.")
            })
        } else {
            output$result <- shiny::renderText("Form is not valid!")
        }
    })
}


shiny::shinyApp(ui=ui, server=server)
```