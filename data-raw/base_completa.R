## code to prepare `base_completa` dataset goes here

devtools::load_all()

base_completa <- seade %>% 
  dplyr::left_join(snis, by = c("munip_cod", "ano")) %>% 
  dplyr::left_join(ibge, by = c("munip_cod")) %>% 
  dplyr::left_join(idh, by = c("munip_cod")) %>% 
  dplyr::filter(ano <= 2018) %>% 
  dplyr::relocate(
    dplyr::starts_with("munip"),
    ano
  )

writexl::write_xlsx(base_completa, "data-raw/base_completa.csv")
writexl::write_xlsx(base_completa, "data-raw/base_completa.xlsx")

usethis::use_data(base_completa, overwrite = TRUE)
