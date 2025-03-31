#=====================================================#
#         STATION DATA HIDDEN IMPLEMENTATION          #
#=====================================================#
#' Raw JSON Station Metadata
#'
#' @param station_id The station identifier (ex: KDEN, KBOS, KNYC, etc).
#'
#' @return Station data provided for the National Weather Service.
#' @export
#'
#' @examples
#' \donttest{
#' .station_data("KDEN")
#' }
.station_data <- function(station_id){

  paste0("https://api.weather.gov/stations/", station_id, "/observations") %>%
    httr2::request() %>%
    httr2::req_headers(
      "Cache-Control" = "no-cache",  # Force fresh data
      "Pragma" = "no-cache",          # Compatibility with older servers
      "Feature-Flags" = runif(1, 0, 1000)) %>% #Cache busting...
    httr2::req_perform() %>%
    httr2::resp_body_json() %>%
    return()
}

#=================================#
#         STATION COORDS          #
#=================================#
#' Station Coordinates
#'
#' @param station_id The station identifier (ex: KDEN, KBOS, KNYC, etc).
#'
#' @return Named list with latitude and longitude like: `c("lat" = x, "lon" = y)`.
#' @export
#'
#' @examples
#' \donttest{
#' station_coords("KBOS")
#' }
station_coords <- function(station_id){

  to_return <- .station_data(station_id) %>% invisible() %>%
    .[["features"]] %>%
    .[[1]] %>%
    .[["geometry"]] %>%
    .[["coordinates"]]

  c("lat" = to_return[[2]], "lon" = to_return[1]) %>%
    return()
}

#===============================#
#         STATION POINT         #
#===============================#
#' Station Coordinates as a Point
#'
#' @param station_id The station identifier (ex: KDEN, KBOS, KNYC, etc).
#'
#' @return Simple features point corresponding to the given station identifier.
#' @export
#'
#' @examples
#' \donttest{
#' station_point("KDEN")
#' }
station_point <- function(station_id){

  station_coords(station_id = station_id) %>%
    data.frame(lat = .[["lat"]], lon = .[["lon"]]) %>%
    dplyr::select(lat, lon) %>%
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
    return()

}

#===================================#
#         STATION TIMEZONE          #
#===================================#
#' Fetch Station Timezone
#'
#' @param station_id The station identifier (ex: KDEN, KBOS, KNYC, etc).
#'
#' @return A character corresponding to a timezone from `OlsonNames()`.
#' @export
#'
#' @examples
#' \donttest{
#' Sys.time() %>% lubridate::force_tz(tzone = station_tz("KDEN"))
#' }
station_tz <- function(station_id){

  coords <- station_coords(station_id = station_id)

  lutz::tz_lookup_coords(as.double(coords[["lat"]]), as.double(coords[["lon"]]), method = "fast", warn = FALSE) %>%
    return()

}
