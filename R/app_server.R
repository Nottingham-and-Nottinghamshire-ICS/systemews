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
                   start = as.Date("2020-04-01"),
                   end = max(all_data()$Date))
  })
  
  # load data and filter by date
  
  all_data <- mod_data_load_server("data_load_ui_1")
  
  filter_data <- reactive({
    
    req(input$dateRange)
    
    all_data() %>% 
      dplyr::filter(Date >= input$dateRange[1], Date <= input$dateRange[2])
  })
  
  # run forecast module
  
  final_model <- mod_build_forecast_server("build_forecast_ui_1", 
                            data = filter_data,
                            variable = reactive(input$variableSelector))
  
  # run spc module
  
  mod_spc_server("spc_ui_1", data = filter_data,
                 variable = reactive(input$variableSelector))
  
  # run decomposition module
  
  mod_decomposition_server("decomposition_ui_1", 
                           data = filter_data,
                           variable = reactive(input$variableSelector))
  
  # residual module
  
  mod_residuals_server("residuals_ui_1",
                       data = filter_data,
                       variable = reactive(input$variableSelector),
                       model = final_model)
}
