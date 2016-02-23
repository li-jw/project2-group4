library(choroplethrZip)
data(zip.regions)
ny <- subset(zip.regions,zip.regions$county.fips.numeric==36061)
ny.region <- ny$region
n <- length(ny.region)
values <- data.frame(array(runif(3*n,0,100),dim = c(n,3)))
names(values) <-  c("price","rating","schools")
data.zip <- data.frame(ny.region,values,stringsAsFactors = F)
f.variable <- function(x){switch(x,'1'="price",'2'="rating",'3'="schools")}


shinyServer(
  function(input,output){
    data.zip.red <- data.zip
    output$plot1 <- renderPlot({
      s.variable=f.variable(input$variable)
      data.zip.red[data.zip$price<input$d.price[1] | data.zip$price>input$d.price[2],s.variable] <- NA
      data.zip.red[data.zip$rating<input$d.rating[1] | data.zip$rating>input$d.rating[2],s.variable] <- NA
      data.zip.red[data.zip$schools<input$d.schools[1] | data.zip$schools>input$d.schools[2],s.variable] <- NA
      data.plot <- data.frame(region=data.zip.red$ny.region, value=data.zip.red[,s.variable],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan housing", legend = s.variable, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
  }
)