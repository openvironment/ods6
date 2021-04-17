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
  tagList(
 
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
    
## To be copied in the UI
# mod_sobre_metodologia_ui("sobre_metodologia_ui_1")
    
## To be copied in the server
# mod_sobre_metodologia_server("sobre_metodologia_ui_1")
