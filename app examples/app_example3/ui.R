library(shinydashboard)

shinyUI(
  dashboardPage(skin="yellow",
    dashboardHeader(title = "Restaurants"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Introduction", tabName = "introduction", icon = icon("hand-peace")),
        menuItem("Explore NYC", tabName = "explore", icon = icon("map")),
        menuItem("Survey",tabName="survey",icon=icon("paper-plane"))
      )
    ),
    dashboardBody(
      tabItems(
        tabItem(
          tabName="introduction",
          h2("Describe the app")
        ),
        tabItem(tabName = "explore",
                fluidPage(center=T,
                  h1("this is the title"),
                  sliderInput("price", "Number of observations:", 1, 100, c(0,100)),
                  plotOutput("plot1", height = 1000),
                  textOutput("range")
                  
#                   box(
#                     title = "Price",
#                     sliderInput("price", "Number of observations:", 1, 100, c(0,100))
#                   )
                )
        ),
        tabItem(tabName = "survey",
                h2("display survey")
        )
      )
    )
  )
)
