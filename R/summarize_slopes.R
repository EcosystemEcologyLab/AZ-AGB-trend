summarize_slopes <- function(raster, sub_vect) {
  raster_name <- deparse(substitute(raster))
  sub_vect_name <- deparse(substitute(sub_vect))
  sub_vect <- terra::project(sub_vect, raster)
  raster <- terra::mask(raster, sub_vect)
  
  as.data.frame(raster, na.rm = TRUE) |>
    dplyr::summarize(
      mean = mean(slope),
      sd = sd(slope),
      min = min(slope),
      max = max(slope),
      median = median(slope),
      q.025 = quantile(slope, 0.025),
      q.1 = quantile(slope, 0.1),
      q.25 = quantile(slope, 0.25),
      q.75 = quantile(slope, 0.75),
      q.9 = quantile(slope, 0.9),
      q.975 = quantile(slope, 0.975),
      n = n()
    ) |> 
    mutate(subset = sub_vect_name, product = raster_name, .before = mean) 
}

