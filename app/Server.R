library(choroplethrZip)
library(shiny)
library(shinythemes)
library(shinydashboard)
library(ggmap)
library(ggplot2)
library("fmsb")
#    load(file="project2-group4/app/zip.data.RData")
load(file="zip.data.RData")
dataadd <- read.csv("all school.csv",header=T)

min.observations <- apply(zip.data[,-1],2,FUN = min)
max.observations <- apply(zip.data[,-1],2,FUN = max)

shinyServer(
  function(input,output){
    output$var2<-renderPlot({
     level<-subset(dataadd,dataadd$Category==input$level)
      longlat<-level[,c(3,2)]
      map <- get_map(location = "Manhattan", zoom=12)
      ggmap(map) +
        geom_point(data =longlat, aes(y = Latitude, x = Longitude,fill = "red", alpha=1.5), size = 1.5, shape = 21,inherit.aes = FALSE) +
        guides(fill=FALSE, alpha=FALSE, size=FALSE)
    })
    
    output$prueba3 <- renderText(input$level)
    output$pruebas <- renderText(input[["range.education1"]][1])
    output$pruebas2 <- renderText(length(input$include.metrics.education))
    output$include.metrics.education <- renderText(length(input$include.metrics.education))
    filters <- reactive({
      zip.data.filters <<- zip.data
      variables <- names(zip.data)[-1]
      for (i in variables[1:6]){
        zip.data.filters[,i] <<- zip.data[i] > input[[paste0("range.",i)]][1] & zip.data[i] < input[[paste0("range.",i)]][2]
      }
#       for (i in variables[1:6]){
#         zip.data.filters[,i] <- zip.data[i] > 5 & zip.data[i] < 90
#       }
      zip.data.filters$education <<- zip.data.filters$education1 &zip.data.filters$education2
      zip.data.filters$safety <<- zip.data.filters$safety1 &zip.data.filters$safety2
      zip.data.filters$entertainment <<- zip.data.filters$entertainment1 &zip.data.filters$entertainment2
      zip.data.filters$general <<- zip.data.filters$education& zip.data.filters$safety & zip.data.filters$entertainment
      
#       filtered.education1 <<- zip.data$education1 > input$range.education1[1] & zip.data$education1 < input$range.education1[2]
#       filtered.education2 <<- zip.data$education2 > input$range.education2[1] & zip.data$education2 < input$range.education2[2]
#       filtered.education <<- filtered.education1 & filtered.education2
# #       filtered.education.zp <- filtered.education
# #       filtered.education.zp[is.na(filtered.education)] <- FALSE
#       
#       filtered.safety1 <<- zip.data$safety1 > input$range.safety1[1] & zip.data$safety1 < input$range.safety1[2]
#       filtered.safety2 <<- zip.data$safety2 > input$range.safety2[1] & zip.data$safety2 < input$range.safety2[2]
#       filtered.safety <<- filtered.safety1 & filtered.safety2
# #       filtered.safety.zp <- filtered.safety
# #       filtered.safety.zp[is.na(filtered.safety)] <- FALSE
# 
#       
# #       filtered.entertainment1 <<- zip.data$entertainment1 > 10 & zip.data$entertainment1 < 80
# #       filtered.entertainment2 <<- zip.data$entertainment2 > 10 & zip.data$entertainment2 < 80
#       
#       filtered.entertainment1 <<- zip.data$entertainment1 > input$range.entertainment1[1] & zip.data$entertainment1 < input$range.entertainment1[2]
#       filtered.entertainment2 <<- zip.data$entertainment2 > input$range.entertainment2[1] & zip.data$entertainment2 < input$range.entertainment2[2]
#       filtered.entertainment <<- filtered.entertainment1 & filtered.entertainment2
#       
#       filtered.general <<- filtered.education & filtered.safety & filtered.entertainment
# #       filtered.general.zp <- filtered.general
# #       filtered.general.zp[is.na(filtered.general)] <- FALSE
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
    output$polygon <- renderPlot({

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
      filter.general <- zip.data.filters$general 
      revert.NA <-is.na(zip.data.filters$general) & zip.data.filters[[input$general.plot.var]]
      revert.NA <- !is.na(revert.NA) & revert.NA
      filter.general[revert.NA]<- TRUE
      filter.general <- filter.general[!is.na(filter.general)]
#       data.plot <- data.frame(region=zip.data$zipcode[filtered.general], value=zip.data[filtered.general,"entertainment1"],stringsAsFactors = F)
#       zip_choropleth(data.plot, title = "Manhattan", legend = "entertainment1", county_zoom = c(36061), reference_map = F)
      data.plot <- data.frame(region=zip.data$zipcode[filter.general], value=zip.data[filter.general,input$general.plot.var],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan", legend = input$general.plot.var, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan", legend = input$education.plot.var, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
    output$education.plot <- renderPlot({
      filters()
      filter.education <- zip.data.filters$education 
      revert.NA <-is.na(zip.data.filters$education) & zip.data.filters[[input$education.plot.var]]
      revert.NA <- !is.na(revert.NA) & revert.NA
      filter.education[revert.NA]<- TRUE
      filter.education <- filter.education[!is.na(filter.education)]
#       data.plot <- data.frame(region=zip.data$zipcode[filtered.education], value=zip.data[filtered.education,"education1"],stringsAsFactors = F)
#       zip_choropleth(data.plot, title = "Manhattan education", legend = "education1", county_zoom = c(36061), reference_map = F)
      data.plot <- data.frame(region=zip.data$zipcode[filter.education], value=zip.data[filter.education,input$education.plot.var],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan education", legend = input$education.plot.var, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan education", legend = input$education.plot.var, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
    output$safety.plot <- renderPlot({
      filters()
      filter.safety <- zip.data.filters$safety 
      revert.NA <-is.na(zip.data.filters$safety) & zip.data.filters[[input$safety.plot.var]]
      revert.NA <- !is.na(revert.NA) & revert.NA
      filter.safety[revert.NA]<- TRUE
      filter.safety <- filter.safety[!is.na(filter.safety)]
      data.plot <- data.frame(region=zip.data$zipcode[filter.safety], value=zip.data[filter.safety,input$safety.plot.var],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan safety", legend = input$safety.plot.var, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan safety", legend = input$safety.plot.var, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
    output$entertainment.plot <- renderPlot({
      filters()
      filter.entertainment <- zip.data.filters$entertainment 
      revert.NA <-is.na(zip.data.filters$entertainment) & zip.data.filters[[input$entertainment.plot.var]]
      revert.NA <- !is.na(revert.NA) & revert.NA
      filter.entertainment[revert.NA]<- TRUE
      filter.entertainment <- filter.entertainment[!is.na(filter.entertainment)]
#     data.plot <- data.frame(region=zip.data$zipcode[filtered.entertainment1], value=zip.data[filtered.entertainment,"entertainment1"],stringsAsFactors = F)
#     zip_choropleth(data.plot, title = "Manhattan entertainment", legend = "entertainment1", county_zoom = c(36061), reference_map = F)
      data.plot <- data.frame(region=zip.data$zipcode[filter.entertainment], value=zip.data[filter.entertainment,input$entertainment.plot.var],stringsAsFactors = F)
      zip_choropleth(data.plot, title = "Manhattan entertainment", legend = input$entertainment.plot.var, county_zoom = c(36061), reference_map = F)
      #  zip_choropleth(data.plot, title = "Manhattan entertainment", legend = input$entertainment.plot.var, county_zoom = c(36061,36005,36047,36081), reference_map = F)
    })
    
  }
)