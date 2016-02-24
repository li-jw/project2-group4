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
                    radioButtons("general.plot.var", label = h3("Choose the variable you want to visualize"), choices = list("education1"="education1","education2"="education2","Felonies"="safety1","Car accidents"="safety2"), selected = "education1") 
                  ),
                  mainPanel(
                    h2("The following zipcodes are the most suitable for you:"),
                    tableOutput("recommedation.table"),
                    plotOutput("general.plot", height = 1000),
                    plotOutput("polygon")
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
                    sliderInput("weight.education2", "Education2:", 0, 5, 3)
                    #textOutput("pruebas")
                  ),
                  mainPanel(plotOutput("education.plot", height = 1000))
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
                    sliderInput("weight.safety2", "Car accidents:", 0, 5, 3)
                  ),
                  mainPanel(plotOutput("safety.plot", height = 1000))
                )  
        ),
        tabItem(tabName = "entertainment",
                fluidPage(
                  titlePanel("Entertainment"),
                  sidebarPanel(
                    radioButtons("entertainment.plot.var", label = h3("Choose the variable you want to visualize"), choices = list("entertainment1"="entertainment1","entertainment2"="entertainment2"), selected = "entertainment1"), 
                    h2("Range"),
                    sliderInput("range.entertainment1", "entertainment1:", 0, 26, c(0,100)),
                    sliderInput("range.entertainment2", "entertainment2:", 0, 100, c(0,100)),
                    h2("Weights"),
                    h4("this weights are used for recommendation tab"),
                    sliderInput("weight.entertainment1", "entertainment1:", 0, 5, 3),
                    sliderInput("weight.entertainment2", "entertainment2:", 0, 5, 3)
                  ),
                  mainPanel(plotOutput("entertainment.plot", height = 1000))
                )
        ),
        tabItem(tabName = "demographics",
                h2("Demographics"),
                selectInput("level", 
                            label = "Choose the education degree",
                            choices = c("Kindergarten", "Elementray",
                                        "Elementray+Junior", "Junior","High School","All Grades"),
                            selected = "Junior"),
                plotOutput("var2"),
                textOutput("prueba3")
        ),
        tabItem(tabName = "survey",
                h2("Survey")
        )
      )
    )
  )
)
