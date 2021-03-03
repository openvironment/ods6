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
      title = "ODS6",

      #---
      navbar = bs4Dash::bs4DashNavbar(),

      #---
      sidebar = bs4Dash::bs4DashSidebar(
        skin = "light",
        title = "ODS6",
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
              "Acesso a água",
              icon = "water",
              tabName = "munip_abast"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Acesso a esgoto",
              icon = "toilet",
              tabName = "munip_esgot"
            ),
            bs4Dash::bs4SidebarMenuSubItem(
              "Inconsistências",
              icon = "exclamation-circle",
              tabName = "munip_incons"
            )
          ),
          bs4Dash::bs4SidebarMenuItem(
            "Sobre",
            tabName = "sobre",
            icon = "info"
          )
        )
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
            tabName = "munip_incons",
          ),
          bs4Dash::bs4TabItem(
            tabName = "sobre",
            mod_sobre_ui("sobre_ui_1")
          )
        ),
        # TIPs
        tippy::tippy_class(
          "tip-abastecimento", 
          content = "Proporção de pessoas no município abastecidas por sistemas adequados."
        ),
        tippy::tippy_class(
          "tip-esgotamento", 
          content = "Proporção de pessoas no município servidas por rede de esgoto."
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
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

