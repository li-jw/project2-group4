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
    output$pruebas <- renderText(input$range.education1)
    output$pruebas2 <- renderText(length(input$include.metrics.education))
    # REACTIVE SIDEBARS
    # _________________________________________________________________________________________________________________
    # _________________________________________________________________________________________________________________
    
    output$general.m <- renderUI(general.f())
    general.f <- reactive({
      general.choice.list <- as.list(input$include.metrics.education)
      names(general.choice.list) <- input$include.metrics.education
      ifelse(is.null(input$include.metrics.education),return("So you don't care about anything? Hmmmmm, we can choose a random ZIP code for you!"),
             return(list(
                    radioButtons("general.plot.var", label = h3("Choose the variable you want to visualize"), choices = general.choice.list, selected = general.choice.list[1]), 
                    textOutput("pruebas2")
                    )
              )
      )
    })
    
    output$education.m <- renderUI(education.f())
    education.f <- reactive({
      education.choice.list <- as.list(input$include.metrics.education)
      names(education.choice.list) <- input$include.metrics.education
      ifelse(is.null(input$include.metrics.education),return("So you don't care about Education? Okaaaay o_O, well then go to the next tab"),
             return(list(
               radioButtons("education.plot.var", label = h3("Choose the variable you want to visualize"), choices = education.choice.list, selected = education.choice.list[1]), 
               textOutput("pruebas2")
             )
             )
      )
    })
     
    # RENDER PLOTS
    # _________________________________________________________________________________________________________________
    # _________________________________________________________________________________________________________________
    
#     output$general.plot <- renderPlot({
#       # general.plot.var.selected="price"
#       general.plot.var.selected=input$general.plot.var
# #       data.zip.red[data.zip$price<10 | data.zip$price>80,general.plot.var.selected] <- NA
# #       data.zip.red[data.zip$rating<10 | data.zip$rating>80,general.plot.var.selected] <- NA
# #       data.zip.red[data.zip$schools<10 | data.zip$schools>80,general.plot.var.selected] <- NA
# #       data.plot <- data.frame(region=data.zip.red$ny.region, value=data.zip.red[,general.plot.var.selected],stringsAsFactors = F)
#       data.zip.red[data.zip$price<input$range.price[1] | data.zip$price>input$range.price[2],general.plot.var.selected] <- NA
#       data.zip.red[data.zip$rating<input$range.rating[1] | data.zip$rating>input$range.rating[2],general.plot.var.selected] <- NA
#       data.zip.red[data.zip$schools<input$range.schools[1] | data.zip$schools>input$range.schools[2],general.plot.var.selected] <- NA
#       data.plot <- data.frame(region=data.zip.red$ny.region, value=data.zip.red[,general.plot.var.selected],stringsAsFactors = F)
#       zip_choropleth(data.plot, title = "Manhattan housing", legend = general.plot.var.selected, county_zoom = c(36061), reference_map = F)
#       #  zip_choropleth(data.plot, title = "Manhattan housing", legend = general.plot.var.selected, county_zoom = c(36061,36005,36047,36081), reference_map = F)
#     })
    output$general.plot <- renderPlot({
      # general.plot.var.selected="price"
      general.plot.var.selected=input$general.plot.var
      zip.data.red[zip.data$education1 < input$range.education1[1] | zip.data$education1 > input$range.education1[2],education.plot.var.selected] <- NA
      zip.data.red[zip.data$education2 < input$range.education2[1] | zip.data$education2 > input$range.education2[2],education.plot.var.selected] <- NA
      data.plot <- data.frame(region=zip.data.red$ny.region, value=zip.data.red[,general.plot.var.selected],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan Education", legend = general.plot.var.selected, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan housing", legend = education.plot.var.selected, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
    output$education.plot <- renderPlot({
      if (!is.null(input$include.metrics.education)){
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
      }
    })
  }
)