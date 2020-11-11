#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#'
#' @noRd
app_server <- function( input, output, session ) {

  mod_sumario_server("sumario")

  mod_dados_server(
    "dados",
    dados = datasets::mtcars,
    resizable = TRUE,
    filterable = TRUE,
    searchable = TRUE,
    showPageSizeOptions = TRUE,
    compact = TRUE,
    wrap = FALSE,
    highlight = TRUE,
    defaultPageSize = 10,
    defaultColDef = reactable::colDef(footer = function(values) {
      if (!is.numeric(values)) return()

      if(length(unique(values)) > 15) {
        values <- cut(values, breaks = 15)
      }

      sparkline::sparkline(
        table(values),
        type = "bar",
        width = 130,
        height = 30,
        barColor = status_para_cor("primary")
      )
    })

  )
}
