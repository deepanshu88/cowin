library(cowin)
library(dplyr)

# List of States
df.States <- extract_states()

# Fetch Districts of a particular state
df.District <- extract_districts(16)

# Fetch Districts of all the Indian states
df.Districts <- extract_districts_all(df.States)

# Vaccine slots for 7 days from today's date in a given district
slots <- slots_district(df.Districts[1,1])

# Vaccine slots for 7 days from week later
slots <- slots_district(df.Districts[1,1], date = Sys.Date()+7)

# Cleaned Output
slots2 <-  slots_cleaned(slots)
slots2 <-  slots_cleaned(slots, age_limit = 45)

# Vaccine slots for Multiple districts
district.ids <- c(1,3)
slots.all <- slots_district_all(district.ids)

# Vaccine slots for 7 days from a specific date in a given pincode
slots.pincodes <- slots_pincode(201301)
slots.pincodes2 <-  slots_cleaned(slots.pincodes)
slots.pincodes2 <-  slots_cleaned(slots.pincodes, age_limit = 45)

# Vaccine slots for multiple pincodes
slots.all <- slots_pincode_all(pincodes = c(201301,110032))
