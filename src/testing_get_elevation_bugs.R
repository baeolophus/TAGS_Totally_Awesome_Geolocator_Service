twl_rise <- TwGeos::findTwilights(tagdata = data.frame(Date = geolocator_raw_moveapps$timestamp,
                                                       Light = geolocator_raw_moveapps$light_level), 
                                  threshold = 100,
                                  include = geolocator_raw_moveapps$timestamp)

twl_rise$tSecond <- dplyr::lead(
  twl_rise$Twilight,                        #column of Twilight times
  n=1                                       #calculate from one row next (lead not lag)
)

twl_rise$type[twl_rise$Rise==TRUE] <- 1
twl_rise$type[twl_rise$Rise==FALSE] <- 2


calib <- na.omit(twl_rise[
  #stop date
                (as.numeric(as.Date(twl_rise$tSecond)) > (as.numeric(as.Date("2015-12-24"))))&
                  
                  # start date
                  (as.numeric(as.Date(twl_rise$Twilight)) < as.numeric(as.Date("2016-01-21"))),])


#filter dates
#https://github.com/slisovski/GeoLight/issues/3




lat.calib <-  10
lon.calib <-  -20

elev <- GeoLight::getElevation(tFirst = calib$Twilight,
                     tSecond = calib$tSecond,
                     type = calib$type,
                     method = "gamma", plot = FALSE,
                     known.coord=c(lon.calib,
                                   lat.calib))

elev[[2]]

coord <- GeoLight::coord(tFirst = twl_rise$Twilight, # formerly named tFirst, left old name since it's the GeoLight format for consistency (will see if need to change later.)
                         tSecond = twl_rise$tSecond,
                         type = twl_rise$type,
                         degElevation=elev[[2]])
coord.df <- data.frame(coord)
coord.df$lng <- coord.df$lon #rename default to match what addMarkers in leaflet() lines below requires.
coord.df$lon <- NULL #delete old column

library(TwGeos)
library(SGAT)
library(GeoLight)
library(MASS)

calib <- TwGeos::thresholdCalibration(calib$Twilight, calib$Rise, lon.calib, lat.calib, method = "log-norm")

library(leaflet)
#run the leaflet function
m <- leaflet() %>%
  addProviderTiles(
    "Stamen.Toner",
    group = "Stamen.Toner"
  )

m

  
  #add the calculated coordinates based on edited twilights
map_1 <- m %>%
  addAwesomeMarkers(
    lat = 48.1,
    lng = 11.5,
    label = "Starting point"
  )

library(mapview)
#https://bookdown.org/nicohahn/making_maps_with_r5/docs/mapview.html

library(sf)

#https://tmieno2.github.io/R-as-GIS-for-Economists/turning-a-data-frame-of-points-into-an-sf.html
coord.sf <- st_as_sf(na.omit(coord.df), coords = c("lng", "lat"), crs = 4326)

#possibly not rendering in leaflet because of number of markers: https://stackoverflow.com/questions/34607908/using-many-markers-with-leaflet-in-combination-with-shiny-server 
#suggests mapview as an alternative or clustering (which is probably not good for this use case?)
#or this: https://github.com/r-spatial/leafgl

mapview(coord.sf, legend = FALSE)

#https://stackoverflow.com/questions/65485747/mapview-points-not-showing-in-r

#https://stackoverflow.com/questions/36679944/mapview-for-shiny#36682268
#https://www.spsanderson.com/steveondata/posts/rtip-2023-05-04/index.html
