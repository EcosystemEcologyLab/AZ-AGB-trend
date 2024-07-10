summarize_yearly <- function(raster, sub_vect) {
  raster_name <- deparse(substitute(raster))
  sub_vect_name <- deparse(substitute(sub_vect))
  sub_vect <- 
    terra::project(sub_vect, raster) |> 
    sf::st_as_sf() |> 
    sf::st_combine() #converts to single multipolygon so only one row of summary stats per subset x product
  
  exactextractr::exact_extract(
    raster, sub_vect, fun = c(
      "count",
      "min",
      "max",
      "mean",
      "stdev",
      "median",
      "sum",
      "quantile"
    ),
    quantiles = c(0.025, 0.1, 0.25, 0.75, 0.9, 0.975),
    max_cells_in_memory = 1e+07, #to lower RAM usage maybe?
    stack_apply = TRUE #slower but less RAM usage maybe?
  ) |> 
    tidyr::pivot_longer(everything(), names_sep = "\\.", names_to = c("stat", "year")) |> 
    tidyr::pivot_wider(names_from = "stat", values_from = "value") |> 
    #fix mangled quantile column names
    dplyr::rename(q02.5 = q02, q97.5 = q97) |> 
    dplyr::mutate(subset = sub_vect_name, product = raster_name, .before = 1) 
}

