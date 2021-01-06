#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  
  # render scale names in UI 
  
  output$variableSelectorUI <- renderUI({
    
    names_data <- all_data() %>% 
      dplyr::select(-Date, -day_of_week, -weekend) %>% 
      names()
    
    selectInput("variableSelector",
                "Variable selector",
                choices = names_data)
  })
  
  # render the date range input
  
  output$dateRangeInput <- renderUI({
    
    dateRangeInput("dateRange", "Date range",
                   start = as.Date("2020-03-01"),
                   end = as.Date("2020-07-01"))
  })
  
  # load data and filter by date
  
  all_data <- mod_data_load_server("data_load_ui_1")
  
  filter_data <- reactive({
    all_data() %>% 
      dplyr::filter(Date >= input$dateRange[1], Date <= input$dateRange[2])
  })
  
  mod_build_forecast_server("build_forecast_ui_1", data = filter_data)
}
