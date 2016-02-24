library(shiny); library(ggmap); library(dplyr);library(data.table)
load("data/felony.RDS") 
mapgilbert <- get_map(location = c(lon = mean(felony$latitude),lat = mean(felony$longitude)),zoom = 12,
                      maptype = "roadmap", scale = 2)
plotFelony <- function(df, mapgilbert) {
  ggmap(mapgilbert) +
    geom_point(data = df, aes(y = longitude, x = latitude, fill = "red", alpha=1.5), size = 1.5, shape = 21) +
    guides(fill=FALSE, alpha=FALSE, size=FALSE)
}

shinyServer(function(input, output) {
  
  output$map <- renderPlot({
    data <- switch(input$var, 
                   "MURDER" = filter(felony, Offense=="MURDER"),
                   "ROBBERY" = filter(felony, Offense=="ROBBERY"),
                   "RAPE" = filter(felony, Offense=="RAPE"),
                   "BURGLARY" = filter(felony, Offense=="BURGLARY"),
                   "LARCENY of CAR" = filter(felony, Offense=="GRAND LARCENY OF MOTOR VEHICLE"))
    
    plotFelony(data, mapgilbert)
  })
}
)