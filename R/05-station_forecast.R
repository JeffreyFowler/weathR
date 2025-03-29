#=======================#
#   STATION FORECAST    #
#=======================#
#' Station Forecast
#'
#' @param station_id Station identifier (ex: KDEN, KBOS, KNYC, etc).
#' @param dir_numeric `TRUE` for numeric directions, `FALSE` for character directions; defaults to `FALSE`.
#' @param timezone The nominal timezone for the forecast. One of `OlsonNames()` or `-1` for local time. Defaults to `-1`.
#'
#' @return Simple features point corresponding to the given station identifier with recent meteorological forecast values.
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
#' Tomorrows Forecast
#'
#' @param station_id Station identifier (ex: KDEN, KBOS, KNYC, etc).
#' @param dir_numeric `TRUE` for numeric directions, `FALSE` for character directions; defaults to `FALSE`.
#' @param timezone The nominal timezone for the forecast. One of `OlsonNames()` or `-1` for local time. Defaults to `-1`.
#' @param short `TRUE` for only tomorrow, `FALSE` for today and tomorrow; defaults to `TRUE`.
#'
#' @return Simple features point corresponding to the given station identifier with recent meteorological forecast values.
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
