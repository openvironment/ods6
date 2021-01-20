#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#'
#' @noRd
app_server <- function( input, output, session ) {

  mod_informacoes_gerais_server("informacoes_gerais_ui_1")
  mod_visao_cidade_server("visao_cidade_ui_1")
  # mod_sobre_server("sobre_ui_1")
  
}
