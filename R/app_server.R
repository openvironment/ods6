#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#'
#' @noRd
app_server <- function( input, output, session ) {
  
  observe({
    shinyjs::toggle(
      id = "div_select_munip", 
      anim = TRUE,
      condition = stringr::str_detect(input$tabs, "munip_")
    )
  })
  
  municipio_selecionado <- reactive({
    input$select_munip
  })
  
  mod_munip_resumo_server(
    "munip_resumo_ui_1", 
    municipio_selecionado
  )
  
  # mod_informacoes_gerais_server("informacoes_gerais_ui_1")
  # mod_visao_cidade_server("visao_cidade_ui_1")
  # mod_sobre_server("sobre_ui_1")
  
}
