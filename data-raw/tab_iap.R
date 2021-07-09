## code to prepare `tab_iap` dataset goes here

arquivos <- list.files(
  "data-raw/xlsx/ugrhi",
  pattern = "IAP",
  full.names = TRUE
)

ler_iap <- function(x) {
  
  ano_ <- stringr::str_extract(x, "[0-9]{4}")
  
  readxl::read_excel(x, col_types = "text", skip = 0) |> 
    janitor::clean_names() |> 
    dplyr::rename_with(
      .cols = dplyr::any_of("nome_do_ponto"),
      .fn = ~ "ponto"
    ) |>
    dplyr::filter(ponto != "Legenda:") |> 
    dplyr::mutate(
      dplyr::across(jan:dez, as.numeric)
    ) |>
    janitor::remove_empty(which = "rows") |>
    dplyr::rename_with(
      .cols = dplyr::any_of("sist_hidrico"),
      .fn = ~ "corpo_hidrico"
    ) |>
    tidyr::fill(ugrhi, corpo_hidrico, .direction = "down") |>
    dplyr::rowwise() |> 
    dplyr::mutate(
      ano = ano_,
      media = mean(dplyr::c_across(jan:dez), na.rm = TRUE)
    ) |> 
    dplyr::select(ano, ugrhi, ponto, corpo_hidrico, jan:dez, media)
}

tab_iap <- purrr::map_dfr(
  arquivos,
  ler_iap
) |> 
  dplyr::relocate(mar,abr, .after = fev) |> 
  dplyr::relocate(set,out, .after = ago)
  

writexl::write_xlsx(tab_iap, "data-raw/xlsx/tab_iap_completa.xlsx")