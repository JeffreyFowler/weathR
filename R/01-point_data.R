#===================================================#
#         .POINT_DATA HIDDEN IMPLEMENTATION         #
#===================================================#
#' Get the JSON Data for a Point
#'
#' @param lat Latitude of the point to fetch data for.
#' @param lon Longitude of the point to fetch data for.
#'
#' @return A nested list containing NWS point data.
#' @export
#'
#' @examples
#' \donttest{
#' .point_data(lat = 40.71427000, lon = -74.00597000) %>% data.frame()
#' }
#' @importFrom httr2 request req_perform resp_body_json
.point_data <- function(lat, lon){
  paste0("https://api.weather.gov/points/", lat, ",", lon) %>% #get the url to request
    httr2::request() %>%
    httr2::req_perform() %>%
    httr2::resp_body_json() %>%
    return()
}

#=============================#
#         POINT_DATA          #
#=============================#
#' Get NWS Metadata for a Point
#'
#' @param lat Latitude.
#' @param lon Longitude.
#'
#' @return A simple features point object with NWS metadata.
#' @export
#'
#' @examples
#' \donttest{
#' point_data(lat = 40.71427000, lon = -74.00597000)
#' }
#' @importFrom janitor clean_names
#' @importFrom dplyr rename select mutate
#' @importFrom sf st_as_sf
point_data <- function(lat, lon){

  .point_data(lat = lat, lon = lon) %>%
    .[["properties"]] %>%
    base::as.data.frame() %>%
    janitor::clean_names() %>%
    dplyr::rename(
      endpoint = x_id,
      city = relative_location_properties_city,
      state = relative_location_properties_state
    ) %>%
    dplyr::select(
      -x_type,
      -dplyr::matches("relative_location")
    ) %>%
    dplyr::mutate(
      lat = lat,
      lon = lon
    ) %>%
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4326) %>%
    return()
}

#=================================#
#         POINT_STATION           #
#=================================#
#' Find Nearest ASOS/AWOS Station
#'
#' @param lat Latitude.
#' @param lon Longitude.
#'
#' @return A string corresponding to an ASOS or AWOS station.
#' @export
#'
#' @examples
#' # Gets the observation data as an sf associated with a point
#' \donttest{
#' point_station(lat = 42, lon = -80) %>% station_obs() %>% data.frame()
#' }
#' @importFrom httr2 request req_perform resp_body_json
#' @importFrom purrr map_dfr
#' @importFrom dplyr mutate filter
point_station <- function(lat, lon){
  #Get the point data for the given point
  point_data(lat, lon) %>%
    as.data.frame() %>%
    #perform an http request for the stations in the corresponding forecast zone
    .[["observation_stations"]] %>%
    httr2::request() %>%
    httr2::req_perform() %>%
    httr2::resp_body_json() %>%
    .[["features"]] %>%
    #map the result to a dataframe
    purrr::map_dfr( function(x){
      data.frame(
        station_id = x$properties$stationIdentifier,
        longitude = x$geometry$coordinates[[1]],
        latitude = x$geometry$coordinates[[2]]
      )
    }
    ) %>%
    dplyr::mutate(
      euc_dist = sqrt( #find the pairwise euclidian distance
        (lat - latitude)**2 + (lon - longitude)**2
      )
    ) %>%
    # Select the distance-minimizing station
    dplyr::filter(euc_dist == min(.$euc_dist)) %>%
    .[["station_id"]] %>%
    return()
}

#===============================#
#         STATIONS NEAR         #
#===============================#
#' Find All Stations in a Point's Forecast Zone
#'
#' @param lat Latitude.
#' @param lon Longitude.
#'
#' @return An sf object with station identifiers, geometry as coordinates, and their euclidian distance (in miles) to the station provided.
#' @export
#'
#' @examples
#' # Plot the a station with given points and the nearby stations in a tmap
#' \dontrun{
#' install.packages("tmap")
#' library(tmap)
#'
#' stations_near(lat = 33, lon = -80) %>%
#'   tm_shape() +
#'   tm_dots(size = .1) +
#'    tm_shape(st_point(c(-80, 33)) %>% st_sfc(crs = 4326)) + tm_dots(size = .1, col = "red3")
#' }
#' @importFrom httr2 request req_perform resp_body_json
#' @importFrom purrr map_dfr
#' @importFrom dplyr mutate
#' @importFrom sf st_as_sf st_transform
stations_near <- function(lat, lon){
  #Get the point data for the given point
  point_data(lat, lon) %>%
    as.data.frame() %>%
    #perform an http request for the stations in the corresponding forecast zone
    .[["observation_stations"]] %>%
    httr2::request() %>%
    httr2::req_perform() %>%
    httr2::resp_body_json() %>%
    .[["features"]] %>%
    #map the result to a dataframe
    purrr::map_dfr( function(x){
      base::data.frame(
        station_id = x$properties$stationIdentifier,
        longitude = x$geometry$coordinates[[1]],
        latitude = x$geometry$coordinates[[2]]
      )
    }
    ) %>%
    dplyr::mutate(
      euc_dist = sqrt( #find the pairwise euclidian distance
        (lat - latitude)**2 + (lon - longitude)**2
      )
    ) %>%
    dplyr::mutate(euc_dist = euc_dist * 60) %>% #approximate the distance in miles
    sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326) %>%
    sf::st_transform(crs = 4326) %>%
    return()
}
