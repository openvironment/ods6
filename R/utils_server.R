filtrar_ano_mais_recente <- function(tab) {
  tab %>% 
    dplyr::filter(ano == max(ano))
}

show_data <- function() {
  base_indicadores %>% 
    dplyr::glimpse()
}

formatar_numero <- function(x, accuracy = 0.1) {
  scales::number(x, big.mark = ".", decimal.mark = ",", accuracy = accuracy)
}

formatar_porcentagem <- function(x) {
  scales::percent(
    x, 
    accuracy = 0.1,
    scale = 1, 
    big.mark = ".", 
    decimal.mark = ","
  )
}

formatar_indicador <- function(valor, unidade_medida, label = FALSE) {
  if (stringr::str_detect(unidade_medida, "^dos |^do ")) {
    formatar_porcentagem(valor)
  } else if (unidade_medida == "habitantes/domicílio") {
    formatar_numero(valor, accuracy = 0.1)
  } else {
    if (label) {
      paste(formatar_numero(valor, accuracy = 1), unidade_medida)
    }
    else {
      formatar_numero(valor, accuracy = 1)
    }
  }
}

colocar_unidade_medida <- function(valor, indicador) {
  unidade <- pegar_unidade_de_medida(indicador)
  valor %>% 
    formatar_indicador(unidade) %>% 
    paste(unidade)
}

formatar_nome_tipo_servico <- function(x) {
  dplyr::case_when(
    x == "pop_servida_abast_agua" ~ "Rede pública",
    x == "pop_servida_poco_nasc" ~ "Poço ou mina",
    x == "prop_pop_fossa_septica" ~ "Fossa séptica",
    x == "prop_pop_servida_rede_coleta" ~ "Rede de coleta"
  )  
}

#' Devolve o nome formatado de um indicador
pegar_nome_formatado <- function(indicador) {
  tab_depara %>% 
    dplyr::filter(cod == indicador) %>% 
    dplyr::pull(nome_formatado)
}

#' Devolve a unidade de medida de um indicador
pegar_unidade_de_medida <- function(indicador) {
  tab_depara %>% 
    dplyr::filter(cod == indicador) %>% 
    dplyr::pull(unidade_de_medida)
}

#' Vetor nomeado com todos os indicadores
seleciona_indicadores <- function(tab_indicadores, tab_depara) {
  
  opcoes <- tab_indicadores %>%
    dplyr::select(pop_servida_abast_agua:prop_esgoto_tratado) %>% 
    names()
  
  nomes_formatados <- purrr::map_chr(
    opcoes, 
    pegar_nome_formatado
  )
  
  opcoes <- purrr::set_names(opcoes, nomes_formatados)
  
  opcoes[order(names(opcoes))]
  
}

verificar_inconsistencias <- function(base_filtrada_contemp, 
                                      base_filtrada) {
  tab_incons <- tibble::tibble(
    id = 0,
    titulo = "",
    valor = "",
    status = "",
    desc_ind = "",
    desc_validacao = "",
    .rows = 0
  )
  
  # Acesso a água
  valor <- base_filtrada_contemp() %>% 
    dplyr::pull(prop_pop_abast_sist_adequados)
  status <- ifelse(valor > 100, "warning", "success")
  
  tab_incons <- tibble::add_row(
    tab_incons,
    id = 1,
    titulo = "1. Indicador de acesso a água menor que 100%",
    desc_ind = "Proporção da população que utiliza 
      serviços de água potável gerenciados de forma segura.", 
    desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.",
    valor = formatar_porcentagem(valor),
    status = status
  )
  
  # Acesso a esgoto
  valor <- base_filtrada_contemp() %>% 
    dplyr::pull(prop_pop_servida_coleta_esgoto)
  status <- ifelse(valor > 100, "warning", "success")
  
  tab_incons <- tibble::add_row(
    tab_incons,
    id = 2,
    titulo = "2. Indicador de acesso a esgoto menor que 100%", 
    desc_ind = "Proporção da população que utiliza serviços de 
        saneamento gerenciados de forma segura", 
    desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
    valor = formatar_porcentagem(valor),
    status = status
  )
  
  # Perdas totais
  valor <- base_filtrada_contemp() %>% 
    dplyr::pull(prop_perdas_rede_dist)
  
  status <- ifelse(valor < 10 | valor > 80, "warning", "success")
  
  tab_incons <- tibble::add_row(
    tab_incons,
    id = 3,
    titulo = "3. Percentual de perdas totais entre 10 e 80%", 
    desc_ind = "Índice percentual de perdas de água na rede de distribuição", 
    desc_validacao = "Considerando a realidade brasileira, é muito 
        improvável que um município ou localidade apresente um índice 
        de perdas totais menor do que 10% ou maior do que 80%. 
        Portanto, valores de perdas totais menores que 10% e 
        iguais ou maiores que 80% são considerados sob suspeição 
        e devem ser considerados com reserva.", 
    valor = colocar_unidade_medida(valor, "prop_perdas_rede_dist"),
    status = status
  )
  
  # Consumo per capita
  valor <- base_filtrada_contemp() %>% 
    dplyr::pull(consumo_medio_per_capita)
  
  status <- ifelse(valor < 100 | valor > 400, "warning", "success")
  
  tab_incons <- tibble::add_row(
    tab_incons,
    id = 4,
    titulo = "4. Consumo médio per capita entre 100 e 400 litros/habitante/dia", 
    desc_ind = "Consumo médio per capito efetivo", 
    desc_validacao = "A Organização Mundial da Saúde recomenda que 
        cada pessoa deve ter no mínimo, 110 litros de água por dia para 
        atender suas necessidades de consumo e higiene. O consumo per 
        capita pode sofrer grandes variações dependendo do clima, 
        aspectos culturais, tamanho da cidade, desperdício em vazamentos, 
        falta ou deficiência de micromedição, entre outros fatores. 
        Dificilmente, um município ou localidade apresenta um valor de 
        consumo médio menor que 100 ou maior que 400 litros/ habitante/dia.
        Portanto, valores fora desta faixa merecem atenção.", 
    valor = colocar_unidade_medida(valor, "consumo_medio_per_capita"),
    status = status
  )
  
  
  # Variação no indicador de acesso a água
  anos <- base_filtrada() %>% 
    dplyr::select(ano, ind = prop_pop_abast_sist_adequados) %>% 
    dplyr::mutate(var = ind - dplyr::lag(ind)) %>% 
    dplyr::filter(abs(var) > 20) %>% 
    dplyr::pull(ano)
  
  l <- formatar_incons_ano(anos)
  
  tab_incons <- tibble::add_row(
    tab_incons,
    id = 5,
    titulo = "1. Nenhuma variação acima de 20% no indicador de acesso à água", 
    desc_ind = "Proporção da população que utiliza 
      serviços de água potável gerenciados de forma segura.", 
    desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.",  
    valor = l$valor,
    status = l$status
  )
  
  # Variação no indicador de acesso a esgoto
  anos <- base_filtrada() %>% 
    dplyr::select(ano, ind = prop_pop_servida_coleta_esgoto) %>% 
    dplyr::mutate(var = ind - dplyr::lag(ind)) %>% 
    dplyr::filter(abs(var) > 20) %>% 
    dplyr::pull(ano)
  
  l <- formatar_incons_ano(anos)
  
  tab_incons <- tibble::add_row(
    tab_incons,
    id = 6,
    titulo = "2. Nenhuma variação acima de 20%  indicador de acesso à coleta de esgoto", 
    desc_ind = "Proporção da população que utiliza serviços de 
        saneamento gerenciados de forma segura", 
    desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
    valor = l$valor,
    status = l$status
  )
  
  # Variação no indicador de acesso a esgoto
  anos <- base_filtrada() %>% 
    dplyr::select(ano, ind = prop_perdas_rede_dist) %>% 
    dplyr::mutate(var = ind - dplyr::lag(ind)) %>% 
    dplyr::filter(abs(var) > 20) %>% 
    dplyr::pull(ano)
  
  l <- formatar_incons_ano(anos)
  
  tab_incons <- tibble::add_row(
    tab_incons,
    id = 7,
    titulo = "3. Nenhuma variação acima de 20% no indicador de perdas totais", 
    desc_ind = "Índice percentual de perdas de água na rede de distribuição", 
    desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
    valor = l$valor,
    status = l$status
  )
  
  # Variação no indicador de acesso a esgoto
  anos <- base_filtrada() %>% 
    dplyr::select(ano, ind = consumo_medio_per_capita) %>% 
    dplyr::mutate(var = (ind - dplyr::lag(ind)) / dplyr::lag(ind)) %>% 
    dplyr::filter(abs(var) > 0.2) %>% 
    dplyr::pull(ano)
  
  l <- formatar_incons_ano(anos)
  
  tab_incons <- tibble::add_row(
    tab_incons,
    id = 8,
    titulo = "4. Nenhuma variação acima de 20% no indicador de consumo média per capita", 
    desc_ind = "Consumo médio per capito efetivo", 
    desc_validacao = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do 
      tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim 
      veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex 
      ea commodo consequat.", 
    valor = l$valor,
    status = l$status
  )
  
  return(tab_incons)
  
}

formatar_incons_ano <- function(x) {
  if (length(x) > 1) {
    status <- "warning"
    valor <- paste("Anos: ", paste(x, collapse = ", "))
  } 
  else if (length(x) == 1) {
    status <- "warning"
    valor <- paste("Ano: ", x)
  } else {
    status <-  "success"
    valor <- "Nenhuma variação acima de 20%."
  }
  return(list(valor = valor, status = status))
}

