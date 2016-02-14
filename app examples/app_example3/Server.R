library(choroplethrZip)
data(zip.regions)
ny <- subset(zip.regions,zip.regions$county.fips.numeric==36061)
ny.region <- ny$region
data.zip <- data.frame(region=ny.region,value=rnorm(length(ny.region),0,1),stringsAsFactors = F)

shinyServer(
  function(input,output){
    set.seed(122)
    histdata <- rnorm(500)
    
    output$plot1 <- renderPlot({
      zip_choropleth(data.zip, title = "2009 Manhattan housing sales", legend = "Number of sales", county_zoom = 36061, reference_map = T)
    })
    output$range <- renderText(paste0(input$price[1]))
    
  }
)