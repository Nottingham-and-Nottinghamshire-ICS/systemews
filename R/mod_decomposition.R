#' decomposition UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_decomposition_ui <- function(id){
  ns <- NS(id)
  tagList(

    plotOutput(ns("decomposition"))
  )
}
    
#' decomposition Server Functions
#'
#' @noRd 
mod_decomposition_server <- function(id, data, variable){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    output$decomposition <- renderPlot({
      
      data() %>%
        dplyr::rename(patients = .data[[variable()]]) %>%
        tsibble::tsibble(index = Date) %>% 
        fabletools::model(feasts::STL(patients ~ trend(window = 11) + 
                                        season("1 week"),
                  robust = TRUE)) %>%
        fabletools::components() %>%
        ggplot2::autoplot() + 
        ggplot2::ggtitle("All data STL decomposition")
    })
  })
}
    
## To be copied in the UI
# 
    
## To be copied in the server
# 
