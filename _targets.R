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
library(crew.cluster)

# Detect whether you're on HPC & not with an Open On Demand session (which cannot submit SLURM jobs) and set appropriate controller
slurm_host <- Sys.getenv("SLURM_SUBMIT_HOST")
hpc <- grepl("hpc\\.arizona\\.edu", slurm_host) & !grepl("ood", slurm_host)
# If on HPC, use SLURM jobs for parallel workers

controller_light <- crew.cluster::crew_controller_slurm(
  name = "hpc_light",
  workers = 4,
  seconds_idle = 300, # time until workers are shut down after idle
  garbage_collection = TRUE, # run garbage collection between tasks
  launch_max = 5L, # number of unproductive launched workers until error
  slurm_partition = "standard",
  slurm_time_minutes = 1200, #wall time for each worker
  slurm_log_output = "logs/crew_log_%A.out",
  slurm_log_error = "logs/crew_log_%A.err",
  slurm_memory_gigabytes_per_cpu = 5,
  slurm_cpus_per_task = 4, #total 20gb RAM
  script_lines = c(
    "#SBATCH --account davidjpmoore",
    "module load gdal/3.8.5 R/4.3 eigen/3.4.0 netcdf/4.7.1"
    #add additional lines to the SLURM job script as necessary here
  )
)

controller_heavy <- crew.cluster::crew_controller_slurm(
  name = "hpc_heavy",
  workers = 4,
  seconds_idle = 300, # time until workers are shut down after idle
  garbage_collection = TRUE, # run garbage collection between tasks
  launch_max = 5L, # number of unproductive launched workers until error
  slurm_partition = "standard",
  slurm_time_minutes = 1200, #wall time for each worker
  slurm_log_output = "logs/crew_log_%A.out",
  slurm_log_error = "logs/crew_log_%A.err",
  slurm_memory_gigabytes_per_cpu = 32,
  slurm_cpus_per_task = 2, # total 64gb RAM
  script_lines = c(
    "#SBATCH --account davidjpmoore",
    "#SBATCH --constraint=hi_mem", #use high-memory nodes
    "module load gdal/3.8.5 R/4.3 eigen/3.4.0 netcdf/4.7.1"
    #add additional lines to the SLURM job script as necessary here
  )
)

controller_local <- 
  crew::crew_controller_local(name = "local", workers = 2, seconds_idle = 60)

# Set target options:
tar_option_set(
  packages = c("ncdf4", "terra", "fs", "purrr", "ncdf4", "car"), # Packages that your targets need for their tasks.
  controller = crew_controller_group(controller_local, controller_heavy, controller_light),
  #if on HPC use "hpc_light" controller by default, otherwise use "local"
  resources = tar_resources(
    crew = tar_resources_crew(controller = ifelse(hpc, "hpc_light", "local"))
  )
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
  tar_terra_rast(chopping_agb, read_clean_chopping(chopping_file, az)),
  tar_terra_rast(xu_agb, read_clean_xu(xu_file, az)),
  tar_terra_rast(liu_agb, read_clean_liu(liu_file, az)),
  tar_terra_rast(
    esa_agb, 
    read_clean_esa(esa_files, az),
    resources = tar_resources(
      crew = tar_resources_crew(controller = "hpc_heavy")
    )
  ),
  tar_terra_rast(
    ltgnn_agb,
    read_clean_ltgnn(ltgnn_files, az),
    resources = tar_resources(
      crew = tar_resources_crew(controller = "hpc_heavy")
    )
  )
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
    #only some of these need high memory nodes, but not sure how to specify that when written in tar_map()
    tar_terra_rast(
      slope, 
      calc_slopes(product),
      resources = tar_resources(
        crew = tar_resources_crew(controller = "hpc_heavy")
      )
    ),
    # Then plot the slopes and export a .png
    tar_target(
      slope_plot,
      plot_slopes(slope, target_name = name, region = az),
      #packages only needed for plotting step:
      packages = c("ggplot2", "tidyterra", "colorspace", "dplyr", "stringr", "ggtext")
    )
  )
)


list(files, rasters, slopes)
