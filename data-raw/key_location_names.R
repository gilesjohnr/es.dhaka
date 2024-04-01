# Make metadata keys
key_location_names <- read.csv(file.path(getwd(), "data-raw/key_location_names_1.csv"))

usethis::use_data(key_location_names, overwrite=TRUE)
