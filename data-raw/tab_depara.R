## code to prepare `tab_depara` dataset goes here

tab_depara <- readxl::read_excel("data-raw/xlsx/base_dicionario_vars.xlsx")

usethis::use_data(tab_depara, overwrite = TRUE)
