get_config <- function(value, sep = ":") {
  if (value %>% stringr::str_detect(sep)) {
    value <- value %>% stringr::str_replace(sep, ".")
    configs <- config::get() %>% unlist()
    configs[value]
  } else {
    config::get(value)
  }
}

if (FALSE) {
  # https://stackoverflow.com/questions/41573995/processing-arbitrary-hierarchies-recursively-with-purrr
  # URL <- paste0(
  #   "https://cdn.rawgit.com/christophergandrud/networkD3/",
  #   "master/JSONdata//flare.json")
  #
  # flare <- jsonlite::fromJSON(URL, simplifyDataFrame = FALSE)
  #
  # library(purrr)
  # prune_2 <- function(tree) {
  #   # print(tree$name)
  #   # print(map_lgl(tree$children, ~ "size" %in% names(.x)))
  #   tree$children %<>%
  #     map_if(~ "children" %in% names(.x), prune_2) %>%
  #     discard(~ if ("size" %in% names(.x)) .x$size < 5000 else FALSE)
  #   tree
  # }
  # pruned_2 <- prune_2(flare)
  # identical(pruned, pruned_2)

  get_config_inner <- function(lst, value) {
    value <- stringr::str_split(value, ":") %>% unlist()
    value %<>%
      purrr::map_if(~.x %in% names(lst), get_config_inner)
  }

}
