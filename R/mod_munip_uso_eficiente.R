#' munip_uso_eficiente UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_munip_uso_eficiente_ui <- function(id){
  ns <- NS(id)
  div(
    class = "card-indicadores tabcard-indicadores",
    fluidRow(
      column(
        width = 12,
        h2("Meta 6.4 - Uso eficiente da água"),
        div(
          class = "meta-desc",
          tags$p(
            span(
              class = "meta-origem",
              "Nações Unidas"
            ),
            "Até 2030, aumentar substancialmente a eficiência do 
          uso da água em todos os setores e assegurar retiradas 
          sustentáveis e o abastecimento de água doce para enfrentar 
          a escassez de água, e reduzir substancialmente o número 
          de pessoas que sofrem com a escassez de água."
          ),
          tags$p(
            span(
              class = "meta-origem",
              "Brasil"
            ),
            "Até 2030, aumentar substancialmente a eficiência do 
          uso da água em todos os setores, assegurando retiradas sustentáveis 
          e o abastecimento de água doce para reduzir substancialmente o número 
          de pessoas que sofrem com a escassez."
          )
        )
      )
    ),
    br(),
    fluidRow(
      tabCard_indicadores(
        id = "ods64",
        bs4Dash::bs4TabPanel(
          tabName = "Consumo médio per capita",
          mod_aux_ind_od6_ui(
            ns("aux_ind_od6_ui_1"),
            desc_ind = "Segundo Organização Mundial da Saúde cada pessoa deve ter no 
          mínimo 110 litros de água por dia para atender as suas 
          necessidades de consumo e higiene.",
            text_pie_chart = ""
          )
        ),
        bs4Dash::bs4TabPanel(
          tabName = "Perda na distribuição",
          mod_aux_ind_od6_ui(
            ns("aux_ind_od6_ui_2"),
            desc_ind = "Segundo Organização Mundial da Saúde cada pessoa deve ter no 
          mínimo 110 litros de água por dia para atender as suas 
          necessidades de consumo e higiene.",
            text_pie_chart = ""
          )
        )
      )
    )
  )
}
    
#' munip_uso_eficiente Server Functions
#'
#' @noRd 
mod_munip_uso_eficiente_server <- function(id, base_filtrada, 
                                           base_filtrada_contemp){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    mod_aux_ind_od6_server(
      "aux_ind_od6_ui_1",
      base_filtrada,
      base_filtrada_contemp,
      indicador = "consumo_medio_per_capita",
      nome_indicador_ods = "Consumo médio per capita",
      tipo_servicos = "",
      indicador_alerta = "*Refere-se apenas aos sistemas públicos coletivos."
    )
    
    mod_aux_ind_od6_server(
      "aux_ind_od6_ui_2",
      base_filtrada,
      base_filtrada_contemp,
      indicador = "prop_perdas_rede_dist",
      nome_indicador_ods = "Perda na distribuição",
      tipo_servicos = "",
      indicador_alerta = "*Refere-se apenas aos sistemas públicos coletivos."
    )
 
  })
}
    
