vertical_scroll_div <- function(height, ...) {
  tags$div(
    style = paste0("overflow-y: scroll; height: ", height, "px;"),
    ...
  )
}

selectInput_munip <- function(id, width = NULL) {
  selectInput(
    inputId = id,
    label = "Você está vendo dados de",
    selected = "Amparo",
    choices = municipios,
    width = width
  )
}

valueDiv <- function(label, icon, ...) {
  htmltools::div(
    class = "valueDiv",
    htmltools::span(label),
    icon,
    htmltools::hr(),
    ...
  )
}