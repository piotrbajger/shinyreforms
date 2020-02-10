#' Constructs a shinyreforms dependency.
shinyReformsDependency <- function() {
    list(htmltools::htmlDependency(
        "shinyreforms",
        as.character(utils::packageVersion("shinyreforms")),
        c(file=system.file(package="shinyreforms")),
        stylesheet="shinyreforms.css"
    ))
}

#' Adds a shinyreforms dependency to a tag object.
#'
#' @param htmlTag A shiny HTML tag.
#' 
#' @examples 
#' \dontrun{
#' shinyReformsPage(shiny::fluidPage(...))
#' }
#' @export
shinyReformsPage <- function(htmlTag) {
    dependency <- shinyReformsDependency()

    old <- attr(htmlTag, "html_dependencies", TRUE)

    htmltools::htmlDependencies(htmlTag) <- c(old, dependency)
    htmlTag
}