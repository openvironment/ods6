#' sobre_metodologia UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_sobre_metodologia_ui <- function(id){
  ns <- NS(id)
  div(
    class = "sobre sobre-metodologia",
    fluidRow(
      column(
        width = 12,
        p("Abaixo descrevemos a metolodia de cálculo de todos os 
          indicadores utilizados neste painel."
        )
      ),
      bs4Dash::bs4TabCard(
        id = "metodologia",
        title = "",
        width = 12,
        side = "left",
        closable = FALSE,
        collapsible = FALSE,
        bs4Dash::tabPanel(
          tabName = "Indicadores",
          includeMarkdown(
            system.file("sobre_met_indicadores.md", package = "ods6")
          )
        ),
        bs4Dash::tabPanel(
          tabName = "Fator de correção",
          includeMarkdown(
            system.file("sobre_met_fator.md", package = "ods6")
          )
        )
      )
    )
  )
}
    
#' sobre_metodologia Server Functions
#'
#' @noRd 
mod_sobre_metodologia_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    