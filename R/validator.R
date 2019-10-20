library(R6)


#' 
#' @export
Validator <- R6Class(
    "Validator",

    public = list(
        test = NULL,
        failMessage = "",

        initialize = function(test, failMessage) {
            # Wrap the test function up to check for emptyness first
            self$test <- function(value) {
                if (is.null(value)) return(FALSE)
                if (length(value) == 0) return(FALSE)

                return(test(value))
            }

            self$failMessage <- failMessage
        },

        check = function(value) {
            return(self$test(value))
        }
    )
)