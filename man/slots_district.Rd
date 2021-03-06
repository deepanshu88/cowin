% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cowinAPI.R
\name{slots_district}
\alias{slots_district}
\title{Vaccine slots for 7 days from a specific date in a given district}
\usage{
slots_district(district_id, date = Sys.Date())
}
\arguments{
\item{district_id}{District ID obtained from extract_districts_all()}

\item{date}{slots available for 7 days from this date. Default today's date}
}
\value{

}
\description{
Vaccine slots for 7 days from a specific date in a given district
}
\examples{
slots <- slots_district(df.Districts[1,1])
}
\author{
Deepanshu Bhalla
}
