#' @param path character; file path to either a .tif or a directory of .tifs that are tiles
#' @param vect SpatVector; rasters will be cropped and masked to this object
read_agb <- function(path, vect) {
  
  if (fs::is_file(path)) {
    rast_crs <- terra::crs(terra::rast(path))
    vect <-  vect |> terra::project(rast_crs)
    
    out <- 
      terra::rast(path, win = terra::ext(vect)) |> 
      terra::crop(vect, mask = TRUE, overwrite = TRUE)
  }
  if (fs::is_dir(path)) { #if tiles, merge them
    tifs <- fs::dir_ls(path, glob = "*.tif") 
    vrt_crs <- terra::crs(terra::rast(tifs[1])) 
    vect <- vect |> terra::project(vrt_crs)
    
    # for each tile, either drop it (if not in vect), keep it whole (if
    # completely inside vect), or crop it to borders of vect.  In benchmarking
    # this ended up being faster than using a vrt() and then cropping and
    # masking.
    # TODO: could potentially speed this up with furrr, but might be tricky with `targets`?
    rast_list <- 
      purrr::map(tifs, terra::rast) |> 
      purrr::map(\(x) process_tile(x, vect)) |> 
      purrr::compact()
    
    out <-
      rast_list |>
      sprc() |>
      merge()
  }
  out
}

# for a single tile in a list of tiles
process_tile <- function(rast, vect) {
  #if tile is not at all within AZ, return NULL
  if (terra::relate(ext(rast), ext(vect), relation =  "disjoint")) {
    return(NULL)
    #if tile is completely within AZ, return as-is
  } else if (terra::relate(ext(rast), ext(vect), relation = "within")) {
    return(rast)
    #otherwise, crop to AZ
  } else {
    return(crop(rast, vect, mask = TRUE, overwrite = TRUE))
  }
}