#' informacoes_gerais UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_informacoes_gerais_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      col_12(
        uiOutput(ns("titulo_metricas"))
      )
    ),
    tags$br(),
    fluidRow(
      col_4(
        bs4Dash::bs4ValueBoxOutput(ns("vb_abastecimento"), width = 12),
        bs4Dash::bs4ValueBoxOutput(ns("vb_esgoto"), width = 12),
        bs4Dash::bs4ValueBoxOutput(ns("vb_esgoto_tratado"), width = 12),
        bs4Dash::bs4ValueBoxOutput(ns("vb_consumo"), width = 12)
      ),
      col_8(
        bs4Dash::bs4TabCard(
          width = 12,
          id = "tabbox",
          bs4Dash::bs4TabPanel(
            tabName = "Abstecimento",
            tags$p(paste0(
              "Proporção da população servida por redes de",
              "abastecimento de água sanitariamento adequados. ",
              "Áreas brancas representam municípios sem informação sobre o indicador"
            )),
            highcharter::highchartOutput(ns("hc_abastecimento")) %>%
              shinycssloaders::withSpinner()
          ),
          bs4Dash::bs4TabPanel(
            tabName = "Esgotamento sanitário",
            tags$p(paste0(
              "Proporção da população servida com sistema",
              "de coleta de esgoto. ",
              "Áreas brancas representam municípios sem informação sobre o indicador"
            )),
            highcharter::highchartOutput(ns("hc_esgoto")) %>%
              shinycssloaders::withSpinner()
          ),
          bs4Dash::bs4TabPanel(
            tabName = "Esgoto tratado",
            tags$p(paste0(
              "Proporção do esgoto tratado em relação ao produzido. ",
              "Áreas brancas representam municípios sem informação sobre o indicador"
            )),
            highcharter::highchartOutput(ns("hc_esgoto_tratado")) %>%
              shinycssloaders::withSpinner()
          ),
          bs4Dash::bs4TabPanel(
            tabName = "Consumo de água",
            tags$p(paste0(
              "Consumo médio per capita efetivo. ",
              "Áreas brancas representam municípios sem informação sobre o indicador"
            )),
            highcharter::highchartOutput(ns("hc_consumo")) %>%
              shinycssloaders::withSpinner()
          )
        )
      )
    )
  )
}

#' informacoes_gerais Server Function
#'
#' @noRd 
mod_informacoes_gerais_server <-  function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
    
    tab_indicadores_filtrada <- filtrar_ano_mais_recente(base_indicadores)
    
    output$titulo_metricas <- renderUI({
      
      ano <- tab_indicadores_filtrada %>% 
        dplyr::pull(ano) %>% 
        unique()
      
      tags$h2(paste0(
        "Abastecimento e esgotamento sanitário para o Estado de São Paulo em ", 
        ano
      ))
      
    })
    
    output$vb_abastecimento <- bs4Dash::renderbs4ValueBox({
      valor <- tab_indicadores_filtrada %>%
        dplyr::summarise(
          prop_pop_abastecida = sum(pop_abast_sist_adequados, na.rm = TRUE) /
            sum(proj_pop_total)
        ) %>%
        dplyr::pull(prop_pop_abastecida) %>%
        scales::percent(accuracy = 0.1)
      
        bs4Dash::bs4ValueBox(
          value = "Abastecimento",
          subtitle = valor,
          width = 12,
          icon = "water",
          status = "primary",
          footer = "Proporção da população servida"
        )
    })

    output$vb_esgoto <- bs4Dash::renderbs4ValueBox({
      valor <- tab_indicadores_filtrada %>%
        dplyr::summarise(
          prop_pop_esgoto = sum(pop_servida_rede_esgoto, na.rm = TRUE) /
            sum(proj_pop_total)
        ) %>%
        dplyr::pull(prop_pop_esgoto) %>%
        scales::percent(accuracy = 0.1)
      
        bs4Dash::bs4ValueBox(
          value = "Rede de esgoto",
          subtitle = valor,
          width = 12,
          status = "primary",
          icon = "tint",
          footer = "Proporção da população servida"
        )
    })

    output$vb_esgoto_tratado <- bs4Dash::renderbs4ValueBox({
      valor <- tab_indicadores_filtrada %>%
        dplyr::summarise(
          volume_esgoto = sum(volume_esgoto_tratado, na.rm = TRUE) /
            sum(volume_esgoto_produzido, na.rm = TRUE)
        ) %>%
        dplyr::pull(volume_esgoto) %>%
        scales::percent(accuracy = 0.1)
      
        bs4Dash::bs4ValueBox(
          value = "Esgoto tratado",
          subtitle = valor,
          width = 12,
          status = "primary",
          icon = "filter",
          footer = "Proporção do total produzido"
        )
    })

    output$vb_consumo <- bs4Dash::renderbs4ValueBox({

      unidade_medida <- pegar_unidade_de_medida(
        "consumo_medio_per_capita"
      )

      valor <- tab_indicadores_filtrada %>%
        dplyr::filter(!is.infinite(consumo_medio_per_capita)) %>%
        dplyr::summarise(
          consumo_estado = mean(consumo_medio_per_capita, na.rm = TRUE)
        ) %>%
        dplyr::pull(consumo_estado) %>%
        formatar_indicador(unidade_medida)
      
      bs4Dash::bs4ValueBox(
          value = "Consumo médio de água",
          subtitle = valor,
          width = 12,
          status = "primary",
          icon = "faucet",
          footer = "Litros por habitante por dia"
        )
      
    })

    output$hc_abastecimento <- highcharter::renderHighchart({
      tab_indicadores_filtrada %>%
        hc_mapa_calor(
          geojson_munip,
          variavel = "prop_pop_abast_sist_adequados"
        )
    })
    

    output$hc_esgoto <- highcharter::renderHighchart({
      tab_indicadores_filtrada %>%
        hc_mapa_calor(
          geojson_munip,
          variavel = "prop_pop_servida_coleta_esgoto"
        )
    })

    output$hc_esgoto_tratado <- highcharter::renderHighchart({
      tab_indicadores_filtrada %>%
        hc_mapa_calor(
          geojson_munip,
          variavel = "prop_esgoto_tratado"
        )
    })

    output$hc_consumo <- highcharter::renderHighchart({
      tab_indicadores_filtrada %>%
        hc_mapa_calor(
          geojson_munip,
          variavel = "consumo_medio_per_capita",
          label = TRUE,
          unit = 1
        )
    })
    
  })
}

