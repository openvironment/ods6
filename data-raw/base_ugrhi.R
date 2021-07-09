## code to prepare `base_ugrhi` dataset goes here

devtools::load_all()

tab_nomes <- readxl::read_excel(
  "data-raw/xlsx/ugrhi/Planilha Modelo.xlsx",
  skip = 1
) |> 
  janitor::clean_names() |> 
  dplyr::select(ugrhi, nome) |> 
  dplyr::mutate(ugrhi = as.character(ugrhi))

base_ugrhi <- tab_iap |> 
  dplyr::select(-(jan:dez), iap = media) |> 
  dplyr::full_join(
   dplyr::select(tab_iqa, -(jan:dez), -corpo_hidrico, iqa = media),
    by = c("ano", "ugrhi", "ponto")
  ) |> 
  dplyr::full_join(
    dplyr::select(tab_iva, -(jan:dez), -corpo_hidrico, iva = media),
    by = c("ano", "ugrhi", "ponto")
  ) |> 
  dplyr::group_by(ugrhi, ano) |> 
  dplyr::summarise(
    dplyr::across(c(iqa, iap, iva), mean, na.rm = TRUE)
  ) |> 
  dplyr::ungroup() |> 
  dplyr::left_join(tab_nomes, by = "ugrhi") |> 
  dplyr::relocate(nome, .after = ugrhi) |> 
  dplyr::arrange(as.numeric(ugrhi), ano)

usethis::use_data(base_ugrhi, overwrite = TRUE)

writexl::write_xlsx(base_ugrhi, "data-raw/xlsx/base_ugrhi.xlsx")

base_ugrhi |> 
  dplyr::select(-iap, -iva) |> 
  tidyr::pivot_wider(
    names_from = ano,
    values_from = iqa
  ) |> 
  writexl::write_xlsx("data-raw/xlsx/tab_iqa.xlsx")

base_ugrhi |> 
  dplyr::select(-iqa, -iva) |> 
  tidyr::pivot_wider(
    names_from = ano,
    values_from = iap
  ) |> 
  writexl::write_xlsx("data-raw/xlsx/tab_iap.xlsx")

base_ugrhi |> 
  dplyr::select(-iap, -iqa) |> 
  tidyr::pivot_wider(
    names_from = ano,
    values_from = iva
  ) |> 
  writexl::write_xlsx("data-raw/xlsx/tab_iva.xlsx")



