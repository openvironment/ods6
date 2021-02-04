#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#'
#' @importFrom bs4Dash tabPanel tabsetPanel updateTabsetPanel dashboardPage dashboardControlbar dashboardHeader dashboardSidebar bs4SidebarMenu bs4SidebarMenuItem dashboardBody bs4TabItems bs4TabItem dashboardFooter bs4SidebarMenuSubItem
#' @importFrom shiny a tagList icon
#'
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    shinyjs::useShinyjs(),
    # List the first level UI elements here
    dashboardPage(
      enable_preloader = FALSE,
      old_school = FALSE,
      sidebar_mini = TRUE,
      sidebar_collapsed = FALSE,
      controlbar_collapsed = TRUE,
      controlbar_overlay = TRUE,
      # loading_background = "#4682B4",
      title = "ODS6",

      #---
      navbar = dashboardHeader(
        title = "ODS6"
      ),

      #---
      sidebar = dashboardSidebar(
        skin = "light",
        title = "ODS6",
        bs4SidebarMenu(
          # bs4SidebarMenuItem(
          #   "Informações gerais",
          #   tabName = "informacoes_gerais",
          #   icon = "bullseye"
          # ),
          id = "tabs",
          bs4SidebarMenuItem(
            "Análise por município",
            icon = "city",
            startExpanded = TRUE,
            bs4SidebarMenuSubItem(
              "Resumo",
              icon = "",
              tabName = "munip_resumo"
            ),
            bs4SidebarMenuSubItem(
              "Abastecimento",
              icon = "",
              tabName = "munip_abast"
            ),
            bs4SidebarMenuSubItem(
              "Esgotamento sanitário",
              icon = "",
              tabName = "munip_esgot"
            ),
            bs4SidebarMenuSubItem(
              "Inconsistências",
              icon = "",
              tabName = "munip_incons"
            )
          ),
          bs4SidebarMenuItem(
            "Sobre",
            tabName = "sobre",
            icon = "info"
          )
        )
      ),

      #---
      body = dashboardBody(
        fluidRow(
          id = "div_select_munip",
          class = "seletor-munip", 
          column(
            width = 12,
            selectInput_munip(id = "select_munip", width = "100%")
          )
        ),
        bs4TabItems(
          # bs4TabItem(
          #   tabName = "informacoes_gerais",
          #   mod_informacoes_gerais_ui("informacoes_gerais_ui_1")
          # ),
          bs4TabItem(
            tabName = "munip_resumo",
            mod_munip_resumo_ui("munip_resumo_ui_1")
          ),
          bs4TabItem(
            tabName = "munip_abast",
          ),
          bs4TabItem(
            tabName = "munip_esgot",
          ),
          bs4TabItem(
            tabName = "munip_incons",
          ),
          bs4TabItem(
            tabName = "sobre",
            mod_sobre_ui("sobre_ui_1")
          )
        ),
        # TIPs
        tippy::tippy_class(
          "tip-abastecimento", 
          content = 
          "Proporção de pessoas no município abastecidas por sistemas adequados."
        ),
        tippy::tippy_class(
          "tip-esgotamento", 
          content = 
            "Proporção de pessoas no município servidas por rede de esgoto."
        )
      ),
      
      #---
      footer = dashboardFooter(
        copyrights = a(
          href = "https://www.curso-r.com/",
          target = "_blank", 
          HTML("Feito com ❤️&nbsp;pela equipe da Curso-R")
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

