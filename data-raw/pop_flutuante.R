## code to prepare `pop_flutuante` dataset goes here

texto_pdf <- tabulizer::extract_text(
  file = "data-raw/pdf/popflutuante.pdf",
  pages = 8
)

pop_flutuante <- texto_pdf %>% 
  stringr::str_extract("Operados pela Sabesp(.|\\n)*") %>% 
  stringr::str_remove_all("[0-9.]") %>% 
  stringr::str_remove("\\nObs (.|\\n)*") %>% 
  stringr::str_split("\\n") %>% 
  purrr::set_names("munip_nome") %>% 
  tibble::as_tibble() %>% 
  dplyr::mutate(
    munip_nome = stringr::str_squish(munip_nome)
  ) %>% 
  dplyr::filter(
    munip_nome != "",
    !munip_nome %in% c("Não Operados", "Operados pela Sabesp")
  ) %>% 
  dplyr::mutate(
    munip_nome_sem = munip_nome %>% 
      abjutils::rm_accent() %>% 
      stringr::str_to_lower() %>% 
      stringr::str_replace_all(" ", "_")
  )
  
usethis::use_data(pop_flutuante, overwrite = TRUE)

