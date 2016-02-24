library(choroplethrZip)
library(shiny)
library(shinythemes)
library(shinydashboard)
library(ggmap)
library(ggplot2)
library("fmsb")

revert.NA2 <- function(x) {
  if (is.na(x[length(x)])){
    boolean.false <- sum(which(x==FALSE))>=1
    if (!boolean.false & sum(which(x==TRUE))>=1) return(TRUE) else return(FALSE)
  } else return(FALSE)
} 
radar_chart <- function(dataset){
  
  name <- names(dataset)
  n <- length(name) - 1
  zip <- subset(dataset, select = name[1])
  VarToPlot <- name[order(dataset[1,2:(n+1)], decreasing = T)[1:5]+1]
  variables <- subset(dataset, select = VarToPlot)
  
  maxmin <- data.frame(
    v1 = c(max(variables[,1]), min(variables[,1])),
    v2 = c(max(variables[,2]), min(variables[,2])),
    v3 = c(max(variables[,3]), min(variables[,3])),
    v4 = c(max(variables[,4]), min(variables[,4])),
    v5 = c(max(variables[,5]), min(variables[,5])))
  
  top3 <- c(1,2,3)
  dat <- data.frame(
    v1 = variables[top3, 1],
    v2 = variables[top3, 2],
    v3 = variables[top3, 3],
    v4 = variables[top3, 4],
    v5 = variables[top3, 5])
  dat <- rbind(maxmin,dat)
  colnames(dat) <- VarToPlot
  
  radarchart(dat, axistype = 0, pcol = c(2,3,4), plty = 1, plwd = 4)
  legend(-2.5, -0.3, legend = as.character(zip[1:3,]), lty = 1, lwd = 4, col = c(2,3,4), cex = 0.6)
}

#    load(file="project2-group4/app/zip.data.RData")
load(file="zip.data.RData")
dataadd <- read.csv("all school.csv",header=T)

min.observations <- apply(zip.data[,-1],2,FUN = min)
max.observations <- apply(zip.data[,-1],2,FUN = max)

shinyServer(
  function(input,output){
    
    output$prueba3 <- renderText(input$level)
    output$pruebas <- renderText(input[["range.education1"]][1])
    output$pruebas2 <- renderText(length(input$include.metrics.education))
    output$include.metrics.education <- renderText(length(input$include.metrics.education))
    
    output$recommedation.table <- renderTable({
      filters()
      zip.data.scale <- zip.data
      zip.data.scale[,2:ncol(zip.data)] <- scale(zip.data[,2:ncol(zip.data)])
      filter.general.table <- zip.data.filters$general
      revert.NA <- apply(zip.data.filters,1,revert.NA2)
      filter.general.table[revert.NA] <- TRUE
      zip.data.red <- zip.data.scale[filter.general.table,]
      zip.data.red$score <- with(zip.data.red,education1*input$weight.education1+education2*input$weight.education2+safety1*input$weight.safety1+safety2*input$weight.safety2)
      zip.data.red <- zip.data.red[order(zip.data.red$score,decreasing=T),]
      zip.data.red <<- zip.data.red
      return(zip.data.red[1:10,c("zipcode","score","education1","education2","safety1","safety2")])
    })

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

    })
    
    output$polygon <- renderPlot({
      radar_chart(zip.data.red)
    })
    output$var2<-renderPlot({
      level<-subset(dataadd,dataadd$Category==input$level)
      longlat<-level[,c(3,2)]
      map <- get_map(location = "Manhattan", zoom=12)
      ggmap(map) +
        geom_point(data =longlat, aes(y = Latitude, x = Longitude,fill = "red", alpha=1.5), size = 1.5, shape = 21,inherit.aes = FALSE) +
        guides(fill=FALSE, alpha=FALSE, size=FALSE)
    })

    # RENDER PLOTS ZIP PLOTs
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