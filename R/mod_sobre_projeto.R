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
        src = "www/adelaide.jpg",
        title = "Adelaide Cassia Nardocci",
        subtitle = "Professora e pesquisadora",
        div(
          "Doutora em Saúde Pública, Professora Associada do Departamento de 
          Saúde Ambiental da Faculdade de Saúde Pública da USP."
        )
      ),
      bs4Dash::bs4UserCard(
        src = "www/americo.jpg",
        title = "Americo Sampaio",
        subtitle = "Engenheiro civil e sanitarista",
        "Engenheiro Civil e Sanitarista, Mestre em hidráulica e saneamento pela 
        escola de engenharia de São Carlos. Foi Superintendente de Pesquisa, 
        Desenvolvimento Tecnológico e Inovação da Sabesp e Coordenador de
        Saneamento da Secretaria de Saneamento e Recursos Hídricos do Estado 
        de São Paulo."
      ),
      bs4Dash::bs4UserCard(
        src = "www/maria.png",
        title = "Maria Tereza Pepe Razzolini",
        subtitle = "Professora e pesquisadora",
        div(
          "Doutora em Saúde Pública, Professora Associada do Departamento 
          de Saúde Ambiental da Faculdade de Saúde Pública da USP.",
          div(
            class = "redes-sociais",
            tags$a(
              href = "http://lattes.cnpq.br/8467049839493963",
              target = "_blank",
              icon("map-marker")
            ),
          )
        )
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
