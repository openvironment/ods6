#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#'
#' @import shiny
#'
#' @noRd
app_ui <- function(request) {
  ano <- max(base_indicadores$ano)
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    shiny::withMathJax(),
    shinyjs::useShinyjs(),
    # List the first level UI elements here
    bs4Dash::bs4DashPage(
      sidebar_mini = TRUE,
      title = "Painel ODS6 | SP",

      #---
      navbar = bs4Dash::bs4DashNavbar(
        div(
          class = "app-title",
          h1(
            "Painel ODS6",
            span("para o Estado de São Paulo", class = "title-sec-color")
          )
        )
      ),

      #---
      sidebar = bs4Dash::bs4DashSidebar(
        skin = "light",
        bs4Dash::bs4SidebarMenu(
          id = "tabs",
          bs4Dash::bs4SidebarMenuItem(
            "Análise por município",
            icon = "city",
            startExpanded = TRUE,
            bs4Dash::bs4SidebarMenuSubItem(
              "Resumo",
              icon = "file-contract",
              tabName = "munip_resumo"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Acesso à água",
              icon = "shower",
              tabName = "munip_abast"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Acesso à coleta de esgoto",
              icon = "toilet",
              tabName = "munip_esgot"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Tratamento de esgoto",
              icon = "hand-holding-water",
              tabName = "munip_trat_esgoto"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Uso eficiente da água",
              icon = "faucet",
              tabName = "munip_uso_eficiente"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Inconsistências",
              icon = "exclamation-circle",
              tabName = "munip_incons"
            )
          ),
          bs4Dash::bs4SidebarMenuItem(
            "Análise por UGRHI",
            icon = "water",
            bs4Dash::bs4SidebarMenuSubItem(
              "Disponibilidade hídrica",
              icon = "flask",
              tabName = "ugrhi_disp"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Qualidade das águas",
              icon = "flask",
              tabName = "ugrhi_qualidade"
            )
          ),
          bs4Dash::bs4SidebarMenuItem(
            "Sobre",
            icon = "info",
            bs4Dash::bs4SidebarMenuSubItem(
              "Este projeto",
              tabName = "sobre_projeto",
              icon = "info-circle"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Dados",
              tabName = "sobre_dados",
              icon = "database"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Metodologia",
              tabName = "sobre_metodologia",
              icon = "pen"
            )
          )
        ),
        img(src = "www/img_agua.jpeg", class = "logo-agua")
      ),

      #---
      body = bs4Dash::bs4DashBody(
        mod_select_munip_ui("select_munip_ui_1"),
        mod_select_ugrhi_ui("select_ugrhi_ui_1"),
        bs4Dash::bs4TabItems(
          bs4Dash::bs4TabItem(
            tabName = "munip_resumo",
            mod_munip_resumo_ui("munip_resumo_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "munip_abast",
            mod_munip_abast_ui("munip_abast_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "munip_esgot",
            mod_munip_esgot_ui("munip_esgot_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "munip_trat_esgoto",
            mod_munip_trat_esgoto_ui("munip_trat_esgoto_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "munip_uso_eficiente",
            mod_munip_uso_eficiente_ui("munip_uso_eficiente_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "munip_incons",
            mod_munip_incons_ui("munip_incons_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "ugrhi_disp",
            mod_ugrhi_disp_ui("ugrhi_disp_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "ugrhi_qualidade",
            mod_ugrhi_qualidade_ui("ugrhi_qualidade_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "sobre_projeto",
            mod_sobre_projeto_ui("sobre_projeto_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "sobre_dados",
            mod_sobre_dados_ui("sobre_dados_ui_1")
          ),
          bs4Dash::bs4TabItem(
            tabName = "sobre_metodologia",
            mod_sobre_metodologia_ui("sobre_metodologia_ui_1")
          )
        ),
        # TIPs
        tippy::tippy_class(
          "tip-abastecimento", 
          content = "Proporção da população que utiliza serviços de água 
          potável gerenciados de forma segura.
          Valores acima de 100% sugerem deficiência no método proposto
          pelo SNIS para avaliação desse indicador ou inconsistência nos 
          dados encaminhados pelo prestador de serviço."
        ),
        tippy::tippy_class(
          "tip-esgotamento", 
          content = "Proporção da população que utiliza serviços de 
          saneamento gerenciados de forma segura. Valores acima de 100% 
          sugerem deficiência no método proposto
          pelo SNIS para avaliação desse indicador ou inconsistência nos 
          dados encaminhados pelo prestador de serviço."
        ),
        tippy::tippy_class(
          "tip-esgoto-tratado", 
          content = "Proporção do fluxo de águas residuais doméstica e industrial tratadas de forma segura."
        ),
        tippy::tippy_class(
          "tip-populacao",
          content = glue::glue(
            "População do município em {ano}. Em anos censitários,
            estimativa do censo. Em anos não censitários, projeção do SEADE."
          )
        ),
        
      ),
      
      #---
      footer = bs4Dash::bs4DashFooter(
        copyrights = a(
          href = "https://www.curso-r.com/",
          target = "_blank", 
          HTML("Desenvolvido em Shiny pela equipe da Curso-R")
        ),
        right_text = "2021 | FSP-USP"
      )
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @importFrom shiny tags
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){

  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'Painel ODS6 | SP'
    ),
    tags$link(
      rel = "preconnect",
      href="https://fonts.gstatic.com"
    ),
    tags$link(
      rel = "stylesheet",
      href="https://fonts.googleapis.com/css2?family=Oswald:wght@200;300;400;500;600;700&display=swap"
    )
  )
}

