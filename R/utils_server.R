`%$%` <- magrittr::`%$%`

`%||%` <- purrr::`%||%`

empty_to_na <- function(x) {
  ifelse(shiny::isTruthy(x), x, NA)
}
