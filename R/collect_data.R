collect_data <- function(...) {
  names <- as.character(rlang::ensyms(...))
  list2(...) |> 
    set_names(names) |> 
    purrr::map(\(x) {
      tidyterra::as_tibble(x, xy = TRUE, na.rm = TRUE)
    }) |> 
    list_rbind(names_to = "product") |> 
    #clean up product column
    dplyr::mutate(product = stringr::str_match(product, "slope_(.+)_agb")[,2])
}


