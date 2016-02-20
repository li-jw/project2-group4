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
                fluidPage(
                  titlePanel("General"),
                  sidebarPanel(
                    uiOutput("general.m")
                  ),
                  mainPanel(plotOutput("general.plot", height = 1000))
                )
        ),
        tabItem(tabName = "education",
                fluidPage(
                  titlePanel("Education"),
                  sidebarPanel(
                    # checkboxGroupInput("include.metrics.education", label = h3("Metrics you care of:"), choices = list("Distance metric" = 1, "AP" = 2),selected = c(1,2)),
                    selectInput("include.metrics.education", label = h3("Metrics you care of:"),multiple=T, choices = list("education1", "education2"),selected = c("education1", "education2")),
                    h2(textOutput("value")),
                    uiOutput("education.m")
                    # conditionalPanel(condition="input.include.metrics.education.length==0", sliderInput("distance", "Distance Metric:", 0, 100, c(0,100))),
                    # sliderInput("ap", "AP:", 0, 100, c(0,100))
                  ),
                  mainPanel(plotOutput("education.plot", height = 1000))
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
