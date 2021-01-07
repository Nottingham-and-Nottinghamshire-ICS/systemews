#' build_forecast UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_build_forecast_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    h3("Accuracy"),
    
    sliderInput(ns("h_step_forecast"),
                "Accuracy graph/ calculation forecast horizon",
                min = 1, max = 30,
                value = 1),
    
    textOutput(ns("accuracyText")),
    
    dygraphs::dygraphOutput(ns("accuracyPlot")),
    
    hr(),
    
    h3("Forecast"),
    
    p("Blue shading indicates 80% prediction intervals"),
    
    dygraphs::dygraphOutput(ns("forecast"))
  )
}

#' build_forecast Server Functions
#'
#' @noRd 
mod_build_forecast_server <- function(id, data, variable){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    the_model <- reactive({
      
      fit_tbats(input_data = data(), variable())
    })
    
    the_forecast <- reactive({
      
      forecast_tbats(the_model(), 30)
    })
    
    output$forecast <- dygraphs::renderDygraph({
      
      plot_dygraph(input_data = data(), 
                   fitted_forecast = the_forecast(),
                   variable_name = variable())
    })
    
    output$accuracyPlot <- dygraphs::renderDygraph({
      
      plot_fitted(input_data = data(), 
                  model = the_model(), 
                  variable_name = variable(), 
                  h = input$h_step_forecast)
    })
  })
}
