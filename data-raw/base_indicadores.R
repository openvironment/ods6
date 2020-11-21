## code to prepare `base_indicadores` dataset goes here

devtools::load_all()

stringr::str_to_sentence("Número de Domicílios Particulares Permanentes Ocupados abastecidos por poços ou minas")

base_indicadores <- base_completa %>% 
  mutate(
    # Domicílios abastecidos por fossa séptica/rudimentar
    num_dom_fossa_septica = proj_domicilios_total * 
      (sanea_fossa_septica_2010 / domicilios_total_2010),
    
    num_dom_fossa_rudimentar = proj_domicilios_total * 
      (sanea_fossa_rudimentar_2010 / domicilios_total_2010),
    
    # Domicílios abastecidos por poço na propriedade
    num_dom_abast_poco_na_propriedade = proj_domicilios_total *
      (abast_poco_ou_nascente_na_propriedade_2010 / domicilios_total_2010),
    
    # Taxa média de Habitantes por domicílio 
    taxa_hab_domicilio = proj_pop_total / proj_domicilios_total,
    
    # População Residente Servida por Rede Pública de Abastecimento de Água 
    pop_servida_abast_agua = taxa_hab_domicilio * ind_ag013,
    
    # População Residente Servida por Poço ou Nascente 
    pop_servida_poco_nasc = taxa_hab_domicilio * 
      num_dom_abast_poco_na_propriedade,
    
    # População Servida por Abastecimento de Água Sanitariamente Adequados
    pop_abast_sist_adequados = pop_servida_poco_nasc + pop_servida_abast_agua,
    
    # Porcentagem da População Servida por Água de Abastecimento
    prop_pop_abast_sist_adequados = pop_abast_sist_adequados / populacao * 100
  )


base_indicadores <- base_completa %>%
  # Porcentagem da População Servida por Água de Abastecimento
    prop_pop_abast_sist_adequados = (pop_abast_sist_adequados/populacao)*100
    # prop_pop_abast_sist_adequados = ifelse(
    #   prop_pop_abast_sist_adequados > 100,
    #   100,
    #   prop_pop_abast_sist_adequados
    # )
  # Porcentagem da População Servida por Poço ou Nascentes
  mutate(
    prop_pop_servida_poco_nasc = (pop_servida_poco_nasc/populacao)*100
  ) %>% 
  # Porcentagem da População Servida por Rede Pública de Abastecimento de Água
  mutate(
    prop_pop_servida_rede_publica_agua = prop_pop_abast_sist_adequados -
      prop_pop_servida_poco_nasc
  ) %>% 
  # População Servida por Rede Coletora de Esgoto 
  mutate(
    pop_servida_rede_esgoto = taxa_hab_domicilio*ind_es0081
  ) %>% 
  # População Residente Servida por Sistema de Fossa Séptica/Rudimentar 
  mutate(
    pop_fossa_septica = num_dom_fossa_septica*taxa_hab_domicilio,
    pop_fossa_rudimentar = num_dom_fossa_rudimentar*taxa_hab_domicilio
  ) %>% 
  # População Residente Total Servida por Sistemas de Coleta de Esgoto
  mutate(
    pop_servida_coleta_esgoto = pop_servida_rede_esgoto + pop_fossa_septica
  ) %>% 
  # Porcentagem da População Residente Servida com Sistema de Coleta de Esgoto
  mutate(
    prop_pop_servida_coleta_esgoto = (pop_servida_coleta_esgoto/populacao)*100
    # prop_pop_servida_coleta_esgoto = ifelse(
    #   prop_pop_servida_coleta_esgoto > 100,
    #   100,
    #   prop_pop_servida_coleta_esgoto
    # )
  ) %>% 
  # Porcentagem da População Residente Servida por Fossa Séptica
  mutate(
    prop_pop_fossa_septica = (pop_fossa_septica/populacao)*100
  ) %>% 
  # Porcentagem da População Servida por sistema Rede Coletora de Esgoto 
  mutate(
    prop_pop_servida_rede_coleta = prop_pop_servida_coleta_esgoto - prop_pop_fossa_septica
  ) %>% 
  # Volume de Água Efetivamente Disponibilizado para Consumo no Município 
  mutate(
    volume_agua_efe_disp = ind_ag006 + ind_ag018 - ind_ag019
  ) %>% 
  # Volume Total de Água Perdido na Rede de Distribuição 
  mutate(
    volume_agua_perdido_rede = volume_agua_efe_disp - ind_ag010 - ind_ag019
  ) %>% 
  # Volume de Água Efetivamente Consumido no Município
  mutate(
    volume_agua_efe_consumido = ind_ag010 + 0.3*volume_agua_perdido_rede - ind_ag019
  ) %>% 
  # Consumo médio per capita efetivo 
  mutate(
    consumo_medio_per_capita = (volume_agua_efe_consumido / ((populacao * prop_pop_servida_rede_coleta) / 100)) * (1e6 / 365)
  ) %>% 
  # Índice Percentual de Perdas de água na Rede de Distribuição
  mutate(
    perc_perdas_rede_dist = volume_agua_perdido_rede / volume_agua_efe_disp * 100
  ) %>% 
  # Volume efetivo de esgoto produzido no Município
  mutate(
    volume_esgoto_produzido = 0.8 * volume_agua_efe_consumido
  ) %>% 
  # Volume do esgoto tratado
  mutate(
    volume_esgoto_tratado = ind_es006
  ) %>% 
  # Porcentagem do Esgoto Tratado em Relação ao Produzido
  mutate(
    prop_esgoto_tratado = (ind_es006 / volume_esgoto_produzido) * 100
  )

writexl::write_xlsx(base_ind, "data/base_indicadores.xlsx")

usethis::use_data(base_indicadores, overwrite = TRUE)
