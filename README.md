
# weathR

<!-- badges: start -->
<!-- badges: end -->

The goal of this package is to facilitate easy interaction with the
National Weather Service API in R!

## Installation

You can install the development version of weathR from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("JeffreyFowler/weathR")
```

Or, you can get the official release version from CRAN:

``` r
install.packages("weathR")
```

## Fetching NWS Metadata for a Location

The function `point_data()` allows the user to fetch NWS metadata for a
specific point as a dataframe.

``` r
library(weathR)
library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
```

``` r
library(sf) #This is used later in our documentation
#> Warning: package 'sf' was built under R version 4.4.2
#> Linking to GEOS 3.12.2, GDAL 3.9.3, PROJ 9.4.1; sf_use_s2() is TRUE
```

``` r

# Using google maps, we find the coordinates for Central Park, NYC.
point_data(lat = 40.768472897200986, lon = -73.97600351884695) %>% 
  as.data.frame() %>% 
  head()
#>                                         endpoint cwa
#> 1 https://api.weather.gov/points/40.7685,-73.976 OKX
#>                       forecast_office grid_id grid_x grid_y
#> 1 https://api.weather.gov/offices/OKX     OKX     34     38
#>                                                forecast
#> 1 https://api.weather.gov/gridpoints/OKX/34,38/forecast
#>                                                forecast_hourly
#> 1 https://api.weather.gov/gridpoints/OKX/34,38/forecast/hourly
#>                             forecast_grid_data
#> 1 https://api.weather.gov/gridpoints/OKX/34,38
#>                                    observation_stations          city state
#> 1 https://api.weather.gov/gridpoints/OKX/34,38/stations West New York    NJ
#>                                   forecast_zone
#> 1 https://api.weather.gov/zones/forecast/NYZ072
#>                                        county
#> 1 https://api.weather.gov/zones/county/NYC061
#>                           fire_weather_zone        time_zone radar_station
#> 1 https://api.weather.gov/zones/fire/NYZ212 America/New_York          KOKX
#>                   geometry
#> 1 POINT (-73.976 40.76847)
```

## Fetching and Displaying Point Forecasts

``` r

# We can fetch forecast temperatures (in degrees fahrenheit) for NYC
point_forecast(lat = 40.768472897200986, lon = -73.97600351884695) %>% 
  as.data.frame() %>% 
  select(time, temp) %>% 
  head()
#>                      time temp
#> 1 2025-03-29 18:00:00 EDT   72
#> 2 2025-03-29 19:00:00 EDT   63
#> 3 2025-03-29 20:00:00 EDT   55
#> 4 2025-03-29 21:00:00 EDT   51
#> 5 2025-03-29 22:00:00 EDT   50
#> 6 2025-03-29 23:00:00 EDT   49
```

``` r

# We can even produce a graph of the forecast
library(ggplot2)
#> Warning: package 'ggplot2' was built under R version 4.4.2
```

``` r

point_forecast(lat = 40.768472897200986, lon = -73.97600351884695) %>% 
  as.data.frame() %>% 
  select(time, temp) %>% 
  mutate(time = as.POSIXct(time)) %>% #convert time to a POSIXct object 
  ggplot(aes(x = time, y = temp)) +
  #Add points for forecast values of temperature
  geom_point(color = "brown") +
  #Add a smoothed line that follows the points
  geom_smooth(method = "loess", span = .15, se = FALSE, color = "indianred") +
  labs(
    title = paste0("KNYC Temperature Forecasts for the Week of ", Sys.Date()),
    y = "Temperature (Degrees Fahrenheit)",
    x = "Day"
  ) +
  theme_minimal()
#> `geom_smooth()` using formula = 'y ~ x'
```

<img src="man/figures/README-example2-1.png" width="100%" />

## Fetching Station ID forecast values

Rather than using a latitude/longitude point, we can use an ASOS or AWOS
station identifier.

Lets get a list of the forecast wind speed, wind direction, and skies,
by time.

``` r

station_forecast(station_id = "KNYC") %>% 
  as.data.frame() %>% 
  select(time, wind_speed, skies) %>% 
  head()
```

                     time wind_speed                                   skies

1 2025-03-29 18:00:00 EDT 12 Slight Chance Showers And Thunderstorms 2
2025-03-29 19:00:00 EDT 10 Slight Chance Showers And Thunderstorms 3
2025-03-29 20:00:00 EDT 10 Chance Rain Showers 4 2025-03-29 21:00:00 EDT
10 Chance Rain Showers 5 2025-03-29 22:00:00 EDT 9 Chance Rain Showers 6
2025-03-29 23:00:00 EDT 9 Chance Rain Showers

``` r

# We can easily put this result into a GT table for easy viewing

library(gt)

station_forecast(station_id = "KNYC") %>% 
  as.data.frame() %>% 
  select(time, wind_dir, wind_speed, skies) %>% 
  filter(dplyr::row_number() == 1 | skies != lag(skies)) %>%  #Keep only observations where the first row is 0 and the skies change
  rename_with(~ gsub("_", " ", .) %>% stringr::str_to_title()) %>% #switch from snake_case to Title Case
  gt::gt() %>% 
  gt::tab_header(title = paste0("Skies forecast for KNYC, the Week of ", Sys.Date()))
```

<div id="zglifvceoi" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#zglifvceoi table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#zglifvceoi thead, #zglifvceoi tbody, #zglifvceoi tfoot, #zglifvceoi tr, #zglifvceoi td, #zglifvceoi th {
  border-style: none;
}
&#10;#zglifvceoi p {
  margin: 0;
  padding: 0;
}
&#10;#zglifvceoi .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#zglifvceoi .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#zglifvceoi .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#zglifvceoi .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#zglifvceoi .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#zglifvceoi .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#zglifvceoi .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#zglifvceoi .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#zglifvceoi .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#zglifvceoi .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#zglifvceoi .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#zglifvceoi .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#zglifvceoi .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#zglifvceoi .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#zglifvceoi .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zglifvceoi .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#zglifvceoi .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#zglifvceoi .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#zglifvceoi .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zglifvceoi .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#zglifvceoi .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zglifvceoi .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#zglifvceoi .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zglifvceoi .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#zglifvceoi .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#zglifvceoi .gt_left {
  text-align: left;
}
&#10;#zglifvceoi .gt_center {
  text-align: center;
}
&#10;#zglifvceoi .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#zglifvceoi .gt_font_normal {
  font-weight: normal;
}
&#10;#zglifvceoi .gt_font_bold {
  font-weight: bold;
}
&#10;#zglifvceoi .gt_font_italic {
  font-style: italic;
}
&#10;#zglifvceoi .gt_super {
  font-size: 65%;
}
&#10;#zglifvceoi .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#zglifvceoi .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#zglifvceoi .gt_indent_1 {
  text-indent: 5px;
}
&#10;#zglifvceoi .gt_indent_2 {
  text-indent: 10px;
}
&#10;#zglifvceoi .gt_indent_3 {
  text-indent: 15px;
}
&#10;#zglifvceoi .gt_indent_4 {
  text-indent: 20px;
}
&#10;#zglifvceoi .gt_indent_5 {
  text-indent: 25px;
}
&#10;#zglifvceoi .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#zglifvceoi div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
  height: 0px !important;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="4" class="gt_heading gt_title gt_font_normal gt_bottom_border" style>Skies forecast for KNYC, the Week of 2025-03-29</td>
    </tr>
    &#10;    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Time">Time</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Wind-Dir">Wind Dir</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Wind-Speed">Wind Speed</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Skies">Skies</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Time" class="gt_row gt_left">2025-03-29 18:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">NW</td>
<td headers="Wind Speed" class="gt_row gt_right">12</td>
<td headers="Skies" class="gt_row gt_left">Slight Chance Showers And Thunderstorms</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-03-29 20:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">E</td>
<td headers="Wind Speed" class="gt_row gt_right">10</td>
<td headers="Skies" class="gt_row gt_left">Chance Rain Showers</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-03-30 00:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">E</td>
<td headers="Wind Speed" class="gt_row gt_right">8</td>
<td headers="Skies" class="gt_row gt_left">Slight Chance Rain Showers</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-03-30 08:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">E</td>
<td headers="Wind Speed" class="gt_row gt_right">7</td>
<td headers="Skies" class="gt_row gt_left">Cloudy</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-03-30 11:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">E</td>
<td headers="Wind Speed" class="gt_row gt_right">6</td>
<td headers="Skies" class="gt_row gt_left">Mostly Cloudy</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-03-30 18:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">E</td>
<td headers="Wind Speed" class="gt_row gt_right">7</td>
<td headers="Skies" class="gt_row gt_left">Slight Chance Rain Showers</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-03-30 20:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">E</td>
<td headers="Wind Speed" class="gt_row gt_right">6</td>
<td headers="Skies" class="gt_row gt_left">Chance Rain Showers</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-03-31 14:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">S</td>
<td headers="Wind Speed" class="gt_row gt_right">12</td>
<td headers="Skies" class="gt_row gt_left">Rain Showers Likely</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-03-31 20:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">S</td>
<td headers="Wind Speed" class="gt_row gt_right">9</td>
<td headers="Skies" class="gt_row gt_left">Showers And Thunderstorms</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-01 02:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">W</td>
<td headers="Wind Speed" class="gt_row gt_right">9</td>
<td headers="Skies" class="gt_row gt_left">Rain Showers Likely</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-01 08:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">NW</td>
<td headers="Wind Speed" class="gt_row gt_right">14</td>
<td headers="Skies" class="gt_row gt_left">Mostly Sunny</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-01 13:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">NW</td>
<td headers="Wind Speed" class="gt_row gt_right">14</td>
<td headers="Skies" class="gt_row gt_left">Sunny</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-01 18:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">NW</td>
<td headers="Wind Speed" class="gt_row gt_right">12</td>
<td headers="Skies" class="gt_row gt_left">Mostly Clear</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-02 03:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">N</td>
<td headers="Wind Speed" class="gt_row gt_right">7</td>
<td headers="Skies" class="gt_row gt_left">Partly Cloudy</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-02 06:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">NE</td>
<td headers="Wind Speed" class="gt_row gt_right">7</td>
<td headers="Skies" class="gt_row gt_left">Mostly Sunny</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-02 15:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">SE</td>
<td headers="Wind Speed" class="gt_row gt_right">10</td>
<td headers="Skies" class="gt_row gt_left">Partly Sunny</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-02 17:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">SE</td>
<td headers="Wind Speed" class="gt_row gt_right">12</td>
<td headers="Skies" class="gt_row gt_left">Mostly Cloudy</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-02 20:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">SE</td>
<td headers="Wind Speed" class="gt_row gt_right">13</td>
<td headers="Skies" class="gt_row gt_left">Slight Chance Rain Showers</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-03 02:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">SE</td>
<td headers="Wind Speed" class="gt_row gt_right">10</td>
<td headers="Skies" class="gt_row gt_left">Chance Rain Showers</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-03 14:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">SW</td>
<td headers="Wind Speed" class="gt_row gt_right">14</td>
<td headers="Skies" class="gt_row gt_left">Slight Chance Rain Showers</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-03 20:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">SW</td>
<td headers="Wind Speed" class="gt_row gt_right">12</td>
<td headers="Skies" class="gt_row gt_left">Chance Rain Showers</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-04 14:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">N</td>
<td headers="Wind Speed" class="gt_row gt_right">5</td>
<td headers="Skies" class="gt_row gt_left">Slight Chance Rain Showers</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-04 20:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">N</td>
<td headers="Wind Speed" class="gt_row gt_right">5</td>
<td headers="Skies" class="gt_row gt_left">Mostly Cloudy</td></tr>
    <tr><td headers="Time" class="gt_row gt_left">2025-04-05 02:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">NE</td>
<td headers="Wind Speed" class="gt_row gt_right">6</td>
<td headers="Skies" class="gt_row gt_left">Slight Chance Rain Showers</td></tr>
  </tbody>
  &#10;  
</table>
</div>

## Finding NWS ASOS/AWOS Stations Near a Point

There a number of different types of weather stations. An advantage of
the weathR package is the ability to easily find ASOS/AWOS stations used
the NWS near a given point. This is useful as these stations tend to
have better quality assurance practices than amateur meteorologist
stations.

``` r

#Using the coordinates for Denver, Colorado from google maps
stations_near(lat = 39.73331998845491, lon = -104.98209127042489) %>% 
  as.data.frame() %>% 
  head()
#>   station_id euc_dist                   geometry
#> 1       KBKF 13.49539 POINT (-104.7581 39.71331)
#> 2       KBJC 12.43745 POINT (-105.1042 39.90085)
#> 3       KAPA 13.13736 POINT (-104.8484 39.55991)
#> 4       KDEN 20.69956 POINT (-104.6562 39.84658)
#> 5       KEIK 17.19671 POINT (-105.0503 40.01169)
#> 6       KCFO 26.84118 POINT (-104.5376 39.78419)
```

``` r

#Or, viewing them plotted on an interactive map
library(tmap)
#> Warning: package 'tmap' was built under R version 4.4.2
#> Breaking News: tmap 3.x is retiring. Please test v4, e.g. with
#> remotes::install_github('r-tmap/tmap')
```

``` r
tmap::tmap_mode("view")
#> tmap mode set to interactive viewing
```

``` r
tmap::tmap_options(basemaps = c(Topo = "Esri.WorldTopoMap"))

kden_map <- stations_near(lat = 39.73331998845491, lon = -104.98209127042489) %>% 
  tmap::tm_shape() + 
  #Plot stations near our point, with color becoming darker as they get closer
  tmap::tm_dots(size = .08, col = "euc_dist", palette = "-Blues", title = "Euclidian Distance") +
  tmap::tm_shape(
    st_as_sf(
      data.frame(
        lon = -104.98209127042489,
        lat = 39.73331998845491
      ),
      coords = c("lon", "lat"),
      crs = 4326
    )
  ) +
  tmap::tm_dots(size = .08)

#Save the map as a static plot so I can show it on github
tmap::tmap_save(kden_map, filename = "man/figures/dynamic_map.html", width = 6, height = 4)
#> Interactive map saved to C:\Users\Jeffr\Desktop\WeathR_WIP\weathR\man\figures\man\figures\dynamic_map.html
```

This is just a sampling of the functionality available in this package.
Feel free to browse the documentation with the `?function` commands in
the R console to explore further!
