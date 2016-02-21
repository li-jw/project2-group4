library(shinydashboard)

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
                    radioButtons("general.plot.var", label = h3("Choose the variable you want to visualize"), choices = list("education1"="education1","education2"="education2","safety1"="safety1","safety2"="safety2"), selected = "education1") 
                  ),
                  mainPanel(
                    h2("The following zipcodes are the most suitable for you:"),
                    tableOutput("recommedation.table"),
                    plotOutput("general.plot", height = 1000)
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
                    h5("this weights are used for recommendation tab"),
                    sliderInput("weight.education1", "Education1:", 0, 5, 3),
                    sliderInput("weight.education2", "Education2:", 0, 5, 3)
                  ),
                  mainPanel(plotOutput("education.plot", height = 1000))
                )  
        ),
        tabItem(tabName = "safety",
                fluidPage(
                  titlePanel("safety"),
                  sidebarPanel(
                    radioButtons("safety.plot.var", label = h3("Choose the variable you want to visualize"), choices = list("safety1"="safety1","safety2"="safety2"), selected = "safety1"), 
                    h2("Range"),
                    sliderInput("range.safety1", "safety1:", 0, 100, c(0,100)),
                    sliderInput("range.safety2", "safety2:", 0, 100, c(0,100)),
                    h2("Weights"),
                    h5("this weights are used for recommendation tab"),
                    sliderInput("weight.safety1", "safety1:", 0, 5, 3),
                    sliderInput("weight.safety2", "safety2:", 0, 5, 3)
                  ),
                  mainPanel(plotOutput("safety.plot", height = 1000))
                )  
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
