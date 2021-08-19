#' select_ugrhi UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_select_ugrhi_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      id = "div_select_ugrhi",
      style = "display: none;",
      class = "seletor-munip",
      column(
        width = 6,
        selectInput(
          inputId = ns("ugrhi"),
          label = "Você está vendo dados de",
          choices = sort(unique(base_ugrhi$nome)),
          width = "100%"
        )
      )
    ),
    br()
  )
}
    
#' select_ugrhi Server Functions
#'
#' @noRd 
mod_select_ugrhi_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    return(reactive(input$ugrhi))
 
  })
}
    
## To be copied in the server
# mod_select_ugrhi_server("select_ugrhi_ui_1")
