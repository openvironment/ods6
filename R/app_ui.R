#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#'
#' @importFrom bs4Dash tabPanel tabsetPanel updateTabsetPanel dashboardPage dashboardControlbar dashboardHeader dashboardSidebar bs4SidebarMenu bs4SidebarMenuItem dashboardBody bs4TabItems bs4TabItem dashboardFooter
#' @importFrom shiny a tagList icon
#'
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here
    dashboardPage(
      enable_preloader = FALSE,
      old_school = FALSE,
      sidebar_mini = TRUE,
      sidebar_collapsed = FALSE,
      controlbar_collapsed = TRUE,
      controlbar_overlay = TRUE,
      # loading_background = "#4682B4",
      title = "TITULO",

      #---
      controlbar = dashboardControlbar(),

      #---
      navbar = dashboardHeader(
        title = "TITULO",
        rightUi = auth0::logoutButton(icon = icon("sign-out-alt"))
      ),

      #---
      sidebar = dashboardSidebar(
        skin = "light",
        title = "TITULO",
        bs4SidebarMenu(
          bs4SidebarMenuItem(
            "Perfil",
            tabName = "menu_sumario",
            icon = "bullseye"
          ),
          bs4SidebarMenuItem(
            "Dados",
            tabName = "menu_dados",
            icon = "database"
          )
        )
      ),

      #---
      body = dashboardBody(
        fresh::use_theme(create_theme_css()), # <-- use the theme
        bs4TabItems(
          bs4TabItem(
            tabName = "menu_sumario",
            mod_sumario_ui("sumario")
          ),
          bs4TabItem(
            tabName = "menu_dados",
            mod_dados_ui("dados")
          )
        )
      ),

      #---
      footer = dashboardFooter(
        copyrights = a(
          href = "https://rseis.com.br",
          target = "_blank", "R6"
        ),
        right_text = "2020 | desenvolvido pela R6"
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

  shinyjs::useShinyjs()
  add_resource_path(
    'www', app_sys('app/www')
  )

  tags$head(
    favicon(ext = "png"),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'TITULO'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

