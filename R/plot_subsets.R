# library(targets)
# tar_load(az)
# tar_load(forest)
# tar_load(pima)
# tar_load(wilderness)
# tar_load(grazing)

# library(tidyterra)
# library(ggplot2)
# library(patchwork)

plot_subsets <- function(az, pima, grazing, wilderness, forest) {
  #base plot
  p_az <- ggplot() +
    geom_spatvector(data = az) +
    theme_minimal()
  
  p_pima <- p_az +
    geom_spatvector(data = pima, fill = "pink", color = "pink")
  
  p_grazing <- p_az +
    geom_spatvector(data = grazing, color = "brown", fill = "brown") 
  
  p_forest <- p_az +
    geom_spatvector(data = forest, fill = "green", color = "green") +
    geom_spatvector(data = wilderness, fill = "darkgreen", color = "darkgreen")
  
  #fake plot just to get a legend to exract to add to all three panels
  df <- dplyr::tibble(
    name = forcats::fct_inorder(c("Pima County", "USFS", "National Wilderness", "Grazing Allotments")),
    x = 1:4,
    y = 4:1
  )
  legend <- ggplot(df, aes(x = x, y = y, fill = name)) + geom_raster() +
    scale_fill_manual(
      "Subset:",
      values = c(
        "Pima County" = "pink",
        "USFS" = "green",
        "National Wilderness" = "darkgreen",
        "Grazing Allotments" = "brown"
      )
    ) +
    theme(legend.position = "bottom")
  
  extractLegend <- function(gg) {
    grobs <- ggplot_gtable(ggplot_build(gg))
    foo <- which(sapply(grobs$grobs, function(x) x$name) == "guide-box")
    grobs$grobs[[foo]]
  }
  
  #patchwork stuff
  p_out <-
    (p_pima | p_forest | p_grazing) /
    wrap_elements(extractLegend(legend)) + 
    plot_layout(heights = c(1, 0.2))
  
  ggsave("output/subset_map.png", p_out, height = 5, width = 10, bg = "white")
  
}