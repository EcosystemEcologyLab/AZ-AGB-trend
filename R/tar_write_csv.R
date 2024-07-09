#wrapper around readr::write_csv that returns the file path so it works with tar_file()
tar_write_csv <- function(x, file, ...) {
  fs::dir_create(fs::path_dir(file))
  readr::write_csv(x, file)
  file
}