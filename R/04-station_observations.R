#=======================================#
#         STATION OBSERVATIONS          #
#=======================================#
#' Station Observations
#'
#' @param station_id The station identifier (ex: KDEN, KBOS, KNYC, etc).
#' @param dir_numeric `TRUE` for numeric directions, `FALSE` for character directions; defaults to `FALSE`.
#' @param timezone The nominal timezone for the forecast. One of `OlsonNames()` or `-1` for local time. Defaults to `-1`.
#'
#' @return Simple features corresponding to the given station identifier with recent meteorological observations.
#' @export
#'
#' @examples
#' \donttest{
#' station_obs("KBOS") %>% data.frame() %>%
#'   dplyr::select(-geometry) %>%
#'   dplyr::filter(temp == max(.$temp))
#' }
#' @importFrom lutz tz_lookup_coords
#' @importFrom tibble tibble
#' @importFrom lubridate with_tz
station_obs <- function(station_id, timezone = -1, dir_numeric = FALSE){

  # Get station metadata ----
  station_data <- .station_data(station_id = station_id)

  if(timezone == -1){
    # Get coordinates ----
    coords <- station_data %>%
      .[["features"]] %>%
      .[[1]] %>%
      .[["geometry"]] %>%
      .[["coordinates"]]

    # Save timezone ----
    timezone <- lutz::tz_lookup_coords(as.double(coords[[2]]), as.double(coords[[1]]), method = "fast", warn = FALSE) #strangely, 1 is long and 2 is lat.
  }

  #Get the observations ----
  station_data %>%
    .$features %>%
    map_dfr( ~ tibble::tibble(
      #type = "observation",
      time = .x$properties$timestamp %>%
        {
          gsub("T", " ", .)
        } %>%
        as.POSIXct(tz = "UTC", format = "%Y-%m-%d %H:%M:%S") %>%
        lubridate::with_tz(tzone = timezone),
      #make a low/high because celcius observations are rounded...
      temp = ((.x$properties$temperature$value) * 9/5) + 32,
      temp_low = ((.x$properties$temperature$value - .05) * 9/5) + 32,
      temp_high = ((.x$properties$temperature$value + .049) * 9/5) + 32,
      dewpoint = ((.x$properties$dewpoint$value) * 9/5) + 32,
      humidity = ((.x$properties$relativeHumidity$value) * 9/5) + 32,
      p_rain = if(length(.x$properties$probabilityOfPrecipitation$value) == 0){
        NA
      }else{
        .x$properties$probabilityOfPrecipitation$value
      },
      hourly_rain = .x$properties$precipitationLastHour$value,
      wind_speed = .x$properties$windSpeed$value %>%
        {
          gsub("mph", "", .)
        } %>%
        trimws(which = "both") %>%
        as.numeric(),
      wind_dir = .x$properties$windDirection$value,
      skies = .x$properties$shortForecast,
      pressure = .x$properties$barometricPressure$value,
      sea_level_pressure = .x$properties$seaLevelPressure$value
      #dewpoint_low = ((.x$properties$dewpoint$value - .05) * 9/5) + 32,
      #dewpoint_high = ((.x$properties$dewpoint$value + .049) * 9/5) + 32,
    )
    ) %>%
    dplyr::mutate(
      wind_dir = ifelse(dir_numeric, wind_dir, wind_dir %>% dir_as_char()),
      lat = as.double(coords[[2]]),
      lon = as.double(coords[[1]])
    ) %>%
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
    return()
}
