#' munip_abast UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_munip_abast_ui <- function(id){
  ns <- NS(id)
  id_js <- ns("select_ind")
  tags$div(
    class = "munip-abast",
    tags$div(
      class = "munip-abast-ods6",
      fluidRow(
        column(
          width = 5,
          div(
            class = "meta-desc",
            tags$h3("ODS 6.1"),
            tags$p(
              span(
                class = "meta-origem",
                "Nações Unidas"
              ),
              "Até 2030, alcançar o acesso universal e equitativo à água 
            potável e segura para todos."
            ),
            tags$p(
              span(
                class = "meta-origem",
                "Brasil"
              ),
              "Até 2030, alcançar o acesso universal e equitativo à água p
            ara consumo humano, segura e acessível para todas e todos."
            ),
          )
        ),
        column(
          width = 7,
          class = "d-flex  align-items-center",
          div(
            class = "meta-ind",
            tags$h4("Proporção da população que utiliza serviços de água potável 
                  gerenciados de forma segura"),
            textOutput(ns("ind_ods_valor"))
          )
        )
      ),
      hr(),
      div(
        class = "meta-ind-serie",
        fluidRow(
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
              class = "explicacao-abast",
              "*Referente à população abastecidada por sistemas de água 
              sanitariamente adequados."
            )
          )
        )
      )
    ),
    hr(),
    tags$div(
      class = "munip-abast-outros-ind",
      fluidRow(
        column(
          width = 12,
          tags$h2("Outros indicadores"),
        )
      ),
      fluidRow(
        column(
          width = 4,
          tags$div(
            class = "vb-clickable",
            fluidRow(
              bs4Dash::bs4ValueBoxOutput(ns("consumo"), width = 12),
            ),
            onclick = glue::glue("clickFunction('{id_js}','consumo')")
          )
        ),
        column(
          width = 4,
          tags$div(
            class = "vb-clickable",
            fluidRow(
              bs4Dash::bs4ValueBoxOutput(ns("perdas"), width = 12)
            ),
            onclick = glue::glue("clickFunction('{id_js}','perdas')")
          )
        )
      ),
      div(
        class = "hc-outros-ind",
        fluidRow(
          column(
            width = 12,
            class = "d-flex justify-content-center",
            highcharter::highchartOutput(
              ns("hc_serie_outro_ind"),
              width = "80%",
              height = "300px"
            )
          )
        )
      )
    )
  )
}
    
#' munip_abast Server Functions
#'
#' @noRd 
mod_munip_abast_server <- function(id, municipio_selecionado){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    base_filtrada <- reactive({
      base_indicadores %>% 
        dplyr::filter(munip_nome == municipio_selecionado())
    })
    
    base_filtrada_contemp <- reactive({
      base_filtrada() %>% 
        dplyr::filter(ano == max(ano))
    })
    
    output$ind_ods_valor <- renderText({
      prop <- base_filtrada_contemp() %>% 
        dplyr::pull(prop_pop_abast_sist_adequados)
      
      formatar_porcentagem(prop)
    })
    
    output$hc_serie_ind_ods <- highcharter::renderHighchart({
      
      unidade_medida <- pegar_unidade_de_medida("prop_pop_abast_sist_adequados")
      nome_formatado <- 
        paste(pegar_nome_formatado("prop_pop_abast_sist_adequados"), "(%)")
      
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
        dplyr::select(
          `Rede pública` = pop_servida_abast_agua,
          `Poço ou mina` = pop_servida_poco_nasc
        ) %>% 
        tidyr::pivot_longer(
          cols = dplyr::everything(), 
          names_to = "name",
          values_to = "y"
        ) %>% 
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
            name = "Tipo de abastecimento",
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
          text = "Tipo de abastecimento*",
          style = list(color = "white")
        )
    })
    
    output$consumo <- bs4Dash::renderbs4ValueBox({
      consumo <- base_filtrada_contemp()$consumo_medio_per_capita
      
      bs4Dash::bs4ValueBox(
        value = "Consumo médio per capita",
        subtitle = formatar_numero(consumo, 1),
        icon = "users",
        status = "primary",
        footer = "Litros por habitante por dia"
      )
      
    })
    
    output$perdas <- bs4Dash::renderbs4ValueBox({
      prop <- base_filtrada_contemp()$prop_perdas_rede_dist
      
      bs4Dash::bs4ValueBox(
        value = "Perda na distribuição",
        subtitle = formatar_porcentagem(prop),
        icon = "users",
        status = "primary",
        footer = "Proporção da água perdida na distribuição"
      )
      
    })
    
    
    output$hc_serie_outro_ind <- highcharter::renderHighchart({
      
      if (!isTruthy(input$select_ind) || input$select_ind == "consumo") {
        indicador <- "consumo_medio_per_capita"
        nome_formatado <- paste(pegar_nome_formatado(indicador), "litros/hab/dia")
      } else if (input$select_ind == "perdas") {
        indicador <- "prop_perdas_rede_dist"
        nome_formatado <- paste(pegar_nome_formatado(indicador), "(%)")
      } 
      
      unidade_medida <- pegar_unidade_de_medida(indicador)
      
      base_filtrada() %>%
        dplyr::select(ano, value = dplyr::one_of(indicador)) %>%
        dplyr::mutate(value = round(value, 1)) %>% 
        dplyr::arrange(ano) %>%
        as.matrix() %>%
        hc_serie(nome_formatado, unidade_medida) %>% 
        highcharter::hc_title(
          text = nome_formatado
        ) %>% 
        highcharter::hc_colors(colors = "orange")
    })
 
  })
}
    
