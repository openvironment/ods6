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
        h2("Indicador de acesso à água"),
        p("O acesso universal à água segura é condição necessária 
          para a realização de direitos fundamentais como o direito 
          à vida, à saúde e à educação.")
      )
    ),
    br(),
    fluidRow(
      card_indicadores(
        title = "ODS 6.1.1",
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

  })
}

