# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(geotargets)
library(rlang)
library(crew)


controller_local <- 
  crew::crew_controller_local(
    name = "local", 
    workers = 4, 
    seconds_idle = 60,
    local_log_directory = "logs"
  )

# Set target options:
tar_option_set(
  packages = c("ncdf4", "terra", "fs", "purrr", "ncdf4", "car", "dplyr"), # Packages that your targets need for their tasks.
  controller = controller_local,
  # improve memory performance
  memory = "transient", 
  garbage_collection = TRUE,
  # allow workers to access _targets/ store directly
  storage = "worker",
  retrieval = "worker"
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

#use local data in this project
root <- "data"

#use data on mounted "snow" drive (super slow and not advisable)
# root <- "/Volumes/moore/"

# Track files
files <- tar_plan(
  tar_file(esa_files, dir_ls(path(root, "ESA_CCI/"), glob = "*.tif*"), deployment = "main"),
  tar_file(chopping_file, path(root, "Chopping/MISR_agb_estimates_20002021.tif"), deployment = "main"),
  tar_file(liu_file, path(root, "Liu/Aboveground_Carbon_1993_2012.nc"), deployment = "main"),
  tar_file(xu_file, path(root, "Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif"), deployment = "main"),
  tar_file(ltgnn_files, fs::dir_ls(path(root, "LT_GNN"), glob = "*.zip"), deployment = "main"),
  tar_terra_vect(az, get_az(), deployment = "main")
)

rasters <- tar_plan(
  tar_terra_rast(xu_agb, read_clean_xu(xu_file, az)),
  tar_terra_rast(liu_agb, read_clean_liu(liu_file, az)),
  tar_terra_rast(chopping_agb, read_clean_chopping(chopping_file, az)),
  tar_terra_rast(esa_agb, read_clean_esa(esa_files, az)),
  tar_terra_rast(ltgnn_agb, read_clean_ltgnn(ltgnn_files, az))
)

slopes_small <- tar_plan(
  tar_map(#for each data product
    values = list(
      product = syms(c("xu_agb", "liu_agb"))
    ),
    #calculate slopes
    tar_terra_rast(
      slope, 
      calc_slopes(product)
    ),
    # Then plot the slopes and export a .png
    tar_target(
      slope_plot,
      plot_slopes(slope, region = az),
      #packages only needed for plotting step:
      packages = c("ggplot2", "tidyterra", "colorspace", "stringr", "ggtext")
    )
  )
)

#for high resolution data products, need to break into tiles to do computations in parallel to not run out of memory
slopes_big <- tar_plan(
  tar_map(
    #for each data product
    values = list(
      product = syms(c("esa_agb", "chopping_agb", "ltgnn_agb"))
    ),
    tar_target(
      tiles,
      make_tiles(product),
    ),
    tar_target(
      tiles_files,
      tiles,
      pattern = map(tiles),
      format = "file"
    ),
    tar_terra_rast(
      slope_tiles,
      calc_slopes(terra::rast(tiles_files)),
      pattern = map(tiles_files),
      iteration = "list"
    ),
    # merge tiles together
    tar_terra_rast(
      slope,
      slope_tiles |> sprc() |> merge()
    ),
    # Then plot the slopes and export a .png
    tar_target(
      slope_plot,
      plot_slopes(slope, region = az),
      #packages only needed for plotting step:
      packages = c("ggplot2", "tidyterra", "colorspace", "stringr", "ggtext")
    )
  )
)

#collect summary statistics
data <- tar_plan(
  tar_map(
    values = list(
      rasters = syms(c(
        "slope_liu_agb", "slope_xu_agb",
        "slope_esa_agb", "slope_chopping_agb", "slope_ltgnn_agb"
      ))
    ),
    tar_target(
      summary,
      summarize_slopes(rasters)
    )
  )
)
stats <- tar_combine(
  summary_stats,
  data,
  command = dplyr::bind_rows(!!!.x, .id = "product")
)

# plot summary statistics
plot <- tar_plan(
  tar_target(
    summary_plot,
    plot_summary_stats(summary_stats),
    packages = c("ggplot2", "ggtext")
  ),
  tar_target(
    summary_plot_png,
    ggsave("output/figs/summary_plot.png", summary_plot)
  )
)

list(files, rasters, slopes_small,
     slopes_big,
     data, stats, plot)
