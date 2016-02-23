setwd("~/Desktop/ADS/proj 2")
education<-read.csv(file="DOE_High_School_Directory_2016.csv",header = T)
ranking<-function(n){
  manhattan<-subset(education,education$boro=="Manhattan")
  sort<-manhattan[manhattan$APC>=n,]
  group<-tapply(sort$zip,sort$zip,length)
  gis<-data.frame(zip=row.names(group),count=as.vector(group))
  return(gis)
}