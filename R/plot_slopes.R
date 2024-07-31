# library(targets)
# tar_load_globals()
# library(ggplot2)
# library(tidyterra)
# library(colorspace)
# library(ggtext)
# library(dplyr)
# library(stringr)


#' Plot trends in AGB
#'
#' @param raster a SpatRaster created by `calc_slopes()`
#' @param subset SpatVector of arizona
#' @param ext file extension for saved figure
#' @param outdir path to save file out to
#' @param ... other arguments passed to ggsave, e.g. `width` and `height`
#'
#' @return when save=TRUE, returns a file path (invisibly), otherwise returns a ggplot object
#'
#' @examples
#' plot_slopes(tar_read(slope_liu_agb), limits = c(-1, 1), width = 5, height = 5)
#' 
plot_slopes <- function(raster, subset, ext = "png", outdir = "output/slopes/figs", ...) {
  fs::dir_create(outdir)
  raster_name <- as.character(rlang::ensym(raster))
  subset_name <- as.character(rlang::ensym(subset))
  filename <- fs::path_ext_set(paste(raster_name, subset_name, sep = "_"), ext)
  
  title <- dplyr::case_when(
    stringr::str_detect(raster_name, "liu") ~ "Liu et al.",
    stringr::str_detect(raster_name, "xu") ~ "Xu et al.",
    stringr::str_detect(raster_name, "esa") ~ "ESA CCI",
    stringr::str_detect(raster_name, "ltgnn") ~ "LT-GNN",
    stringr::str_detect(raster_name, "chopping") ~ "Chopping et al."
  )
  
  years <- dplyr::case_when(
    stringr::str_detect(raster_name, "liu") ~ "1993-2012",
    stringr::str_detect(raster_name, "xu") ~ "2000-2019",
    stringr::str_detect(raster_name, "esa") ~ "2010, 2017-2020",
    stringr::str_detect(raster_name, "ltgnn") ~ "1990-2017",
    stringr::str_detect(raster_name, "chopping") ~ "2000-2021"
  )
  
  #project to common CRS and extent for uniform plotting
  raster <- raster[["slope"]]
  plot_crs <- "+proj=longlat +datum=WGS84 +no_defs"
  subset <- 
    terra::project(subset, plot_crs)
  raster <- 
    raster |> 
    terra::project(plot_crs) |> 
    terra::crop(subset) |> 
    terra::mask(subset)
  p <-
    ggplot() +
    geom_spatraster(data = raster) +
    geom_spatvector(data = subset, fill = NA) +
    colorspace::scale_fill_continuous_diverging(na.value = "transparent") +
    labs(title = title, subtitle = years, fill = "∆AGB <br>(Mg Ha<sup>-1</sup> yr<sup>-1</sup>)") +
    theme_dark() +
    theme(legend.title = element_markdown())
    
    ggsave(filename = filename, plot = p, path = outdir, bg = "white", ...)
    
    #return
    return(invisible(fs::path(outdir, filename)))
}

