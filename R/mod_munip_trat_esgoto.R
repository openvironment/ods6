#' munip_trat_esgoto UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_munip_trat_esgoto_ui <- function(id){
  ns <- NS(id)
  div(
    class = "card-indicadores munip-abast",
    fluidRow(
      column(
        width = 12,
        h2("Meta 6.3 - Tratamento de esgoto doméstico"),
        div(
          class = "meta-desc",
          tags$p(
            span(
              class = "meta-origem",
              "Nações Unidas"
            ),
            "Até 2030, melhorar a qualidade da água, reduzindo a 
          poluição, eliminando despejo e minimizando a liberação de produtos 
          químicos e materiais perigosos, reduzindo à metade a proporção de 
          águas residuais não tratadas e aumentando substancialmente a 
          reciclagem e reutilização segura globalmente."
          ),
          tags$p(
            span(
              class = "meta-origem",
              "Brasil"
            ),
            "Até 2030, melhorar a qualidade da água nos corpos 
          hídricos, reduzindo a poluição, eliminando despejos e minimizando
          o lançamento de materiais e substâncias perigosas, reduzindo 
          pela metade a proporção do lançamento de efluentes não tratados
          e aumentando substancialmente o reciclo e reuso seguro 
          localmente."
          )
        )
      )
    ),
    br(),
    fluidRow(
      card_indicadores(
        title = "Esgoto tratado",
        mod_aux_ind_od6_ui(
          ns("aux_ind_od6_ui_1"),
          desc_ind = "O tratamento de esgoto doméstico é condição necessária para a 
          promoção da saúde e a melhoria da qualidade dos recursos 
          hídricos, em especial aqueles destinados ao abastecimento 
          público.",
          text_pie_chart = ""
        )
      )
    )
  )
}
    
#' munip_trat_esgoto Server Functions
#'
#' @noRd 
mod_munip_trat_esgoto_server <- function(id, base_filtrada, 
                                         base_filtrada_contemp){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    mod_aux_ind_od6_server(
      "aux_ind_od6_ui_1",
      base_filtrada,
      base_filtrada_contemp,
      indicador = "prop_esgoto_tratado",
      nome_indicador_ods = "Porcentagem de esgoto sanitário tratado em relação ao produzido",
      tipo_servicos = NULL
    )
 
  })
}
