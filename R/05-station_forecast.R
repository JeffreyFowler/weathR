#=======================#
#   STATION FORECAST    #
#=======================#
#' Fetch the NWS hourly forecast at a given AWOS or ASOS station identifier.
#'
#' @param station_id The station identifier for which to get the observations
#' @param timezone The timezone to denominate timestamps in. Defaults to local time.
#' @param dir_numeric Should the wind direction be returned as a numeric, or a character? TRUE uses numeric wind directions, FALSE uses characters.
#'
#' @return An sf with coordinates for the AWOS/ASOS station, time, and forecast values.
#' @export
#'
#' @examples
#' \donttest{
#' station_forecast("KBOS") %>% data.frame() %>% dplyr::select(-geometry)
#' }
station_forecast <- function(station_id, timezone = -1, dir_numeric = FALSE){

  #Get the coordinates for the station
  coords <- station_coords(station_id = station_id)

  #Query for that stations forecast
  point_forecast(lat = coords[["lat"]], lon = coords[["lon"]], timezone = timezone, dir_numeric = dir_numeric) %>%
    return()
}

#===================================#
#         STATION TOMORROW          #
#===================================#
#' Get tomorrows forecast for a given station_id
#'
#' @param station_id An ASOS or AWOS station identifier
#' @param timezone A timezone to denominate the forecast in
#' @param dir_numeric logical; if TRUE return the wind direction as numeric. If FALSE return the wind direction as a character
#' @param short logical; if TRUE return the forecast for only tomorrow. If FALSE return the forecast for the remainder of today and tomorrow.
#'
#' @return Returns a sf with coordinates for the AWOS/ASOS station, time, and forecast values
#' @export
#'
#' @examples
#' station_tomorrow("KBOS")
#'
station_tomorrow <- function(station_id, timezone = -1, dir_numeric = FALSE, short = TRUE){

  coords <- station_coords(station_id)

  point_tomorrow(
    lat = coords[["lat"]],
    lon = coords[["lon"]],
    timezone = timezone,
    dir_numeric = dir_numeric,
    short = short
  ) %>%
    return()

}
