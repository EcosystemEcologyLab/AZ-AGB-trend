# library(ggplot2)
# library(tidyterra)
# library(ggtext)
# library(scales)
plot_stdev <- function(raster, subset, ext = "png", outdir = "output/comparison/figs", ...) {
  fs::dir_create(outdir)
  raster_name <- as.character(rlang::ensym(raster))
  subset_name <- as.character(rlang::ensym(subset))
  filename <- fs::path_ext_set(paste(raster_name, subset_name, sep = "_"), ext)
  subset <- project(subset, raster)
  raster <- crop(raster, subset, mask = TRUE)
  
  p <- ggplot() +
    tidyterra::geom_spatraster(
      data = raster + 1
    ) +
    scale_fill_viridis_c(
      option = "viridis",
      trans = "log10",
      breaks = scales::breaks_log(6),
      na.value = "transparent",
      guide = guide_colorbar(barwidth = 0.6, title.position = "top")
    ) +
    theme_minimal() +
    labs(fill = "Stdev (Mg ha<sup>-1</sup>)") +
    theme(legend.title = element_markdown())
  
  ggsave(filename = filename, plot = p, path = outdir, bg = "white", ...)
  return(invisible(fs::path(outdir, filename)))
  
}

