
#############################
# forecast helper functions #
#############################

# return TBATS model

fit_tbats <- function(input_data, variable_name){
  
  input_data <- input_data %>% 
    tsibble::tsibble(index = Date)
  
  series <- forecast::msts(input_data %>%
                             dplyr::pull({{variable_name}}),
                           seasonal.periods = c(7, 365.25),
                           start = c(lubridate::year(min(input_data$Date)), 
                                     lubridate::yday(min(input_data$Date))))
  
  return(
    forecast::tbats(series)
  )
}

# forecast using TBATS model

forecast_tbats <- function(tbats_model, horizon){
  
  return(
    as.data.frame(
      forecast::forecast(tbats_model, horizon)))
}

# draw dygraph of forecast

plot_dygraph <- function(input_data, fitted_forecast, variable_name){
  
  forecast_data <- fitted_forecast %>% 
    dplyr::mutate(Actual = NA,
                  Date = seq(max(input_data$Date) + 1, by = "day", 
                             length.out = nrow(fitted_forecast))) %>% 
    dplyr::select(Date, Actual, everything())
  
  dygraphs_data <- input_data %>% 
    dplyr::rename(Actual = {{variable_name}}) %>% 
    dplyr::select(Date, Actual) %>% 
    dplyr::mutate(`Point Forecast` = NA,
                  `Lo 80` = NA,
                  `Hi 80` = NA,
                  `Lo 95` = NA,
                  `Hi 95` = NA) %>% 
    dplyr::select(Date, `Actual` : `Hi 95`) %>% 
    dplyr::bind_rows(forecast_data)
  
  dygraphs_data <- xts::xts(dygraphs_data, order.by = dygraphs_data$Date)
  
  dygraphs::dygraph(dygraphs_data) %>%
    dygraphs::dySeries(c("Lo 80", "Point Forecast", "Hi 80")) %>%
    dygraphs::dyRangeSelector(dateWindow = c(max(input_data$Date) - 30,
                                             max(time(dygraphs_data))))
}

# plot fitted h step

plot_fitted <- function(input_data, model, variable_name, h){
  
  fitted_values <- input_data %>% 
    dplyr::select(Date, Actual = {{variable_name}}) %>% 
    dplyr::mutate(fitted = fitted(model, h))
  
  fitted_xts <- xts::xts(fitted_values, order.by = fitted_values$Date)
  
  dygraphs::dygraph(fitted_xts) %>%
    dygraphs::dyRangeSelector(dateWindow = c(max(time(fitted_xts)) - 30,
                                             max(time(fitted_xts))))
}
