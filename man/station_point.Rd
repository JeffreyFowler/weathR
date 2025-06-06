% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/03-station_data.R
\name{station_point}
\alias{station_point}
\title{Station Coordinates as a Point}
\usage{
station_point(station_id)
}
\arguments{
\item{station_id}{The station identifier (ex: KDEN, KBOS, KNYC, etc).}
}
\value{
Simple features point corresponding to the given station identifier.
}
\description{
Station Coordinates as a Point
}
\examples{
\donttest{
station_point("KDEN")
}
}
