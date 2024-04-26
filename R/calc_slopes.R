calc_slopes <- function(rast, p_adj_method = "fdr") {
  years <- as.integer(names(rast))
  getTrend <- function(x) {
    #only attempt to fit a line if there are ≥3 non-NA points
    if (sum(!is.na(x)) < 3) { 
      c(slope = NA, p.val = NA)
    } else {
      m = lm(x ~ years)
      #if residual sum of squares is 0, p-value can't be calculated
      # not sure if Inf is always appropriate, but I want these to be masked out in the plot along with non-significant p-values
      if (deviance(m) < sqrt(.Machine$double.eps)) {
        c(slope = coef(m)[2], p.val = Inf)
      } else {
        c(slope = coef(m)[2], p.val = car::Anova(m)$`Pr(>F)`[1])
      }
    }
  }
  
  slope_rast <- app(rast, getTrend)
  # p.adjust uses the number of non-NA p-values for `n`, so I don't need to worry about all the NAs here
  slope_rast[[2]] <- app(slope_rast[[2]], p.adjust, method = p_adj_method)
  names(slope_rast) <- c("slope", "p.value")
  
  #return
  slope_rast
}

