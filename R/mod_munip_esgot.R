#' munip_esgot UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_munip_esgot_ui <- function(id){
  ns <- NS(id)
  div(
    class = "card-indicadores munip-esgot",
    fluidRow(
      column(
        width = 12,
        h2("Indicador de acesso à coleta de esgoto"),
        p(" O acesso à coleta de esgoto é condição primordial para a
          promoção da saúde e redução da vulnerabilidade social.")
      )
    ),
    br(),
    fluidRow(
      card_indicadores(
        title = "ODS 6.2.1", 
        mod_aux_ind_od6_ui(
          ns("aux_ind_od6_ui_1"),
          desc_onu = "Até 2030, alcançar o acesso a saneamento e 
              higiene adequados e equitativos para todos, e acabar 
              com a defecação a céu aberto, com especial atenção 
              para as necessidades das mulheres e meninas e daqueles 
              em situação de vulnerabilidade.",
          desc_br = "Meta mantida sem alteração.",
          text_pie_chart = "*Referente à população servida por 
              serviços de saneamento gerenciados de forma segura."
        )
      )
    )
  )
}

#' munip_esgot Server Functions
#'
#' @noRd 
mod_munip_esgot_server <- function(id, base_filtrada,
                                   base_filtrada_contemp){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    mod_aux_ind_od6_server(
      "aux_ind_od6_ui_1",
      base_filtrada,
      base_filtrada_contemp,
      indicador = "prop_pop_servida_coleta_esgoto",
      nome_indicador_ods = "Proporção da população que utiliza 
      serviços de saneamento gerenciados de forma segura",
      tipo_servicos = c("prop_pop_servida_rede_coleta", "prop_pop_fossa_septica")
    )
    
  })
}

## To be copied in the UI
# mod_munip_esgot_ui("munip_esgot_ui_1")

## To be copied in the server
# mod_munip_esgot_server("munip_esgot_ui_1")
