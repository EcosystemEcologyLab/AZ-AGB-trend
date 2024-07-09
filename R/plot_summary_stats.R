plot_summary_stats <- function(data) {
  # Get better product names
  data |> 
    dplyr::mutate(product = dplyr::case_when(
      stringr::str_detect(product, "liu") ~ "Liu et al.",
      stringr::str_detect(product, "xu") ~ "Xu et al.",
      stringr::str_detect(product, "esa") ~ "ESA CCI",
      stringr::str_detect(product, "ltgnn") ~ "LT-GNN",
      stringr::str_detect(product, "chopping") ~ "Chopping et al.",
      .default = product
    )) |> 
    dplyr::mutate(subset = dplyr::case_when(
      subset == "az" ~ "AZ",
      subset == "forest" ~ "Forest Service",
      subset == "wilderness" ~ "Wilderness",
      subset == "grazing" ~ "Grazing Alotments",
      subset == "pima" ~ "Pima County",
      .default = subset
    )) |> 
    ggplot(aes(x = product, y = median, color = median > 0)) +
    facet_wrap(vars(subset), scales = "free_y") +
    geom_hline(yintercept = 0, linetype = 3) +
    geom_point() +
    geom_linerange(aes(ymin = q25, ymax = q75), linewidth = 1.3) +
    geom_linerange(aes(ymin = q10, ymax = q90), linewidth = 0.7) +
    labs(
      y = "Median Slope (Mg ha<sup>-1</sup> yr<sup>-1</sup>)",
      x = " ",
      color = "Median AGB Trend",
      caption = "Error bars represent interquartile range (thick) and 10th-90th percentile (thin)."
    ) +
    scale_color_manual(values = c("TRUE"="darkgreen", "FALSE"="darkred"),
                       labels = c("TRUE" = "Increasing", "FALSE" = "Decreasing")) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 45, hjust = 1),
      axis.title = ggtext::element_markdown()
    ) 
}
