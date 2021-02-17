#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#'
#' @noRd
app_server <- function(input, output, session) {
  
  municipio_selecionado <- mod_select_munip_server(
    id = "select_munip_ui_1"
  )
  
  observe({
    shinyjs::toggle(
      id = "div_select_munip", 
      anim = TRUE,
      condition = stringr::str_detect(input$tabs, "munip_")
    )
  })
  
  mod_munip_resumo_server("munip_resumo_ui_1", municipio_selecionado)
  mod_munip_abast_server("munip_abast_ui_1", municipio_selecionado)
  
  # mod_sobre_server("sobre_ui_1")
  
}
