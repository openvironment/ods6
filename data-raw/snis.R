## code to prepare `snis` dataset goes here

library(tidyverse)

tab <- readxl::read_excel(
  "data-raw/snis/Desagregado-20201112200130.xlsx",
  skip = 1
)

snis <- tab %>% 
  rename_with(
    .fn = ~str_remove(.x, " - .*") %>%
      str_to_lower() %>% 
      paste0("ind_", .),
    .cols = contains(" - ")
  ) %>% 
  janitor::clean_names() %>% 
  janitor::remove_empty(which = "rows") %>% 
  select(
    munip_cod = codigo_do_municipio,
    ano = ano_de_referencia,
    prestador,
    prestador_sigla = sigla_do_prestador,
    natureza_juridica,
    starts_with("ind")
  ) %>% 
  filter(munip_cod != "TOTAL da AMOSTRA:") %>% 
  mutate(ano = as.numeric(ano)) %>% 
  filter(ano >= 2010) %>% 
  arrange(munip_cod)

usethis::use_data(snis, overwrite = TRUE)
