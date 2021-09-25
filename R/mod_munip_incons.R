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
  div(
    class = "inconsistencias",
    fluidRow(
      column(
        width = 12,
        h2("Inconsistências de nível 1"),
        p("Se referem aos indicadores de percentuais da população com acesso a 
          sistemas seguros de abastecimento de água e coleta de esgoto sanitário 
          que superem o valor de 100%. Caixas", 
          span(style = "color: orange; font-weight: bold;", " laranjas "),
          "representam presença da inconsistência. Caixas",
          span(style = "color: var(--verdeODS6); font-weight: bold;", " verdes "),
          "representam ausência da inconsistência.")
      )
    ),
    br(),
    fluidRow(
      uiOutput(ns("ind_acesso_agua")),
      uiOutput(ns("ind_acesso_esgoto"))
    ),
    hr(),
    fluidRow(
      column(
        width = 12,
        h2("Inconsistências de nível 2"),
        p("Indicadores de perda total no sistema de distribuição de água e de 
          consumo médio per capita cujos valores estejam fora das faixas 
          convencionais. Caixas", 
          span(style = "color: orange; font-weight: bold;", " laranjas "),
          "representam presença da inconsistência. Caixas",
          span(style = "color: var(--verdeODS6); font-weight: bold;", " verdes "),
          "representam ausência da inconsistência.")
      )
    ),
    br(),
    fluidRow(
      uiOutput(ns("ind_perdas_totais")),
      uiOutput(ns("ind_consumo"))
    ),
    hr(),
    fluidRow(
      column(
        width = 12,
        h2("Inconsistências de nível 3"),
        p("se referem aos indicadores de acesso à água e acesso à
          coleta de esgoto que apresentam valores superiores ou 
          inferiores a 20% do registrado no ano imediatamente 
          anterior. Caixas", 
          span(style = "color: orange; font-weight: bold;", " laranjas "),
          "representam presença da inconsistência. Caixas",
          span(style = "color: var(--verdeODS6); font-weight: bold;", " verdes "),
          "representam ausência da inconsistência.")
      )
    ),
    br(),
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
mod_munip_incons_server <- function(id, base_filtrada, tab_incons) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    
    # Acesso a água
    output$ind_acesso_agua <- renderUI({
      tab <- tab_incons() %>% 
        dplyr::filter(id == 1)
      
      card_inconsistencia(
        titulo = tab$titulo, 
        desc_ind = tab$desc_ind, 
        desc_validacao = tab$desc_validacao, 
        valor = tab$valor,
        status = tab$status
      )
    })
    
    # Acesso a esgoto
    output$ind_acesso_esgoto <- renderUI({
      tab <- tab_incons() %>% 
        dplyr::filter(id == 2)
      
      card_inconsistencia(
        titulo = tab$titulo, 
        desc_ind = tab$desc_ind, 
        desc_validacao = tab$desc_validacao, 
        valor = tab$valor,
        status = tab$status
      )
    })
    
    # Perdas totais
    output$ind_perdas_totais <- renderUI({
      tab <- tab_incons() %>% 
        dplyr::filter(id == 3)
      
      card_inconsistencia(
        titulo = tab$titulo, 
        desc_ind = tab$desc_ind, 
        desc_validacao = tab$desc_validacao, 
        valor = tab$valor,
        status = tab$status
      )
    })
    
    # Consumo per capita
    output$ind_consumo <- renderUI({
      tab <- tab_incons() %>% 
        dplyr::filter(id == 4)
      
      card_inconsistencia(
        titulo = tab$titulo, 
        desc_ind = tab$desc_ind, 
        desc_validacao = tab$desc_validacao, 
        valor = tab$valor,
        status = tab$status
      )
    })
    
    # Variação no indicador de acesso a água
    output$ind_var_acesso_agua <- renderUI({
      tab <- tab_incons() %>% 
        dplyr::filter(id == 5)
      
      card_inconsistencia(
        titulo = tab$titulo, 
        desc_ind = tab$desc_ind, 
        desc_validacao = tab$desc_validacao, 
        valor = tab$valor,
        status = tab$status
      )
    })
    
    # Variação no indicador de acesso a esgoto
    output$ind_var_acesso_esgoto <- renderUI({
      tab <- tab_incons() %>% 
        dplyr::filter(id == 6)
      
      card_inconsistencia(
        titulo = tab$titulo, 
        desc_ind = tab$desc_ind, 
        desc_validacao = tab$desc_validacao, 
        valor = tab$valor,
        status = tab$status
      )
    })
    
    # Variação no indicador de perdas totais
    output$ind_var_perdas_totais <- renderUI({
      tab <- tab_incons() %>% 
        dplyr::filter(id == 7)
      
      card_inconsistencia(
        titulo = tab$titulo, 
        desc_ind = tab$desc_ind, 
        desc_validacao = tab$desc_validacao, 
        valor = tab$valor,
        status = tab$status
      )
    })
    
    # Variação no indicador de consumo per capita
    output$ind_var_consumo <- renderUI({
      tab <- tab_incons() %>% 
        dplyr::filter(id == 8)
      
      card_inconsistencia(
        titulo = tab$titulo, 
        desc_ind = tab$desc_ind, 
        desc_validacao = tab$desc_validacao, 
        valor = tab$valor,
        status = tab$status
      )
    })
    
 
  })
}
    