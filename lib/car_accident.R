# Read in car accident data and process it with total count per zip code
library(data.table); library(dplyr)

var <- c("BOROUGH", "LATITUDE", "LONGITUDE", "ZIP CODE")
setwd("~/Documents/project2-group4")
carAccident <- fread("data/Vehicle_Collisions.csv", select = var, nrows = 238493)

carAccident <- filter(carAccident, BOROUGH=="MANHATTAN")
save(carAccident, file = "data/car accident.RDS")
rm(carAccident)
load("data/car accident.RDS")
# Group data by zip code, output total number into new column
groupCar <- group_by(carAccident, `ZIP CODE`)
countCar <- summarise(groupCar, carAccident = n())
save(countCar, file = "data/car accident zip.RDS")
