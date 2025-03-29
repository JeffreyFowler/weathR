#=============================#
#         POINT TODAY         #
#=============================#
#' Get the weather observed thus far today at the nearest ASOS station to a point which is in the same forecast zone as the given point.
#'
#' @param lat Latitude of a point
#' @param lon Longitude of a point
#' @param timezone Timezone to denominate results in; -1 for local time
#' @param dir_numeric Logical; TRUE for numeric wind directions, FALSE for character wind directions
#'
#' @return A sf object with weather observations for today
#' @export
#'
#' @examples
#' # Produce a GT summary of the weather thus far for a given lat/lon
#' \donttest{
#' install.packages("gt")
#' library(gt)
#' install.packages("snakecase")
#' library(snakecase)
#'
#' point_today(lat = 33, lon = -80) %>%
#' as.data.frame() %>%
#'  dplyr::mutate(time = as.POSIXct(time) %>% format("%H:%M")) %>%
#'   dplyr::select(time, temp, dewpoint, humidity, wind_speed) %>%
#'   gt::gt() %>%
#'   gt::tab_header(title = "Weather at latitude 33, longitude -80 for today") %>%
#'   gt::tab_style(
#'     style = gt::cell_borders(
#'       sides = "right",
#'       color = "lightgray",
#'       style = "dashed",
#'       weight = px(1)
#'       ),
#'       locations = cells_body(columns = everything())
#'     ) %>%
#'    gt::tab_style(
#'     style = gt::cell_text(align = "center"),
#'      locations = gt::cells_column_labels(columns = everything())
#'    ) %>%
#'    gt::tab_style(
#'     style = gt::cell_borders(sides = "right", color = "lightgray", weight = px(2)),
#'     locations = gt::cells_body(columns = 1)
#'     ) %>%
#'     gt::cols_label_with(fn = ~ snakecase::to_title_case(.x))
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
