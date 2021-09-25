## code to prepare `base_ugrhi` dataset goes here

devtools::load_all()

tab_nomes <- readxl::read_excel(
  "data-raw/xlsx/ugrhi/Planilha Modelo.xlsx",
  skip = 1
) |> 
  janitor::clean_names() |> 
  dplyr::select(ugrhi, nome) |> 
  dplyr::mutate(
    ugrhi = as.character(ugrhi)
  )

tab_munip <- foreign::read.dbf("data-raw/dbf/munic_bacias.dbf") |> 
  janitor::clean_names() |> 
  tibble::as_tibble() |> 
  dplyr::distinct(cod_ugrhi, codigo) |> 
  dplyr::mutate(codigo = stringr::str_sub(codigo, 1, 6))

tab_pop <- base_indicadores |> 
  dplyr::select(ano, codigo = munip_cod, pop = proj_pop_total) |> 
  dplyr::left_join(
    tab_munip,
    by = "codigo"
  ) |> 
  dplyr::group_by(ano, codigo) |> 
  dplyr::mutate(
    n = dplyr::n(),
    pop = pop / n
  ) |> 
  dplyr::group_by(ano, ugrhi = cod_ugrhi) |> 
  dplyr::summarise(
    pop = sum(pop)
  ) |> 
  dplyr::ungroup()

tab_disp <- readxl::read_excel(
  "data-raw/xlsx/planilha disponibilidade hidrica.xlsx",
  skip = 4
) |> 
  dplyr::select(-dplyr::starts_with("...")) |> 
  dplyr::filter(!is.na(ano)) |> 
  janitor::clean_names() |> 
  dplyr::mutate(
    dplyr::across(.fns = as.numeric),
    ugrhi = as.character(ugrhi)
  )

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
    dplyr::across(c(iqa, iap, iva), mean, na.rm = TRUE),
    .groups = "drop"
  ) |> 
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
    iva = round(iva, 1),
    ano = as.numeric(ano)
  ) |> 
  dplyr::left_join(tab_disp, by = c("ano", "ugrhi")) |> 
  dplyr::left_join(tab_pop, by = c("ano", "ugrhi")) |> 
  dplyr::mutate(
    demanda_per_capita = qmedio / pop / (1 / 60 / 60 / 24 / 365)
  )


usethis::use_data(base_ugrhi, overwrite = TRUE)

writexl::write_xlsx(base_ugrhi, "data-raw/xlsx/base_ugrhi.xlsx")
readr::write_csv(base_ugrhi, "data-raw/csv/base_ugrhi.csv")

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



