#' ugrhi_qualidade UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ugrhi_qualidade_ui <- function(id){
  ns <- NS(id)
  tagList(
    div(
      class = "card-indicadores ugrhi-quali",
      fluidRow(
        column(
          width = 12,
          div(
            class = "meta-desc",
            includeMarkdown("inst/meta_63.md")
          )
        )
      ),
      hr(class = "hr-50"),
      fluidRow(
        column(
          width = 6,
          includeMarkdown("inst/iqa.md")
        ),
        column(
          width = 6,
          highcharter::highchartOutput(ns("hc_gauge_iqa"))
        )
      ),
      br(),
      fluidRow(
        column(
          width = 12,
          highcharter::highchartOutput(ns("hc_serie_iqa"), height = "300px")
        )
      ),
      hr(class = "hr-50"),
      fluidRow(
        column(
          width = 6,
          includeMarkdown("inst/iap.md")
        ),
        column(
          width = 6,
          highcharter::highchartOutput(ns("hc_gauge_iap"))
        )
      ),
      br(),
      fluidRow(
        column(
          width = 12,
          highcharter::highchartOutput(ns("hc_serie_iap"), height = "300px")
        )
      ),
      hr(class = "hr-50"),
      fluidRow(
        column(
          width = 6,
          includeMarkdown("inst/iva.md")
        ),
        column(
          width = 6,
          highcharter::highchartOutput(ns("hc_gauge_iva"))
        )
      ),
      br(),
      fluidRow(
        column(
          width = 12,
          highcharter::highchartOutput(ns("hc_serie_iva"), height = "300px")
        )
      ),
    )
  )
}

#' ugrhi_qualidade Server Functions
#'
#' @noRd 
mod_ugrhi_qualidade_server <- function(id, ugrhi) {
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
    
    output$hc_gauge_iqa <- highcharter::renderHighchart({
      
      validate(need(
        nrow(tidyr::drop_na(base_filtrada_contemp(), iqa)) > 0,
        "Não há dados disponíveis."
      ))
      
      base_filtrada_contemp() |> 
        hc_gauge("iqa", c(0, 19, 36, 51, 79, 100), cores_gauge())
    })
    
    output$hc_serie_iqa <- highcharter::renderHighchart({
      
      validate(need(
        nrow(tidyr::drop_na(base_filtrada(), iqa)) > 0,
        "Não há dados disponíveis."
      ))
      
      base_filtrada() |>
        dplyr::mutate(ano = as.numeric(ano)) |> 
        dplyr::select(ano, value = iqa) |> 
        dplyr::arrange(ano) |> 
        as.matrix() |> 
        hc_serie(
          nome_formatado = "IQA",
          unidade_de_medida = "",
          text_color = "black",
          ylab = "IQA",
          xlab = "Ano"
        ) |> 
        highcharter::hc_colors(colors = "orange")
    })
    
    output$hc_gauge_iap <- highcharter::renderHighchart({
      
      validate(need(
        nrow(tidyr::drop_na(base_filtrada_contemp(), iap)) > 0,
        "Não há dados disponíveis."
      ))
      
      base_filtrada_contemp() |> 
        hc_gauge("iap", c(0, 19, 36, 51, 79, 100), cores_gauge())
    })
    
    output$hc_serie_iap <- highcharter::renderHighchart({
      
      validate(need(
        nrow(tidyr::drop_na(base_filtrada(), iap)) > 0,
        "Não há dados disponíveis."
      ))
      
      base_filtrada() |>
        dplyr::mutate(ano = as.numeric(ano)) |> 
        dplyr::select(ano, value = iap) |> 
        dplyr::arrange(ano) |> 
        as.matrix() |> 
        hc_serie(
          nome_formatado = "IAP",
          unidade_de_medida = "",
          text_color = "black",
          ylab = "IAP",
          xlab = "Ano"
        ) |> 
        highcharter::hc_colors(colors = "orange")
    })
    
    output$hc_gauge_iva <- highcharter::renderHighchart({
      
      validate(need(
        nrow(tidyr::drop_na(base_filtrada_contemp(), iva)) > 0,
        "Não há dados disponíveis."
      ))
      
      base_filtrada_contemp() |> 
        hc_gauge("iva", c(0, 2.5, 3.3, 4.5, 6.7, 10), rev(cores_gauge()))
    })
    
    output$hc_serie_iva <- highcharter::renderHighchart({
      
      validate(need(
        nrow(tidyr::drop_na(base_filtrada(), iva)) > 0,
        "Não há dados disponíveis."
      ))
      
      base_filtrada() |>
        dplyr::mutate(ano = as.numeric(ano)) |> 
        dplyr::select(ano, value = iva) |> 
        dplyr::arrange(ano) |> 
        as.matrix() |> 
        hc_serie(
          nome_formatado = "IVA",
          unidade_de_medida = "",
          text_color = "black",
          ylab = "IVA",
          xlab = "Ano"
        ) |> 
        highcharter::hc_colors(colors = "orange")
    })
    
  })
}
