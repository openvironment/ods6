#' aux_ind_od6 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_aux_ind_od6_ui <- function(id, desc_ind, text_pie_chart) {
  ns <- NS(id)
  div(
    class = "munip-ind-ods6",
    fluidRow(
      column(
        width = 5,
        tags$p(
          desc_ind
        )
      ),
      column(
        width = 7,
        class = "d-flex  align-items-center indicadorODS",
        uiOutput(ns("ind_valor"))
      )
    ),
    hr(),
    fluidRow(
      class = "meta-ind-serie",
      column(
        width = ifelse(isTruthy(text_pie_chart), 8, 12),
        class = "d-flex justify-content-center",
        highcharter::highchartOutput(
          ns("hc_serie_ind_ods"),
          width = "90%",
          height = "250px"
        )
      ),
      if(isTruthy(text_pie_chart)) {
        column(
          width = 4,
          highcharter::highchartOutput(
            ns("hc_prop_rede"),
            width = "100%",
            height = "200px"
          ),
          tags$p(
            class = "explicacao-hc-pie",
            text_pie_chart
          )
        )
      } else {
        NULL
      }
    )
  )
}

#' aux_ind_od6 Server Functions
#'
#' @noRd 
mod_aux_ind_od6_server <- function(id, base_filtrada, base_filtrada_contemp,
                                   indicador, nome_indicador_ods,
                                   tipo_servicos, indicador_alerta = "") {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    valor_ind <- reactive({
      base_filtrada_contemp() %>% 
        dplyr::pull(indicador)
    })
    
    output$ind_valor <- renderUI({
      
      unidade <- pegar_unidade_de_medida(indicador)
      valor <- formatar_indicador(valor_ind(), unidade)
      
      if (stringr::str_detect(indicador, "^prop_")) {
        unidade <- ""
      }
      
      if(isTruthy(indicador_alerta)) {
        nome_indicador_ods <- paste0(nome_indicador_ods, "*")
      }
      
      simple_value_box(
        titulo = nome_indicador_ods,
        valor = valor,
        alerta = indicador_alerta,
        unidade = unidade
      )
    })
    
    output$hc_serie_ind_ods <- highcharter::renderHighchart({
      
      unidade_medida <- pegar_unidade_de_medida(indicador)
      nome_formatado <- nome_indicador_ods
      
      base_filtrada() %>%
        dplyr::select(ano, value = dplyr::one_of(indicador)) %>%
        dplyr::arrange(ano) %>%
        as.matrix() %>%
        hc_serie(nome_formatado, unidade_medida, text_color = "white") %>% 
        highcharter::hc_title(
          text = nome_formatado,
          style = list(color = "white")
        ) %>% 
        highcharter::hc_colors(colors = "orange")
    })
    
    output$hc_prop_rede <- highcharter::renderHighchart({
      
      if (!is.null(tipo_servicos)) {
        tab <- base_filtrada_contemp() %>% 
          dplyr::select(dplyr::one_of(tipo_servicos)) %>% 
          tidyr::pivot_longer(
            cols = dplyr::everything(), 
            names_to = "name",
            values_to = "y"
          ) %>% 
          dplyr::mutate(name = formatar_nome_tipo_servico(name)) %>% 
          highcharter::list_parse()
        
        hc_donut(
          tab,
          "Tipo de serviço",
          cor = c("orange", "white"),
          size = "210%"
        ) %>% 
          highcharter::hc_title(
            text = "Tipo de serviço*",
            style = list(color = "white")
          )
      } else {
        NULL
      }
        
    })
    
  })
}
