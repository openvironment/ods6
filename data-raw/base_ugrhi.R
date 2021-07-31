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
  dplyr::arrange(as.numeric(ugrhi), ano) |> 
  dplyr::mutate(
    iqa_label = dplyr::case_when(
      iqa <= 19 ~ "Péssimo",
      iqa <= 36 ~ "Ruim",
      iqa <= 51 ~ "Regular",
      iqa <= 79 ~ "Bom",
      TRUE ~ "Ótimo"
    ),
    iap_label = dplyr::case_when(
      iap <= 19 ~ "Péssimo",
      iap <= 36 ~ "Ruim",
      iap <= 51 ~ "Regular",
      iap <= 79 ~ "Bom",
      TRUE ~ "Ótimo"
    ),
    iva_label = dplyr::case_when(
      iva <= 2.5 ~ "Ótimo",
      iva <= 3.3 ~ "Bom",
      iva <= 4.5 ~ "Regular",
      iva <= 6.7 ~ "Ruim",
      TRUE ~ "Péssimo"
    ),
    iqa = round(iqa),
    iap = round(iap),
    iva = round(iva, 1)
  )

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



