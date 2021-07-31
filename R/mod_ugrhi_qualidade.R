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
    fluidRow(
      class = "seletor-munip",
      column(
        width = 6,
        selectInput(
          inputId = ns("ugrhi"),
          label = "Você está vendo dados de",
          selected = "São Paulo",
          choices = sort(unique(base_ugrhi$nome)),
          width = "100%"
        )
      )
    ),
    br(),
    div(
      class = "card-indicadores ugrhi-quali",
      fluidRow(
        column(
          width = 12,
          h2("Meta 6.3 - Qualidade das águas superficiais"),
          div(
            class = "meta-desc",
            tags$p(
              span(
                class = "meta-origem",
                "Nações Unidas"
              ),
              "Até 2030, melhorar a qualidade da água, reduzindo a poluição, 
            eliminando despejo e minimizando a liberação de produtos químicos 
            e materiais perigosos, reduzindo à metade a proporção de águas 
            residuais não tratadas e aumentando substancialmente a reciclagem 
            e reutilização segura globalmente."
            ),
            tags$p(
              span(
                class = "meta-origem",
                "Brasil"
              ),
              "Até 2030, melhorar a qualidade da água nos corpos hídricos, 
            reduzindo a poluição, eliminando despejos e minimizando o 
            lançamento de materiais e substâncias perigosas, reduzindo pela 
            metade a proporção do lançamento de efluentes não tratados e 
            aumentando substancialmente o reciclo e reuso seguro localmente."
            ),
          )
        )
      ),
      hr(class = "hr-50"),
      fluidRow(
        column(
          width = 6,
          h2("Índice de Qualidade das Águas — IQA "),
          p("Incorpora nove variáveis consideradas relevantes para a 
            avaliação da qualidade das águas, tendo como determinante 
            principal a sua utilização para abastecimento público.")
        ),
        column(
          width = 6,
          highcharter::highchartOutput(ns("hc_gauge_iqa"))
        )
      ),
      hr(class = "hr-50"),
      fluidRow(
        column(
          width = 6,
          h2("Índice de Qualidade das Águas Brutas para Fins 
             de Abastecimento Público — IAP "),
          p("Estimado pelo produto da ponderação dos resultados atuais do 
            IQA (Índice de Qualidade de Águas) e do ISTO (Índice de Substâncias
            Tóxicas e Organolépticas), que é composto pelo grupo de 
            substâncias que afetam a qualidade organoléptica da água, 
            bem como de substâncias tóxicas.")
        ),
        column(
          width = 6,
          highcharter::highchartOutput(ns("hc_gauge_iap"))
        )
      ),
      hr(class = "hr-50"),
      fluidRow(
        column(
          width = 6,
          h2("Índices de Qualidade das Águas para Proteção da Vida Aquática 
             e de Comunidades Aquáticas — IVA "),
          p("Tem o objetivo de avaliar a qualidade das águas para fins 
            de proteção da fauna e flora em geral. O IVA leva em consideração 
            a presença e concentração de contaminantes químicos tóxicos, 
            seu efeito sobre os organismos aquáticos (toxicidade) e duas 
            das variáveis consideradas essenciais para a biota (pH e 
            oxigênio dissolvido).")
        ),
        column(
          width = 6,
          highcharter::highchartOutput(ns("hc_gauge_iva"))
        )
      )
    )
  )
}

#' ugrhi_qualidade Server Functions
#'
#' @noRd 
mod_ugrhi_qualidade_server <- function(id) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    base_filtrada <- reactive({
      base_ugrhi |> 
        dplyr::filter(nome == input$ugrhi)
    })
    
    base_filtrada_contemp <- reactive({
      base_filtrada() %>% 
        dplyr::filter(ano == max(ano))
    })
    
    output$hc_gauge_iqa <- highcharter::renderHighchart({
      base_filtrada() |> 
        dplyr::filter(ano == max(ano)) |> 
        hc_gauge("iqa", c(0, 19, 36, 51, 79, 100), cores_gauge())
    })
    
    output$hc_gauge_iap <- highcharter::renderHighchart({
      base_filtrada() |> 
        dplyr::filter(ano == max(ano)) |> 
        hc_gauge("iap", c(0, 19, 36, 51, 79, 100), cores_gauge())
    })
    
    output$hc_gauge_iva <- highcharter::renderHighchart({
      base_filtrada() |> 
        dplyr::filter(ano == max(ano)) |> 
        hc_gauge("iva", c(0, 2.5, 3.3, 4.5, 6.7, 10), rev(cores_gauge()))
    })
    
  })
}
