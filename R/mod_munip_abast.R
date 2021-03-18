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
  div(
    class = "card-indicadores munip-abast",
    fluidRow(
      column(
        width = 12,
        h2("Indicadores de acesso a água"),
        br(),
        p("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
          tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
          veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
          ea commodo consequat.")
      )
    ),
    br(),
    fluidRow(
      card_indicadores(
        id = "tabcard-abast",
        bs4Dash::bs4TabPanel(
          tabName = "ODS 6.1", 
          active = TRUE,
          mod_aux_ind_od6_ui(
            ns("aux_ind_od6_ui_1"),
            desc_onu = "Até 2030, alcançar o acesso universal e 
                  equitativo à água potável e segura para todos.",
            desc_br = "Até 2030, alcançar o acesso universal e 
                  equitativo à água para consumo humano, segura e acessível 
                  para todas e todos.",
            text_pie_chart = "*Referente à população abastecidada por 
              serviços de água potável gerenciados de forma segura."
          )
        ),
        bs4Dash::bs4TabPanel(
          tabName = "Outros indicadores", 
          active = FALSE,
          mod_aux_outros_indicadores_ui(
            ns("aux_outros_indicadores_ui_1"),
            indicadores = c(
              "Consumo médio per capita" = "consumo_medio_per_capita",
              "Perda na distribuição" = "prop_perdas_rede_dist"
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
mod_munip_abast_server <- function(id, base_filtrada, 
                                   base_filtrada_contemp) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    mod_aux_ind_od6_server(
      "aux_ind_od6_ui_1",
      base_filtrada,
      base_filtrada_contemp,
      indicador = "prop_pop_abast_sist_adequados",
      nome_indicador_ods = "Proporção da população que utiliza 
      serviços de água potável gerenciados de forma segura",
      tipo_servicos = c("pop_servida_abast_agua", "pop_servida_poco_nasc")
    )
    
    mod_aux_outros_indicadores_server(
      "aux_outros_indicadores_ui_1",
      base_filtrada,
      base_filtrada_contemp
    )
  })
}

