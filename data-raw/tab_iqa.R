## code to prepare `tab_iqa` dataset goes here

arquivos <- list.files(
  "data-raw/xlsx/ugrhi",
  pattern = "IQA",
  full.names = TRUE
)

ler_iqa <- function(x) {
  
  ano_ <- stringr::str_extract(x, "[0-9]{4}")
  
  if (ano_ == 2018) {
    pular <- 2
  } else {
    pular <- 0
  }
  
  readxl::read_excel(x, col_types = "text", skip = pular) |> 
    janitor::clean_names() |> 
    dplyr::mutate(
      dplyr::across(jan:dez, as.numeric)
    ) |> 
    janitor::remove_empty(which = "rows") |>
    dplyr::rename_with(
      .cols = dplyr::any_of("sist_hidrico"),
      .fn = ~ "corpo_hidrico"
    ) |> 
    dplyr::rename_with(
      .cols = dplyr::any_of("nome_do_ponto"),
      .fn = ~ "ponto"
    ) |> 
    tidyr::fill(ugrhi, corpo_hidrico, .direction = "down") |> 
    dplyr::rowwise() |> 
    dplyr::mutate(
      ano = ano_,
      media = mean(dplyr::c_across(jan:dez), na.rm = TRUE)
    ) |> 
    dplyr::select(ano, ugrhi, ponto, corpo_hidrico, jan:dez, media)
  
}

tab_iqa <- purrr::map_dfr(
  arquivos,
  ler_iqa
)

usethis::use_data(tab_iqa, overwrite = TRUE)

writexl::write_xlsx(tab_iqa, "data-raw/xlsx/tab_iqa_completa.xlsx")