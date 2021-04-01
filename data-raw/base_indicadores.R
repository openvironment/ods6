# Dúvidas:
# 3- por que não usar o fator nos anos censitários?

devtools::load_all()

# Dados censo de 2010 (SEADE só tem projeções a partir de 2011)
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

# Juntando todas as bases
base_agregada <- seade %>% 
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

tab_fator_correcao <- base_agregada %>% 
  dplyr::filter(ano == 2010) %>%
  dplyr::group_by(munip_cod, munip_turistico) %>% 
  dplyr::summarise(
    dplyr::across(
      c(pop_total_2010, domicilios_total_2010, abast_rede_geral_2010,
        esgot_rede_geral_de_esgoto_ou_pluvial_2010),
      dplyr::first
    ),
    dplyr::across(
      c(ind_ag013, ind_es008),
      ~dplyr::first(na.omit(.x))
    )
  ) %>% 
  dplyr::mutate(
    abast_rede_fator_correcao = abast_rede_geral_2010 / ind_ag013,
    esgot_fator_correcao = 
      esgot_rede_geral_de_esgoto_ou_pluvial_2010 / ind_es008
  ) %>%
  # dplyr::mutate(dplyr::across(
  #   dplyr::contains("fator_correcao"),
  #   ~ifelse(munip_turistico == "sim", .x, 1)
  # )) %>% 
  dplyr::select(
    munip_cod,
    dplyr::contains("fator_correcao")
  )

base_indicadores <- base_agregada %>% 
  dplyr::left_join(
    tab_fator_correcao, 
    by = c("munip_cod")
  ) %>% 
  dplyr::mutate(
    # Domicílios abastecidos por fossa séptica/rudimentar
    num_dom_fossa_septica = proj_domicilios_total * 
      (esgot_fossa_septica_2010 / domicilios_total_2010),
    
    num_dom_fossa_rudimentar = proj_domicilios_total * 
      (esgot_fossa_rudimentar_2010 / domicilios_total_2010),
    
    # Domicílios abastecidos por poço na propriedade
    num_dom_abast_poco_na_propriedade = proj_domicilios_total *
      (abast_poco_ou_nascente_na_propriedade_2010 / domicilios_total_2010),
    
    # Taxa média de Habitantes por domicílio 
    taxa_hab_domicilio = proj_pop_total / proj_domicilios_total,
    
    # População Residente Servida por Rede Pública de Abastecimento de Água 
    pop_servida_abast_agua = 
      taxa_hab_domicilio * ind_ag013 * 
      tidyr::replace_na(abast_rede_fator_correcao, 1),
    
    # População Residente Servida por Poço ou Nascente 
    pop_servida_poco_nasc = taxa_hab_domicilio * 
      num_dom_abast_poco_na_propriedade,
    
    # População Servida por Abastecimento de Água Sanitariamente Adequados
    pop_abast_sist_adequados = pop_servida_poco_nasc + pop_servida_abast_agua,
    
    # Porcentagem da População Servida por Água de Abastecimento
    prop_pop_abast_sist_adequados = 
      pop_abast_sist_adequados / proj_pop_total * 100,
    
    # Porcentagem da População Servida por Poço ou Nascentes
    prop_pop_servida_poco_nasc = pop_servida_poco_nasc / proj_pop_total * 100,
    
    # Porcentagem da População Servida por Rede Pública de Abastecimento de Água
    prop_pop_servida_rede_publica_agua = prop_pop_abast_sist_adequados -
      prop_pop_servida_poco_nasc,
    
    # População Servida por Rede Coletora de Esgoto 
    pop_servida_rede_esgoto = 
      taxa_hab_domicilio * ind_es008 * 
      tidyr::replace_na(esgot_fator_correcao, 1),
    
    # População Residente Servida por Sistema de Fossa Séptica/Rudimentar 
    pop_fossa_septica = num_dom_fossa_septica * taxa_hab_domicilio,
    pop_fossa_rudimentar = num_dom_fossa_rudimentar * taxa_hab_domicilio,
    
    # População Residente Total Servida por Sistemas de Coleta de Esgoto
    pop_servida_coleta_esgoto = pop_servida_rede_esgoto + pop_fossa_septica,
    
    # Porcentagem da População Residente Servida com Sistema de Coleta de Esgoto
    prop_pop_servida_coleta_esgoto =
      pop_servida_coleta_esgoto / proj_pop_total * 100,
    
    # Porcentagem da População Residente Servida por Fossa Séptica
    prop_pop_fossa_septica = pop_fossa_septica / proj_pop_total * 100,
    
    # Porcentagem da População Servida por sistema Rede Coletora de Esgoto 
    prop_pop_servida_rede_coleta = 
      prop_pop_servida_coleta_esgoto - prop_pop_fossa_septica,
    
    # Volume de Água Efetivamente Disponibilizado para Consumo no Município 
    volume_agua_efe_disp = ind_ag006 + ind_ag018 - ind_ag019,
    
    # Volume Total de Água Perdido na Rede de Distribuição 
    volume_agua_perdido_rede = volume_agua_efe_disp - ind_ag010 - ind_ag019,
    
    # Volume de Água Efetivamente Consumido no Município
    volume_agua_efe_consumido = 
      ind_ag010 + 0.3 * volume_agua_perdido_rede - ind_ag019,
    
    # Consumo médio per capita efetivo 
    consumo_medio_per_capita =
      volume_agua_efe_consumido / 
      (proj_pop_total * prop_pop_servida_rede_coleta / 100) *
      (1e6 / 365),
    
    # Índice Percentual de Perdas de água na Rede de Distribuição
    prop_perdas_rede_dist = 
      volume_agua_perdido_rede / volume_agua_efe_disp * 100,
    
    # Volume efetivo de esgoto produzido no Município
    volume_esgoto_produzido = 0.8 * volume_agua_efe_consumido,
    
    # Volume do esgoto tratado
    volume_esgoto_tratado = ind_es006,
    
    # Porcentagem do Esgoto Tratado em Relação ao Produzido
    prop_esgoto_tratado = (volume_esgoto_tratado / volume_esgoto_produzido) * 100
  ) %>% 
  dplyr::select(
    ano,
    munip_cod,
    munip_nome,
    munip_turistico,
    dplyr::contains("fator_correcao"),
    dplyr::starts_with("idh"),
    dplyr::starts_with("proj_"),
    dplyr::starts_with("pop_"),
    dplyr::starts_with("prop_"),
    domicilios_total_2010,
    dplyr::starts_with("num"),
    dplyr::starts_with("taxa"),
    dplyr::starts_with("volume"),
    consumo_medio_per_capita,
    ind_ag013,
    abast_rede_geral_ibge_2010 = abast_rede_geral_2010
  )

readr::write_csv(base_agregada, "data-raw/base_agregada.csv")
writexl::write_xlsx(base_agregada, "data-raw/base_agregada.xlsx")

readr::write_csv(base_indicadores, "data-raw/base_indicadores.csv")
writexl::write_xlsx(base_indicadores, "data-raw/base_indicadores.xlsx")

usethis::use_data(base_indicadores, overwrite = TRUE)
