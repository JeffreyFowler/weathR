
<!-- README.md is generated from README.Rmd. Please edit that file -->

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
  as.data.frame() 
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
  select(time, temp)
#>                        time temp
#> 1   2025-03-29 15:00:00 EDT   79
#> 2   2025-03-29 16:00:00 EDT   80
#> 3   2025-03-29 17:00:00 EDT   79
#> 4   2025-03-29 18:00:00 EDT   72
#> 5   2025-03-29 19:00:00 EDT   63
#> 6   2025-03-29 20:00:00 EDT   55
#> 7   2025-03-29 21:00:00 EDT   51
#> 8   2025-03-29 22:00:00 EDT   50
#> 9   2025-03-29 23:00:00 EDT   49
#> 10  2025-03-30 00:00:00 EDT   48
#> 11  2025-03-30 01:00:00 EDT   47
#> 12  2025-03-30 02:00:00 EDT   47
#> 13  2025-03-30 03:00:00 EDT   47
#> 14  2025-03-30 04:00:00 EDT   46
#> 15  2025-03-30 05:00:00 EDT   46
#> 16  2025-03-30 06:00:00 EDT   46
#> 17  2025-03-30 07:00:00 EDT   46
#> 18  2025-03-30 08:00:00 EDT   47
#> 19  2025-03-30 09:00:00 EDT   47
#> 20  2025-03-30 10:00:00 EDT   48
#> 21  2025-03-30 11:00:00 EDT   49
#> 22  2025-03-30 12:00:00 EDT   51
#> 23  2025-03-30 13:00:00 EDT   54
#> 24  2025-03-30 14:00:00 EDT   55
#> 25  2025-03-30 15:00:00 EDT   55
#> 26  2025-03-30 16:00:00 EDT   55
#> 27  2025-03-30 17:00:00 EDT   54
#> 28  2025-03-30 18:00:00 EDT   54
#> 29  2025-03-30 19:00:00 EDT   52
#> 30  2025-03-30 20:00:00 EDT   52
#> 31  2025-03-30 21:00:00 EDT   53
#> 32  2025-03-30 22:00:00 EDT   53
#> 33  2025-03-30 23:00:00 EDT   54
#> 34  2025-03-31 00:00:00 EDT   54
#> 35  2025-03-31 01:00:00 EDT   55
#> 36  2025-03-31 02:00:00 EDT   56
#> 37  2025-03-31 03:00:00 EDT   56
#> 38  2025-03-31 04:00:00 EDT   57
#> 39  2025-03-31 05:00:00 EDT   57
#> 40  2025-03-31 06:00:00 EDT   57
#> 41  2025-03-31 07:00:00 EDT   58
#> 42  2025-03-31 08:00:00 EDT   59
#> 43  2025-03-31 09:00:00 EDT   55
#> 44  2025-03-31 10:00:00 EDT   57
#> 45  2025-03-31 11:00:00 EDT   60
#> 46  2025-03-31 12:00:00 EDT   63
#> 47  2025-03-31 13:00:00 EDT   65
#> 48  2025-03-31 14:00:00 EDT   67
#> 49  2025-03-31 15:00:00 EDT   68
#> 50  2025-03-31 16:00:00 EDT   69
#> 51  2025-03-31 17:00:00 EDT   69
#> 52  2025-03-31 18:00:00 EDT   67
#> 53  2025-03-31 19:00:00 EDT   64
#> 54  2025-03-31 20:00:00 EDT   61
#> 55  2025-03-31 21:00:00 EDT   59
#> 56  2025-03-31 22:00:00 EDT   57
#> 57  2025-03-31 23:00:00 EDT   56
#> 58  2025-04-01 00:00:00 EDT   54
#> 59  2025-04-01 01:00:00 EDT   53
#> 60  2025-04-01 02:00:00 EDT   51
#> 61  2025-04-01 03:00:00 EDT   49
#> 62  2025-04-01 04:00:00 EDT   48
#> 63  2025-04-01 05:00:00 EDT   47
#> 64  2025-04-01 06:00:00 EDT   47
#> 65  2025-04-01 07:00:00 EDT   47
#> 66  2025-04-01 08:00:00 EDT   48
#> 67  2025-04-01 09:00:00 EDT   49
#> 68  2025-04-01 10:00:00 EDT   50
#> 69  2025-04-01 11:00:00 EDT   52
#> 70  2025-04-01 12:00:00 EDT   53
#> 71  2025-04-01 13:00:00 EDT   54
#> 72  2025-04-01 14:00:00 EDT   55
#> 73  2025-04-01 15:00:00 EDT   55
#> 74  2025-04-01 16:00:00 EDT   55
#> 75  2025-04-01 17:00:00 EDT   55
#> 76  2025-04-01 18:00:00 EDT   53
#> 77  2025-04-01 19:00:00 EDT   50
#> 78  2025-04-01 20:00:00 EDT   48
#> 79  2025-04-01 21:00:00 EDT   46
#> 80  2025-04-01 22:00:00 EDT   45
#> 81  2025-04-01 23:00:00 EDT   43
#> 82  2025-04-02 00:00:00 EDT   42
#> 83  2025-04-02 01:00:00 EDT   41
#> 84  2025-04-02 02:00:00 EDT   39
#> 85  2025-04-02 03:00:00 EDT   38
#> 86  2025-04-02 04:00:00 EDT   37
#> 87  2025-04-02 05:00:00 EDT   36
#> 88  2025-04-02 06:00:00 EDT   36
#> 89  2025-04-02 07:00:00 EDT   36
#> 90  2025-04-02 08:00:00 EDT   37
#> 91  2025-04-02 09:00:00 EDT   39
#> 92  2025-04-02 10:00:00 EDT   41
#> 93  2025-04-02 11:00:00 EDT   43
#> 94  2025-04-02 12:00:00 EDT   45
#> 95  2025-04-02 13:00:00 EDT   46
#> 96  2025-04-02 14:00:00 EDT   48
#> 97  2025-04-02 15:00:00 EDT   48
#> 98  2025-04-02 16:00:00 EDT   48
#> 99  2025-04-02 17:00:00 EDT   48
#> 100 2025-04-02 18:00:00 EDT   48
#> 101 2025-04-02 19:00:00 EDT   47
#> 102 2025-04-02 20:00:00 EDT   47
#> 103 2025-04-02 21:00:00 EDT   47
#> 104 2025-04-02 22:00:00 EDT   46
#> 105 2025-04-02 23:00:00 EDT   46
#> 106 2025-04-03 00:00:00 EDT   46
#> 107 2025-04-03 01:00:00 EDT   46
#> 108 2025-04-03 02:00:00 EDT   46
#> 109 2025-04-03 03:00:00 EDT   45
#> 110 2025-04-03 04:00:00 EDT   45
#> 111 2025-04-03 05:00:00 EDT   45
#> 112 2025-04-03 06:00:00 EDT   45
#> 113 2025-04-03 07:00:00 EDT   45
#> 114 2025-04-03 08:00:00 EDT   47
#> 115 2025-04-03 09:00:00 EDT   51
#> 116 2025-04-03 10:00:00 EDT   55
#> 117 2025-04-03 11:00:00 EDT   59
#> 118 2025-04-03 12:00:00 EDT   62
#> 119 2025-04-03 13:00:00 EDT   65
#> 120 2025-04-03 14:00:00 EDT   68
#> 121 2025-04-03 15:00:00 EDT   69
#> 122 2025-04-03 16:00:00 EDT   69
#> 123 2025-04-03 17:00:00 EDT   69
#> 124 2025-04-03 18:00:00 EDT   68
#> 125 2025-04-03 19:00:00 EDT   66
#> 126 2025-04-03 20:00:00 EDT   65
#> 127 2025-04-03 21:00:00 EDT   63
#> 128 2025-04-03 22:00:00 EDT   63
#> 129 2025-04-03 23:00:00 EDT   62
#> 130 2025-04-04 00:00:00 EDT   61
#> 131 2025-04-04 01:00:00 EDT   60
#> 132 2025-04-04 02:00:00 EDT   59
#> 133 2025-04-04 03:00:00 EDT   58
#> 134 2025-04-04 04:00:00 EDT   58
#> 135 2025-04-04 05:00:00 EDT   57
#> 136 2025-04-04 06:00:00 EDT   57
#> 137 2025-04-04 07:00:00 EDT   57
#> 138 2025-04-04 08:00:00 EDT   58
#> 139 2025-04-04 09:00:00 EDT   59
#> 140 2025-04-04 10:00:00 EDT   59
#> 141 2025-04-04 11:00:00 EDT   60
#> 142 2025-04-04 12:00:00 EDT   61
#> 143 2025-04-04 13:00:00 EDT   62
#> 144 2025-04-04 14:00:00 EDT   63
#> 145 2025-04-04 15:00:00 EDT   63
#> 146 2025-04-04 16:00:00 EDT   63
#> 147 2025-04-04 17:00:00 EDT   63
#> 148 2025-04-04 18:00:00 EDT   61
#> 149 2025-04-04 19:00:00 EDT   59
#> 150 2025-04-04 20:00:00 EDT   57
#> 151 2025-04-04 21:00:00 EDT   56
#> 152 2025-04-04 22:00:00 EDT   55
#> 153 2025-04-04 23:00:00 EDT   54
#> 154 2025-04-05 00:00:00 EDT   53
#> 155 2025-04-05 01:00:00 EDT   52
#> 156 2025-04-05 02:00:00 EDT   51
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
  select(time, wind_speed, skies)
#>                        time wind_speed                                   skies
#> 1   2025-03-29 15:00:00 EDT         17                            Partly Sunny
#> 2   2025-03-29 16:00:00 EDT         15                            Partly Sunny
#> 3   2025-03-29 17:00:00 EDT         13                            Partly Sunny
#> 4   2025-03-29 18:00:00 EDT         12 Slight Chance Showers And Thunderstorms
#> 5   2025-03-29 19:00:00 EDT         10 Slight Chance Showers And Thunderstorms
#> 6   2025-03-29 20:00:00 EDT         10                     Chance Rain Showers
#> 7   2025-03-29 21:00:00 EDT         10                     Chance Rain Showers
#> 8   2025-03-29 22:00:00 EDT          9                     Chance Rain Showers
#> 9   2025-03-29 23:00:00 EDT          9                     Chance Rain Showers
#> 10  2025-03-30 00:00:00 EDT          8              Slight Chance Rain Showers
#> 11  2025-03-30 01:00:00 EDT          8              Slight Chance Rain Showers
#> 12  2025-03-30 02:00:00 EDT          7              Slight Chance Rain Showers
#> 13  2025-03-30 03:00:00 EDT          7              Slight Chance Rain Showers
#> 14  2025-03-30 04:00:00 EDT          6              Slight Chance Rain Showers
#> 15  2025-03-30 05:00:00 EDT          6              Slight Chance Rain Showers
#> 16  2025-03-30 06:00:00 EDT          6              Slight Chance Rain Showers
#> 17  2025-03-30 07:00:00 EDT          7              Slight Chance Rain Showers
#> 18  2025-03-30 08:00:00 EDT          7                                  Cloudy
#> 19  2025-03-30 09:00:00 EDT          7                                  Cloudy
#> 20  2025-03-30 10:00:00 EDT          6                                  Cloudy
#> 21  2025-03-30 11:00:00 EDT          6                           Mostly Cloudy
#> 22  2025-03-30 12:00:00 EDT          6                           Mostly Cloudy
#> 23  2025-03-30 13:00:00 EDT          7                           Mostly Cloudy
#> 24  2025-03-30 14:00:00 EDT          7                           Mostly Cloudy
#> 25  2025-03-30 15:00:00 EDT          7                           Mostly Cloudy
#> 26  2025-03-30 16:00:00 EDT          7                           Mostly Cloudy
#> 27  2025-03-30 17:00:00 EDT          7                           Mostly Cloudy
#> 28  2025-03-30 18:00:00 EDT          7              Slight Chance Rain Showers
#> 29  2025-03-30 19:00:00 EDT          6              Slight Chance Rain Showers
#> 30  2025-03-30 20:00:00 EDT          6                     Chance Rain Showers
#> 31  2025-03-30 21:00:00 EDT          6                     Chance Rain Showers
#> 32  2025-03-30 22:00:00 EDT          6                     Chance Rain Showers
#> 33  2025-03-30 23:00:00 EDT          6                     Chance Rain Showers
#> 34  2025-03-31 00:00:00 EDT          6                     Chance Rain Showers
#> 35  2025-03-31 01:00:00 EDT          6                     Chance Rain Showers
#> 36  2025-03-31 02:00:00 EDT          6                     Chance Rain Showers
#> 37  2025-03-31 03:00:00 EDT          7                     Chance Rain Showers
#> 38  2025-03-31 04:00:00 EDT          7                     Chance Rain Showers
#> 39  2025-03-31 05:00:00 EDT          8                     Chance Rain Showers
#> 40  2025-03-31 06:00:00 EDT          9                     Chance Rain Showers
#> 41  2025-03-31 07:00:00 EDT          9                     Chance Rain Showers
#> 42  2025-03-31 08:00:00 EDT         10                     Chance Rain Showers
#> 43  2025-03-31 09:00:00 EDT         10                     Chance Rain Showers
#> 44  2025-03-31 10:00:00 EDT         10                     Chance Rain Showers
#> 45  2025-03-31 11:00:00 EDT         10                     Chance Rain Showers
#> 46  2025-03-31 12:00:00 EDT         10                     Chance Rain Showers
#> 47  2025-03-31 13:00:00 EDT         12                     Chance Rain Showers
#> 48  2025-03-31 14:00:00 EDT         12                     Rain Showers Likely
#> 49  2025-03-31 15:00:00 EDT         12                     Rain Showers Likely
#> 50  2025-03-31 16:00:00 EDT         12                     Rain Showers Likely
#> 51  2025-03-31 17:00:00 EDT         12                     Rain Showers Likely
#> 52  2025-03-31 18:00:00 EDT         10                     Rain Showers Likely
#> 53  2025-03-31 19:00:00 EDT         10                     Rain Showers Likely
#> 54  2025-03-31 20:00:00 EDT          9               Showers And Thunderstorms
#> 55  2025-03-31 21:00:00 EDT          9               Showers And Thunderstorms
#> 56  2025-03-31 22:00:00 EDT         10               Showers And Thunderstorms
#> 57  2025-03-31 23:00:00 EDT         10               Showers And Thunderstorms
#> 58  2025-04-01 00:00:00 EDT         10               Showers And Thunderstorms
#> 59  2025-04-01 01:00:00 EDT          9               Showers And Thunderstorms
#> 60  2025-04-01 02:00:00 EDT          9                     Rain Showers Likely
#> 61  2025-04-01 03:00:00 EDT         10                     Rain Showers Likely
#> 62  2025-04-01 04:00:00 EDT         12                     Rain Showers Likely
#> 63  2025-04-01 05:00:00 EDT         13                     Rain Showers Likely
#> 64  2025-04-01 06:00:00 EDT         13                     Rain Showers Likely
#> 65  2025-04-01 07:00:00 EDT         14                     Rain Showers Likely
#> 66  2025-04-01 08:00:00 EDT         14                            Mostly Sunny
#> 67  2025-04-01 09:00:00 EDT         14                            Mostly Sunny
#> 68  2025-04-01 10:00:00 EDT         15                            Mostly Sunny
#> 69  2025-04-01 11:00:00 EDT         15                            Mostly Sunny
#> 70  2025-04-01 12:00:00 EDT         14                            Mostly Sunny
#> 71  2025-04-01 13:00:00 EDT         14                                   Sunny
#> 72  2025-04-01 14:00:00 EDT         13                                   Sunny
#> 73  2025-04-01 15:00:00 EDT         13                                   Sunny
#> 74  2025-04-01 16:00:00 EDT         13                                   Sunny
#> 75  2025-04-01 17:00:00 EDT         13                                   Sunny
#> 76  2025-04-01 18:00:00 EDT         12                            Mostly Clear
#> 77  2025-04-01 19:00:00 EDT         10                            Mostly Clear
#> 78  2025-04-01 20:00:00 EDT          9                            Mostly Clear
#> 79  2025-04-01 21:00:00 EDT          8                            Mostly Clear
#> 80  2025-04-01 22:00:00 EDT          8                            Mostly Clear
#> 81  2025-04-01 23:00:00 EDT          7                            Mostly Clear
#> 82  2025-04-02 00:00:00 EDT          7                            Mostly Clear
#> 83  2025-04-02 01:00:00 EDT          7                            Mostly Clear
#> 84  2025-04-02 02:00:00 EDT          7                            Mostly Clear
#> 85  2025-04-02 03:00:00 EDT          7                           Partly Cloudy
#> 86  2025-04-02 04:00:00 EDT          7                           Partly Cloudy
#> 87  2025-04-02 05:00:00 EDT          7                           Partly Cloudy
#> 88  2025-04-02 06:00:00 EDT          7                            Mostly Sunny
#> 89  2025-04-02 07:00:00 EDT          7                            Mostly Sunny
#> 90  2025-04-02 08:00:00 EDT          7                            Mostly Sunny
#> 91  2025-04-02 09:00:00 EDT          7                            Mostly Sunny
#> 92  2025-04-02 10:00:00 EDT          8                            Mostly Sunny
#> 93  2025-04-02 11:00:00 EDT          8                            Mostly Sunny
#> 94  2025-04-02 12:00:00 EDT          9                            Mostly Sunny
#> 95  2025-04-02 13:00:00 EDT          9                            Mostly Sunny
#> 96  2025-04-02 14:00:00 EDT         10                            Mostly Sunny
#> 97  2025-04-02 15:00:00 EDT         10                            Partly Sunny
#> 98  2025-04-02 16:00:00 EDT         12                            Partly Sunny
#> 99  2025-04-02 17:00:00 EDT         12                           Mostly Cloudy
#> 100 2025-04-02 18:00:00 EDT         13                           Mostly Cloudy
#> 101 2025-04-02 19:00:00 EDT         13                           Mostly Cloudy
#> 102 2025-04-02 20:00:00 EDT         13              Slight Chance Rain Showers
#> 103 2025-04-02 21:00:00 EDT         13              Slight Chance Rain Showers
#> 104 2025-04-02 22:00:00 EDT         12              Slight Chance Rain Showers
#> 105 2025-04-02 23:00:00 EDT         12              Slight Chance Rain Showers
#> 106 2025-04-03 00:00:00 EDT         12              Slight Chance Rain Showers
#> 107 2025-04-03 01:00:00 EDT         10              Slight Chance Rain Showers
#> 108 2025-04-03 02:00:00 EDT         10                     Chance Rain Showers
#> 109 2025-04-03 03:00:00 EDT         10                     Chance Rain Showers
#> 110 2025-04-03 04:00:00 EDT         10                     Chance Rain Showers
#> 111 2025-04-03 05:00:00 EDT         12                     Chance Rain Showers
#> 112 2025-04-03 06:00:00 EDT         12                     Chance Rain Showers
#> 113 2025-04-03 07:00:00 EDT         13                     Chance Rain Showers
#> 114 2025-04-03 08:00:00 EDT         13                     Chance Rain Showers
#> 115 2025-04-03 09:00:00 EDT         13                     Chance Rain Showers
#> 116 2025-04-03 10:00:00 EDT         14                     Chance Rain Showers
#> 117 2025-04-03 11:00:00 EDT         14                     Chance Rain Showers
#> 118 2025-04-03 12:00:00 EDT         14                     Chance Rain Showers
#> 119 2025-04-03 13:00:00 EDT         14                     Chance Rain Showers
#> 120 2025-04-03 14:00:00 EDT         14              Slight Chance Rain Showers
#> 121 2025-04-03 15:00:00 EDT         14              Slight Chance Rain Showers
#> 122 2025-04-03 16:00:00 EDT         14              Slight Chance Rain Showers
#> 123 2025-04-03 17:00:00 EDT         13              Slight Chance Rain Showers
#> 124 2025-04-03 18:00:00 EDT         13              Slight Chance Rain Showers
#> 125 2025-04-03 19:00:00 EDT         13              Slight Chance Rain Showers
#> 126 2025-04-03 20:00:00 EDT         12                     Chance Rain Showers
#> 127 2025-04-03 21:00:00 EDT         10                     Chance Rain Showers
#> 128 2025-04-03 22:00:00 EDT          9                     Chance Rain Showers
#> 129 2025-04-03 23:00:00 EDT          8                     Chance Rain Showers
#> 130 2025-04-04 00:00:00 EDT          7                     Chance Rain Showers
#> 131 2025-04-04 01:00:00 EDT          7                     Chance Rain Showers
#> 132 2025-04-04 02:00:00 EDT          6                     Chance Rain Showers
#> 133 2025-04-04 03:00:00 EDT          6                     Chance Rain Showers
#> 134 2025-04-04 04:00:00 EDT          6                     Chance Rain Showers
#> 135 2025-04-04 05:00:00 EDT          6                     Chance Rain Showers
#> 136 2025-04-04 06:00:00 EDT          7                     Chance Rain Showers
#> 137 2025-04-04 07:00:00 EDT          7                     Chance Rain Showers
#> 138 2025-04-04 08:00:00 EDT          7                     Chance Rain Showers
#> 139 2025-04-04 09:00:00 EDT          7                     Chance Rain Showers
#> 140 2025-04-04 10:00:00 EDT          6                     Chance Rain Showers
#> 141 2025-04-04 11:00:00 EDT          6                     Chance Rain Showers
#> 142 2025-04-04 12:00:00 EDT          6                     Chance Rain Showers
#> 143 2025-04-04 13:00:00 EDT          5                     Chance Rain Showers
#> 144 2025-04-04 14:00:00 EDT          5              Slight Chance Rain Showers
#> 145 2025-04-04 15:00:00 EDT          5              Slight Chance Rain Showers
#> 146 2025-04-04 16:00:00 EDT          5              Slight Chance Rain Showers
#> 147 2025-04-04 17:00:00 EDT          5              Slight Chance Rain Showers
#> 148 2025-04-04 18:00:00 EDT          5              Slight Chance Rain Showers
#> 149 2025-04-04 19:00:00 EDT          5              Slight Chance Rain Showers
#> 150 2025-04-04 20:00:00 EDT          5                           Mostly Cloudy
#> 151 2025-04-04 21:00:00 EDT          5                           Mostly Cloudy
#> 152 2025-04-04 22:00:00 EDT          5                           Mostly Cloudy
#> 153 2025-04-04 23:00:00 EDT          5                           Mostly Cloudy
#> 154 2025-04-05 00:00:00 EDT          6                           Mostly Cloudy
#> 155 2025-04-05 01:00:00 EDT          6                           Mostly Cloudy
#> 156 2025-04-05 02:00:00 EDT          6              Slight Chance Rain Showers
```

``` r

# We can easily put this result into a GT table for easy viewing

library(gt)
#> Warning: package 'gt' was built under R version 4.4.3
```

``` r

station_forecast(station_id = "KNYC") %>% 
  as.data.frame() %>% 
  select(time, wind_dir, wind_speed, skies) %>% 
  filter(dplyr::row_number() == 1 | skies != lag(skies)) %>%  #Keep only observations where the first row is 0 and the skies change
  rename_with(~ gsub("_", " ", .) %>% stringr::str_to_title()) %>% #switch from snake_case to Title Case
  gt::gt() %>% 
  gt::tab_header(title = paste0("Skies forecast for KNYC, the Week of ", Sys.Date()))
```

<div id="eoofcrwhyf" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#eoofcrwhyf table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#eoofcrwhyf thead, #eoofcrwhyf tbody, #eoofcrwhyf tfoot, #eoofcrwhyf tr, #eoofcrwhyf td, #eoofcrwhyf th {
  border-style: none;
}
&#10;#eoofcrwhyf p {
  margin: 0;
  padding: 0;
}
&#10;#eoofcrwhyf .gt_table {
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
&#10;#eoofcrwhyf .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#eoofcrwhyf .gt_title {
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
&#10;#eoofcrwhyf .gt_subtitle {
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
&#10;#eoofcrwhyf .gt_heading {
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
&#10;#eoofcrwhyf .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#eoofcrwhyf .gt_col_headings {
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
&#10;#eoofcrwhyf .gt_col_heading {
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
&#10;#eoofcrwhyf .gt_column_spanner_outer {
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
&#10;#eoofcrwhyf .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#eoofcrwhyf .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#eoofcrwhyf .gt_column_spanner {
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
&#10;#eoofcrwhyf .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#eoofcrwhyf .gt_group_heading {
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
&#10;#eoofcrwhyf .gt_empty_group_heading {
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
&#10;#eoofcrwhyf .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#eoofcrwhyf .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#eoofcrwhyf .gt_row {
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
&#10;#eoofcrwhyf .gt_stub {
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
&#10;#eoofcrwhyf .gt_stub_row_group {
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
&#10;#eoofcrwhyf .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#eoofcrwhyf .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#eoofcrwhyf .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#eoofcrwhyf .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#eoofcrwhyf .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#eoofcrwhyf .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#eoofcrwhyf .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#eoofcrwhyf .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#eoofcrwhyf .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#eoofcrwhyf .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#eoofcrwhyf .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#eoofcrwhyf .gt_footnotes {
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
&#10;#eoofcrwhyf .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#eoofcrwhyf .gt_sourcenotes {
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
&#10;#eoofcrwhyf .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#eoofcrwhyf .gt_left {
  text-align: left;
}
&#10;#eoofcrwhyf .gt_center {
  text-align: center;
}
&#10;#eoofcrwhyf .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#eoofcrwhyf .gt_font_normal {
  font-weight: normal;
}
&#10;#eoofcrwhyf .gt_font_bold {
  font-weight: bold;
}
&#10;#eoofcrwhyf .gt_font_italic {
  font-style: italic;
}
&#10;#eoofcrwhyf .gt_super {
  font-size: 65%;
}
&#10;#eoofcrwhyf .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#eoofcrwhyf .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#eoofcrwhyf .gt_indent_1 {
  text-indent: 5px;
}
&#10;#eoofcrwhyf .gt_indent_2 {
  text-indent: 10px;
}
&#10;#eoofcrwhyf .gt_indent_3 {
  text-indent: 15px;
}
&#10;#eoofcrwhyf .gt_indent_4 {
  text-indent: 20px;
}
&#10;#eoofcrwhyf .gt_indent_5 {
  text-indent: 25px;
}
&#10;#eoofcrwhyf .katex-display {
  display: inline-flex !important;
  margin-bottom: 0.75em !important;
}
&#10;#eoofcrwhyf div.Reactable > div.rt-table > div.rt-thead > div.rt-tr.rt-tr-group-header > div.rt-th-group:after {
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
    <tr><td headers="Time" class="gt_row gt_left">2025-03-29 15:00:00 EDT</td>
<td headers="Wind Dir" class="gt_row gt_left">W</td>
<td headers="Wind Speed" class="gt_row gt_right">17</td>
<td headers="Skies" class="gt_row gt_left">Partly Sunny</td></tr>
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
  as.data.frame()
#>    station_id  euc_dist                   geometry
#> 1        KBKF  13.49539 POINT (-104.7581 39.71331)
#> 2        KBJC  12.43745 POINT (-105.1042 39.90085)
#> 3        KAPA  13.13736 POINT (-104.8484 39.55991)
#> 4        KDEN  20.69956 POINT (-104.6562 39.84658)
#> 5        KEIK  17.19671 POINT (-105.0503 40.01169)
#> 6        KCFO  26.84118 POINT (-104.5376 39.78419)
#> 7        KBDU  23.47739 POINT (-105.2258 40.03943)
#> 8        KLMO  27.81048 POINT (-105.1604 40.16115)
#> 9        KMNH  36.77850 POINT (-104.6423 39.22317)
#> 10       KFNL  43.05082    POINT (-105.0167 40.45)
#> 11       KGXY  46.92477 POINT (-104.6333 40.43333)
#> 12       KAFF  47.05761 POINT (-104.8167 38.96667)
#> 13       K4BM  51.95940 POINT (-105.5144 39.05028)
#> 14       KGNB  60.01934 POINT (-105.9166 40.09006)
#> 15       KCCU  71.89873 POINT (-106.1523 39.47523)
#> 16       KCOS  58.15739 POINT (-104.6887 38.80949)
#> 17       KFCS  64.40845 POINT (-104.7598 38.68312)
#> 18       KFMM  79.11224  POINT (-103.807 40.33148)
#> 19       KABH  71.37519  POINT (-104.3013 38.7578)
#> 20       K20V  85.39828 POINT (-106.3689 40.05361)
#> 21       KLIC  83.57135 POINT (-103.6674 39.27334)
#> 22       KLXV  85.58982 POINT (-106.3161 39.22806)
#> 23       K33V  98.53442  POINT (-106.2754 40.7454)
#> 24       KAKO 109.30061 POINT (-103.2146 40.17428)
#> 25       KCYS  86.10921 POINT (-104.8081 41.15789)
#> 26       KANK  96.10582 POINT (-106.0486 38.53828)
#> 27       KC07 109.56033 POINT (-106.6992 40.35442)
#> 28       KEGE 116.18233    POINT (-106.9167 39.65)
#> 29       KPUB  91.26914 POINT (-104.5057 38.28869)
#> 30       KASE 117.26181 POINT (-106.8705 39.22992)
#> 31       KSTK 115.97595 POINT (-103.2611 40.61331)
#> 32       KMYP 109.27892  POINT (-106.3197 38.4972)
#> 33       KLAR 103.63920  POINT (-105.6729 41.3165)
#> 34       KIBM 117.46618 POINT (-103.6667 41.18333)
#> 35       KHDN 141.42519 POINT (-107.2167 40.48333)
#> 36       K04V 121.26310 POINT (-106.1686 38.09722)
#> 37       KGUC 137.44203 POINT (-106.9333 38.53333)
#> 38       KLHX 134.06360 POINT (-103.5133 38.04949)
#> 39       KSNY 145.15067 POINT (-102.9856 41.09944)
#> 40       KCAG 159.17609 POINT (-107.5239 40.49297)
#> 41       KITR 164.67710 POINT (-102.2819 39.24149)
#> 42       KHEQ 169.93295 POINT (-102.2768 40.57155)
#> 43       KLAA 169.98217 POINT (-102.6874 38.07178)
#> 44       KGLD 198.55877  POINT (-101.6931 39.3675)
#> 45       KIML 207.32320 POINT (-101.6167 40.51667)
#> 46       KOGA 209.97229 POINT (-101.7689 41.11972)
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

stations_near(lat = 39.73331998845491, lon = -104.98209127042489) %>% 
  tmap::tm_shape() + 
  #Plot stations near our point, with color becoming darker as they get closer
  tmap::tm_dots(col = "euc_dist", palette = "-Blues", title = "Euclidian Distance") +
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
  tmap::tm_dots()
```

<div class="leaflet html-widget html-fill-item" id="htmlwidget-d489e2d8663df6a6d093" style="width:100%;height:480px;"></div>
<script type="application/json" data-for="htmlwidget-d489e2d8663df6a6d093">{"x":{"options":{"crs":{"crsClass":"L.CRS.EPSG3857","code":null,"proj4def":null,"projectedBounds":null,"options":{}}},"calls":[{"method":"createMapPane","args":["tmap401",401]},{"method":"createMapPane","args":["tmap402",402]},{"method":"addProviderTiles","args":["Esri.WorldGrayCanvas",null,"Esri.WorldGrayCanvas",{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"pane":"tilePane"}]},{"method":"addProviderTiles","args":["OpenStreetMap",null,"OpenStreetMap",{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"pane":"tilePane"}]},{"method":"addProviderTiles","args":["Esri.WorldTopoMap",null,"Esri.WorldTopoMap",{"minZoom":0,"maxZoom":18,"tileSize":256,"subdomains":"abc","errorTileUrl":"","tms":false,"noWrap":false,"zoomOffset":0,"zoomReverse":false,"opacity":1,"zIndex":1,"detectRetina":false,"pane":"tilePane"}]},{"method":"addCircleMarkers","args":[[39.71331,39.90085,39.55991,39.84658,40.01169,39.78419,40.0394297,40.16115,39.22317,40.45,40.43333,38.96667,39.05028,40.09006,39.47523,38.8094899,38.68312,40.33148,38.7578,40.05361,39.27334,39.22806,40.7453999,40.17428,41.15789,38.53828,40.35442,39.65,38.28869,39.22992,40.61331,38.4972,41.3165,41.18333,40.48333,38.09722,38.53333,38.04949,41.09944,40.49297,39.24149,40.57155,38.0717799,39.3675,40.51667,41.11972],[-104.75806,-105.10417,-104.84841,-104.65622,-105.05033,-104.53764,-105.2258217,-105.16042,-104.6422599,-105.01667,-104.63333,-104.81667,-105.5144399,-105.91664,-106.15228,-104.68873,-104.75977,-103.80704,-104.3013,-106.3688899,-103.66738,-106.31611,-106.2754,-103.21459,-104.80812,-106.04864,-106.69922,-106.91667,-104.5057,-106.87051,-103.26109,-106.3197,-105.67287,-103.66667,-107.2166699,-106.16861,-106.93333,-103.51334,-102.98556,-107.52394,-102.2818999,-102.27676,-102.68745,-101.69306,-101.61667,-101.76889],[2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619,2.82842712474619],["KBKF","KBJC","KAPA","KDEN","KEIK","KCFO","KBDU","KLMO","KMNH","KFNL","KGXY","KAFF","K4BM","KGNB","KCCU","KCOS","KFCS","KFMM","KABH","K20V","KLIC","KLXV","K33V","KAKO","KCYS","KANK","KC07","KEGE","KPUB","KASE","KSTK","KMYP","KLAR","KIBM","KHDN","K04V","KGUC","KLHX","KSNY","KCAG","KITR","KHEQ","KLAA","KGLD","KIML","KOGA"],".",{"interactive":true,"className":"","pane":"tmap401","stroke":true,"color":"#666666","weight":1,"opacity":0.5,"fill":true,"fillColor":["#084A92","#084A92","#084A92","#084A92","#084A92","#084A92","#084A92","#084A92","#084A92","#084A92","#084A92","#084A92","#2676B7","#2676B7","#2676B7","#2676B7","#2676B7","#2676B7","#2676B7","#2676B7","#2676B7","#2676B7","#2676B7","#5AA2CF","#2676B7","#2676B7","#5AA2CF","#5AA2CF","#2676B7","#5AA2CF","#5AA2CF","#5AA2CF","#5AA2CF","#5AA2CF","#5AA2CF","#5AA2CF","#5AA2CF","#5AA2CF","#5AA2CF","#9FCAE1","#9FCAE1","#9FCAE1","#9FCAE1","#9FCAE1","#CFE1F2","#CFE1F2"],"fillOpacity":[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]},null,null,["<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KBKF<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>13.50<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KBJC<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>12.44<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KAPA<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>13.14<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KDEN<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>20.70<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KEIK<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>17.20<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KCFO<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>26.84<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KBDU<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>23.48<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KLMO<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>27.81<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KMNH<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>36.78<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KFNL<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>43.05<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KGXY<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>46.92<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KAFF<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>47.06<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>K4BM<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>51.96<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KGNB<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>60.02<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KCCU<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>71.90<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KCOS<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>58.16<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KFCS<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>64.41<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KFMM<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>79.11<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KABH<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>71.38<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>K20V<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>85.40<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KLIC<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>83.57<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KLXV<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>85.59<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>K33V<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>98.53<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KAKO<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>109.30<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KCYS<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>86.11<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KANK<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>96.11<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KC07<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>109.56<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KEGE<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>116.18<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KPUB<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>91.27<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KASE<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>117.26<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KSTK<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>115.98<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KMYP<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>109.28<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KLAR<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>103.64<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KIBM<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>117.47<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KHDN<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>141.43<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>K04V<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>121.26<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KGUC<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>137.44<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KLHX<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>134.06<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KSNY<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>145.15<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KCAG<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>159.18<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KITR<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>164.68<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KHEQ<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>169.93<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KLAA<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>169.98<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KGLD<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>198.56<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KIML<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>207.32<\/nobr><\/td><\/tr><\/table><\/div>","<style> div.leaflet-popup-content {width:auto !important;overflow-y:auto; overflow-x:hidden;}<\/style><div style=\"max-height:25em;padding-right:0px;\"><table>\n\t\t\t   <thead><tr><th colspan=\"2\"><b>KOGA<\/b><\/th><\/thead><\/tr><tr><td style=\"color: #888888;\"><nobr>euc_dist<\/nobr><\/td><td align=\"right\"><nobr>209.97<\/nobr><\/td><\/tr><\/table><\/div>"],null,["KBKF","KBJC","KAPA","KDEN","KEIK","KCFO","KBDU","KLMO","KMNH","KFNL","KGXY","KAFF","K4BM","KGNB","KCCU","KCOS","KFCS","KFMM","KABH","K20V","KLIC","KLXV","K33V","KAKO","KCYS","KANK","KC07","KEGE","KPUB","KASE","KSTK","KMYP","KLAR","KIBM","KHDN","K04V","KGUC","KLHX","KSNY","KCAG","KITR","KHEQ","KLAA","KGLD","KIML","KOGA"],{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addLegend","args":[{"colors":["#084A92","#2676B7","#5AA2CF","#9FCAE1","#CFE1F2"],"labels":["0 to 50","50 to 100","100 to 150","150 to 200","200 to 250"],"na_color":null,"na_label":"NA","opacity":1,"position":"topright","type":"unknown","title":"Euclidian Distance","extra":null,"layerId":"legend401","className":"info legend .","group":"."}]},{"method":"addCircleMarkers","args":[39.73331998845491,-104.9820912704249,2.82842712474619,[null,"KOGA"],"st_as_sf(data.frame(lon = -104.982091270425, lat = 39.7333199884549), ",{"interactive":true,"className":"","pane":"tmap402","stroke":true,"color":"#666666","weight":1,"opacity":0.5,"fill":true,"fillColor":"#000000","fillOpacity":1},null,null,null,null,null,{"interactive":false,"permanent":false,"direction":"auto","opacity":1,"offset":[0,0],"textsize":"10px","textOnly":false,"className":"","sticky":true},null]},{"method":"addLayersControl","args":[["Esri.WorldGrayCanvas","OpenStreetMap","Esri.WorldTopoMap"],[".","st_as_sf(data.frame(lon = -104.982091270425, lat = 39.7333199884549), "],{"collapsed":true,"autoZIndex":true,"position":"topleft"}]}],"limits":{"lat":[38.04949,41.3165],"lng":[-107.52394,-101.61667]},"fitBounds":[38.04949,-107.52394,41.3165,-101.61667,[]]},"evals":[],"jsHooks":[]}</script>

This is just a sampling of the functionality available in this package.
Feel free to browse the documentation with the `?function` commands in
the R console to explore further!
