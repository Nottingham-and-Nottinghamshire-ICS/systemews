#' residuals UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_residuals_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    selectInput(ns("spcFacet"), "Divide SPC by:",
                choices = c("No division" = "none",
                            "Weekday/ weekend" = "weekend",
                            "Day of week" = "day_of_week")),

    textOutput(ns("ljungBox")),
    
    hr(),
    
    plotOutput(ns("residualCheck")),
    
    hr(),
    
    plotOutput(ns("spcResidual"))
  )
}
    
#' residuals Server Functions
#'
#' @noRd 
mod_residuals_server <- function(id, data, variable, model){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$ljungBox <- renderText({
      
      p_value <- forecast::checkresiduals(model())$p.value
      
      p_cutoff <- ifelse(p_value < 0.05, "", "not ")
      
      paste0("Ljung Box test returns p of ", round(p_value, 3), ", indicating that 
               residuals are ", p_cutoff, "autocorrelated")
    })
    
    # plot of residuals
    
    output$residualCheck <- renderPlot({
      
      forecast::checkresiduals(model())
    })
    
    # SPC of residuals
    
    output$spcResidual <- renderPlot({
      
      if(input$spcFacet != "none"){
        facet <- rlang::expr(~ !!(rlang::sym(input$spcFacet)))
        
      } else {
        
        facet <- rlang::expr(~ TRUE)
      }
      
      return(
        data() %>% 
          dplyr::mutate(error = model()$errors) %>% 
          tail(100) %>% 
          qicharts2::qic(data = .,
              x = Date, 
              y = error, 
              chart = "i",
              xlab = "Date",
              title = "Residuals over time",
              facet = facet)
      )
    })
  })
}
