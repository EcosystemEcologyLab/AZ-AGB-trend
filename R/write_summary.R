write_summary <- function(summary_stats, path = "output/slope_summary.csv") {
  write_csv(summary_stats, path )
  path
}