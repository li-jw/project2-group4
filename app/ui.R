library(shinydashboard)
library(shiny)
library(shinythemes)

shinyUI(
  dashboardPage(skin="yellow",
    dashboardHeader(title = "Find your home!"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Introduction", tabName = "introduction", icon = icon("hand-peace-o")),
        menuItem("Recommendation", tabName = "general", icon = icon("map")),
        menuItem("Education",tabName="education",icon=icon("book")),
        menuItem("Safety",tabName="safety",icon=icon("lock")),
        menuItem("Entertainment",tabName="entertainment",icon=icon("smile-o")),
        menuItem("Demographics",tabName="demographics",icon=icon("area-chart")),
        menuItem("Survey",tabName="survey",icon=icon("paper-plane"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName="introduction",
          h2("Describe the app")
        ),
        tabItem(tabName = "general",
                fluidPage(
                  titlePanel("General"),
                  sidebarPanel(
                    radioButtons("general.plot.var", label = h3("Choose the variable you want to visualize"), choices = list("education1"="education1","education2"="education2","Felonies"="safety1","Car accidents"="safety2", "Restaurant Ratings"="entertainment1", "entertainment2"="entertainment2", "Age"="demographics1","Density"="demographics2"), selected = "education1") 
                  ),
                  mainPanel(
                    h2("The following zipcodes are the most suitable for you:"),
                    tableOutput("recommedation.table"),
                    plotOutput("general.plot", height = 1000),
                    plotOutput("polygon",height=700)
                  )
                )
        ),
        tabItem(tabName = "education",
                fluidPage(
                  titlePanel("Education"),
                  sidebarPanel(
                    radioButtons("education.plot.var", label = h3("Choose the variable you want to visualize"), choices = list("education1"="education1","education2"="education2"), selected = "education1"), 
                    h2("Range"),
                    sliderInput("range.education1", "Education1:", 0, 100, c(0,100)),
                    sliderInput("range.education2", "Education2:", 0, 100, c(0,100)),
                    h2("Weights"),
                    h4("this weights are used for recommendation tab"),
                    sliderInput("weight.education1", "Education1:", 0, 5, 3),
                    sliderInput("weight.education2", "Education2:", 0, 5, 3),
                    selectInput("level", 
                                label = "Choose the education degree",
                                choices = c("Kindergarten", "Elementray",
                                            "Elementray+Junior", "Junior","High School","All Grades"),
                                selected = "Junior")
                    #textOutput("pruebas")
                  ),
                  mainPanel(
                    plotOutput("education.plot", height = 1000),
                    plotOutput("plot.education.google")
                  )
                )  
        ),
        tabItem(tabName = "safety",
                fluidPage(
                  titlePanel("Safety"),
                  sidebarPanel(
                    radioButtons("safety.plot.var", label = h3("Choose the variable you want to visualize"), choices = list("Felonies"="safety1","Car accidents"="safety2"), selected = "safety1"), 
                    h2("Range"),
                    sliderInput("range.safety1", "Felonies:", 0, 2700, c(0,2700)),
                    sliderInput("range.safety2", "Car accidents:", 0, 350, c(0,350)),
                    h2("Weights"),
                    h4("this weights are used for recommendation tab"),
                    sliderInput("weight.safety1", "Felonies:", 0, 5, 3),
                    sliderInput("weight.safety2", "Car accidents:", 0, 5, 3),
                    selectInput("var", 
                                label = "Choose a crime category to display",
                                choices = list("MURDER", "BURGLARY", "RAPE", "ROBBERY", "LARCENY of CAR"),
                                selected = "MURDER")
                  ),
                  mainPanel(
                    plotOutput("safety.plot", height = 1000),
                    imageOutput("map.safety.google", height=1000)
                  )
                )  
        ),
        tabItem(tabName = "entertainment",
                fluidPage(
                  titlePanel("Entertainment"),
                  sidebarPanel(
                    radioButtons("entertainment.plot.var", label = h3("Choose the variable you want to visualize"), choices = list("entertainment1"="entertainment1","entertainment2"="entertainment2"), selected = "entertainment1"), 
                    h2("Range"),
                    sliderInput("range.entertainment1", "entertainment1:", 0, 26, c(0,26)),
                    sliderInput("range.entertainment2", "entertainment2:", 0, 100, c(0,100)),
                    h2("Weights"),
                    h4("this weights are used for recommendation tab"),
                    sliderInput("weight.entertainment1", "entertainment1:", 0, 5, 3),
                    sliderInput("weight.entertainment2", "entertainment2:", 0, 5, 3)
                  ),
                  mainPanel(
                    plotOutput("entertainment.plot", height = 1000)
                    )
                )
        ),
        tabItem(tabName = "demographics",
                fluidPage(
                  titlePanel("Demographics"),
                  sidebarPanel(
                    radioButtons("demographics.plot.var", label = h3("Choose the variable you want to visualize"), choices = list("demographics1"="demographics1","demographics2"="demographics2"), selected = "demographics1"), 
                    h2("Range"),
                    sliderInput("range.demographics1", "Age:", 28, 52, c(28,52)),
                    sliderInput("range.demographics2", "Density:", 2600, 135000, c(2600,135000)),
                    h2("Weights"),
                    h4("this weights are used for recommendation tab"),
                    sliderInput("weight.demographics1", "Age:", 0, 5, 3),
                    sliderInput("weight.demographics2", "Density:", 0, 5, 3)
                  ),
                  mainPanel(
                    plotOutput("demographics.plot", height = 1000)
                  )
                )
        ),
        tabItem(tabName = "survey",
                h2("Survey")
        )
      )
    )
  )
)
