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
#' @param slope_rast a SpatRaster created by `calc_slopes()`
#' @param region SpatVector of arizona
#' @param target_name optional, the name of the dataset (e.g. slope_liu_agb).
#'   If not provided, this will be taken from varnames(slope_rast) which
#'   sometimes has this info.
#' @param save this plot as a file?
#' @param ext file extension for saved figure
#' @param outdir path to save file out to
#' @param limits optional, provide a length 2 vector to set limits on the fill scale
#' @param ... other arguments passed to ggsave, e.g. `width` and `height`
#'   (although note that output images have exess whitespace trimmed by
#'   `trim_image()`)
#'
#' @return when save=TRUE, returns a file path (invisibly), otherwise returns a ggplot object
#'
#' @examples
#' plot_slopes(tar_read(slope_liu_agb), limits = c(-1, 1), width = 5, height = 5)
#' 
plot_slopes <- function(slope_rast, region, target_name = NULL, save = TRUE, ext = "png", outdir = "output/figs", limits = NULL, ...) {
  if (is.null(target_name)) {
    target_name <- varnames(slope_rast)
  }
  title <- dplyr::case_when(
    stringr::str_detect(target_name, "liu") ~ "Liu et al.",
    stringr::str_detect(target_name, "xu") ~ "Xu et al.",
    stringr::str_detect(target_name, "esa") ~ "ESA CCI",
    stringr::str_detect(target_name, "ltgnn") ~ "LT-GNN",
    stringr::str_detect(target_name, "chopping") ~ "Chopping et al."
  )
  
  years <- dplyr::case_when(
    stringr::str_detect(target_name, "liu") ~ "1993-2012",
    stringr::str_detect(target_name, "xu") ~ "2000-2019",
    stringr::str_detect(target_name, "esa") ~ "2010, 2017-2020",
    stringr::str_detect(target_name, "ltgnn") ~ "1990-2017",
    stringr::str_detect(target_name, "chopping") ~ "2000-2021"
  )
  
  #project to common CRS and extent for uniform plotting
  #better to do this before plotting
  # slope_rast <- project(slope_rast, crs(region)) |> crop(region)
  
  p <-
    ggplot() +
    geom_spatraster(data = slope_rast, aes(fill = slope)) +
    labs(title = title, subtitle = years, fill = "∆AGB <br>(Mg Ha<sup>-1</sup> yr<sup>-1</sup>)") +
    theme_dark() +
    theme(legend.title = element_markdown())
  
  if (!is.null(limits)) {
    p <- p +
      scale_fill_continuous_diverging(na.value = "transparent", limits = limits)
  } else {
    p <- p +
      scale_fill_continuous_diverging(na.value = "transparent")
  }
  
  if (isTRUE(save)) {
    
    filename <- fs::path_ext_set(target_name, ext)
    ggsave(filename = filename, plot = p, path = outdir, ...) |> 
      trim_image()
    
    #return
    return(invisible(fs::path(outdir, filename)))
  } else {
    return(p)
  }
  
}

