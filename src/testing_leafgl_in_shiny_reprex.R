library(leaflet)
library(leafgl)
library(sf)
library(shiny)



ui <- fluidPage(
  leafglOutput("mymap")
)

server <- function(input, output, session) {
  
  n = 1e6
  
  df1 = data.frame(id = 1:n,
                   x = rnorm(n, 10, 3),
                   y = rnorm(n, 49, 1.8))
  
  pts = st_as_sf(df1, coords = c("x", "y"), crs = 4326)
  
  #options(viewer = NULL) # view in browser
  
  m = leaflet() %>%
    addProviderTiles(provider = providers$CartoDB.DarkMatter) %>%
    addGlPoints(data = pts, group = "pts") %>%
    setView(lng = 10.5, lat = 49.5, zoom = 4) %>% 
    addLayersControl(overlayGroups = "pts")
  
  output$mymap <- renderLeaflet(m)
}

shinyApp(ui, server)
