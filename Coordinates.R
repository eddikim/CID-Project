install.packages("opencage")
library(opencage)

key <- "3c6529b5ea0649ec9f527444553e86c9"

parcels <- read.csv('CID_parcels2008.csv')

parcelswo <- parcels[parcels$`Parcel.address` != "#Error", ]

# Function to geocode an address and return a list with lat and lng
parcels$coordinates <- lapply(parcels$`Parcel.address`, function(x) {
  result <- opencage_forward(placename = x, key = "3c6529b5ea0649ec9f527444553e86c9")
  if (result$status$message == "OK") {
    return(paste(result$results$geometry$lat, result$results$geometry$lng))
  } else {
    return(NA)
  }
})


# Apply the function to all addresses
coordinates <- lapply(parcels$`Parcel.address`, geocode_address)

# Convert the list of coordinates to a data frame
coordinates_df <- do.call(rbind, lapply(coordinates, data.frame))

# Add the coordinates to the original data frame
parcels <- cbind(parcels, coordinates_df)

# Load the necessary library
library(dplyr)

# Create the data frame
count_df <- CID_parcels2008 %>%
  filter(SalePrice == 0) %>%
  select(Parcel.number, BuyerName, SellerName, Parcel.address, DocumentDate, SalePrice)

write.csv(count_df, "ZeroSalePrice.csv", row.names = FALSE)

