#' ugrhi_disp UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ugrhi_disp_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' ugrhi_disp Server Functions
#'
#' @noRd 
mod_ugrhi_disp_server <- function(id, ugrhi) {
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
