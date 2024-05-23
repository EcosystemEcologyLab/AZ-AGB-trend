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
    ggplot(aes(x = product)) +
    #Median and inter-quartile range (IQR)
    geom_pointrange(aes(y = median, ymin = q.25, ymax = q.75), linewidth = 2, fatten = 5) +
    #95% of data
    # geom_linerange(aes(ymin = q.025, ymax = q.975), linewidth = 1) +
    #80% of data
    geom_linerange(aes(ymin = q.1, ymax = q.9), linewidth = 1) +
    #Dotted line at zero
    geom_hline(yintercept = 0, linetype = 2, color = "grey20") +
    ## add a point for mean?
    # geom_point(aes(y = mean), shape = "cross", color = "blue", size = 4) +
    labs(y = "Slope (Mg ha<sup>-1</sup> yr<sup>-1</sup>)", x = "") +
    theme_minimal() +
    coord_flip() +
    theme(axis.title = element_markdown())
}