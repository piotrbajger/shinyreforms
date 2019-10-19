library(R6)


#' 
#' @export
Validator <- R6Class(
    "Validator",

    public = list(
        test = NULL,
        failMessage = "",

        initialize = function(test, failMessage) {
            self$test <- test
            self$failMessage <- failMessage
        },

        check = function(value) {
            return(self$test(value))
        }
    )
)