#' ugrhi_disp UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ugrhi_disp_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      class = "card-indicadores ugrhi-disp",
      fluidRow(
        column(
          width = 12,
          div(
            class = "meta-desc",
            includeMarkdown("inst/meta_64.md")
          )
        )
      ),
      hr(class = "hr-50"),
      fluidRow(
        column(
          width = 6,
          includeMarkdown("inst/disp_demanda_total.md")
        ),
        column(
          offset = 2,
          width = 4,
          br(),
          valueDiv(
            label = "Demanda total",
            icon = "water",
            textOutput(ns("demanda_total"))
          )
        )
      ),
      br(),
      fluidRow(
        column(
          width = 12,
          highcharter::highchartOutput(ns("hc_demanda_total"), height = "300px")
        )
      ),
      hr(class = "hr-50"),
      fluidRow(
        column(
          width = 6,
          includeMarkdown("inst/disp_qmedio.md")
        ),
        column(
          offset = 2,
          width = 4,
          br(),
          valueDiv(
            label = "Q médio",
            icon = "water",
            textOutput(ns("qmedio"))
          )
        )
      ),
      br(),
      fluidRow(
        column(
          width = 12,
          highcharter::highchartOutput(ns("hc_serie_qmedio"), height = "300px")
        )
      ),
      hr(class = "hr-50"),
      fluidRow(
        column(
          width = 6,
          includeMarkdown("inst/disp_q7.md")
        ),
        column(
          offset = 2,
          width = 4,
          br(),
          valueDiv(
            label = "Q7.10",
            icon = "water",
            textOutput(ns("q7"))
          )
        )
      ),
      br(),
      fluidRow(
        column(
          width = 12,
          highcharter::highchartOutput(ns("hc_serie_q7"), height = "300px")
        )
      ),
      hr(class = "hr-50"),
      fluidRow(
        column(
          width = 6,
          includeMarkdown("inst/disp_q95.md")
        ),
        column(
          offset = 2,
          width = 4,
          br(),
          valueDiv(
            label = "Q95",
            icon = "water",
            textOutput(ns("q95"))
          )
        )
      ),
      br(),
      fluidRow(
        column(
          width = 12,
          highcharter::highchartOutput(ns("hc_serie_q95"), height = "300px")
        )
      )
    )
  )
}
    
#' ugrhi_disp Server Functions
#'
#' @noRd 
mod_ugrhi_disp_server <- function(id, ugrhi) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    base_filtrada <- reactive({
      base_ugrhi |> 
        dplyr::filter(nome == ugrhi())
    })
    
    base_filtrada_contemp <- reactive({
      base_filtrada() %>% 
        dplyr::filter(ano == max(ano))
    })
    
    output$demanda_total <- renderText(
      base_filtrada_contemp() |> 
        dplyr::pull(demanda_total) |> 
        formatar_numero() |> 
        paste(" m³/s")
    )
    
    output$hc_demanda_total <- highcharter::renderHighchart({
      base_filtrada() |>
        dplyr::select(ano, value = demanda_total) |> 
        dplyr::arrange(ano) |> 
        as.matrix() |> 
        hc_serie(
          nome_formatado = "Demanda total",
          unidade_de_medida = "",
          text_color = "black",
          ylab = "Demanda total (m³/s)",
          xlab = "Ano"
        ) |> 
        highcharter::hc_colors(colors = "orange")
    })
    
    output$qmedio <- renderText({
      base_filtrada_contemp() |> 
        dplyr::pull(demanda_total_qmedio) |> 
        formatar_numero() |> 
        paste("%")
    })
    
    output$hc_serie_qmedio <- highcharter::renderHighchart({
      base_filtrada() |>
        dplyr::select(ano, value = demanda_total_qmedio) |> 
        dplyr::arrange(ano) |> 
        as.matrix() |> 
        hc_serie(
          nome_formatado = "Q medio",
          unidade_de_medida = "",
          text_color = "black",
          ylab = "qmedio (%)",
          xlab = "Ano"
        ) |> 
        highcharter::hc_colors(colors = "orange")
    })
 
    output$q7 <- renderText({
      base_filtrada_contemp() |>
        dplyr::pull(demanda_superficial_q7_10) |> 
        formatar_numero() |> 
        paste("%")
    })
    
    output$hc_serie_q7 <- highcharter::renderHighchart({
      base_filtrada() |>
        dplyr::select(ano, value = demanda_superficial_q7_10) |> 
        dplyr::arrange(ano) |> 
        as.matrix() |> 
        hc_serie(
          nome_formatado = "Q7",
          unidade_de_medida = "",
          text_color = "black",
          ylab = "q7 (%)",
          xlab = "Ano"
        ) |> 
        highcharter::hc_colors(colors = "orange")
    })
    
    output$q95 <- renderText({
      base_filtrada_contemp() |> 
        dplyr::pull(demanda_total_q95_percent) |> 
        formatar_numero() |> 
        paste("%")
    })
    
    output$hc_serie_q95 <- highcharter::renderHighchart({
      base_filtrada() |>
        dplyr::select(ano, value = demanda_total_q95_percent) |> 
        dplyr::arrange(ano) |> 
        as.matrix() |> 
        hc_serie(
          nome_formatado = "Q 95",
          unidade_de_medida = "",
          text_color = "black",
          ylab = "q95 (%)",
          xlab = "Ano"
        ) |> 
        highcharter::hc_colors(colors = "orange")
    })
    
  })
}
    
