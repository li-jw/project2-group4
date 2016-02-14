library(shinydashboard)

shinyUI(
  dashboardPage(skin="yellow",
    dashboardHeader(title = "Find your home!"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Introduction", tabName = "introduction", icon = icon("hand-peace-o")),
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
                  h1("Find the most suitable home for you!"),
                  radioButtons("variable", label = h3("Choose the variable you want to visualize"), choices = list("Price" = 1, "Rating" = 2, "Schools" = 3), selected = 1),
                  fluidRow(
                    column(4,sliderInput("d.price", "Price:", 0, 100, c(0,100))),
                    column(4,sliderInput("d.rating", "Rating:", 0, 100, c(0,100))),
                    column(4,sliderInput("d.schools", "Number of schools:", 0, 100, c(0,100)))
                  ),
                  
                  plotOutput("plot1", height = 1000)
                  
#                   box(
#                     title = "Price",
#                     sliderInput("price", "Price range:", 0, 100, c(0,100))
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
