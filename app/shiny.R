library(choroplethrZip)
library(shiny)
library(shinythemes)
library(shinydashboard)

load(file="zip.data.RData")

min.observations <- apply(zip.data[,-1],2,FUN = min)
max.observations <- apply(zip.data[,-1],2,FUN = max)

shinyServer(
  function(input,output){
    output$pruebas <- renderText(input$range.education1)
    output$pruebas2 <- renderText(length(input$include.metrics.education))
    output$include.metrics.education <- renderText(length(input$include.metrics.education))
    filters <- reactive({
#       filtered.education1 <<- zip.data$education1 > 20 & zip.data$education1 < 80
#       filtered.education2 <<- zip.data$education2 > 20 & zip.data$education2 < 80
      
      filtered.education1 <<- zip.data$education1 > input$range.education1[1] & zip.data$education1 < input$range.education1[2]
      filtered.education2 <<- zip.data$education2 > input$range.education2[1] & zip.data$education2 < input$range.education2[2]
      filtered.education <<- filtered.education1 & filtered.education2
      filtered.education[is.na(filtered.education)] <- FALSE
      filtered.safety1 <<- zip.data$safety1 > input$range.safety1[1] & zip.data$safety1 < input$range.safety1[2]
      filtered.safety2 <<- zip.data$safety2 > input$range.safety2[1] & zip.data$safety2 < input$range.safety2[2]
      filtered.safety <<- filtered.safety1 & filtered.safety2
      filtered.safety[is.na(filtered.safety)] <- FALSE
      
#       filtered.entertainment1 <<- zip.data$entertainment1 > 10 & zip.data$entertainment1 < 80
#       filtered.entertainment2 <<- zip.data$entertainment2 > 10 & zip.data$entertainment2 < 80
      
      filtered.entertainment1 <<- zip.data$entertainment1 > input$range.entertainment1[1] & zip.data$entertainment1 < input$range.entertainment1[2]
      filtered.entertainment2 <<- zip.data$entertainment2 > input$range.entertainment2[1] & zip.data$entertainment2 < input$range.entertainment2[2]
      filtered.entertainment <<- filtered.entertainment1 & filtered.entertainment2
      filtered.entertainment[is.na(filtered.entertainment)] <- FALSE
      filtered.general <<- filtered.education & filtered.safety & filtered.entertainment
    })
    output$recommedation.table <- renderTable({
       filters()
       zip.data.scale <- zip.data
       zip.data.scale[,2:ncol(zip.data)] <- scale(zip.data[,2:ncol(zip.data)])
       zip.data.red <- zip.data.scale[filtered.general,]
       zip.data.red$score <- with(zip.data.red,education1*input$weight.education1+education2*input$weight.education2+safety1*input$weight.safety1+safety2*input$weight.safety2)
       zip.data.red <- zip.data.red[order(zip.data.red$score,decreasing=T),]
       return(zip.data.red[1:10,c("zipcode","score","education1","education2","safety1","safety2")])
    })
    
#     # REACTIVE SIDEBARS
#     # _________________________________________________________________________________________________________________
#     # _________________________________________________________________________________________________________________
#     
#     output$general.m <- renderUI(general.f())
#     general.f <- reactive({
#       general.choice.list <- as.list(c(input$include.metrics.education,input$include.metrics.safety))
#       names(general.choice.list) <- c(input$include.metrics.education,input$include.metrics.safety)
#       ifelse(is.null(input$include.metrics.education),return("So you don't care about anything? Hmmmmm, we can choose a random ZIP code for you!"),
#              return(list(
#                     radioButtons("general.plot.var", label = h3("Choose the variable you want to visualize"), choices = general.choice.list, selected = general.choice.list[1]), 
#                     textOutput("pruebas2")
#                     )
#               )
#       )
#     })

     
    # RENDER PLOTS
    # _________________________________________________________________________________________________________________
    # _________________________________________________________________________________________________________________

    output$general.plot <- renderPlot({
      filters()
#       data.plot <- data.frame(region=zip.data$zipcode[filtered.general], value=zip.data[filtered.general,"entertainment1"],stringsAsFactors = F)
#       zip_choropleth(data.plot, title = "Manhattan", legend = "entertainment1", county_zoom = c(36061), reference_map = F)
      data.plot <- data.frame(region=zip.data$zipcode[filtered.general], value=zip.data[filtered.general,input$general.plot.var],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan", legend = input$general.plot.var, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan", legend = input$education.plot.var, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
    output$education.plot <- renderPlot({
      filters()
#       data.plot <- data.frame(region=zip.data$zipcode[filtered.education], value=zip.data[filtered.education,"education1"],stringsAsFactors = F)
#       zip_choropleth(data.plot, title = "Manhattan education", legend = "education1", county_zoom = c(36061), reference_map = F)
      data.plot <- data.frame(region=zip.data$zipcode[filtered.education], value=zip.data[filtered.education,input$education.plot.var],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan education", legend = input$education.plot.var, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan education", legend = input$education.plot.var, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
    output$safety.plot <- renderPlot({
      filters()
      data.plot <- data.frame(region=zip.data$zipcode[filtered.safety], value=zip.data[filtered.safety,input$safety.plot.var],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan safety", legend = input$safety.plot.var, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan safety", legend = input$safety.plot.var, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
    output$entertainment.plot <- renderPlot({
      filters()
#       data.plot <- data.frame(region=zip.data$zipcode[filtered.entertainment], value=zip.data[filtered.entertainment,"entertainment1"],stringsAsFactors = F)
#       zip_choropleth(data.plot, title = "Manhattan entertainment", legend = "entertainment1", county_zoom = c(36061), reference_map = F)
      data.plot <- data.frame(region=zip.data$zipcode[filtered.entertainment], value=zip.data[filtered.entertainment,input$entertainment.plot.var],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan entertainment", legend = input$entertainment.plot.var, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan entertainment", legend = input$entertainment.plot.var, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
    
  }
)