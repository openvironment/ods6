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

card_indicadores <- function(id, ...) {
  bs4Dash::bs4TabCard(
    id = id,
    width = 12,
    closable = FALSE,
    collapsible = FALSE,
    headerBorder = FALSE,
    title = "",
    ...
  )
}

simple_value_box <- function(titulo, valor, unidade = "") {
  div(
    class = "meta-ind",
    tags$h4(titulo),
    span(class = "meta-ind-valor", valor), 
    span(class = "meta-ind-unidade", unidade)
  )
}

card_inconsistencia <- function(titulo, desc_ind, desc_validacao, valor,
                                status) {
  bs4Dash::bs4Card(
    title = titulo,
    width = 12,
    status = status,
    closable = FALSE,
    fluidRow(
      column(
        width = 8,
        span("Indicador", style = "font-weight: bold;"),
        span(": ", desc_ind), class = "incons-desc-indicador",
        br(),
        br(),
        span(desc_validacao, class = "incons-desc-validacao")
      ),
      column(
        width = 4,
        valor
      )
    )
  )
}
