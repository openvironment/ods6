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
  
  observe(priority = 1,{
    shinyjs::toggle(
      id = "div_select_munip", 
      anim = FALSE,
      condition = stringr::str_detect(input$tabs, "munip_")
    )
  })
  
  ugrhi <- mod_select_ugrhi_server("select_ugrhi_ui_1")
  
  observe(priority = 2, {
    shinyjs::toggle(
      id = "div_select_ugrhi", 
      anim = FALSE,
      condition = stringr::str_detect(input$tabs, "ugrhi_")
    )
  })
  
  base_filtrada <- reactive({
    base_indicadores %>% 
      dplyr::filter(munip_nome == municipio_selecionado())
  })
  
  base_filtrada_contemp <- reactive({
    base_filtrada() %>% 
      dplyr::filter(ano == max(ano))
  })
  
  tab_incons <- reactive({
    verificar_inconsistencias(base_filtrada_contemp, base_filtrada)
  })
  
  mod_munip_resumo_server(
    "munip_resumo_ui_1",
    municipio_selecionado,
    tab_incons
  )
  
  mod_munip_abast_server(
    "munip_abast_ui_1",
    base_filtrada, 
    base_filtrada_contemp
  )
  
  mod_munip_esgot_server(
    "munip_esgot_ui_1",
    base_filtrada,
    base_filtrada_contemp
  )
  
  mod_munip_trat_esgoto_server(
    "munip_trat_esgoto_ui_1",
    base_filtrada,
    base_filtrada_contemp
  )
  
  mod_munip_incons_server(
    "munip_incons_ui_1",
    base_filtrada,
    tab_incons
  )
  
  mod_munip_uso_eficiente_server(
    "munip_uso_eficiente_ui_1",
    base_filtrada,
    base_filtrada_contemp
  )
  
  mod_ugrhi_disp_server("ugrhi_disp_ui_1", ugrhi)
  mod_ugrhi_qualidade_server("ugrhi_qualidade_ui_1", ugrhi)
  
  
  mod_sobre_projeto_server("sobre_projeto_ui_1")
  mod_sobre_dados_server("sobre_dados_ui_1")
  mod_sobre_metodologia_server("sobre_metodologia_ui_1")
  
  
}
