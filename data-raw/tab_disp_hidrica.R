## code to prepare `tab_disp_hidrica` dataset goes here

tab <- readxl::read_excel(
  "data-raw/xlsx/planilha disponibilidade hidrica.xlsx",
  skip = 4
) |> 
  dplyr::select(-dplyr::starts_with("...")) |> 
  dplyr::filter(!is.na(ano)) |> 
  dplyr::mutate(dplyr::across(.fns = as.numeric)) |> 
  janitor::clean_names()

usethis::use_data(tab_disp_hidrica, overwrite = TRUE)
