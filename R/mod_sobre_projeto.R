#' sobre_projeto UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_sobre_projeto_ui <- function(id){
  ns <- NS(id)
  div(
    class = "sobre",
    fluidRow(
      column(
        width = 12,
        includeMarkdown(
          system.file("sobre_projeto.md", package = "ods6")
        )
      )
    ),
    br(),
    fluidRow(
      bs4Dash::bs4UserCard(
        src = "www/user.jpeg",
        title = "Adelaide Cassia Nardocci",
        subtitle = "título",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
        tempor incididunt ut labore et dolore magna aliqua."
      ),
      bs4Dash::bs4UserCard(
        src = "www/user.jpeg",
        title = "Americo Sampaio",
        subtitle = "título",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
        tempor incididunt ut labore et dolore magna aliqua."
      ),
      bs4Dash::bs4UserCard(
        src = "www/user.jpeg",
        title = "Maria Tereza Pepe Razzolini",
        subtitle = "título",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
        tempor incididunt ut labore et dolore magna aliqua."
      ),
      bs4Dash::bs4UserCard(
        src = "www/william_amorim.jpg",
        title = "William Nilson de Amorim",
        subtitle = "Cientista de dados", 
        div(
          "Doutor em Estatística pelo Instituto de Matemática e Estatística
        da Universidade de São Paulo. Cientista de dados e professor na
        Curso-R. Especialista em criação de dashboards em Shiny.",
          div(
            class = "redes-sociais",
            tags$a(
              href = "https://twitter.com/wamorim_",
              target = "_blank",
              icon("twitter")
            ),
            tags$a(
              href = "https://www.linkedin.com/in/william-amorim-796798210/",
              target = "_blank",
              icon("linkedin")
            ),
            tags$a(
              href = "https://github.com/williamorim",
              target = "_blank",
              icon("github")
            ),
            tags$a(
              href = "https://wamorim.com/",
              target = "_blank",
              icon("globe")
            )
          )
        )
      )
    )
  )
}

#' sobre_projeto Server Functions
#'
#' @noRd 
mod_sobre_projeto_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
  })
}
