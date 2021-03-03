#' aux_ind_od6 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_aux_ind_od6_ui <- function(id, desc_onu, desc_br, text_pie_chart) {
  ns <- NS(id)
  div(
    class = "munip-ind-ods6",
    fluidRow(
      column(
        width = 5,
        div(
          class = "meta-desc",
          tags$p(
            span(
              class = "meta-origem",
              "Nações Unidas"
            ),
            desc_onu
          ),
          tags$p(
            span(
              class = "meta-origem",
              "Brasil"
            ),
            desc_br
          ),
        )
      ),
      column(
        width = 7,
        class = "d-flex  align-items-center",
        uiOutput(ns("ind_valor"))
      )
    ),
    hr(),
    fluidRow(
      class = "meta-ind-serie",
      column(
        width = 8,
        class = "d-flex justify-content-center",
        highcharter::highchartOutput(
          ns("hc_serie_ind_ods"),
          width = "90%",
          height = "250px"
        )
      ),
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
    )
  )
}

#' aux_ind_od6 Server Functions
#'
#' @noRd 
mod_aux_ind_od6_server <- function(id, base_filtrada, base_filtrada_contemp,
                                   indicador, nome_indicador_ods,
                                   tipo_servicos) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$ind_valor <- renderUI({
      prop <- base_filtrada_contemp() %>% 
        dplyr::pull(indicador) %>% 
        formatar_porcentagem()
      
      simple_value_box(
        titulo = nome_indicador_ods,
        valor = prop
      )
    })
    
    output$hc_serie_ind_ods <- highcharter::renderHighchart({
      
      unidade_medida <- pegar_unidade_de_medida(indicador)
      nome_formatado <- nome_indicador_ods
      
      base_filtrada() %>%
        dplyr::select(ano, value = prop_pop_abast_sist_adequados) %>%
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
      
      tab <- base_filtrada_contemp() %>% 
        dplyr::select(dplyr::one_of(tipo_servicos)) %>% 
        tidyr::pivot_longer(
          cols = dplyr::everything(), 
          names_to = "name",
          values_to = "y"
        ) %>% 
        dplyr::mutate(name = formatar_nome_tipo_servico(name)) %>% 
        highcharter::list_parse()
      
      highcharter::highchart() %>% 
        highcharter::hc_chart(
          plotBackgroundColor = "transparent",
          plotBorderWidth = 0,
          plotShadow = FALSE
        ) %>% 
        highcharter::hc_series(
          list(
            data = tab, 
            name = "Tipo de serviço",
            type = "pie",
            innerSize = "50%"
          )
        ) %>% 
        highcharter::hc_plotOptions(
          pie = list(
            dataLabels = list(
              enabled = TRUE,
              distance = -10,
              style = list(
                fontWeight = "bold",
                color = "white"
              )
            ),
            startAngle = -90,
            endAngle = 90,
            center = c("50%", "95%"),
            size = "210%"
          )
        ) %>% 
        highcharter::hc_tooltip(
          useHTML = TRUE,
          headerFormat = "<small>{series.name}</small><br>",
          pointFormat = "{point.name}: <b>{point.percentage:.1f}%</b>"
        ) %>% 
        highcharter::hc_colors(colors = c("orange", "white")) %>% 
        highcharter::hc_title(
          text = "Tipo de serviço*",
          style = list(color = "white")
        )
    })
    
  })
}
