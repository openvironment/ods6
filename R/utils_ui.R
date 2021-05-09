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
    selected = "São Paulo",
    choices = municipios,
    width = width
  )
}

valueDiv <- function(label, ..., classe = "", icon = NULL, 
                     tooltip_class = NULL) {
  if (!is.null(tooltip_class)) {
    sobre <- icon(
      "question-circle", 
      class = paste("about-icon", tooltip_class, collapse = " ")
    )
  } else {
    sobre <- NULL
  }
  
  if (!is.null(icon)) {
    icone <- icon(icon)
  } else {
    icone <- NULL
  }
  
  htmltools::div(
    class = paste("valueDiv", classe, collapse = " "),
    htmltools::span(class = "valueDiv-label", label),
    sobre,
    htmltools::hr(align = "left"),
    htmltools::span(class = "valueDiv-icon", icone),
    htmltools::div(class = "valueDiv-value", ...)
  )
}

card_indicadores <- function(...) {
  bs4Dash::bs4Card(
    width = 12,
    closable = FALSE,
    collapsible = FALSE,
    headerBorder = FALSE,
    ...
  )
}

tabCard_indicadores <- function(id, ...) {
  bs4Dash::bs4TabCard(
    id = id,
    title = "",
    width = 12,
    closable = FALSE,
    collapsible = FALSE,
    headerBorder = FALSE,
    ...
  )
}

simple_value_box <- function(titulo, valor, unidade = "", alerta = NULL) {
  tagList(
    div(
      class = "meta-ind",
      tags$h4(titulo),
      span(class = "meta-ind-valor", valor), 
      span(class = "meta-ind-unidade", unidade)
    ),
    div(
      class = "ods-ind-alerta",
      alerta
    )
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
        class = "d-flex align-items-center",
        width = 4,
        div(
          class = "valor-incons text-center w-100 fs-1_5em",
          valor
        )
      )
    )
  )
}
