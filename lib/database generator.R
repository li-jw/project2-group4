save(zip.data,file="project2-group4/app/zip.data.RData")

data(zip.regions)
ny <- subset(zip.regions,zip.regions$county.fips.numeric %in% c(36061))
# ny <- subset(zip.regions,zip.regions$county.fips.numeric %in% c(36061,36005,36047,36081))
zipcode <- ny$region
n <- length(zipcode)
zip.data <- data.frame(array(runif(4*2*n,0,100),dim = c(n,4*2)))
names(zip.data) <-  c("education1","education2","safety1","safety2","entertainment1","entertainment2","demographics1","demographics2")
zip.data <- data.frame(zipcode,zip.data,stringsAsFactors = F)

# Restaurant Data
load("project2-group4/data/Data by zipcode/restaurant.RData")
restaurant.data <- as.data.frame(restau)
restaurant.data <- restaurant.data[,c(1,3)]
names(restaurant.data) <- c("zipcode","entertainment1")
zip.data <- merge(zip.data[,c(-6)],restaurant.data,by="zipcode",all.x=T)



# Car accident Data
load("project2-group4/data/Data by zipcode/car accident zip.RDS")
car <- as.data.frame(countCar)
names(car) <- c("zipcode","safety1")
load("project2-group4/data/Data by zipcode/felony zip.RDS")
fel <- as.data.frame(countFel)
names(fel) <- c("zipcode","safety2")
carfel <- merge(car,fel,by="zipcode",all = T)
carfel <- carfel[!is.na(carfel$zipcode),]
zip.data <- merge(zip.data[,c(-4,-5)],carfel,by="zipcode",all.x=T)

# Demographics
age <- read.csv("project2-group4/data/Data by zipcode/median age.csv",header=T)
names(age) <- c("zipcode","demographics1")
density <- read.csv("project2-group4/data/Data by zipcode/population density.csv",header=T)
names(density) <- c("zipcode","demographics2")
demographics <- merge(age,density,by="zipcode",all=T)
zip.data <- merge(zip.data[,c(-5,-6)],demographics,by="zipcode",all.x=T)

