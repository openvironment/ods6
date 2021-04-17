#' sobre_dados UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_sobre_dados_ui <- function(id){
  ns <- NS(id)
  div(
    class = "sobre",
    fluidRow(
      column(
        width = 12,
        p("Abaixo descrevemos as fontes e o processo de importação dos dados 
        utilizados neste projeto. Em seguida, também descrevemos o 
        processo de construção das bases que alimentam este painel."
        )
      ),
      bs4Dash::bs4TabCard(
        id = "sobre_fonte_dados",
        title = "Fonte de dados",
        width = 12,
        side = "right",
        closable = FALSE,
        collapsible = FALSE,
        bs4Dash::tabPanel(
          tabName = "IBGE",
          includeMarkdown(
            system.file("sobre_dados_ibge.md", package = "ods6")
          )
        ),
        bs4Dash::tabPanel(
          tabName = "SEADE",
          includeMarkdown(
            system.file("sobre_dados_seade.md", package = "ods6")
          )
        ),
        bs4Dash::tabPanel(
          tabName = "SNIS",
          includeMarkdown(
            system.file("sobre_dados_snis.md", package = "ods6")
          )
        )
      )
    ),
    br(),
    fluidRow(
      bs4Dash::bs4TabCard(
        id = "sobre_dados_construidos",
        title = "Bases construídas",
        width = 12,
        side = "right",
        closable = FALSE,
        collapsible = FALSE,
        bs4Dash::tabPanel(
          tabName = "Base agregada",
          includeMarkdown(
            system.file("sobre_dados_agregados.md", package = "ods6")
          )
        ),
        bs4Dash::tabPanel(
          tabName = "Base de indicadores",
          includeMarkdown(
            system.file("sobre_dados_indicadores.md", package = "ods6")
          )
        )
      )
    )
  )
}

#' sobre_dados Server Functions
#'
#' @noRd 
mod_sobre_dados_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
  })
}
