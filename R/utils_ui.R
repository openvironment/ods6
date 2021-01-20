#' @importFrom shiny column
col_3 <- function(...){
  column(3, ...)
}

#' @importFrom shiny column
col_5 <- function(...){
  column(5, ...)
}

#' @importFrom shiny column
col_7 <- function(...){
  column(7, ...)
}

#' @importFrom shiny column
col_9 <- function(...){
  column(9, ...)
}

vertical_scroll_div <- function(height, ...) {
  tags$div(
    style = paste0("overflow-y: scroll; height: ", height, "px;"),
    ...
  )
}