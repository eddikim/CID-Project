install.packages("ggmap")
library(ggmap)
library(dplyr)
data3 <- read.csv("CID_parcels2008.csv")
register_google(key = "AIzaSyDtlgxMzwhUnV9vR_I188tIgF2n3DU_YTY")

# Function to geocode an address
geocode_address <- function(address) {
  result <- geocode(address, output = "latlon", source = "google", key = "AIzaSyDtlgxMzwhUnV9vR_I188tIgF2n3DU_YTY")
  return(result)
}

# Apply geocoding to each address
data <- data %>%
  mutate(
    geocode_result = purrr::map(Parcel.address, geocode_address),
    latitude = purrr::map_dbl(geocode_result, "lat"),
    longitude = purrr::map_dbl(geocode_result, "lon")
  )

data <- data[, !(names(data) %in% "geocode_result")]

write.csv(data, "Coords_CID_Parcels2008.csv", row.names = FALSE)
