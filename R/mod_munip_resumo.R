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
        h2("População", class = "titulo-pop"),
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
        h2("Indicadores de acesso à água, coleta e tratamento de esgoto")
      )
    ),
    br(),
    fluidRow(
      column(
        width = 4,
        valueDiv(
          label = "Acesso à água",
          icon = "shower",
          tooltip_class = "tip-abastecimento",
          textOutput(ns("prop_abastecimento"))
        )
      ),
      column(
        width = 4,
        valueDiv(
          label = "Coleta de esgoto",
          icon = "toilet",
          tooltip_class = "tip-esgotamento",
          textOutput(ns("prop_esgotamento"))
        )
      ),
      column(
        width = 4,
        valueDiv(
          label = "Esgoto tratado",
          icon = "hand-holding-water",
          tooltip_class = "tip-esgoto-tratado",
          textOutput(ns("prop_esgoto_tratado"))
        )
      )
    ),
    br(),
    fluidRow(
      column(
        width = 12,
        h2("Inconsistências"),
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
mod_munip_resumo_server <- function(id, municipio_selecionado, tab_incons) {
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
      
      tab_label <- tab_geo %>% 
        dplyr::filter(munip_nome == municipio_selecionado())
      
      tab_geo %>% 
        dplyr::mutate(
          value = ifelse(munip_nome == municipio_selecionado(), "1", "0")
        ) %>% 
        ggplot2::ggplot() +
        ggplot2::geom_sf(
          ggplot2::aes(fill = value),
          show.legend = FALSE, 
          size = 0.2,
          color = "#616161"
        ) +
        ggplot2::scale_fill_manual(values = c("#f5e9e7", "orange")) +
        ggrepel::geom_label_repel(
          data = tab_label,
          ggplot2::aes(geometry = geom, label = munip_nome),
          stat = "sf_coordinates",
          size = 5,
          nudge_x = 0.5, 
          nudge_y = 0.5
        ) +
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
    
    output$prop_esgoto_tratado <- renderText({
      prop <- base_filtrada()$prop_esgoto_tratado
      
      formatar_porcentagem(prop)
    })
    
    output$tab_incons <- reactable::renderReactable({
      tab_incons() %>% 
        dplyr::select(
          titulo,
          status
        ) %>% 
        dplyr::mutate(
          titulo = stringr::str_remove(titulo, "[0-9]\\.")
        ) %>% 
        reactable::reactable(
          sortable = FALSE,
          pagination = FALSE,
          columns = list(
            titulo = reactable::colDef(
              name = "Validação",
              align = "left"
            ),
            status = reactable::colDef(
              name = "",
              align = "center",
              width = 100,
              cell = function(value) {
                if (value == "success") {
                  icon("check-circle", class = "incons-check")
                } else {
                  icon("exclamation-circle", class = "incons-alert")
                }
              }
            )
          )
        )
    })
 
  })
}
