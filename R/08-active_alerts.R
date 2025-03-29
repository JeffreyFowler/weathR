#===============================#
#         SAFE COLLAPSE         #
#===============================#
#' Safe Collapse
#'
#' @param x A list to collapse.
#'
#' @return A comma delimited version of your input list, or NA when the input list is blank.
#' @export
#'
#' @examples safe_collapse(c("This is one", "And this is another one"))
#' @note
#' This is a helper function that is used to collapse a list into a string, and is used in building the active warnings dataset.
safe_collapse <- function(x){
  if(is.null(x) || length(x) == 0){NA_character_}else{paste0(x, collapse = ", ")}
}

#=================================#
#         ACTIVE WARNINGS         #
#=================================#
#' National Weather Service Alerts
#'
#' @return Dataframe containing various columns identifying and describing alerts.
#' @export
#'
#' @importFrom dplyr relocate bind_rows
#' @importFrom httr2 resp_body_json
#'
#' @examples
#' # Get all the red flag warnings
#' red_flags <- alerts()
#' red_flags <- filter(red_flags, grepl("red flag", red_flags$headline, ignore.case = TRUE))
alerts <- function(){

  #Signal that httr2::resp_body_json uses jsonlite dependency to avoid a warning
  if(FALSE){jsonlite::fromJSON}

  httr2::request("https://api.weather.gov/alerts") %>%
    httr2::req_perform() %>%
    httr2::resp_body_json() %>%
    .[["features"]] %>%
    lapply(function(alert){

      #move into the properties list ----
      alert <- alert$properties

      #Map the alerts to a dataframe
      data.frame(
        area_desc    = alert$areaDesc %>% safe_collapse(),
        SAME         = alert$geocode$SAME %>% safe_collapse(),
        UGC          = alert$geocode$UGC %>% safe_collapse(),
        zones        = alert$affectedZones %>% safe_collapse(),
        sent         = alert$sent %>% safe_collapse(),
        effective    = alert$effective %>% safe_collapse(),
        onset        = alert$onset %>% safe_collapse(),
        expires      = alert$expires %>% safe_collapse(),
        status       = alert$status %>% safe_collapse(),
        type         = alert$messageType %>% safe_collapse(),
        category     = alert$category %>% safe_collapse(),
        severity     = alert$severity %>% safe_collapse(),
        certainty    = alert$certainty %>% safe_collapse(),
        urgency      = alert$urgency %>% safe_collapse(),
        headline     = alert$headline %>% safe_collapse(),
        description  = alert$description %>% safe_collapse(),
        instructions = alert$instruction %>% safe_collapse(),
        response     = alert$response %>% safe_collapse()
      ) %>%
        dplyr::relocate(headline, description, area_desc, severity, certainty, instructions, urgency, effective, status, type, category, response)
    }) %>%
    dplyr::bind_rows()
}


