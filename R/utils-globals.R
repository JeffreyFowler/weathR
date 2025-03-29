# Suppress R CMD check notes for unquoted variable names in tidyverse code

utils::globalVariables(c(
  ".", "area_desc", "category", "certainty", "description", "effective",
  "euc_dist", "headline", "instructions", "lat", "latitude", "lon", "longitude",
  "relative_location_properties_city", "relative_location_properties_state",
  "response", "severity", "status", "time", "type", "urgency", "wind_dir",
  "x_id", "x_type"
))
