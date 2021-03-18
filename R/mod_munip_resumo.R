#' munip_resumo UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_munip_resumo_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      column(
        width = 12,
        h2("Dados demográficos")
      )
    ),
    br(),
    fluidRow(
      column(
        width = 7,
        plotOutput(ns("plot_mapa"), height = "360px")
      ),
      column(
        offset = 1,
        width = 4,
        fluidRow(
          bs4Dash::bs4ValueBoxOutput(ns("pop_total"), width = 12)
        ),
        fluidRow(
          column(
            width = 12,
            highcharter::highchartOutput(ns("prop_populacao"), height = "200px")
          )
        )
      )
    ),
    br(),
    fluidRow(
      column(
        width = 12,
        h2("Indicadores de acesso a água e esgoto")
      )
    ),
    br(),
    fluidRow(
      column(
        width = 3,
        valueDiv(
          label = "Abastecimento",
          icon = icon("question-circle", class = "tip-abastecimento"),
          textOutput(ns("prop_abastecimento"))
        )
      ),
      column(
        width = 3,
        valueDiv(
          label = "Esgotamento sanitário",
          icon = icon("question-circle", class = "tip-esgotamento"),
          textOutput(ns("prop_esgotamento"))
        )
      ),
      column(
        width = 3,
        valueDiv(
          label = "Perda na distribuição",
          icon = icon("question-circle", class = "tip-perda"),
          textOutput(ns("prop_perda"))
        )
      ),
      column(
        width = 3,
        valueDiv(
          label = "Esgoto tratado",
          icon = icon("question-circle", class = "tip-esgoto-tratado"),
          textOutput(ns("prop_esgoto_tratado"))
        )
      )
    ),
    fluidRow(
      column(
        width = 12,
        h2("Inconsistências nos dados"),
      )
    ),
    br(),
    fluidRow(
      column(
        width = 12,
        reactable::reactableOutput(ns("tab_incons"))
      )
    ),
  )
}
    
#' munip_resumo Server Functions
#'
#' @noRd 
mod_munip_resumo_server <- function(id, municipio_selecionado) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    base_filtrada <- reactive({
      base_indicadores %>% 
        dplyr::filter(munip_nome == municipio_selecionado(), ano == max(ano))
    })
    
    output$plot_mapa <- renderPlot(bg = "transparent", {
      
      tab_geo <- shape_estado
        
      sf::st_crs(tab_geo) <- 4674
      sf::st_crs(tab_geo$geom) <- 4674
      
      tab_geo %>% 
        dplyr::mutate(
          value = ifelse(munip_nome == municipio_selecionado(), "1", "0")
        ) %>% 
        ggplot2::ggplot(ggplot2::aes(fill = value)) +
        ggplot2::geom_sf(show.legend = FALSE, size = 0.2, color = "#616161") +
        ggplot2::scale_fill_manual(values = c("#f5e9e7", "#2aaee2")) +
        tema_gg_blank()
      
    })
    
    output$pop_rural <- bs4Dash::renderbs4ValueBox({
      pop <- base_filtrada()$proj_pop_rural
      pop_perc <- pop / base_filtrada()$proj_pop_total * 100
      
      valor <- paste0(
        formatar_numero(pop, 1), 
        " (", formatar_porcentagem(pop_perc), ")"
      )
      
      bs4Dash::bs4ValueBox(
        value = "População rural",
        subtitle = valor,
        icon = "tractor",
        status = "primary",
        footer = "Projeção SEADE"
      )
      
    })
    
    output$pop_urbana <- bs4Dash::renderbs4ValueBox({
      pop <- base_filtrada()$proj_pop_urbana
      pop_perc <- pop / base_filtrada()$proj_pop_total * 100
      
      valor <- paste0(
        formatar_numero(pop, 1), 
        " (", formatar_porcentagem(pop_perc), ")"
      )
      
      bs4Dash::bs4ValueBox(
        value = "População urbana",
        subtitle = valor,
        icon = "city",
        status = "primary",
        footer = "Projeção SEADE"
      )
      
    })
    
    output$pop_total <- bs4Dash::renderbs4ValueBox({
      pop <- base_filtrada()$proj_pop_total
      
      bs4Dash::bs4ValueBox(
        value = "População total",
        subtitle = formatar_numero(pop, 1),
        icon = "users",
        status = "primary",
        footer = "Projeção SEADE"
      )
      
    })
    
    output$prop_abastecimento <- renderText({
      prop <- base_filtrada()$prop_pop_abast_sist_adequados
      
      formatar_porcentagem(prop)
    })
    
    output$prop_esgotamento <- renderText({
      prop <- base_filtrada()$prop_pop_servida_coleta_esgoto
      
      formatar_porcentagem(prop)
    })
    
    output$prop_perda <- renderText({
      prop <- base_filtrada()$prop_perdas_rede_dist
      
      formatar_porcentagem(prop)
    })
    
    output$prop_esgoto_tratado <- renderText({
      prop <- base_filtrada()$prop_esgoto_tratado
      
      formatar_porcentagem(prop)
    })
 
  })
}
