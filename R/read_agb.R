#' @param path character; file path to either a .tif or a directory of .tifs that are tiles
#' @param vect SpatVector; rasters will be cropped and masked to this object
read_agb <- function(path, vect) {
  
  if (fs::is_file(path)) {
    rast_crs <- terra::crs(terra::rast(path))
    vect <-  vect |> terra::project(rast_crs)
    
    out <- 
      terra::rast(path, win = terra::ext(vect)) |> 
      terra::crop(vect, mask = TRUE)
  }
  if (fs::is_dir(path)) { #if tiles, merge them
    #TODO apply window to these as well so unecessary tiles don't get read in
    tifs <- fs::dir_ls(path, glob = "*.tif") 
    vrt_crs <- terra::crs(terra::rast(tifs[1])) 
    vect <- vect |> terra::project(vrt_crs)
    
    out <-
      vrt(tifs, set_names = TRUE) |> 
      crop(vect, mask = TRUE)
  }
  out
}