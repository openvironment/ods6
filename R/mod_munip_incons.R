#' munip_incons UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_munip_incons_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 12
      )
    ),
    fluidRow(
      bs4Dash::bs4Card(
        title = "1. Indicador de acesso a água maior que 100%",
        width = 12,
        closable = FALSE,
        fluidRow(
          column(
            width = 8,
            span("Indicador", style = "font-weight: bold;"),
            span(": Proporção da população que utiliza 
      serviços de água potável gerenciados de forma segura."),
            br(),
            br(),
            span(
              "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", style = "font-size: 0.9em;"
            )
          ),
          column(
            width = 4,
            bs4Dash::valueBox(value = 100, subtitle = "Abastecimento", width = 12)
          )
        )
      )
    )
  )
}
    
#' munip_incons Server Functions
#'
#' @noRd 
mod_munip_incons_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_munip_incons_ui("munip_incons_ui_1")
    
## To be copied in the server
# mod_munip_incons_server("munip_incons_ui_1")
