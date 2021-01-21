#' visao_cidade UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_visao_cidade_ui <- function(id) {
  ns <- NS(id)
  tagList(
    fluidRow(
      col_12(
        uiOutput(ns("ui_select_cidade"))
      )
    ),
    fluidRow(
      bs4Dash::bs4Card(
        width = 8,
        title = "Principais indicadores",
        solidHeader = TRUE,
        status = "info",
        height = "350px",
        collapsible = FALSE,
        closable = FALSE,
        reactable::reactableOutput(ns("tab_resumo"))
      ),
      col_4(
        bs4Dash::bs4ValueBoxOutput(ns("vb_populacao"), width = 12),
        bs4Dash::bs4ValueBoxOutput(ns("vb_num_domicilios"), width = 12),
        bs4Dash::bs4ValueBoxOutput(ns("vb_taxa_pop_domicilios"), width = 12)
      )
    ),
    fluidRow(
      bs4Dash::bs4Card(
        width = 12,
        title = "Alertas",
        solidHeader = TRUE,
        status = "danger",
        height = "300px",
        collapsible = FALSE,
        closable = FALSE,
        reactable::reactableOutput(ns("tab_alertas"))
      )
    ),
    br(),
    fluidRow(
      col_6(
        uiOutput(ns("ui_select_indicador"))
      ),
      col_4(
        offset = 2,
        bs4Dash::bs4ValueBoxOutput(ns("vb_valor_ind_atual"), width = 12)
      )
    ),
    fluidRow(
      bs4Dash::bs4Card(
        width = 12,
        height = "420px",
        status = "info",
        title = "Série histórica",
        solidHeader = TRUE,
        highcharter::highchartOutput(ns("plot_serie"), height = "360px")
      )
    )
  )
}

#' visao_cidade Server Function
#'
#' @noRd 
mod_visao_cidade_server <- function(id) {
  moduleServer( id, function(input, output, session) {
    
    ns <- session$ns
    
    output$ui_select_cidade <- renderUI({

      opcoes <- base_indicadores %>%
        dplyr::pull(munip_nome) %>%
        unique() %>%
        sort()

      selectInput(
        inputId = ns("select_cidade"),
        label = "Selecione uma cidade",
        selected = "São Paulo",
        choices = opcoes,
        width = "30%"
      )

    })

    base_filtrada <- reactive({
      req(input$select_cidade)
      base_indicadores %>%
        dplyr::filter(munip_nome == input$select_cidade)
    })
    

    output$vb_populacao <- bs4Dash::renderbs4ValueBox({
      valor <- base_filtrada() %>%
        filtrar_ano_mais_recente() %>%
        dplyr::pull(proj_pop_total) %>%
        formatar_numero(accuracy = 1)
      
        bs4Dash::bs4ValueBox(
          value = "População",
          subtitle = valor,
          icon = "user-friends",
          status = "info",
          footer = "Número de habitantes"
        )
    })

    output$vb_num_domicilios <- bs4Dash::renderbs4ValueBox({
      valor <- base_filtrada() %>%
        filtrar_ano_mais_recente() %>%
        dplyr::pull(proj_domicilios_total) %>%
        formatar_numero(accuracy = 1)
      
      bs4Dash::bs4ValueBox(
          value = "Número de domicílios",
          subtitle = valor,
          icon = "home",
          status = "info",
          footer = "Domicílios permanentes ocupados"
        )
    })
    
    output$vb_taxa_pop_domicilios <- bs4Dash::renderbs4ValueBox({
      valor <- base_filtrada() %>%
        filtrar_ano_mais_recente() %>%
        dplyr::pull(taxa_hab_domicilio) %>%
        formatar_numero()
      
      bs4Dash::bs4ValueBox(
        value = "Habiantes por domicílio",
        subtitle = valor,
        icon = "house-user",
        status = "info",
        footer = "Domicílios permanentes ocupados"
      )
    })
    
    output$tab_resumo <- reactable::renderReactable({
      base_filtrada() %>%
        filtrar_ano_mais_recente() %>%
        dplyr::select(
          prop_pop_abast_sist_adequados,
          prop_pop_servida_coleta_esgoto,
          prop_esgoto_tratado,
          prop_perdas_rede_dist,
          consumo_medio_per_capita
        ) %>%
        dplyr::mutate_at(
          dplyr::vars(-consumo_medio_per_capita),
          ~scales::percent(.x, accuracy = 0.1, scale = 1)
        ) %>%
        dplyr::mutate(
          consumo_medio_per_capita = paste(
            round(consumo_medio_per_capita),
            "litros/habitante/dia"
          )
        ) %>%
        tidyr::gather(var, val) %>%
        dplyr::left_join(
          tab_depara,
          by = c("var" = "cod")
        ) %>%
        dplyr::select(nome_formatado, val) %>%
        reactable::reactable(
          columns = list(
            nome_formatado = reactable::colDef(
              name = "Indicador",
              align = "left"
            ),
            val = reactable::colDef(
              name = "",
              align = "right"
            )
          ),
          striped = TRUE,
          highlight = TRUE
        )
    })

    output$tab_alertas <- reactable::renderReactable({
      base_filtrada() %>%
        filtrar_ano_mais_recente() %>%
        dplyr::select(dplyr::starts_with("prop"), prop_perdas_rede_dist) %>%
        tidyr::gather(var, val) %>%
        dplyr::filter(val > 100) %>%
        dplyr::arrange(dplyr::desc(val)) %>%
        dplyr::mutate(
          val = scales::percent(val, accuracy = 0.1, scale = 1)
        ) %>%
        dplyr::left_join(
          tab_depara,
          by = c("var" = "cod")
        ) %>%
        dplyr::select(nome_formatado, val) %>%
        reactable::reactable(
          columns = list(
            nome_formatado = reactable::colDef(
              name = "Indicador",
              align = "left"
            ),
            val = reactable::colDef(
              name = "",
              align = "right"
            )
          ),
          striped = TRUE,
          highlight = TRUE
        )
    })

    output$ui_select_indicador <- renderUI({

      opcoes <- seleciona_indicadores(base_indicadores, tab_depara)

      selectInput(
        inputId = ns("select_indicador"),
        label = "Selecione um indicador",
        choices = opcoes,
        width = "100%"
      )
    })

    unidade_medida <- reactive({
      req(input$select_indicador)
      pegar_unidade_de_medida(input$select_indicador)
    })

    output$vb_valor_ind_atual <- bs4Dash::renderbs4ValueBox({
      
      valor <- base_filtrada() %>%
        filtrar_ano_mais_recente() %>%
        dplyr::pull(isolate(input$select_indicador)) %>%
        formatar_indicador(unidade_medida())
      
      bs4Dash::bs4ValueBox(
        value = valor,
        subtitle = unidade_medida(),
        icon = "water",
        status = "primary",
        footer = "Valor atual"
      )

    })

    output$plot_serie <- highcharter::renderHighchart({
      
      req(input$select_indicador)

      nome_formatado <- pegar_nome_formatado(
        isolate(input$select_indicador)
      )
      
      base_filtrada() %>%
        dplyr::select(ano, value = isolate(input$select_indicador)) %>%
        dplyr::arrange(ano) %>%
        as.matrix() %>%
        hc_serie(nome_formatado, unidade_medida())
    })
    
  })
  
}
