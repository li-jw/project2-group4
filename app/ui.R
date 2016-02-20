library(shinydashboard)

shinyUI(
  dashboardPage(skin="yellow",
    dashboardHeader(title = "Find your home!"),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Introduction", tabName = "introduction", icon = icon("hand-peace-o")),
        menuItem("Explore NYC", tabName = "explore", icon = icon("map")),
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
        tabItem(tabName = "education",
                fluidPage(
                  titlePanel("Education"),
                  sidebarPanel(
                    # checkboxGroupInput("cmetrics", label = h3("Metrics you care of:"), choices = list("Distance metric" = 1, "AP" = 2),selected = c(1,2)),
                    selectInput("cmetrics", label = h3("Metrics you care of:"),multiple=T, choices = list("Distance", "AP"),selected = c("Distance", "AP")),
                    h2(textOutput("value")),
                    uiOutput("education.m")
                    # conditionalPanel(condition="input.cmetrics.length==0", sliderInput("distance", "Distance Metric:", 0, 100, c(0,100))),
                    # sliderInput("ap", "AP:", 0, 100, c(0,100))
                  ),
                  mainPanel(h2("Education"))
                )  
        ),
        tabItem(tabName = "safety",
                h2("Safety")
        ),
        tabItem(tabName = "entertainment",
                h2("Entertainment")
        ),
        tabItem(tabName = "demographics",
                h2("Demographics")
        ),
        tabItem(tabName = "survey",
                h2("Survey")
        )
      )
    )
  )
)
