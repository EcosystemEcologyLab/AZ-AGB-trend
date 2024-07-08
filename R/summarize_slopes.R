summarize_slopes <- function(raster, sub_vect) {
  raster_name <- deparse(substitute(raster))
  sub_vect_name <- deparse(substitute(sub_vect))
  raster <- raster[["slope"]] #only use coef layer, not p-value layer
  sub_vect <- terra::project(sub_vect, raster) |> sf::st_as_sf()
  
  exactextractr::exact_extract(
    raster, sub_vect, fun = c(
      "count",
      "min",
      "max",
      "mean",
      "stdev",
      "median",
      "quantile"
    ),
    quantiles = c(0.025, 0.1, 0.25, 0.75, 0.9, 0.975)
  ) |> 
    #fix mangled quantile column names
    dplyr::rename(q02.5 = q02, q97.5 = q97) |> 
    dplyr::mutate(subset = sub_vect_name, product = raster_name, .before = 1) 
}

