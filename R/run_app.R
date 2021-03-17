#' Run the Shiny Application
#'
#' @param ... A series of options to be used inside the app.
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom golem with_golem_options
run_app <- function(...) {
  with_golem_options(
    app = do.call(shinyApp, list(
      ui = app_ui,
      server = app_server,
      options = list(launch.browser = FALSE, port = 4242)
    )),
    golem_opts = list(...)
  )
}
