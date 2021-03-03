#' aux_outros_indicadores UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_aux_outros_indicadores_ui <- function(id, indicadores) {
  ns <- NS(id)
  tagList(
    tags$div(
      class = "munip-outros-ind",
      fluidRow(
        column(
          width = 5,
          selectInput(
            ns("select_outro_ind"),
            label = "Selecione o indicador",
            choices = indicadores
          )
        ),
        column(
          width = 7,
          uiOutput(ns("ind_valor"))
        )
      ),
      fluidRow(
        class = "desc",
        column(
          width = 12,
          textOutput(ns("outros_ind_desc"))
        )
      ),
      fluidRow(
        class = "hc-outros-ind",
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
}
    
#' aux_outros_indicadores Server Functions
#'
#' @noRd 
mod_aux_outros_indicadores_server <- function(id, base_filtrada,
                                              base_filtrada_contemp){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$ind_valor <- renderUI({
      
      unidade <- pegar_unidade_de_medida(input$select_outro_ind)
      
      valor <- base_filtrada_contemp() %>% 
        dplyr::pull(input$select_outro_ind) %>% 
        formatar_indicador(unidade)
      
      nome <- tab_depara %>% 
        dplyr::filter(cod == input$select_outro_ind) %>% 
        dplyr::pull(nome_formatado)
      
      simple_value_box(
        titulo = nome,
        valor = valor,
        unidade = pegar_unidade_de_medida(input$select_outro_ind)
      )
    })
    
    output$outros_ind_desc <- renderText({
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat. Duis aute irure dolor in reprehenderit in 
      voluptate velit esse cillum dolore eu fugiat nulla pariatur. 
      Excepteur sint occaecat cupidatat non proident, sunt in culpa qui 
      officia deserunt mollit anim id est laborum."
    })
    
    output$hc_serie_outro_ind <- highcharter::renderHighchart({
      
      nome_formatado <- tab_depara %>% 
        dplyr::filter(cod == input$select_outro_ind) %>% 
        dplyr::pull(nome_formatado)
      
      unidade_medida <- pegar_unidade_de_medida(input$select_outro_ind)
      
      base_filtrada() %>%
        dplyr::select(ano, value = dplyr::one_of(input$select_outro_ind)) %>%
        dplyr::mutate(value = round(value, 1)) %>% 
        dplyr::arrange(ano) %>%
        as.matrix() %>%
        hc_serie(nome_formatado, unidade_medida, text_color = "white") %>% 
        highcharter::hc_title(
          text = nome_formatado,
          style = list(color = "white")
        )  %>% 
        highcharter::hc_colors(colors = "orange")
    })
 
  })
}
    
