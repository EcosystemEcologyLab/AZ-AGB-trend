# library(targets)
# tar_load(slope_liu_agb)
# tar_load(slope_xu_agb)
# tar_load_globals()
# slope_data <- collect_data(slope_liu_agb, slope_xu_agb)
# library(ggplot2)
# library(ggdist)
# library(ggtext)
# library(colorspace)

plot_slope_slabinterval <- function(slope_data) {
  
  slope_data |> 
    dplyr::mutate(product = dplyr::case_when(
      stringr::str_detect(product, "liu") ~ "Liu et al.",
      stringr::str_detect(product, "xu") ~ "Xu et al.",
      stringr::str_detect(product, "esa") ~ "ESA CCI",
      stringr::str_detect(product, "ltgnn") ~ "LT-GNN",
      stringr::str_detect(product, "chopping") ~ "Chopping et al."
    )) |> 
    
    ggplot(aes(y = product, x = slope)) +
    geom_vline(xintercept = 0, linetype = 2, alpha = 0.7, color = "darkred") +
    stat_gradientinterval(
      # aes(fill = product),
      fill_type = "gradient",
      density = "unbounded",
      point_interval = "median_qi",
      .width = c(.5, .8, .95)
    ) +
    # scale_fill_discrete_qualitative(palette = "Dark 3") +
    theme_minimal() +
    labs(x = "Estimated Slope (Mg ha<sup>-1</sup> yr<sup>-1</sup>)") +
    theme(legend.position = "none",
          axis.title.y = element_blank(),
          axis.title.x = element_markdown())
  
}