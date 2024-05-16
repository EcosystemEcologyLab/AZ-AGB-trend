make_tiles <- function(rast) {
  rast_name <- as.character(rlang::ensym(rast))
  x <- terra::rast(ncols = 3, nrows = 3) #9 tiles
  ext(x) <- ext(rast)
  fs::dir_create("tiles")
  makeTiles(rast, x, filename = fs::path("tiles", path_ext_set(rast_name, "tiff")), overwrite = TRUE)
}

