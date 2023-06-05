install.packages("ggmap")
library(ggmap)
library(dplyr)
data <- read.csv("CID_parcels2008.csv")
register_google(key = "AIzaSyDtlgxMzwhUnV9vR_I188tIgF2n3DU_YTY")

# Function to geocode an address
geocode_address <- function(address) {
  result <- geocode(address, output = "latlon", source = "google", key = "AIzaSyDtlgxMzwhUnV9vR_I188tIgF2n3DU_YTY")
  return(result)
}


# Assuming you have a data frame called 'data' with three columns: column1, column2, column3

data <- data %>%
  filter(Parcel.address != "#Error")

data$Full_Address <- paste(data$Parcel.address, data$Jurisdiction, data$Zip.code, sep = ", ")

# Apply geocoding to each address
data <- data %>%
  mutate(
    geocode_result = purrr::map(Full_Address, geocode_address),
    latitude = purrr::map_dbl(geocode_result, "lat"),
    longitude = purrr::map_dbl(geocode_result, "lon")
  )

data <- data[, !(names(data) %in% "geocode_result")]

write.csv(data, "Coords_CID_Parcels2008.csv", row.names = FALSE)
