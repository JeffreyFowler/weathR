#=========================#
#   WINDDIR AS INTEGER    #
#=========================#
#' Convert wind direction from a character to an integer
#'
#' @param direction The direction as a string (N, NNE, NE, ENE, E, ESE, etc.)
#'
#' @return An integer representing degrees clockwise from north
#' @export
#'
#' @importFrom magrittr `%>%`
#' @examples dir_as_integer("NNW")
dir_as_integer <- function(direction){

  #Create a lookup table
  direction_lookup <- c(
    "N" = 0,
    "NNE" = 22.5,
    "NE" = 45,
    "ENE" = 67.5,
    "E" = 90,
    "ESE" = 112.5,
    "SE" = 135,
    "SSE" = 157.5,
    "S" = 180,
    "SSW" = 202.5,
    "SW" = 225,
    "WSW" = 247.5,
    "W" = 270,
    "WNW" = 292.5,
    "NW" = 315,
    "NNW" = 337.5
  )

  # Match the input direction with the lookup table
  # cast to an integer (round down)
  degrees <- direction_lookup[direction] %>% as.integer()

  # Return the degree value or NA if direction is invalid
  return(ifelse(is.na(degrees), NA, degrees))
}

#=================================#
#         WINDDIR AS CHAR         #
#=================================#
#' Convert wind direction from a numeric to a character
#'
#' @param direction A string corresponding to direction ("N", "NNE", etc.)
#'
#' @return Returns a character (N, NNE, NE, etc.)
#' @export
#'
#' @examples dir_as_char(330)
dir_as_char <- function(direction){

  direction_lookup <- list(
    "N" = c(348.75, 11.25),
    "NNE" = c(11.25, 33.75),
    "NE" = c(33.75, 56.25),
    "ENE" = c(56.25, 78.75),
    "E" = c(78.75, 101.25),
    "ESE" = c(101.25, 123.75),
    "SE" = c(123.75, 146.25),
    "SSE" = c(146.25, 168.75),
    "S" = c(168.75, 191.25),
    "SSW" = c(191.25, 213.75),
    "SW" = c(213.75, 236.25),
    "WSW" = c(236.25, 258.75),
    "W" = c(258.75, 281.25),
    "WNW" = c(281.25, 303.75),
    "NW" = c(303.75, 326.25),
    "NNW" = c(326.25, 348.75)
  )

  to_return <- names(direction_lookup)[sapply(direction_lookup, function(bounds) {
    if (bounds[1] <= bounds[2]) {
      direction >= bounds[1] & direction < bounds[2]
    } else {
      # Wrap-around case: e.g., for "N", where the range goes from 348.75 to 11.25
      direction >= bounds[1] | direction < bounds[2]
    }
  })]

  return(to_return)
}
