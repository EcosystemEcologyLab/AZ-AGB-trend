#re-project and crop shapefiles to AZ
read_az_landuse <- function(landuse_file, az) {
  terra::vect(landuse_file) |> 
    terra::project(az) |> terra::crop(az)
}