#=======================================================#
#         .POINT FORECAST HIDDEN IMPLEMENTATION         #
#=======================================================#
#' Raw JSON Point Forecast Data
#'
#' @param lat Latitude.
#' @param lon Longitude.
#'
#' @return Returns the json data as a nested list.
#' @export
#'
#' @examples .point_forecast(33, -80)
#' @importFrom httr2 request req_headers req_perform resp_body_json
#' @importFrom stats runif
.point_forecast <- function(lat, lon){

  .point_data(lat = lat, lon = lon) %>%
    .[["properties"]] %>%
    .[["forecastHourly"]] %>%
    httr2::request() %>%
    httr2::req_headers(
      "Cache-Control" = "no-cache",  # Force fresh data
      "Pragma" = "no-cache",          # Compatibility with older servers
      "Feature-Flags" = runif(1, 0, 1000)) %>% #Cache busting...
    httr2::req_perform() %>%
    httr2::resp_body_json() %>%
    return()
}

#=========================================================#
#         ..POINT FORECAST HIDDEN IMPLEMENTATION          #
#=========================================================#
#' Point Forecast Data and Local Timezone
#'
#' @param lat Latitude.
#' @param lon Longitude.
#' @param dir_numeric `TRUE` for numeric directions, `FALSE` for character directions; defaults to `FALSE`.
#' @param timezone The nominal timezone for the forecast. One of `OlsonNames()` or `-1` for local time. Defaults to `-1`.
#'
#' @return A list containing point forecast sf and the timezone.
#' @export
#'
#' @examples
#' \donttest{
#' ..point_forecast(33, -80)
#' }
#' @importFrom lutz tz_lookup_coords
#' @importFrom lubridate with_tz
#' @importFrom dplyr mutate
#' @importFrom sf st_as_sf
..point_forecast <- function(lat, lon, timezone = -1, dir_numeric = FALSE){

  #Set the timezone to local time if it left default ----
  if(timezone == -1){
    timezone <- lutz::tz_lookup_coords(lat, lon, method = "fast", warn = FALSE)
  }

  to_return <- .point_forecast(lat, lon) %>%
    .[["properties"]] %>%
    .[["periods"]] %>%
    purrr::map_dfr( ~ as.data.frame( #Map the json object (a nested list), to a tibble
      list(
        time = .x$startTime %>% #By default gives the observations in local time
          {
            gsub("T", " ", .)
          } %>%
          as.POSIXct(format = "%Y-%m-%d %H:%M:%S") %>%
          lubridate::with_tz(tz = timezone),
        #end_time = .x$endTime, #not necessary
        temp = .x$temperature,
        #temp_trend = .x$temperatureTrend, #Probably not necessary for our purposes
        dewpoint = .x$dewpoint$value,
        humidity = .x$relativeHumidity$value,
        p_rain = .x$probabilityOfPrecipitation$value,
        #measured in mph
        wind_speed = .x$windSpeed %>%
          {
            gsub("mph", "", .)
          } %>%
          trimws(which = "both") %>%
          as.numeric(),
        wind_dir = ifelse(dir_numeric, dir_as_integer(.x$windDirection), .x$windDirection),
        skies = .x$shortForecast
      )
    )
    ) %>%
    dplyr::mutate(lat = lat, lon = lon) %>%
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4326)

  return(list(to_return, timezone))
}

#=================================#
#         POINT FORECAST          #
#=================================#
#' Point Forecast Data
#'
#' @param lat Latitude.
#' @param lon Longitude.
#' @param dir_numeric `TRUE` for numeric directions, `FALSE` for character directions; defaults to `FALSE`.
#' @param timezone The nominal timezone for the forecast. One of `OlsonNames()` or `-1` for local time. Defaults to `-1`.
#'
#' @return Simple features object with forecast meteorological values.
#' @export
#'
#' @examples
#' \donttest{
#' point_forecast(lat = 40.71427000, lon = -74.00597000, dir_numeric = TRUE)
#' }
#' @importFrom lutz tz_lookup_coords
point_forecast <- function(lat, lon, timezone = -1, dir_numeric = FALSE){

  #Set the timezone to local time if it left default ----
  if(timezone == -1){
    timezone <- lutz::tz_lookup_coords(lat, lon, method = "fast", warn = FALSE)
  }

  .point_forecast(lat, lon) %>%
    .[["properties"]] %>%
    .[["periods"]] %>%
    purrr::map_dfr( ~ as.data.frame( #Map the json object (a nested list), to a tibble
      list(
        time = .x$startTime %>% #By default gives the observations in local time
          {
            gsub("T", " ", .)
          } %>%
          as.POSIXct(format = "%Y-%m-%d %H:%M:%S") %>%
          format("%Y-%m-%d %H:%M:%S", tz = timezone, usetz = TRUE),
        #end_time = .x$endTime, #not necessary
        temp = .x$temperature,
        #temp_trend = .x$temperatureTrend, #Probably not necessary for our purposes
        dewpoint = .x$dewpoint$value,
        humidity = .x$relativeHumidity$value,
        p_rain = .x$probabilityOfPrecipitation$value,
        #measured in mph
        wind_speed = .x$windSpeed %>%
          {
            gsub("mph", "", .)
          } %>%
          trimws(which = "both") %>%
          as.numeric(),
        wind_dir = ifelse(dir_numeric, dir_as_integer(.x$windDirection), .x$windDirection),
        skies = .x$shortForecast
        )
      )
    ) %>%
    dplyr::mutate(lat = lat, lon = lon) %>%
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
    return()
}

#=================================#
#         POINT TOMORROW          #
#=================================#
#' Fetch the weather forecast for a lat/lon point tomorrow, denominated in the given timezone.
#'
#' @param lat Latitude.
#' @param lon Longitude.
#' @param dir_numeric `TRUE` for numeric directions, `FALSE` for character directions; defaults to `FALSE`.
#' @param timezone The nominal timezone for the forecast. One of `OlsonNames()` or `-1` for local time. Defaults to `-1`.
#' @param short `TRUE` for only tomorrow, `FALSE` for today and tomorrow; defaults to `TRUE`.
#'
#' @return Simple features object with forecast meteorological values.
#' @export
#'
#' @examples
#' \donttest{
#' point_tomorrow(lat = 33, lon = -80)
#' }
#' @importFrom lubridate force_tz
point_tomorrow <- function(lat, lon, timezone = -1, dir_numeric = FALSE, short = TRUE){

  # Get the point forecast in local time, worry about timezone adjustments later...
  to_return <- ..point_forecast(lat = lat, lon = lon, timezone = -1, dir_numeric = dir_numeric)

  if(short){
    to_return[[1]] <- to_return[[1]] %>%
      dplyr::filter(
        time >= {Sys.Date() + 1} %>% lubridate::force_tz(to_return[[2]]), #midnight tonight in local time
        time < {Sys.Date() + 2} %>% lubridate::force_tz(to_return[[2]]) #midnight tomorrow in local time
      )
  }else{
    to_return[[1]] <- to_return[[1]] %>%
      dplyr::filter(
        time < {Sys.Date() + 1} %>% lubridate::force_tz(to_return[[2]])
      )
  }

  if(timezone == -1){ #Alias for local time when we have timezone == -1
    timezone <- to_return[[2]]
  }

  to_return[[1]] %>%
    #put the result in the requested timezone and format it as requested
    dplyr::mutate(time = format(time, "%Y-%m-%d %H:%M:%S", tz = timezone, usetz = TRUE)) %>%
    return()
}
