#' spc UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_spc_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    selectInput(ns("spcFacet"), "Divide SPC by:",
                choices = c("No division" = "none",
                            "Weekday/ weekend" = "weekend",
                            "Day of week" = "day_of_week")),
    
    plotOutput(ns("spc"))
  )
}
    
#' spc Server Functions
#'
#' @noRd 
mod_spc_server <- function(id, data, variable){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$spc <- renderPlot({
      
      if(input$spcFacet != "none"){
        facet <- rlang::expr(~ !!(rlang::sym(input$spcFacet)))
        
      } else {
        
        facet <- rlang::expr(~ TRUE)
      }
      
      return(
        data() %>% 
          dplyr::rename(patients = .data[[variable()]]) %>% 
          tail(100) %>% 
          qicharts2::qic(data = .,
              x = Date, 
              y = patients, 
              chart = "i",
              xlab = "Date",
              ylab = "Number of patients",
              facet = facet)
      )
    })
  })
}
