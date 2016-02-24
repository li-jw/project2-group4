devtools::install_github("rstudio/shiny")
# devtools::install_github("hadley/devtools")
devtools::install_github('rstudio/rsconnect')
library(rsconnect)
library(shiny)
library(shinythemes)
library(shinydashboard)
library(choroplethrZip)
library(ggmap)

setwd("/Users/JPC/Documents/Columbia/2nd Semester/1. Applied Data Science/2. Homeworks/Project 2")

runApp("project2-group4/app")



runApp("healthrank")


# launch app

shinyapps::deployApp(appName="/Users/JPC/Documents/Columbia/2nd Semester/1. Applied Data Science/2. Homeworks/Project 2/project2-group4/app")
rsconnect::deployApp(appName="/Users/JPC/Documents/Columbia/2nd Semester/1. Applied Data Science/2. Homeworks/Project 2/project2-group4/app")
