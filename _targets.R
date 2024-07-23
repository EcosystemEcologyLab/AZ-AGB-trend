# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes)
library(geotargets) #dev version for tar_terra_tiles()
library(rlang) #for syms()
library(crew)
library(quarto) #only required for rendering reports

# Set up a "controller" for parallelization of tasks.  Here I'm using a max of 4 concurrent workers.
controller_local <- 
  crew::crew_controller_local(
    name = "local", 
    workers = 3, # max workers
    seconds_idle = 60, # how long a worker can be doing nothing before it is shut down
    local_log_directory = "logs"
  )

# Use d:// drive for targets store so all have access
# TODO: this doesn't work and also might not be a good idea because different
# people using the same _targets/ store will cause race conditions and
# overwriting of work.  Versioned S3 bucket is a better way to go for this.
# tar_config_set(
#   store = "d://targets_stores/AZ-AGB-trend/_targets"
# )

# Set target options:
tar_option_set(
  packages = c("ncdf4", "terra", "geotargets", "fs", "purrr", "car", "dplyr", "exactextractr", "sf"), # Packages that your targets need for their tasks.
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

## use data on mounted "snow" drive 
## (reading files dircetly from snow is quite slow for me working from home over
## the VPN, and I prefer to just copy them to my hard drive)
# root <- "/Volumes/moore/"

#use local data in this project
root <- "d://"

# Inputs ------------------------------------------------------------------
targets_inputs <- tar_plan(
  # create shapefiles for southwest
  tar_file_fast(file_az, path(root, "shapefiles/az_border/azboundary.geojson")),
  tar_terra_vect(az, terra::vect(file_az)),
  tar_file_fast(dir_pima, path(root, "shapefiles/pima_county/Pima_County_Boundary.geojson")),
  tar_terra_vect(pima, terra::vect(dir_pima)),
  tar_file_fast(file_forest, path(root, "shapefiles/sw_forest/R03_AdministrativeForest_-2750697026511621369/AdministrativeForest.shp")),
  tar_terra_vect(forest, read_az_landuse(file_forest, az)),
  tar_file_fast(file_wilderness, path(root, "shapefiles/sw_wilderness/R03_WildernessStatus_2471728660373494475/Wilderness.shp")),
  #currently subsets to just national wilderness
  tar_terra_vect(wilderness, read_az_wilderness(file_wilderness, az)),
  tar_file_fast(file_grazing, path(root, "shapefiles/sw_grazing/allot_-2546361503834281186.geojson")),
  tar_terra_vect(grazing, read_az_landuse(file_grazing, az)),
  
  # Track raster files 
  tar_file_fast(file_xu,       fs::path(root, "AGB_cleaned/xu/xu_2000-2029.tif")),
  tar_file_fast(file_liu,      fs::path(root, "AGB_cleaned/liu/liu_1993-2012.tif")),
  tar_file_fast(file_menlove,  fs::path(root, "AGB_cleaned/menlove/menlove_2009-2019.tif")),
  tar_file_fast(file_gedi,     fs::path(root, "AGB_cleaned/gedi/gedi_2019-2023.tif")),
  tar_file_fast(file_chopping, fs::path(root, "AGB_cleaned/chopping/chopping_2000-2021.tif")),
  
  # These are tiles
  tar_file_fast(dir_esa,       fs::path(root, "AGB_cleaned/esa_cci/")),
  tar_file_fast(dir_ltgnn,     fs::path(root, "AGB_cleaned/lt_gnn/")),
  
  
  # Read in rasters (all layers for now)
  tar_terra_rast(agb_xu, read_agb(file_xu, az)),
  tar_terra_rast(agb_liu, read_agb(file_liu, az)),
  tar_terra_rast(agb_chopping, read_agb(file_chopping, az)),
  tar_terra_rast(agb_esa, read_agb(dir_esa, az)),
  tar_terra_rast(agb_ltgnn, read_agb(dir_ltgnn, az)),
  
)


# Yearly summary stats ----------------------------------------------------

target_yearly <- tar_plan(
  tar_map(
    values = tidyr::expand_grid(
      product = syms(c("agb_esa", "agb_xu", "agb_liu", "agb_chopping", "agb_ltgnn")),
      subset = syms(c("az", "forest", "wilderness", "grazing", "pima"))
    ),
    tar_target(
      summary,
      summarize_yearly(product, subset)
    )
  )
)

target_yearly_summary <- tar_plan(
  tar_combine(
    summary_yearly,
    target_yearly, #all the targets defined above
    command = dplyr::bind_rows(!!!.x) |> 
      arrange(subset, product)
  ),
  tar_file(
    summary_yearly_csv,
    tar_write_csv(summary_yearly, "output/yearly/yearly_summary.csv")
  )
)

# Averages ----------------------------------------------------------------
target_averages <- tar_plan(
  # These products just have one layer that is an average over time
  tar_terra_rast(avg_menlove, read_agb(file_menlove, az)),
  tar_terra_rast(avg_gedi, read_agb(file_gedi, az)),
  
  # These need to be calculated
  tar_terra_rast(avg_esa, mean(agb_esa, na.rm = TRUE)),
  tar_terra_rast(avg_xu, mean(agb_xu, na.rm = TRUE)),
  tar_terra_rast(avg_liu, mean(agb_liu, na.rm = TRUE)),
  tar_terra_rast(avg_chopping, mean(agb_chopping, na.rm = TRUE)),
  tar_terra_rast(avg_ltgnn, mean(agb_ltgnn, na.rm = TRUE))
)

target_avg_maps <- tar_plan(
  tar_map(
    values = list(
      product = syms(c("avg_menlove", "avg_gedi", "avg_esa", "avg_xu", "avg_liu", "avg_chopping", "avg_ltgnn"))
    ),
    tar_file(
      map,
      plot_avg_map(product, az),
      packages = c("ggplot2", "tidyterra", "colorspace", "stringr", "ggtext")
    )
  )
)

target_avg_summary <- tar_plan(
  tar_map(
    values = tidyr::expand_grid(
      avg_products = syms(c("avg_menlove", "avg_gedi", "avg_esa", "avg_xu", "avg_liu", "avg_chopping", "avg_ltgnn")),
      subsets = syms(c("az", "forest", "wilderness", "grazing", "pima"))
    ),
    tar_target(
      summary,
      summarize_means(avg_products, subsets)
    )
  )
)

target_avg_summary_combine <- tar_plan(
  tar_combine(
    summary_avg,
    target_avg_summary, #all the targets defined above
    command = dplyr::bind_rows(!!!.x) |> 
      arrange(subset, product)
  ),
  tar_file(
    summary_avg_csv,
    tar_write_csv(summary_avg, "output/average/average_summary.csv"),
    packages = c("readr")
  )
)
# Slopes ------------------------------------------------------------------
# Calculate trends in AGB
# Only some products have multiple layers, so only those are included in these targets
targets_slopes <- tar_plan(
  tar_terra_rast(slope_xu, calc_slopes(agb_xu)),
  tar_terra_rast(slope_liu, calc_slopes(agb_liu)),
  
  #for higher res products, split into a few tiles for dynamic branching
  tar_terra_tiles(tiles_agb_chopping, raster = agb_chopping, ncol = 3, nrow = 4),
  tar_terra_rast(
    tiles_slope_chopping,
    calc_slopes(tiles_agb_chopping),
    iteration = "list",
    pattern = map(tiles_agb_chopping)
  ), 
  tar_terra_rast(slope_chopping, merge(sprc(tiles_slope_chopping)), description = "recombine tiles"),
  
  tar_terra_tiles(tiles_agb_esa, raster = agb_esa, ncol = 3, nrow = 3),
  tar_terra_rast(
    tiles_slope_esa,
    calc_slopes(tiles_agb_esa),
    iteration = "list",
    pattern = map(tiles_agb_esa)
  ),
  tar_terra_rast(slope_esa, merge(sprc(tiles_slope_esa)), description = "recombine tiles"),
  
  tar_terra_tiles(tiles_agb_ltgnn, raster = agb_ltgnn, ncol = 6, nrow = 6),
  tar_terra_rast(
    tiles_slope_ltgnn,
    calc_slopes(tiles_agb_ltgnn),
    iteration = "list",
    pattern = map(tiles_agb_ltgnn)
  ),
  tar_terra_rast(slope_ltgnn, merge(sprc(tiles_slope_ltgnn)), description = "recombine tiles")
)

targets_slope_plots <- tar_plan(
  tar_map(
    values = list(
      product = syms(c(
        "slope_xu", "slope_liu",
        "slope_esa", "slope_chopping", "slope_ltgnn"
      ))
    ),
    tar_file(
      plot,
      plot_slopes(product, az),
      packages = c("ggplot2", "tidyterra", "colorspace", "stringr", "ggtext"),
      garbage_collection = TRUE
    )
  )
)

targets_slope_summary <- tar_plan(
  tar_map(#for each raster * subset combination
    values = tidyr::expand_grid(
      rasters = syms(c(
        "slope_liu", "slope_xu",
        "slope_esa", "slope_chopping", "slope_ltgnn"
      )),
      subsets = syms(c(
        "az", "forest", "wilderness", "grazing", "pima"
      ))
    ),
    #get summary stats
    tar_target(
      summary,
      summarize_slopes(rasters, subsets)
    )
  )
)

targets_slope_summary_combine <- tar_plan(
  tar_combine(
    summary_slope,
    targets_slope_summary, #combine all the targets defined above in slope_summary
    command = dplyr::bind_rows(!!!.x) |> 
      arrange(subset, product)
  ),
  tar_file(
    summary_slope_csv,
    tar_write_csv(summary_slope, "output/slopes/slopes_summary.csv"),
    packages = c("readr")
  )
)
 
# # plot summary statistics
targets_slope_summary_plot <- tar_plan(
  tar_target(
    summary_slope_plot,
    plot_summary_stats(summary_slope),
    packages = c("ggplot2", "ggtext")
  ),
  tar_file(
    summary_slope_plot_png,
    ggplot2::ggsave("output/slopes/figs/summary_plot.png", summary_slope_plot, bg = "white")
  )
)

# Product comparison ------------------------------------------------------

# re-project to common CRS and resolution and calculate pixel-wise standard
# deviation across products to get a sense of how variation ("disagreement")
# varies spatially


# # Render .Qmd documents
render <- tar_plan(
  tar_quarto(readme, "README.qmd"),
  # tar_quarto(report, "docs/index.qmd")
)

#_targets.R must end with a list of targets.  They can be arbitrarily nested
list(
  targets_inputs,
  
  target_yearly,
  target_yearly_summary,
  
  target_averages,
  target_avg_summary,
  target_avg_summary_combine,
  target_avg_maps,
  
  targets_slopes,
  targets_slope_plots,
  targets_slope_summary,
  targets_slope_summary_combine,
  targets_slope_summary_plot,
  
  render
)
