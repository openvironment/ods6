## code to prepare `tab_iva` dataset goes here

arquivos <- list.files(
  "data-raw/xlsx/ugrhi",
  pattern = "IVA",
  full.names = TRUE
)

ler_iva <- function(x) {
  
  ano_ <- stringr::str_extract(x, "[0-9]{4}")
  
  readxl::read_excel(x, col_types = "text", skip = 0) |> 
    janitor::clean_names() |> 
    dplyr::rename_with(
      .cols = dplyr::any_of("nome_do_ponto"),
      .fn = ~ "ponto"
    ) |>
    dplyr::rename_with(
      .cols = dplyr::any_of("ughri"),
      .fn = ~ "ugrhi"
    ) |>
    dplyr::filter(ponto != "Legenda:") |>
    dplyr::mutate(
      dplyr::across(
        jan:dez,
        ~stringr::str_remove_all(.x, "\\*")
      ),
      dplyr::across(
        jan:dez,
        ~stringr::str_replace(.x, ",", "\\.")
      ),
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
    dplyr::select(ano, ugrhi, ponto, corpo_hidrico, jan:dez, media) |>
    dplyr::ungroup()
  
}

tab_iva <- purrr::map_dfr(
  arquivos,
  ler_iva
)

usethis::use_data(tab_iva, overwrite = TRUE)

writexl::write_xlsx(tab_iva, "data-raw/xlsx/tab_iva_completa.xlsx")
