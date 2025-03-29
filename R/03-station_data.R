#=====================================================#
#         STATION DATA HIDDEN IMPLEMENTATION          #
#=====================================================#
#' Fetch station metadata data as a nested list
#'
#' @param station_id The ASOS or AWOS station ID (ex: KDEN, KBOS, KNYC, etc)
#'
#' @return Returns all station data provided for the NWS
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
#' Fetch station coordinates
#'
#' @param station_id The ASOS or AWOS station ID (ex: KDEN, KBOS, KNYC, etc)
#'
#' @return Returns a named list with latitude and longitude like c("lat" = x, "lon" = y)
#' @export
#'
#' @examples
#' # Converts station data to a sf point
#' \dontrun{
#' station_coords("KBOS") %>%
#'   data.frame(lat = .[["lat"]], lon = .[["lon"]]) %>%
#'   select(lat, lon) %>%
#'   st_as_sf(coords = c("lon", "lat"), crs = 4326)
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
#' Fetch station coordinates as a point
#'
#' @param station_id The ASOS or AWOS station ID (ex: KDEN, KBOS, KNYC, etc)
#'
#' @return an sf point
#' @export
#'
#' @examples
#' # plots the ASOS station for KDEN using tmap
#' \dontrun{
#' tmap_mode("view")
#' station_point("KDEN") %>% tm_shape() + tm_dots(size = .1)
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
#' Fetch station timezone
#'
#' @param station_id The ASOS or AWOS station ID (ex: KDEN, KBOS, KNYC, etc)
#'
#' @return Returns a string corresponding to a timezone from OlsonNames()
#' @export
#'
#' @examples
#' # Converts the current time into the timezone for the Denver International Airport ASOS station.
#' donttest{
#' Sys.time() %>% lubridate::force_tz(tzone = station_tz("KDEN"))
#' }
station_tz <- function(station_id){

  coords <- station_coords(station_id = station_id)

  lutz::tz_lookup_coords(as.double(coords[["lat"]]), as.double(coords[["lon"]]), method = "fast", warn = FALSE) %>%
    return()

}
