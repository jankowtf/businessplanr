renv::activate()
renv::install("devtools")
renv::install("rstudio/config")
renv::install("stringr")
renv::install("dplyr")
usethis::use_package("magrittr")

get_config("column_names:col_group")
get_config("column_names")

config::get("column_names")
# $col_id
# [1] "id"
#
# $col_value
# [1] "value"

config::get("column_orders")
# $data_structure_a
# [1] "column_names/col_id"    "column_names/col_value"
#
# $data_structure_b
# [1] "column_names/col_value" "column_names/col_id"

config::get("column_names:col_id")

config::get("column_orders/data_structure_a")

get_config <- function(value, sep = ":") {
  if (value %>% stringr::str_detect(sep)) {
    value <- value %>% stringr::str_replace(sep, ".")
    configs <- config::get() %>% unlist()
    configs[value]
  } else {
    config::get(value)
  }
}

get_config("column_names")
# $col_id
# [1] "id"
#
# $col_value
# [1] "value"

get_config("column_names:col_id")
# column_names.col_id
# "id"

get_config("column_orders:data_structure_a")
# <NA>
#   NA

config::get() %>% unlist()
# column_names.col_id          column_names.col_value
# "id"                         "value"
# column_orders.data_structure_a1 column_orders.data_structure_a2
# "column_names/col_id"        "column_names/col_value"
# column_orders.data_structure_b1 column_orders.data_structure_b2
# "column_names/col_value"           "column_names/col_id"
