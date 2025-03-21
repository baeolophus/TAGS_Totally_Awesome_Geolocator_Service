i.twilightEvents <- function(datetime, light, LightThreshold){
  
  # for manual testing for smooth
  datetime <- df1[,1]
  light <- df1[,2]
  
  # for manual testing for raw
  datetime <- bas$datetime
  light <- bas$light
  
  #actual function
  
  df <- data.frame(datetime, light)
  
  ind1 <- which((df$light[-nrow(df)] < LightThreshold & df$light[-1] > LightThreshold) | 
                  (df$light[-nrow(df)] > LightThreshold & df$light[-1] < LightThreshold) | 
                  df$light[-nrow(df)] == LightThreshold)
  
  # Binding together rows where lights are different from threshold
  bas1 <- cbind(df[ind1,],df[ind1+1,])
  
  #Only selecting rows where the light levels are not equal.
  bas1 <- bas1[bas1[,2]!=bas1[,4],]
  
  # changing date time values to numeric for subtraction
  x1 <- as.numeric(unclass(bas1[,1])); x2 <- as.numeric(unclass(bas1[,3]))
  
  #assigning light levels to objects
  y1 <- bas1[,2]; y2 <- bas1[,4]
  
  # slope aka change in light level?
  m <- (y2-y1)/(x2-x1)
  
  # still unclear why intercept (?) b is needed.
  b <- y2-(m*x2)
  
  xnew <- (LightThreshold - b)/m
  
  #labels as sunset or sunrise based on whether previous light level was larger or smaller
  type <- ifelse(bas1[,2]<bas1[,4],1,2)
  
  # data frame to be exported from this function that includes a date time stamp, and the twilight type.
  res  <- data.frame(datetime=as.POSIXct(xnew, origin="1970-01-01", tz="UTC"),type)
  
  return(res)
  
}

