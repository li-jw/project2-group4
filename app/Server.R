library(choroplethrZip)
data(zip.regions)
ny <- subset(zip.regions,zip.regions$county.fips.numeric %in% c(36061))
# ny <- subset(zip.regions,zip.regions$county.fips.numeric %in% c(36061,36005,36047,36081))
ny.region <- ny$region
n <- length(ny.region)
zip.data <- data.frame(array(runif(4*2*n,0,100),dim = c(n,4*2)))
names(zip.data) <-  c("education1","education2","safety1","safety2","entertainment1","entertainment2","demographics1","demographics2")
zip.data <- data.frame(ny.region,zip.data,stringsAsFactors = F)

values <- data.frame(array(runif(3*n,0,100),dim = c(n,3)))
names(values) <- c("price","rating","schools")
data.zip <- data.frame(ny.region,values,stringsAsFactors = F)

f.variable <- function(x){switch(x,'1'="price",'2'="rating",'3'="schools")}


shinyServer(
  function(input,output){
    data.zip.red <- data.zip
    zip.data.red <- zip.data
    output$education.m <- renderUI(education.f())
    education.f <- reactive({
      ifelse(is.null(input$cmetrics),return(""),
        ifelse(length(input$cmetrics)>1,
               return(list(
                          sliderInput("range.education1", "AP:", 0, 100, c(0,100)),
                          sliderInput("range.education2", "Distance metric:", 0, 100, c(0,100)),
                          radioButtons("education.plot.var", label = h3("Choose the variable you want to visualize"), choices = list("Distance" = "education1", "AP" = "education2"), selected = "education1")
                      )
               ),
                ifelse(input$cmetrics=="AP", 
                       return(sliderInput("ranage.education1", "AP:", 0, 100, c(0,100))),
                       return(sliderInput("range.education2", "Distance metric:", 0, 100, c(0,100)))
                       
                )
          )
        )
    })
#     output$plot.education <- renderPlot({
     
    output$value <- renderText(length(input$cmetrics))
    output$general.plot <- renderPlot({
      # general.plot.var.selected="price"
      general.plot.var.selected=input$general.plot.var
#       data.zip.red[data.zip$price<10 | data.zip$price>80,general.plot.var.selected] <- NA
#       data.zip.red[data.zip$rating<10 | data.zip$rating>80,general.plot.var.selected] <- NA
#       data.zip.red[data.zip$schools<10 | data.zip$schools>80,general.plot.var.selected] <- NA
#       data.plot <- data.frame(region=data.zip.red$ny.region, value=data.zip.red[,general.plot.var.selected],stringsAsFactors = F)
      data.zip.red[data.zip$price<input$range.price[1] | data.zip$price>input$range.price[2],general.plot.var.selected] <- NA
      data.zip.red[data.zip$rating<input$range.rating[1] | data.zip$rating>input$range.rating[2],general.plot.var.selected] <- NA
      data.zip.red[data.zip$schools<input$range.schools[1] | data.zip$schools>input$range.schools[2],general.plot.var.selected] <- NA
      data.plot <- data.frame(region=data.zip.red$ny.region, value=data.zip.red[,general.plot.var.selected],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan housing", legend = general.plot.var.selected, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan housing", legend = general.plot.var.selected, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
    output$education.plot <- renderPlot({
      #       education.plot.var.selected="education1"
      education.plot.var.selected=input$education.plot.var
#       zip.data.red[zip.data$education1 < 20 | zip.data$education1 > 80,education.plot.var.selected] <- NA
#       zip.data.red[zip.data$education2 < 20 | zip.data$education2 > 80,education.plot.var.selected] <- NA
      
      #       data.plot <- data.frame(region=zip.data.red$ny.region, value=zip.data.red[,education.plot.var.selected],stringsAsFactors = F)
      zip.data.red[zip.data$education1 < input$range.education1[1] | zip.data$education1 > input$range.education1[2],education.plot.var.selected] <- NA
      zip.data.red[zip.data$education2 < input$range.education2[1] | zip.data$education2 > input$range.education2[2],education.plot.var.selected] <- NA
      data.plot <- data.frame(region=zip.data.red$ny.region, value=zip.data.red[,education.plot.var.selected],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan Education", legend = education.plot.var.selected, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan housing", legend = education.plot.var.selected, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
  }
)