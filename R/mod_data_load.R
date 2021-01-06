#' data_load UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_data_load_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    # no UI
  )
}

#' data_load Server Functions
#'
#' @noRd 
mod_data_load_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    # this loads some prepared data in
    # you could easily convert this module to return the same data
    # from something else like a spreadsheet upload
    
    reactive({
      
      load("data_store/open_data.rda")
      
      open_data %>% 
        dplyr::mutate(weekend = dplyr::case_when(
          lubridate::wday(Date) %in% c(1, 7) ~ "Weekend",
          TRUE ~ "Weekday"
        )) %>% 
        dplyr::mutate(day_of_week = lubridate::wday(Date, label = TRUE))
        
    })
  })
}

## To be copied in the UI
# mod_data_load_ui("data_load_ui_1")
