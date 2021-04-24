#' select_munip UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_select_munip_ui <- function(id){
  ns <- NS(id)
  div(
    id = "div_select_munip",
    class = "seletor-munip",
    fluidRow(
      column(
        width = 6,
        selectInput_munip(id = ns("select_munip"), width = "100%")
      ),
      column(
        width = 3,
        tippy::with_tippy(
          uiOutput(ns("tag_turistico")),
          "Um município é considerado turístico quando...
          Ver seção de Metodologia para mais informações."
        )
        
      ),
      column(
        width = 3,
        tippy::with_tippy(
          uiOutput(ns("tag_pop")),
          "O município possui mais de 100 mil habitantes."
        )
      )
    )
  )
}

#' select_munip Server Functions
#'
#' @noRd 
mod_select_munip_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$tag_turistico <- renderUI({
      turistico <- base_indicadores %>% 
        dplyr::filter(munip_nome == input$select_munip) %>% 
        dplyr::pull(munip_turistico) %>% 
        dplyr::first()
      
      if (turistico == "sim") {
        htmltools::span(class = "tag-turistico", "Município turístico")
      }
    })
    
    output$tag_pop <- renderUI({
      pop <- base_indicadores %>% 
        dplyr::filter(
          munip_nome == input$select_munip,
          ano == max(ano)
        ) %>% 
        dplyr::pull(proj_pop_total)
      
      if (pop > 100000) {
        htmltools::span(
          class = "tag-pop",
          "+100 mil hab."
        )
      }
    })
    
    return(reactive(input$select_munip))
    
  })
}

