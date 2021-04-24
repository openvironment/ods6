#' sobre_projeto UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_sobre_projeto_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 12,
        includeMarkdown(
          system.file("sobre_projeto.md", package = "ods6")
        )
      )
    )
  )
}
    
#' sobre_projeto Server Functions
#'
#' @noRd 
mod_sobre_projeto_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
