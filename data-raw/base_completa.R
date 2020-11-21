## code to prepare `base_completa` dataset goes here

devtools::load_all()

tab_2010 <- ibge %>% 
  dplyr::mutate(ano = 2010) %>% 
  dplyr::select(
    munip_cod,
    ano,
    proj_pop_urbana = pop_urbana_2010,
    proj_pop_rural = pop_rural_2010,
    proj_pop_total = pop_total_2010,
    proj_domicilios_total = domicilios_total_2010
  )

base_completa <- seade %>% 
  dplyr::bind_rows(tab_2010) %>% 
  dplyr::arrange(munip_cod, ano) %>% 
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
