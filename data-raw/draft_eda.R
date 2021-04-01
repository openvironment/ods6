devtools::load_all()
library(tidyverse)

cidade <- "São Paulo"

tab <- base_indicadores %>% 
  filter(munip_nome == cidade)

# tab %>% 
#   ggplot(aes(x = ano, y = taxa_hab_domicilio)) +
#   geom_line()

# populacao (nominal)

tab %>% 
  mutate(
    abast_rede_geral_ibge_2010 = 
      abast_rede_geral_ibge_2010 * pop_total_2010 / domicilios_total_2010,
    pop_servida_abast_agua = taxa_hab_domicilio * ind_ag013
  ) %>% 
  pivot_longer(
    c(pop_total_2010, 
      proj_pop_total, 
      pop_servida_abast_agua, 
      pop_servida_poco_nasc,
      abast_rede_geral_ibge_2010),
    names_to = "serie",
    values_to = "valor"
  ) %>% 
  mutate(valor = valor / 1e6) %>% 
  ggplot(aes(x = ano, y = valor, color = serie)) +
  geom_line()

# populacao (corrigida)

tab %>% 
  mutate(
    abast_rede_geral_ibge_2010 = 
      abast_rede_geral_ibge_2010 * pop_total_2010 / domicilios_total_2010
  ) %>% 
  pivot_longer(
    c(pop_total_2010, 
      proj_pop_total, 
      pop_servida_abast_agua, 
      pop_servida_poco_nasc,
      abast_rede_geral_ibge_2010),
    names_to = "serie",
    values_to = "valor"
  ) %>% 
  mutate(valor = valor / 1e6) %>% 
  ggplot(aes(x = ano, y = valor, color = serie)) +
  geom_line()
  
tab %>% 
  ggplot(aes(x = ano, y = taxa_hab_domicilio)) +
  geom_line()

# domicilios

tab %>% 
  pivot_longer(
    c(domicilios_total_2010, 
      proj_domicilios_total, 
      ind_ag013),
    names_to = "serie",
    values_to = "valor"
  ) %>% 
  mutate(valor = valor / 1e6) %>% 
  ggplot(aes(x = ano, y = valor, color = serie)) +
  geom_line() +
  labs(y = "número de domicílios (milhões)")


# 100 pessoas
# 50 dom pemanentes ocupados
# 50 dom outros
# 
# IBGE 2010: THD = 100/50 = 2
# SNIS: economias ativas de água: 100 dom
# 
# ind pop atendida pela rede: 2 * 100 = 200
# 
# prop = 200%






