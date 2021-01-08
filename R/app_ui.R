#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    fluidPage(
      h1("systemews"),
      
      sidebarLayout(
        sidebarPanel(
          
          uiOutput("dateRangeInput"),
          
          uiOutput("variableSelectorUI"),
          
          p("Select your variable and date range and then click calculate."),
          p("Each time you make changes you will need to click calculate"),
          
          actionButton("calculate", "Calculate..."), 
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
          tabsetPanel(id = "tabsetID",
                      tabPanel(value = "forecastDetail",
                               "Forecast",
                               mod_build_forecast_ui("build_forecast_ui_1")
                      ),
                      
                      tabPanel(value = "spc",
                               "SPC",
                               mod_spc_ui("spc_ui_1")),

                      tabPanel(value = "decomposition",
                               "Decomposition",
                               mod_decomposition_ui("decomposition_ui_1")
                      ),
                    tabPanel(value = "residuals",
                             "Residual check",
                             mod_residuals_ui("residuals_ui_1")
                      )
          )
        )
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'systemews'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

