#' dados UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_dados_ui <- function(id){
  ns <- NS(id)
  tagList(
    reactable::reactableOutput(ns("dados")) %>% shinycssloaders::withSpinner(type = 4)
  )
}

#' dados Server Function
#'
#' @noRd
mod_dados_server <- function(id, dados, ...) {
  moduleServer(
    id,
    function(input, output, session) {
      output$dados <- reactable::renderReactable({
        reactable::reactable(dados, ...)
      })
    }
  )
}



## To be copied in the UI
# mod_dados_ui("dados_ui_1")

## To be copied in the server
# callModule(mod_dados_server, "dados_ui_1")

