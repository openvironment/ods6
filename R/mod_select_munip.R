#' select_munip UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_select_munip_ui <- function(id){
  ns <- NS(id)
  div(
    id = "div_select_munip",
    class = "seletor-munip",
    fluidRow(
      column(
        width = 9,
        selectInput_munip(id = ns("select_munip"), width = "100%")
      ),
      column(
        width = 3,
        uiOutput(ns("tag_turistico"))
      )
    )
  )
}
    
#' select_munip Server Functions
#'
#' @noRd 
mod_select_munip_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    output$tag_turistico <- renderUI({
      turistico <- base_indicadores %>% 
        dplyr::filter(munip_nome == input$select_munip) %>% 
        dplyr::pull(munip_turistico) %>% 
        dplyr::first()
      
      if (turistico == "sim") {
        htmltools::span(class = "tag-turistico", "Município turístico")
      }
    })
    
    return(reactive(input$select_munip))
    
  })
}
    
