make_tiles <- function(rast) {
  rast_name <- as.character(rlang::ensym(rast))
  x <- terra::rast(ncols = 3, nrows = 2) #6 tiles 
  ext(x) <- ext(rast)
  makeTiles(rast, x, filename = fs::path("data", "tiles", path_ext_set(rast_name, "tiff")), overwrite = TRUE)
}

