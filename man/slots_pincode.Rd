% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cowinAPI.R
\name{slots_pincode}
\alias{slots_pincode}
\title{Vaccine slots for 7 days from a specific date in a given pincode}
\usage{
slots_pincode(pincode, date = Sys.Date())
}
\arguments{
\item{pincode}{6 digit pincode where you want availability of slots}

\item{date}{slots shown for 7 days from this date}
}
\value{

}
\description{
Vaccine slots for 7 days from a specific date in a given pincode
}
\examples{
slots.pincodes <- slots_pincode(201301)
slots.pincodes2 <-  slots_cleaned(slots.pincodes, age_limit = 45)
}
\author{
Deepanshu Bhalla
}
