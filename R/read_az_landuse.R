#generic re-project and crop shapefiles to AZ
read_az_landuse <- function(landuse_file, az) {
  terra::vect(landuse_file) |> 
    terra::project(az) |> 
    terra::crop(az)
}

#for wilderness, subset to just national wilderness
read_az_wilderness <- function(file, az) {
  wilderness <- terra::vect(file)
  wilderness[wilderness$AREATYPE == "NATIONAL WILDERNESS AREA"] |> 
    terra::project(az) |> 
    terra::crop(az)
  
}
