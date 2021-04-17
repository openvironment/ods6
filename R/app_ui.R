#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#'
#' @import shiny
#'
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
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
          # bs4SidebarMenuItem(
          #   "Informações gerais",
          #   tabName = "informacoes_gerais",
          #   icon = "bullseye"
          # ),
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
              icon = "water",
              tabName = "munip_abast"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Acesso à coleta de esgoto",
              icon = "toilet",
              tabName = "munip_esgot"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Tratamento de esgoto",
              icon = "swimmer",
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
            "Sobre",
            icon = "info",
            bs4Dash::bs4SidebarMenuSubItem(
              "Este projeto",
              tabName = "sobre_projeto",
              icon = "database"
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
        bs4Dash::bs4TabItems(
          # bs4TabItem(
          #   tabName = "informacoes_gerais",
          #   mod_informacoes_gerais_ui("informacoes_gerais_ui_1")
          # ),
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
          content = "Proporção da população que utiliza serviços de água potável gerenciados de forma segura. Valores maiores que 100% sugerem inconsistências nos dados declarados pelo município."
        ),
        tippy::tippy_class(
          "tip-esgotamento", 
          content = "Proporção da população que utiliza serviços de saneamento gerenciados de forma segura. Valores maiores que 100% sugerem inconsistências nos dados declarados pelo município."
        )
      ),
      
      #---
      footer = bs4Dash::bs4DashFooter(
        copyrights = a(
          href = "https://www.curso-r.com/",
          target = "_blank", 
          HTML("Desenvolvido pela equipe da Curso-R")
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
      app_title = 'ODS6'
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

