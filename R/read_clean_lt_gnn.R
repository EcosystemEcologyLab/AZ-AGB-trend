#' Read and wrangle LT-GNN dataset
#'
#' @param files vector of paths to .zip files in data/LT_GNN/
#' @param region SpatVector of AZ
#' @return a SpatRaster object
#' 
read_clean_lt_gnn <- function(files, region) {
  
  tifs <- 
    files |> 
    fs::path_file() |>
    fs::path_ext_set(".tif")
  
  rast_paths <- fs::path("/vsizip", files, tifs)
  
  tiles_sprc <-
    rast_paths |> 
    # Each tile has 27 layers, one for each year from 1990:2017; layer 21 is year 2010
    purrr::map(terra::rast) |>  
    terra::sprc() 
  
  tiles_combined <- 
    tiles_sprc |> 
    terra::merge() #slow step
  #I did some benchmarking and of vrt(), merge(), and mosaic(), merge() is the fastest.
  
  varnames(tiles_combined) <- "AGB"
  names(tiles_combined) <- 1990:2017
  units(tiles_combined) <- "Mg/ha"

  # Project and crop
  tiles_combined |> crop(region) |> mask(region)
}
