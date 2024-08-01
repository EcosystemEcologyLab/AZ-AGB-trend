#' Reproject and stack SpatRasters
#'
#' Projects single-layer SpatRasters to a common CRS, resolution, and extent and
#' returns a single multi-layer SpatRaster.
#'
#' @param ... SpatRaster objects, the first of which will be used as a template
#'   for transforming and cropping the others.
#'
#' @return SpatRaster with one later for each input to `...`
#' 
reproject_stack <- function(...) {
  dots <- rlang::dots_list(..., .named = TRUE)
  #use the first SpatRaster as a template for CRS and resolution
  template <- dots[[1]]
  to_transform <- dots[2:length(dots)]
  
  transformed <- #for each to_transform...
    purrr::map(to_transform, \(x) {
      new <- 
        terra::project(x, template, method = "near") |>
        terra::crop(template, mask = TRUE)
      terra::varnames(new) <- ""
      #return:
      new
    }) 
  
  #append template back to the start of the list
  stack <- 
    append(list(template), transformed) |> 
    terra::rast()
  names(stack) <- names(dots)
  
  #return:
  stack
}

