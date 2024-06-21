# library(targets)
# tar_load_globals()
# tar_load(az_forest)
# tar_load(liu_agb)

mask_get_data <- function(product, vect_sub) {
  
  raster_name <- deparse(substitute(product))
  subset_name <- deparse(substitute(vect_sub))
  
  vect_sub <- vect_sub |> terra::project(product)
  
  product |> 
    terra::mask(vect_sub) |> 
    mean() |>  #mean across years
    as_tibble(na.rm = TRUE) |> 
    rename(agb = mean) |> 
    mutate(product = raster_name, subset = subset_name)
}
# mask_get_data(liu_agb, vect_sub = az_forest)
