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

library(TwGeos)
library(SGAT)
library(GeoLight)
library(MASS)

calib <- TwGeos::thresholdCalibration(calib$Twilight, calib$Rise, lon.calib, lat.calib, method = "log-norm")
