# # library(tidyverse)
# # library(httr)
# # library(RSelenium)
#
# # Other -------------------------------------------------------------------
#
# date_access_webresources <- "17.09.2019"
# ex_rate_dollar_euro <- 0.91
#
# eb <- 84
# bb <- 35
# n <- 2023 - 2017
#
# compute_cagr <- function(bb, eb, n) {
#   ((eb / bb)^(1/n)) - 1
# }
#
# # compute_cagr(4.6, 13.9, 2023 - 2017)
# # bb <- 4.6
#
# format_currency <- function(
#   x,
#   nsmall = 0,
#   # curr_unit = character(),
#   curr_unit = "",
#   curr_symbol = "€"
# ) {
#   if (nsmall == 0) {
#     nsmall <- x %>%
#       as.character() %>%
#       stringr::str_split("\\.") %>%
#       unlist() %>% {
#         if (length(.) == 2) {
#           nchar(.[[2]])
#         } else {
#           nsmall
#         }
#       }
#   }
#   x %>%
#     format(big.mark = ".", decimal.mark = ",", nsmall = nsmall) %>%
#     stringr::str_c(stringr::str_glue("{curr_unit}{curr_symbol}"))
# }
# # format_currency(1000)
# # format_currency(1000.50, nsmall = 2)
# # format_currency(1000.50)
#
# format_percentage <- function(x) {
#   `*`(x, 100) %>%
#     as.character() %>%
#     stringr::str_c("%")
# }
# # format_percentage(0.5)
# # format_percentage(0.555)
#
# calc_in_m <- function(
#   in_rate_d = 800,
#   days_per_m = 21.75,
#   # https://www.shiftjuggler.com/blog/berechnung-der-taeglichen-woechentlichen-und-monatlichen-arbeitszeit/
#   utilization = 1.0
# ) {
#   in_rate_d * days_per_m * utilization
# }
#
# calc_out_m <- function(
#   out_salary_m = 0,
#   out_bundle_m = 0
# ) {
#   out_salary_m + out_bundle_m
# }
#
# calc_m <- function(
#   in_m = 800,
#   out_m = 0
# ) {
#   in_m - out_m
# }
#
# # Year -----
# calc_in_y <- function(
#   in_m,
#   months = 12
# ) {
#   in_m * months
# }
#
# calc_out_y <- function(
#   out_m,
#   months = 12
# ) {
#   out_m * months
# }
#
# calc_y <- function(
#   in_m,
#   out_m = 0,
#   out_bundle_y = 0,
#   months = 12
# ) {
#   calc_in_y(in_m = in_m, months = months) -
#     calc_out_y(out_m = out_m, months = months) -
#     out_bundle_y
# }
#
# calc_y_at <- function(
#   total_y,
#   tax_rate_total
# ) {
#   total_y - (total_y * tax_rate_total)
# }
#
# # Globals -----------------------------------------------------------------
#
# .font_size <- "85%"
# gt_tab_options <- list(
#   table.width = gt::pct(100),
#   heading.title.font.size = .font_size,
#   heading.subtitle.font.size = .font_size,
#   column_labels.font.size = .font_size,
#   column_labels.font.weight = .font_size,
#   table.font.size = .font_size,
#   footnote.font.size = .font_size,
#   sourcenote.font.size = .font_size
# )
#
# in_rate_d_2019_true <- 800
# in_rate_d_2019 <- 400
#
# in_rate_d_2020_true <- 1000
# in_rate_d_2020 <- 600
#
# n_cust_2019 <- 1
# n_cust_2020 <- "5 - 8"
#
# # Out -----
# out_salary_m_2019 <- 3000
#
# out_once_laptop_2019 <- 2000
# out_once_monitor_2019 <- 500
# out_once_infra_2019 <- 1000
#
# out_recu_phone_2019 <- 50 * 3.5
# out_recu_tools_2019 <- 100 * 3.5
# out_recu_travel_2019 <- 50 * 3.5
#
# out_recu_m_2019 <- out_recu_phone_2019 +
#   out_recu_tools_2019 +
#   out_recu_travel_2019
#
# out_once_y_2019 <-
#   out_once_laptop_2019 +
#   out_once_monitor_2019 +
#   out_once_infra_2019
#
# utilization_2019 <- 0.5
#
# tax_rate_kst <- 0.1583
# tax_rate_gst <- 0.15
# tax_rate_total <- tax_rate_kst + tax_rate_gst
#
# in_m_2019 <- calc_in_m(
#   in_rate_d = in_rate_d_2019,
#   utilization = 0.5
# )
# out_m_2019 <- calc_out_m(
#   # out_salary_m = out_salary_m_2019
#   out_bundle_m = out_recu_m_2019
# )
#
# m_2019 <- calc_m(
#   in_m = in_m_2019,
#   out_m = out_m_2019
# )
#
# in_y_2019 <- calc_in_y(in_m = in_m_2019, months = 3.5)
# out_y_2019 <- calc_out_y(out_m = out_m_2019, months = 3.5)
#
# y_2019 <- calc_y(
#   in_m = in_m_2019,
#   out_m = out_m_2019,
#   out_bundle_y = out_y_2019 + out_once_y_2019,
#   months = 3.5
# )
#
# y_2019_at <- y_2019 %>%
#   calc_y_at(tax_rate_total = tax_rate_total)
#
# trans_market_share_data <- function(tbl,
#   ex_rate_dollar_euro,
#   val_scope = "Weltweit"
# ) {
#   tbl %>%
#     dplyr::filter(scope == val_scope) %>%
#     tidyr::pivot_longer(cols = starts_with("y"),
#       names_to = "time", values_to = "amount") %>%
#     # View()
#     dplyr::mutate(
#       amount_euro = dplyr::case_when(
#         curr == "dollar" ~ amount * ex_rate_dollar_euro,
#         curr == "euro" ~ amount
#       ),
#       time = time %>% stringr::str_remove_all("^y")
#     ) %>%
#     dplyr::select(
#       source,
#       keyword,
#       # scope,
#       time,
#       amount_euro,
#       cagr,
#       url
#     )
# }
