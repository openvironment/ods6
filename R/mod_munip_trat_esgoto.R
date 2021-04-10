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
        h2("Indicador de tratamento de esgoto doméstico"),
        p("O tratamento de esgoto doméstico é condição necessária para a 
          promoção da saúde e a melhoria da qualidade dos recursos 
          hídricos, em especial aqueles destinados ao abastecimento 
          público.")
      )
    ),
    br(),
    fluidRow(
      card_indicadores(
        title = "ODS 6.3.1",
        mod_aux_ind_od6_ui(
          ns("aux_ind_od6_ui_1"),
          desc_onu = "Até 2030, melhorar a qualidade da água, reduzindo a 
          poluição, eliminando despejo e minimizando a liberação de produtos 
          químicos e materiais perigosos, reduzindo à metade a proporção de 
          águas residuais não tratadas e aumentando substancialmente a 
          reciclagem e reutilização segura globalmente.",
          desc_br = "Até 2030, melhorar a qualidade da água nos corpos 
          hídricos, reduzindo a poluição, eliminando despejos e minimizando
          o lançamento de materiais e substâncias perigosas, reduzindo 
          pela metade a proporção do lançamento de efluentes não tratados
          e aumentando substancialmente o reciclo e reuso seguro 
          localmente.",
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
      nome_indicador_ods = "Proporção do fluxo de águas residuais doméstica e 
      industrial tratadas de forma segura.",
      tipo_servicos = NULL
    )
 
  })
}
