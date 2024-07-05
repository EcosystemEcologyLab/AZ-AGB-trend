# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(geotargets)
library(rlang) #for syms()
library(crew)
library(quarto) #only required for rendering reports

# Set up a "controller" for parallelization of tasks.  Here I'm using a max of 4 concurrent workers.
controller_local <- 
  crew::crew_controller_local(
    name = "local", 
    workers = 4, # max workers
    seconds_idle = 60, # how long a worker can be doing nothing before it is shut down
    local_log_directory = "logs"
  )

# Set target options:
tar_option_set(
  packages = c("ncdf4", "terra", "fs", "purrr", "car", "dplyr"), # Packages that your targets need for their tasks.
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

#use local data in this project
# root <- "data"

#use data on mounted "snow" drive (super slow and not advisable)
root <- "/Volumes/moore/"

inputs <- tar_plan(
  # create shapefiles for southwest
  tar_file_fast(file_az, "data/azboundary.geojson"),
  tar_terra_vect(az, terra::vect(file_az)),
  tar_file_fast(dir_pima, "data/Pima_County_Boundary/"),
  tar_terra_vect(pima, terra::vect(dir_pima)),
  tar_file_fast(file_forest, "data/USFS_Southwestern_Region_3_-_Administrative_Forest_Boundaries.geojson"),
  tar_terra_vect(forest, read_az_landuse(file_forest, az)),
  #TODO there are different types of wilderness designation that might be of
  #interest and this might need to be split into multiple vectors
  tar_file_fast(file_wilderness, "data/USFS_Southwestern_Region_3_-_Wilderness_Status.geojson"),
  tar_terra_vect(wilderness, read_az_landuse(file_wilderness, az)),
  tar_file_fast(file_grazing, "data/allot_-2546361503834281186.geojson"),
  tar_terra_vect(grazing, read_az_landuse(file_grazing, az)),
  
  # Track raster files 
  tar_file_fast(file_xu,       fs::path(root, "AGB_cleaned/xu/xu_2000-2029.tif")),
  tar_file_fast(file_liu,      fs::path(root, "AGB_cleaned/liu/liu_1993-2012.tif")),
  tar_file_fast(file_menlove,  fs::path(root, "AGB_cleaned/menlove/menlove_2009-2019.tif")),
  tar_file_fast(file_gedi,     fs::path(root, "AGB_cleaned/gedi/gedi_2019-2023.tif")),
  tar_file_fast(file_chopping, fs::path(root, "AGB_cleaned/chopping/chopping_2000-2021.tif")),
  tar_file_fast(dir_esa,       fs::path(root, "AGB_cleaned/esa_cci/")),
  tar_file_fast(dir_ltgnn,     fs::path(root, "AGB_cleaned/lt_gnn/")),
  
  # Read in rasters (all layers for now)
  tar_terra_rast(agb_xu, read_agb(file_xu, az)),
  tar_terra_rast(agb_liu, read_agb(file_liu, az)),
  tar_terra_rast(agb_menlove, read_agb(file_menlove, az)),
  tar_terra_rast(agb_gedi, read_agb(file_gedi, az)),
  tar_terra_rast(agb_chopping, read_agb(file_chopping, az)),
  tar_terra_rast(agb_esa, read_agb(dir_esa, az)),
  tar_terra_rast(agb_ltgnn, read_agb(dir_ltgnn, az))
)

# Calculate trends in AGB
slopes_small <- tar_plan(
  tar_map(#for each data product
    values = list(
      product = syms(c("agb_xu", "agb_liu"))
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

# for high resolution data products, need to break into tiles and do
# computations by tile to not run out of memory
slopes_big <- tar_plan(
  tar_map(# for each data product
    values = list(
      product = syms(c("agb_esa", "agb_chopping", "agb_ltgnn"))
    ),
    # split into tiles on disk
    tar_target(
      tiles,
      make_tiles(product),
    ),
    # track the resulting files
    tar_target(
      tiles_files,
      tiles,
      pattern = map(tiles),
      format = "file"
    ),
    # iterate over files to read them in and calculate slopes
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

# Calculate summary stats for each slope raster
data <- tar_plan(
  tar_map(#for each raster * subset combination
    values = tidyr::expand_grid(
      rasters = syms(c(
        "slope_agb_liu", "slope_agb_xu",
        "slope_agb_esa", "slope_agb_chopping", "slope_agb_ltgnn"
      )),
      subsets = syms(c(
        "az", "forest", "wilderness", "grazing"
      ))
    ),
    #get summary stats
    tar_target(
      summary,
      summarize_slopes(rasters, subsets)
    )
  )
)

# Combine all the summary stats into one dataframe
stats <- tar_plan(
  tar_combine(
    summary_stats,
    data,
    command = dplyr::bind_rows(!!!.x) |> 
      arrange(subset, product)
  ),
  tar_file(
    summary_stats_csv,
    write_summary(summary_stats),
    packages = c("readr")
  )
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
    ggsave("output/figs/summary_plot.png", summary_plot, bg = "white"),
    format = "file"
  )
)

# Render .Qmd documents
render <- tar_plan(
  tar_quarto(readme, "README.qmd"),
  tar_quarto(report, "docs/index.qmd")
)

#_targets.R must end with a list of targets.  They can be arbitrarily nested
list(inputs,
     slopes_small,
     slopes_big,
     data,
     stats,
     plot,
     render)
