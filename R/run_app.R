#' Run the Shiny Application
#'
#' @param auth0 whether to use auth0 or not
#' @param ... A series of options to be used inside the app.
#'
#' @export
#' @importFrom shiny shinyApp
#' @importFrom auth0 shinyAppAuth0
#' @importFrom golem with_golem_options
run_app <- function(auth0 = FALSE, ...) {
  engine <- ifelse(auth0, shinyAppAuth0, shinyApp)
  with_golem_options(
    app = do.call(engine, list(
      ui = app_ui,
      server = app_server,
      options = list(launch.browser =TRUE)
    )),
    golem_opts = list(...)
  )
}
