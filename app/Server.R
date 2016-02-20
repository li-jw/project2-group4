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
    output$education.m <- renderUI(education.f())
    education.f <- reactive({
      ifelse(is.null(input$cmetrics),return(""),
        ifelse(length(input$cmetrics)>1,
               return(list(
                          sliderInput("ap", "AP:", 0, 100, c(0,100)),
                          sliderInput("distance", "Distance metric:", 0, 100, c(0,100))
                      )
               ),
                ifelse(input$cmetrics=="AP", 
                       return(sliderInput("ap", "AP:", 0, 100, c(0,100))),
                       return(sliderInput("distance", "Distance metric:", 0, 100, c(0,100)))
                       
                )
          )
        )
    })
#     output$plot.education <- renderPlot({
#       s.variable=f.variable(input$variable)
#       data.zip.red[data.zip$price<input$d.price[1] | data.zip$price>input$d.price[2],s.variable] <- NA
#       data.zip.red[data.zip$rating<input$d.rating[1] | data.zip$rating>input$d.rating[2],s.variable] <- NA
#       data.zip.red[data.zip$schools<input$d.schools[1] | data.zip$schools>input$d.schools[2],s.variable] <- NA
#       data.plot <- data.frame(region=data.zip.red$ny.region, value=data.zip.red[,s.variable],stringsAsFactors = F)
#       zip_choropleth(data.plot, title = "Manhattan housing", legend = s.variable, county_zoom = c(36061,36005,36047,36081), reference_map = F)
#     })
     
    output$value <- renderText(length(input$cmetrics))
    output$plot1 <- renderPlot({
      # s.variable="price"
      s.variable=input$variable
#       data.zip.red[data.zip$price<10 | data.zip$price>80,s.variable] <- NA
#       data.zip.red[data.zip$rating<10 | data.zip$rating>80,s.variable] <- NA
#       data.zip.red[data.zip$schools<10 | data.zip$schools>80,s.variable] <- NA
#       data.plot <- data.frame(region=data.zip.red$ny.region, value=data.zip.red[,s.variable],stringsAsFactors = F)
      data.zip.red[data.zip$price<input$d.price[1] | data.zip$price>input$d.price[2],s.variable] <- NA
      data.zip.red[data.zip$rating<input$d.rating[1] | data.zip$rating>input$d.rating[2],s.variable] <- NA
      data.zip.red[data.zip$schools<input$d.schools[1] | data.zip$schools>input$d.schools[2],s.variable] <- NA
      data.plot <- data.frame(region=data.zip.red$ny.region, value=data.zip.red[,s.variable],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan housing", legend = s.variable, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan housing", legend = s.variable, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
  }
)