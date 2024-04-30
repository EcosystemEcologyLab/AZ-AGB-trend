plot_slopes_all <- function(...) {
  rast_list <- dots_list(..., .named = TRUE)  |> 
    purrr::map(\(x) {
    project(x, crs(az)) |> crop(az)
  }) 
  
  lims <- rast_list |>
    purrr::map(\(x) minmax(x$slope) |> as.numeric()) |> 
    unlist() |> 
    range()
  # lims
  plot_list <- purrr::imap(rast_list, \(x, xid) plot_slopes(x, az, xid, limits = lims, save = FALSE))
  patchwork::wrap_plots(plot_list) + patchwork::plot_layout(guides = "collect")
  
  #TODO save the plot
  # ggsave()
}

# plot_slopes_all(slope_chopping_agb, slope_liu_agb, slope_xu_agb)
