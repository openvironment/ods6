#' sumario UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList uiOutput
mod_sumario_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("desfechos")) %>% shinycssloaders::withSpinner(type = 4)
  )
}

#' sumario Server Function
#'
#' @noRd
#' @importFrom shiny moduleServer renderUI h1
mod_sumario_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      output$desfechos <- renderUI({
        h1("Sum\u00e1rio")
      })
    }
  )
}

## To be copied in the UI
# mod_sumario_ui("sumario_ui_1")

## To be copied in the server
# callModule(mod_sumario_server, "sumario_ui_1")

