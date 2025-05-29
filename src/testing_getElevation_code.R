
tab<- data.frame(twilight = calib$Twilight,
                 rise = calib$Rise)

known.coord=c(lon.calib,
              lat.calib)
sun <- solar(tab[, 1])
z <- GeoLight::refracted(zenith(sun, known.coord[1], known.coord[2]))
inc = 0
repeat {
  twl_t <- GeoLight::twilight(tm = tab[, 1], 
                              lon = known.coord[1], 
                              lat = known.coord[2], 
                    rise = tab[, 2],
                    zenith = max(z) + inc)
  twl_dev <- ifelse(tab$rise, #was Rise with caps earlier, could matter?  not sure.  probably not, but maybe docs need fixed?
                    
                    as.numeric(difftime(tab[,1], twl_t, units = "mins")),
                    as.numeric(difftime(twl_t, tab[, 1], units = "mins")))
  if (all(twl_dev >= 0)) {
    break
  }
  else {
    inc <- inc + 0.01
  }
}
z0 <- max(z) + inc
seq <- seq(0, max(twl_dev), length = 100)
if (method == "log-norm") {
  fitml_ng <- suppressWarnings(fitdistr(twl_dev, "log-normal"))
  lns <- dlnorm(seq, fitml_ng$estimate[1], fitml_ng$estimate[2])
}
if (method == "gamma") {
  fitml_ng <- suppressWarnings(fitdistr(twl_dev, "gamma"))
  lns <- dgamma(seq, fitml_ng$estimate[1], fitml_ng$estimate[2])
}
diffz <- as.data.frame(cbind(min = apply(cbind(tab[, 1], 
                                               twilight(tab[, 1], known.coord[1], known.coord[2], rise = tab[, 
                                                                                                             2], zenith = z0)), 1, function(x) abs(x[1] - x[2]))/60, 
                             z = z))
mod <- lm(z ~ min, data = diffz)
mod2 <- lm(min ~ z, data = diffz)
a1.0 <- seq[which.max(lns)]
a1.1 <- 90 - predict(mod, newdata = data.frame(min = a1.0))