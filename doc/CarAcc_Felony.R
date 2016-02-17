# Read in car accident data and process it with total count per zip code
library(data.table); library(dplyr)
var <- c("BOROUGH", "ZIP CODE")
setwd("~/Documents/project2-group4")
carAccident <- fread("Vehicle_Collisions.csv", select = var)
# Group data by zip code, output total number into new column
groupCar <- group_by(carAccident, `ZIP CODE`)
countCar <- summarise(groupCar, carAccident = n())


# Felony data process, and plot it by ggmap 
var <- c("Occurrence Year","Offense","Location 1")
felony <- fread("Felony_Incidents.csv", select = var)
# We only care about felony happened in year 2015
felony <- filter(felony, `Occurrence Year` == 2015)
# We need to change Offense to catgory for differentiate them later
felony$Offense <- as.factor(felony$Offense)
# Plot incidents of felony according each category,
# here I use MURDER as an example.
murder <- filter(felony, Offense=="MURDER")
# plotFelony is a function that preprocess coordinates and then
# plot all incidents on google map.
library(ggmap)
plotFelony <- function(felony) {
  co <- gsub(",", "", felony$`Location 1`)
  co <- gsub("\\(", "", co)
  co <- gsub("\\)", "", co)
  coord <- strsplit(co, " ")
  coord <- matrix(sapply(coord, as.numeric), ncol = 2, byrow = T)
  
  df <- as.data.frame(coord)
  mapgilbert <- get_map(location = c(lon = mean(df$V2),lat = mean(df$V1)),zoom = 11,
                        maptype = "roadmap", scale = 2)
  ggmap(mapgilbert) +
    geom_point(data = df, aes(y = V1, x = V2, fill = "red", alpha=1.5), size = 1.5, shape = 21) +
    guides(fill=FALSE, alpha=FALSE, size=FALSE)
}
# Test it out.
plotFelony(murder)