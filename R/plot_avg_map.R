# library(ggplot2)
# library(tidyterra)
# library(targets)
# tar_load(avg_menlove)
# tar_load(az)
# 
# raster <- avg_chopping
# subset <- az

#' Plot maps of mean AGB
#'
#' @param raster SpatRaster with a single layer for mean AGB
#' @param subset SpatVector for a subset
#' @param ext file extension to save the plot as (default "png")
#' @param outdir path to save the output to
#' @param ... other arguments passed to ggsave() (e.g. `width` and `height`)
#'
#' @return the file path (invisibly)
#'
plot_avg_map <- function(raster, subset, ext = "png", outdir = "output/average/figs/", ...) {
  fs::dir_create(outdir)
  #varnames are lost in current version of geotargets, so pull from target name instead
  target_name <- as.character(rlang::ensym(raster))
  
  #build title and subtitle
  title <- dplyr::case_when(
    stringr::str_detect(target_name, "liu") ~ "Liu et al.",
    stringr::str_detect(target_name, "xu") ~ "Xu et al.",
    stringr::str_detect(target_name, "esa") ~ "ESA CCI",
    stringr::str_detect(target_name, "ltgnn") ~ "LT-GNN",
    stringr::str_detect(target_name, "chopping") ~ "Chopping et al.",
    stringr::str_detect(target_name, "menlove") ~ "Menlove et al.",
    stringr::str_detect(target_name, "gedi") ~ "GEDI", 
    .default = target_name
  )
  
  years <- dplyr::case_when(
    stringr::str_detect(target_name, "liu") ~ "1993-2012",
    stringr::str_detect(target_name, "xu") ~ "2000-2019",
    stringr::str_detect(target_name, "esa") ~ "2010, 2017-2020",
    stringr::str_detect(target_name, "ltgnn") ~ "1990-2017",
    stringr::str_detect(target_name, "chopping") ~ "2000-2021",
    stringr::str_detect(target_name, "menlove") ~ "2009-2019",
    stringr::str_detect(target_name, "gedi") ~ "2019-2023"
  )
  # project to common CRS and crop to subset
  plot_crs <- "+proj=longlat +datum=WGS84 +no_defs"
  subset <- 
    terra::project(subset, plot_crs)
  raster <- 
    raster |> 
    terra::project(plot_crs) |> 
    terra::crop(subset, mask = TRUE) 
  
  # Subset of colors from the scio pacakge batlow_w palette
  map_cols <- c("#EFB298", "#C39E4B", "#7D8737", "#437153", "#185661", "#0C325D")
  
  p <-
    ggplot() +
    geom_spatraster(data = raster) +
    geom_spatvector(data = subset, fill = NA) +
    scale_fill_gradientn(
      colors = map_cols,
      na.value = "transparent",
      guide = guide_colorbar(barwidth = 0.6, title.psition = "top")
    ) +
    labs(title = title, subtitle = glue::glue("mean of {years}"), fill = "AGB (Mg ha<sup>-1</sup>)") +
    theme_dark() +
    theme(legend.title = ggtext::element_markdown())
  
  filename <- fs::path_ext_set(target_name, ext)
  ggsave(filename = filename, plot = p, path = outdir, bg = "white", ...)
  
  #return
  return(invisible(fs::path(outdir, filename)))
  
}
# plot_avg_map(avg_gedi, az)
