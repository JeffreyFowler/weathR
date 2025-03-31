#=============================#
#         POINT TODAY         #
#=============================#
#' Weather Observed Today at a Point
#'
#' @param lat Latitude.
#' @param lon Longitude.
#' @param timezone The nominal timezone for the forecast. One of `OlsonNames()` or `-1` for local time. Defaults to `-1`.
#' @param dir_numeric `TRUE` for numeric directions, `FALSE` for character directions; defaults to `FALSE`.
#'
#' @return Simple features point corresponding to the given station identifier with recent meteorological forecast values for today.
#' @export
#'
#' @examples
#' # Produce a GT summary of the weather thus far for a given lat/lon
#' \donttest{
#' point_today(lat = 33, lon = -80) %>%
#' as.data.frame() %>%
#'  dplyr::mutate(time = as.POSIXct(time) %>% format("%H:%M")) %>%
#'   dplyr::select(time, temp, dewpoint, humidity, wind_speed)
#'  }
point_today <- function(lat, lon, timezone = -1, dir_numeric = FALSE){

  #First, find the local timezone
  to_tz <- lutz::tz_lookup_coords(lat = lat, lon = lon, warn = FALSE)

  #If we are using local time, save local time as timezone
  if(timezone == -1){
    timezone = to_tz
  }

  point_station(lat, lon) %>%
    station_obs(timezone = -1, dir_numeric = FALSE) %>% #for now, get data in local time
    dplyr::filter(time >= Sys.Date() %>% lubridate::force_tz(tzone = to_tz)) %>%
    dplyr::mutate(time = format(time, "%Y-%m-%d %H:%M:%S", tz = timezone, usetz = TRUE)) %>% #reformat using the specified timezone
    return()

}
