## code to prepare `ibge` dataset goes here

library(tidyverse)

# Saneamento --------------------------------------------------------------

dados_sidra <- sidrar::get_sidra(
  x = 1394,
  geo = "City",
  geo.filter = list(State = 35),
  classific = c("c11558"),
  format = 3
)

saneamento <- dados_sidra %>% 
  janitor::clean_names() %>% 
  select(
    munip_cod = municipio_codigo,
    munip_nome = municipio,
    ano,
    tipo_de_esgotamento_sanitario,
    valor
  ) %>% 
  mutate(
    tipo_de_esgotamento_sanitario = paste0(
      "sanea_", 
      tipo_de_esgotamento_sanitario
    )
  ) %>%  
  pivot_wider(
    names_from = tipo_de_esgotamento_sanitario,
    values_from = valor
  ) %>% 
  janitor::clean_names() %>% 
  rename(domicilios_total = sanea_total)

# Abastecimento -----------------------------------------------------------

dados_sidra <- sidrar::get_sidra(
  x = 3217,
  geo = "City",
  variable = 96,
  geo.filter = list(State = 35),
  classific = c("c61"),
  format = 3
)

abastecimento <- dados_sidra %>% 
  janitor::clean_names() %>% 
  select(
    munip_cod = municipio_codigo,
    ano,
    forma_de_abastecimento_de_agua,
    valor
  ) %>% 
  mutate(
    forma_de_abastecimento_de_agua = paste0(
      "abast_", 
      forma_de_abastecimento_de_agua
    )
  ) %>% 
  pivot_wider(
    names_from = forma_de_abastecimento_de_agua,
    values_from = valor
  ) %>% 
  janitor::clean_names() %>% 
  select(-abast_total)


# Populacao ---------------------------------------------------------------

dados_sidra <- sidrar::get_sidra(
  x = 200,
  period = "2010",
  geo = "City",
  variable = 93,
  geo.filter = list(State = 35),
  classific = c("c1"),
  format = 3
)

populacao <- dados_sidra %>% 
  janitor::clean_names() %>%
  select(
    munip_cod = municipio_codigo,
    ano,
    situacao_do_domicilio,
    valor
  ) %>% 
  mutate(
    situacao_do_domicilio = paste0(
      "pop_",
      str_to_lower(situacao_do_domicilio)
    )
  ) %>% 
  pivot_wider(
    names_from = situacao_do_domicilio,
    values_from = valor
  ) %>% 
  janitor::clean_names() %>% 
  mutate(across(c(pop_rural, pop_urbana), replace_na, 0))

# Criando base ------------------------------------------------------------

ibge <- saneamento %>% 
  left_join(abastecimento, by = c("munip_cod", "ano")) %>% 
  left_join(populacao, by = c("munip_cod", "ano"))

ibge <- ibge %>% 
  mutate(
    munip_nome = str_remove(munip_nome, " - SP"),
    munip_cod = stringr::str_sub(munip_cod, 1, 6)
  ) %>% 
  rename_with(
    .cols = -c("munip_cod", "munip_nome", "ano"),
    ~paste0(.x, "_2010")
  ) %>% 
  select(-ano)

usethis::use_data(ibge, overwrite = TRUE)
