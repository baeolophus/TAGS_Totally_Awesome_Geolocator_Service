twl_rise <- TwGeos::findTwilights(tagdata = data.frame(Date = geolocator_raw_moveapps$timestamp,
                                                       Light = geolocator_raw_moveapps$light_level), 
                                  threshold = 100,
                                  include = geolocator_raw_moveapps$timestamp)

twl_rise$tSecond <- dplyr::lead(
  twl_rise$Twilight,                        #column of Twilight times
  n=1                                       #calculate from one row next (lead not lag)
)

twl_rise$geolight_sunrise_is_1[twl_rise$Rise==TRUE] <- 1
twl_rise$geolight_sunrise_is_1[twl_rise$Rise==FALSE] <- 2


calib <- na.omit(twl_rise[
  #stop date
                (as.numeric(as.Date(twl_rise$tSecond)) < (as.numeric(as.Date("2016-06-24"))))&
                  
                  # start date
                  (as.numeric(as.Date(twl_rise$Twilight)) > as.numeric(as.Date("2016-06-21"))),])


#filter dates
#https://github.com/slisovski/GeoLight/issues/3


lat.calib <-  15
lon.calib <-  78

elev <- GeoLight::getElevation(tFirst = calib$Twilight,
                     tSecond = calib$tSecond,
                     type = calib$geolight_sunrise_is_1,
                     method = "gamma", plot = FALSE,
                     known.coord=c(lon.calib,
                                   lat.calib))


calib <- thresholdCalibration(calib$Twilight, calib$Rise, lon.calib, lat.calib, method = "gamma")
