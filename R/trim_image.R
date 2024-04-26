#useful for cropping exess whitespace in fixed aspect ratio plots saved by ggsave()
#' @param file file path to image
#' @param buffer_size size, in pixels, of border to add back after trimming image
#' @param buffer_color color of border added back after trimming image
#' @examples
#' trim_image("docs/fig/agb_map.png")
#' 
trim_image <- function(file, buffer_size = 20, buffer_color = "white") {
  magick::image_read(file) |> 
    magick::image_trim() |> 
    magick::image_border(color = buffer_color, geometry = glue::glue("{buffer_size}x{buffer_size}")) |> 
    magick::image_write(file)
}