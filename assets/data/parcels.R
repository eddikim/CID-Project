
#read all parcel files downloaded from parcel viewer
library(readxl)

parcel1 <- read_excel("parcel1.xls")
parcel2 <- read_excel("parcel2.xls")
parcelk1 <- read_excel("parcelk1.xlsx")
parcelk2 <- read_excel("parcelk2.xlsx")
parcelk3 <- read_excel("parcelk3.xlsx")

#join all dataframes
library(dplyr)

join1 <- full_join(parcel1, parcel2)
join2 <- full_join(join1, parcelk2)
join3 <- full_join(join2, parcelk3)
parcels <- full_join(join3, parcelk1)

#create csv with all dataframes
write.csv(parcels, "parcels.csv", row.names = FALSE)

#read in csv
parcels <- read.csv("parcels.csv", colClasses = c(Parcel.number = "character"))

#read in sales file
sales <- read.csv("EXTR_RPSale.csv")

#add leading 0's to major and minor for sales file
library(stringr)

sales$Minor <- str_pad(sales$Minor, 4, pad = "0")
sales$Major <- str_pad(sales$Major, 6, pad = "0")

#change date column from char into date
sales$DocumentDate <- as.Date(sales$DocumentDate, format="%m/%d/%Y") 

#filter to only have dates past 2008
sales <- sales %>%
  filter(DocumentDate >= '2008-01-01')

#mutate major and minor into parcel column
sales$Parcel.number <- paste(sales$Major, sales$Minor, sep = "")

#join sales file with parcels to only include CID parcels
CID_parcels <- merge(parcels, sales, all.x = TRUE)

