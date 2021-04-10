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
        width = 8,
        h2("Localização do município"),
        br(),
        plotOutput(ns("plot_mapa"), height = "360px")
      ),
      column(
        width = 4,
        h2("População"),
        br(),
        valueDiv(
          label = "População total",
          classe = "populacao",
          tooltip_class = "tip-populacao",
          icon = "users",
          textOutput(ns("pop_total"))
        ),
        highcharter::highchartOutput(ns("prop_populacao"), height = "200px")
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
          label = "Acesso à água",
          icon = "water",
          tooltip_class = "tip-abastecimento",
          textOutput(ns("prop_abastecimento"))
        )
      ),
      column(
        width = 3,
        valueDiv(
          label = "Esgotamento sanitário",
          icon = "toilet",
          tooltip_class = "tip-esgotamento",
          textOutput(ns("prop_esgotamento"))
        )
      ),
      column(
        width = 3,
        valueDiv(
          label = "Esgoto produzido (m³/ano)",
          icon = "ruler-vertical",
          tooltip_class = "tip-esgoto-produzido",
          textOutput(ns("prop_esgoto_produzido"))
        )
      ),
      column(
        width = 3,
        valueDiv(
          label = "Esgoto tratado",
          icon = "swimmer",
          tooltip_class = "tip-esgoto-tratado",
          textOutput(ns("prop_esgoto_tratado"))
        )
      )
    ),
    br(),
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
        dplyr::filter(
          munip_nome == municipio_selecionado(), 
          ano == max(ano)
        )
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
    
    output$pop_total <- renderText({
      pop <- base_filtrada()$proj_pop_total
      
      formatar_numero(pop, 1)
      
    })
    
    output$prop_populacao <- highcharter::renderHighchart({
      tab <- base_filtrada() %>% 
        dplyr::select("proj_pop_urbana", "proj_pop_rural") %>% 
        tidyr::pivot_longer(
          cols = dplyr::everything(), 
          names_to = "name",
          values_to = "y"
        ) %>% 
        dplyr::mutate(name = dplyr::case_when(
          name == "proj_pop_urbana" ~ "URBANA",
          TRUE ~ "RURAL"
        )) %>% 
        highcharter::list_parse()
      
      hc_donut(
        tab, 
        "População", 
        cor = c("orange", "var(--verdeODS6)"),
        size = "200%"
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
    
    output$prop_esgoto_produzido <- renderText({
      valor <- base_filtrada()$volume_esgoto_produzido
      formatar_numero(valor, 1)
    })
    
    output$prop_esgoto_tratado <- renderText({
      prop <- base_filtrada()$prop_esgoto_tratado
      
      formatar_porcentagem(prop)
    })
 
  })
}
