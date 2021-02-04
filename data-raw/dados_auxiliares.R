## code to prepare `tab_auxiliares` dataset goes here

pkgload::load_all()

municipios <- base_indicadores %>%
  dplyr::pull(munip_nome) %>%
  unique() %>%
  sort()

usethis::use_data(municipios, overwrite = TRUE)


shape_estado <- geobr::read_municipality() %>% 
  dplyr::filter(code_state == 35) %>% 
  dplyr::mutate(
    code_muni = stringr::str_sub(code_muni, 1, 6)
  ) %>% 
  dplyr::select(
    munip_cod = code_muni,
    geom
  ) %>% 
  dplyr::left_join(
    unique(dplyr::select(base_indicadores, munip_cod, munip_nome))
  )

usethis::use_data(shape_estado, overwrite = TRUE)
