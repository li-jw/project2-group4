shinyUI(fluidPage(
  titlePanel("Find a Home in New York City"),
  
  sidebarLayout(
    sidebarPanel(
      h3("Safety Level in New York City"),
      
      selectInput("var", 
                  label = "Choose a crime category to display",
                  choices = list("MURDER", "BURGLARY", "RAPE", "ROBBERY", "LARCENY of CAR"),
                  selected = "MURDER")
      ),
    
    mainPanel(
      imageOutput("map")
    )
  )
))