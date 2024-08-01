summarize_stdev <- function(raster, subset) {
  raster_name <- deparse(substitute(raster))
  subset_name <- deparse(substitute(subset))
  subset <- 
    terra::project(subset, raster) |> 
    sf::st_as_sf() |> 
    sf::st_combine() #converts to single multipolygon so only one row of summary stats per subset x product
  
  exactextractr::exact_extract(
    raster, subset, fun = c(
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
    dplyr::mutate(subset = subset_name, product = raster_name, .before = 1) 
}