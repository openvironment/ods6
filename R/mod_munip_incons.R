#' munip_incons UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_munip_incons_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 12,
        h2("Inconsistências de nível 1"),
        p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.")
      )
    ),
    fluidRow(
      uiOutput(ns("ind_acesso_agua")),
      uiOutput(ns("ind_acesso_esgoto")),
      uiOutput(ns("ind_perdas_totais")),
      uiOutput(ns("ind_consumo"))
    ),
    fluidRow(
      column(
        width = 12,
        h2("Inconsistências de nível 2"),
        p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.")
      )
    ),
    fluidRow(
      uiOutput(ns("ind_var_acesso_agua")),
      uiOutput(ns("ind_var_acesso_esgoto")),
      uiOutput(ns("ind_var_perdas_totais")),
      uiOutput(ns("ind_var_consumo"))
    )
  )
}
    
#' munip_incons Server Functions
#'
#' @noRd 
mod_munip_incons_server <- function(id, base_filtrada,
                                    base_filtrada_contemp){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # Acesso a água
    output$ind_acesso_agua <- renderUI({
      valor <- base_filtrada_contemp() %>% 
        dplyr::pull(prop_pop_abast_sist_adequados) %>% 
        formatar_porcentagem()
      
      status <- ifelse(valor > 100, "warning", "success")
      
      card_inconsistencia(
        titulo = "1. Indicador de acesso a água menor que 100%", 
        desc_ind = "Proporção da população que utiliza 
      serviços de água potável gerenciados de forma segura.", 
        desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
        valor = valor,
        status = status
      )
    })
    
    # Acesso a esgoto
    output$ind_acesso_esgoto <- renderUI({
      valor <- base_filtrada_contemp() %>% 
        dplyr::pull(prop_pop_servida_coleta_esgoto) %>% 
        formatar_porcentagem()
      
      status <- ifelse(valor > 100, "warning", "success")
      
      card_inconsistencia(
        titulo = "2. Indicador de acesso a esgoto menor que 100%", 
        desc_ind = "Proporção da população que utiliza serviços de 
        saneamento gerenciados de forma segura", 
        desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
        valor = valor,
        status = status
      )
    })
    
    # Perdas totais
    output$ind_perdas_totais <- renderUI({
      valor <- base_filtrada_contemp() %>% 
        dplyr::pull(prop_perdas_rede_dist)
        
      status <- ifelse(valor < 10 | valor > 80, "warning", "success")
      
      card_inconsistencia(
        titulo = "3. Percentual de perdas totais entre 10 e 80%", 
        desc_ind = "Índice percentual de perdas de água na rede de distribuição", 
        desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
        valor = colocar_unidade_medida(valor, "prop_perdas_rede_dist"),
        status = status
      )
    })
    
    # Consumo per capita
    output$ind_consumo <- renderUI({
      valor <- base_filtrada_contemp() %>% 
        dplyr::pull(consumo_medio_per_capita)
      
      status <- ifelse(valor < 100 | valor > 400, "warning", "success")
      
      card_inconsistencia(
        titulo = "4. Consumo médio per capita entre 100 e 400 litros/habitante/dia", 
        desc_ind = "Consumo médio per capito efetivo", 
        desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
        valor = colocar_unidade_medida(valor, "consumo_medio_per_capita"),
        status = status
      )
    })
    
    # Variação no indicador de acesso a água
    output$ind_var_acesso_agua <- renderUI({
      anos <- base_filtrada() %>% 
        dplyr::select(ano, ind = prop_pop_abast_sist_adequados) %>% 
        dplyr::mutate(var = ind - dplyr::lag(ind)) %>% 
        dplyr::filter(var > 20) %>% 
        dplyr::pull(ano)
      
      
      if (length(anos) >= 1) {
        status <- "warning"
        valor <- paste("Anos: ", anos, collapse = ", ")
      } else {
        status <-  "success"
        valor <- "Nenhuma variação acima de 20%."
      }
      card_inconsistencia(
        titulo = "1. Variações do indicador de acesso a esgoto", 
        desc_ind = "Proporção da população que utiliza 
      serviços de água potável gerenciados de forma segura.", 
        desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
        valor = valor,
        status = status
      )
    })
    
    # Variação no indicador de acesso a esgoto
    output$ind_var_acesso_esgoto <- renderUI({
      anos <- base_filtrada() %>% 
        dplyr::select(ano, ind = prop_pop_servida_coleta_esgoto) %>% 
        dplyr::mutate(var = ind - dplyr::lag(ind)) %>% 
        dplyr::filter(var > 20) %>% 
        dplyr::pull(ano)
      
      
      if (length(anos) >= 1) {
        status <- "warning"
        valor <- paste("Anos: ", anos, collapse = ", ")
      } else {
        status <-  "success"
        valor <- "Nenhuma variação acima de 20%."
      }
      card_inconsistencia(
        titulo = "2. Variações do indicador de acesso a esgoto", 
        desc_ind = "Proporção da população que utiliza serviços de 
        saneamento gerenciados de forma segura", 
        desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
        valor = valor,
        status = status
      )
    })
    
    # Variação no indicador de perdas totais
    output$ind_var_perdas_totais <- renderUI({
      anos <- base_filtrada() %>% 
        dplyr::select(ano, ind = prop_perdas_rede_dist) %>% 
        dplyr::mutate(var = ind - dplyr::lag(ind)) %>% 
        dplyr::filter(abs(var) > 20) %>% 
        dplyr::pull(ano)
      
      if (length(anos) >= 1) {
        status <- "warning"
        valor <- paste("Ano(s): ", anos, collapse = ", ")
      } else {
        status <-  "success"
        valor <- "Nenhuma variação acima de 20%."
      }
      card_inconsistencia(
        titulo = "3. Variações do indicador de perdas totais", 
        desc_ind = "Índice percentual de perdas de água na rede de distribuição", 
        desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
        valor = valor,
        status = status
      )
    })
    
    # Variação no indicador de consumo per capita
    output$ind_var_consumo <- renderUI({
      anos <- base_filtrada() %>% 
        dplyr::select(ano, ind = consumo_medio_per_capita) %>% 
        dplyr::mutate(var = (ind - dplyr::lag(ind)) / dplyr::lag(ind)) %>% 
        dplyr::filter(abs(var) > 0.2) %>% 
        dplyr::pull(ano)
      
      if (length(anos) >= 1) {
        status <- "warning"
        valor <- paste("Ano(s): ", anos, collapse = ", ")
      } else {
        status <-  "success"
        valor <- "Nenhuma variação acima de 20%."
      }
      card_inconsistencia(
        titulo = "4. Variações do indicador de consumo média per capita", 
        desc_ind = "Consumo médio per capito efetivo", 
        desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
        valor = valor,
        status = status
      )
    })
    
 
  })
}
    