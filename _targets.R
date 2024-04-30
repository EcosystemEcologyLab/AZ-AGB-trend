# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(geotargets)
library(rlang)

# Set target options:
tar_option_set(
  packages = c("ncdf4", "terra", "fs", "purrr", "ncdf4", "car"), # Packages that your targets need for their tasks.
  controller = crew::crew_controller_local(workers = 2, seconds_idle = 60)
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# tar_source("other_functions.R") # Source other scripts as needed.

# Track files
files <- tar_plan(
  tar_file(esa_files, dir_ls("data/ESA_CCI/", glob = "*.tif*")),
  tar_file(chopping_file, "data/Chopping/MISR_agb_estimates_20002021.tif"),
  tar_file(liu_file, "data/Liu/Aboveground_Carbon_1993_2012.nc"),
  tar_file(xu_file, "data/Xu/test10a_cd_ab_pred_corr_2000_2019_v2.tif"),
  tar_file(ltgnn_files, fs::dir_ls("data/LT_GNN", glob = "*.zip")),
  tar_terra_vect(az, get_az())
)

rasters <- tar_plan(
  tar_terra_rast(chopping_agb, read_clean_chopping(chopping_file, az)),
  tar_terra_rast(xu_agb, read_clean_xu(xu_file, az)),
  tar_terra_rast(liu_agb, read_clean_liu(liu_file, az)),
  tar_terra_rast(esa_agb, read_clean_esa(esa_files, az)),
  tar_terra_rast(ltgnn_agb, read_clean_ltgnn(ltgnn_files, az))
)

slopes <- tar_plan(
  tar_map(
    #for each data product
    values = list(product = syms(c(
      "chopping_agb", "xu_agb", "liu_agb", "esa_agb", "ltgnn_agb"
    )),
    name = c("chopping_agb", "xu_agb", "liu_agb", "esa_agb", "ltgnn_agb")
    ),
    #calculate slopes
    tar_terra_rast(
      slope,
      calc_slopes(product)
    ),
    # Then plot the slopes and export a .png
    tar_target(
      slope_plot,
      plot_slopes(slope, target_name = name, region = az),
      #packages only needed for plotting step:
      packages = c("ggplot2", "tidyterra", "colorspace", "dplyr", "stringr", "ggtext", "magick")
    )
  )
)

# TODO plot a multipanel figure with common colorbar legend using
# plot_slopes_all(). Or maybe don't since they're all different time periods and
# it doesn't make sense to compare them that way?

list(files, rasters, slopes)
