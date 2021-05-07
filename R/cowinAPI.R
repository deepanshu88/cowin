#' Base URLS
#'
#' @return list of URLs
#' @author Deepanshu Bhalla
#' @export
#'
#' @examples
URLS <- function() {
  base_url = "https://cdn-api.co-vin.in/api/v2"
  states_list_url = paste0(base_url, "/admin/location/states")
  districts_list_url = paste0(base_url, "/admin/location/districts/")
  districts_calendar_url = paste0(base_url, "/appointment/sessions/public/calendarByDistrict?district_id=")
  pincodes_calendar_url = paste0(base_url, "/appointment/sessions/public/calendarByPin?pincode=")

  return(list(states = states_list_url,
              districts = districts_list_url,
              districts_calendar = districts_calendar_url,
              pincodes_calendar = pincodes_calendar_url
              ))
}

#' Call CowinAPI
#'
#' @return
#' @author Deepanshu Bhalla
#' @export
#'
#' @examples
cowinAPI <- function(URL) {
  request <- GET(url = URL, add_headers("user-agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36"))
  response <- content(request, as = "text", encoding = "UTF-8")
  df <- fromJSON(response, flatten = TRUE) %>% data.frame()
  return(df)
}


#' List of States
#'
#' @return
#' @author Deepanshu Bhalla
#' @export
#'
#' @examples
#' df.States <- extract_states()
extract_states <- function() {
  df.Districts <- cowinAPI(URLS()$states)
  return(df.Districts)
}

#' Fetch Districts of a particular state
#'
#' @param state_id State ID (get from extract_states() function)
#' @return
#' @author Deepanshu Bhalla
#' @export
#'
#' @examples
#' df.District <- extract_districts(16)
extract_districts <- function(state_id) {
  districts_list_url = paste0(URLS()$districts, state_id)
  df.Districts <- cowinAPI(districts_list_url)
  return(df.Districts)
}

#' Fetch Districts of all the Indian states
#'
#' @param df Frame Name of output of extract_states() function
#' @return
#' @author Deepanshu Bhalla
#' @export
#'
#' @examples
#' df.Districts <- extract_districts_all(df.States)

extract_districts_all <- function(df) {

states.ids <- df %>% select(states.state_id) %>% pull()
states <- df %>% select(states.state_name) %>% pull()
df.Districts.Updated <- data.frame(stringsAsFactors = F)

for (i in 1:length(states.ids)) {
    df.Districts <- extract_districts(states.ids[i]) %>% mutate(State = states[i])
    df.Districts.Updated <- rbind(df.Districts.Updated, df.Districts)
}
  return(df.Districts.Updated)

}

#' Vaccine slots for 7 days from a specific date in a given district
#'
#' @param district_id District ID obtained from extract_districts_all()
#' @param date slots available for 7 days from this date. Default today's date
#' @return
#' @author Deepanshu Bhalla
#' @export
#'
#' @examples
#' slots <- slots_district(df.Districts[1,1])

slots_district <- function(district_id, date = Sys.Date()) {

  date <- format.Date(date, "%d-%m-%Y")
  districts_calendar_url = paste0(URLS()$districts_calendar, district_id, "&date=", date)
  df.Districts <- cowinAPI(districts_calendar_url)
  return(df.Districts)

}

#' Clean Output of slots_district() and slots_pincode()
#'
#' @param slots.df Dataframe obtained from slots_district() function
#' @param age_limit Enter 18 for 18+, 45 for 45+. By default, combination of both
#' @return
#' @author Deepanshu Bhalla
#' @export
#'
#' @examples
#' slots2 <-  slots_cleaned(slots, age_limit = 45)

slots_cleaned <- function(slots.df, age_limit = NULL) {

  l <- lapply(1:nrow(slots.df), function(i) cbind(name = slots.df[["centers.name"]][[i]],
                                                  address = slots.df[["centers.address"]][[i]],
                                                  district = slots.df[["centers.district_name"]][[i]],
                                                  pincode = slots.df[["centers.pincode"]][[i]],
                                                  state = slots.df[["centers.state_name"]][[i]],
                                                  fee_type = slots.df[["centers.fee_type"]][[i]],
                                                  slots.df[["centers.sessions"]][[i]] ))

  l2 <- bind_rows(l)

  if(!is.null(age_limit)) {
    if(('min_age_limit' %in% names(l2))) {
      l2 <- l2 %>% filter(min_age_limit == age_limit)
    } else { l2 }
  }

  return(l2)

}

#' Vaccine slots for 7 days from a specific date for multiple districts
#'
#' @param slots.df Dataframe obtained from slots_district() function
#' @param age_limit Enter 18 for 18+, 45 for 45+. By default, combination of both
#' @return
#' @author Deepanshu Bhalla
#' @export
#'
#' @examples
#' district.ids <- df.Districts %>% select(1) %>% pull() %>% .[1:2]
#' slots.all <- slots_district_all(district.ids)

slots_district_all <- function(districts, date = Sys.Date(), age_limit = NULL) {

df.Districts.Slots <- data.frame()
for (i in 1:length(districts)) {
  s  <- slots_district(districts[i], date)
  s2 <- slots_cleaned(s, age_limit = age_limit)
  df.Districts.Slots <- rbind(df.Districts.Slots, s2)
}

return(df.Districts.Slots)

}

#' Vaccine slots for 7 days from a specific date in a given pincode
#'
#' @param pincode 6 digit pincode where you want availability of slots
#' @param date slots shown for 7 days from this date
#' @return
#' @author Deepanshu Bhalla
#' @export
#'
#' @examples
#' slots.pincodes <- slots_pincode(201301)
#' slots.pincodes2 <-  slots_cleaned(slots.pincodes, age_limit = 45)

slots_pincode <- function(pincode, date = Sys.Date()) {

  date <- format.Date(date, "%d-%m-%Y")
  pincodes_calendar_url = paste0(URLS()$pincodes_calendar, pincode, "&date=", date)
  df.pincodes <- cowinAPI(pincodes_calendar_url)
  return(df.pincodes)

}

#' Vaccine slots for 7 days from a specific date for multiple pincodes
#'
#' @param pincode 6 digit pincode where you want availability of slots
#' @param date slots shown for 7 days from this date
#' @return
#' @author Deepanshu Bhalla
#' @export
#'
#' @examples
#' slots.all <- slots_pincode_all(pincodes = c(201301,110032))

slots_pincode_all <- function(pincodes, date = Sys.Date(), age_limit = NULL) {

  df.pincodes.Slots <- data.frame()
  for (i in 1:length(pincodes)) {
    s  <- slots_pincode(pincodes[i], date)
    s2 <- slots_cleaned(s, age_limit = age_limit)
    df.pincodes.Slots <- rbind(df.pincodes.Slots, s2)
  }

  return(df.pincodes.Slots)

}
