library("shiny")

# Required CRAN libraries other than shiny
library(dplyr)
library(DT)
library(FLightR)
library(ggplot2)
library(leaflet)
library(lubridate)
library(scales)
library(shinycssloaders)

# Required GitHub library
# devtools::install_github("SLisovski/GeoLight")

library(GeoLight)

# to display messages to the user in the log file of the App in MoveApps
# one can use the function from the src/common/logger.R file:
# logger.fatal(), logger.error(), logger.warn(), logger.info(), logger.debug(), logger.trace()

########
#Bring in functions to make the main app work.
#These are the pager for the editing plot 
#and the adapted twilight calculation function from GeoLight.
source("global.R")

########
#Define UI for application
#This is where you lay out page design and specify buttons, etc.


shinyModuleUserInterface <- function(id, label) {
  # all IDs of UI functions need to be wrapped in ns()
  ns <- NS(id)
  # showcase to access a file ('auxiliary files') that is 
  # a) provided by the app-developer and 
  # b) can be overridden by the workflow user.
  fileName <- getAuxiliaryFilePath("auxiliary-file-a")
 
   tagList(
     titlePanel(
       "Totally Awesome Geolocator Service",
       windowTitle = "TAGS"),
     # img(src = "images/TAGS_logo.png"),
     # #TAGS logo placed here
     sidebarLayout(
       sidebarPanel(
         
         h3("Step 1. Select your file"),
         p("File upload limit of 30 mb; please run the app on your own machine if you have larger datasets."),
         tags$a(href="https://github.com/baeolophus/TAGS_shiny_version",
                "Get the TAGS app code here."),
         br(),
         tags$a(href="mailto: cmcurry@ou.edu",
                "Contact Claire M. Curry with any questions."),
         br(),
         radioButtons("filetype", 
                      label = "Select your filetype before browsing for your file",
                      choices = list(".csv (generic data)",
                                     ".lig",
                                     ".lux"
                      ),
                      selected = ".csv (generic data)"),
         br(),
         radioButtons("dateformat", 
                      label = "Select your date format before browsing for your file",
                      choices = list("d/m/y H:M:S",
                                     "Y/m/d H:M:S"
                      ),
                      selected = "d/m/y H:M:S"),
         
         fileInput("filename",
                   label = "Browse for your file",
                   accept = c("text/csv",
                              "text/comma-separated-values,text/plain",
                              ".csv",
                              ".lig",
                              ".lux")
         ),
         br(), #linebreak
         h3("Step 2. Calibration period information"),
         numericInput("calib_lon", 
                      h4("Calibration longitude"), 
                      value = 0, #default value
                      step = 0.00001), #"steps" with arrow buttons.
         numericInput("calib_lat", 
                      h4("Calibration latitude"), 
                      value = 0,
                      step = 0.00001),
         dateInput("start_calib_date", 
                   h4("Calibration start date"), 
                   value = NULL),
         dateInput("stop_calib_date", 
                   h4("Calibration stop date"), 
                   value = NULL),
         #Enter a value for sun angle. 
         #Or, this is also where calculated value appears if you press actionButton "calculate"
         numericInput("sunangle", "Sun angle", value = 0),
         actionButton("calculate", "Calculate sun angle from data"),
         br(),
         h3("Step 3. Light threshold entry"),
         p("Be sure to enter a value within the range of your data. For example, if the values of light in your dataset range from 40 to 200, you will need to increase the light threshold to a value between 40 and 200"),
         #Enter a value for light threshold to calculate sunrise/sunset.
         numericInput("light_threshold", 
                      h4("Light threshold"), 
                      value = 5.5,
                      step = 0.1),
         br(),
         h3("Step 4. Optional: change value for finding problem areas"),
         #Enter a value for length of time between twilights to count as a potential problem.
         p("This is the difference in twilight times in hours that will highlight a twilight as a potential problem in red."),
         p("Five hours is usually suitable, but you can experiment if you wish to highlight further potential problems."),
         p("Changing the value will not erase your previous selections for excluded points."),
         
         numericInput("problem_threshold", 
                      h4("Problem threshold (hours)"), 
                      value = 5,
                      step = 1,
                      min = 0,
                      max = 24)
         
         
       ),
       mainPanel(
         
         h2("Step 5. Find problem areas and edit your data"),
         p("This plot shows all of your data with problem areas highlighted in red boxes and the location of the editing window shown in gray."),
         p("An error may show briefly but the plot is still loading as long as the loading indicator returns."),
         #This places a plot in main area that shows all values from 
         #output$plotall (generated in server section)
         withSpinner(plotOutput("plotall",
                                height = "150px")),
         
         
         ##############################
         #Input slider based on reactive dataframe.
         #https://stackoverflow.com/questions/18700589/interactive-reactive-change-of-min-max-values-of-sliderinput
         
         uiOutput("dateslider"),
         
         p("The plot below can be edited by clicking a single data point or left-clicking and dragging your cursor to select multiple points."),
         
         radioButtons("edit_units", 
                      label = "Select your time units",
                      choices = list("days",
                                     "hours"),
                      selected = "days"),
         
         
         numericInput("time_window", "Editing window length",
                      value = 2), #Default shows 2 days in seconds (172800) for posixct
         
         numericInput("overlap_window", "What overlap with previous window?",
                      value = round(1/24, 2)), #Default shows 1 hour in seconds (3600 sec)
         p("Use the Previous and Next buttons to move to the next or previous editing window or problem twilight"),
         actionButton("click_Prev", "Previous editing window"),
         actionButton("click_Next", "Next editing window"),
         br(),
         actionButton("click_PrevProb", "Previous problem"),
         actionButton("click_NextProb", "Next problem"),
         ##############################
         #plot a subset of the data that is zoomed in enough to see and edit individual points.
         plotOutput("plotselected",
                    click = "plotselected_click",
                    brush = brushOpts(
                      id = "plotselected_brush"
                    )
         ),
         #buttons to toggle editing plot points selected by a box.
         actionButton("exclude_toggle", "Toggle currently selected points"),
         actionButton("exclude_reset", "Reset ALL EXCLUDED POINTS"),
         br(),
         
         actionButton("render_edits", "Show/refresh edited values"),
         DTOutput('excludedtbl'),
         h2("Step 6. Generate coordinates"),
         
         #This actionButton is linked by its name (update_map) to an observeEvent in the server function
         #When you press this the keep dataset is generated and the mymap object is shown.
         
         actionButton("create_data", "6A. Generate edited twilights for coordinate calculation"),
         DTOutput('data_preview'),
         
         br(),
         actionButton("update_map", "6B. Generate map from edited twilights"),
         #Map showing calculated coordinates from sunrise/sunset times.
         leafletOutput("mymap"),
         br(),
         
         h2("Step 7. Download data"),
         
         #Button to download data.
         downloadButton('downloadData', 'Download TAGS format (original data with edits and twilights)'),
         
         #Add one for coordinates only
         downloadButton('downloadDataCoord', 'Download edited coordinates only'),
         
         #Add one for edited twilights only
         downloadButton('downloadDataTwilights', 'Download edited twilights only')
         
         
         
         
       )
       
     )
  )
}



#######
# Define server functions that pass back to UI (this is where all the data processing happens)

# The parameter "data" is reserved for the data object passed on from the previous app
shinyModule <- function(input, output, session, data) {
  # all IDs of UI functions need to be wrapped in ns()
  ns <- session$ns
  current <- reactiveVal(data)
  
  ##--## example code - choose which individual to plot ##--## 
  output$uiIndivL <- renderUI({
    selectInput(ns("indivL"), "Select individual", choices=unique(mt_track_id(data)), selected=unique(mt_track_id(data))[1])
  })
  output$plot <- renderPlot({
    dat <- filter_track_data(data, .track_id=input$indivL)
    plot(st_geometry(mt_track_lines(dat)))
  })
  ##--## end of example ##--##
  
  # data must be returned. Either the unmodified input data, or the modified data by the app
  return(reactive({ current() }))
}
