summarize_slopes <- function(raster) {
  as.data.frame(raster, na.rm = TRUE) |>
    dplyr::summarize(
      mean = mean(slope),
      sd = sd(slope),
      min = min(slope),
      max = max(slope),
      median = median(slope),
      q.025 = quantile(slope, 0.025),
      q.25 = quantile(slope, 0.25),
      q.75 = quantile(slope, 0.74),
      q.975 = quantile(slope, 0.975),
    ) 
}
