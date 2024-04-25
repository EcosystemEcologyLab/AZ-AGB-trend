get_az <- function() {
  usa <- geodata::gadm("USA", path = fs::path_temp("gadm"))
  
  return(usa[usa$NAME_1 == "Arizona"])
}
