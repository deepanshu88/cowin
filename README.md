
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cowin

<!-- badges: start -->

<!-- badges: end -->

The goal of this package is to create R wrapper for [cowin
API](https://apisetu.gov.in/) It allows user to find slots for
vaccination in your district or pincode. API has some restrictions - it
allows maximum 100 request per 5 minutes per IP. Your IP address can be
blocked if rate limit exceeds.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("deepanshu88/cowin")
```

## Example

### Extract list of States

``` r
library(cowin)
library(dplyr)
df.States <- extract_states()
```

### Fetch Districts of a particular state

``` r
df.District <- extract_districts(16)
```

### Fetch Districts of all the Indian states

``` r
df.Districts <- extract_districts_all(df.States)
```

### Vaccine slots for 7 days from today’s date in a given district

``` r
slots <- slots_district(df.Districts[1,1])
```

### Vaccine slots for 7 days from week later

``` r
slots <- slots_district(df.Districts[1,1], date = Sys.Date()+7)
```

### Cleaned Output of slots\_district() and slots\_pincode()

``` r
slots2 <-  slots_cleaned(slots)
slots2 <-  slots_cleaned(slots, age_limit = 45)
```

### Vaccine slots for Multiple districts

``` r
district.ids <- c(1,3)
slots.all <- slots_district_all(district.ids)
```

### Vaccine slots for 7 days from a specific date in a given pincode

``` r
slots.pincodes <- slots_pincode(201301)
slots.pincodes2 <-  slots_cleaned(slots.pincodes)
slots.pincodes2 <-  slots_cleaned(slots.pincodes, age_limit = 45)
```

### Vaccine slots for multiple pincodes

``` r
slots.all <- slots_pincode_all(pincodes = c(201301,110032))
```
