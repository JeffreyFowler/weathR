#===============================#
#         STATION TODAY         #
#===============================#
#' Get todays weather data, given a station ID
#'
#' @param station_id The station identifier (ex: KDEN, KNYC, etc).
#' @param timezone The nominal timezone for the forecast. One of `OlsonNames()` or `-1` for local time. Defaults to `-1`.
#' @param dir_numeric `TRUE` for numeric directions, `FALSE` for character directions; defaults to `FALSE`.
#'
#' @return A sf object with timestamps and weather values
#' @export
#'
#' @examples
#' station_today("KNYC")
station_today <- function(station_id, timezone = -1, dir_numeric = FALSE){

  coords <- station_coords("KDEN")

  #First, find the local timezone
  to_tz <- lutz::tz_lookup_coords(lat = coords[["lat"]], lon = coords[["lon"]], warn = FALSE)

  #If we are using local time, save local time as timezone
  if(timezone == -1){
    timezone = to_tz
  }

  station_obs(station_id = station_id, timezone = -1, dir_numeric = dir_numeric) %>%
    filter(time >= Sys.Date() %>% force_tz(tzone = to_tz)) %>%
    mutate(time = format(time, "%Y-%m-%d %H:%M:%S", tz = timezone, usetz = TRUE)) %>% #reformat using the specified timezone
    return()

}
