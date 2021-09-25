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
    titulo = "1. Indicador de acesso à água maior que 100%",
    desc_ind = "Proporção da população que utiliza 
      serviços de água potável gerenciados de forma segura.", 
    desc_validacao = "Valores acima de 100% sugerem deficiência no método 
    proposto pelo SNIS para avaliação desse indicador ou inconsistência 
    nos dados encaminhados pela prestadora de serviço.",
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
    titulo = "2. Indicador de acesso à coleta de esgoto maior que 100%", 
    desc_ind = "Proporção da população que utiliza serviços de 
        saneamento gerenciados de forma segura", 
    desc_validacao = "Valores acima de 100% sugerem deficiência no método 
    proposto pelo SNIS para avaliação desse indicador ou inconsistência 
    nos dados encaminhados pela prestadora de serviço.", 
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
    titulo = "3. Percentual de perdas totais fora da faixa de 10 a 80%", 
    desc_ind = "Índice percentual de perdas de água na rede de distribuição", 
    desc_validacao = "Considerando a realidade brasileira, é muito 
        improvável que um município ou localidade apresente um índice 
        de perdas totais menor do que 10% ou maior do que 80%. 
        Portanto, valores de perdas totais menores que 10% e 
        maiores que 80% são considerados sob suspeição 
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
    titulo = "4. Consumo médio per capita fora da faixa de 100 a
    400 litros/habitante/dia", 
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
    titulo = "1. Variação anual acima de 20% no indicador de acesso à água", 
    desc_ind = "Proporção da população que utiliza 
      serviços de água potável gerenciados de forma segura.", 
    desc_validacao = "Variações entre dois anos consecutivos acima de 20% 
    devem ser consideradas suspeitas pois é pouco provável que a cobertura 
    da rede seja incrementada neste valor no período de 1 ano.",  
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
    titulo = "2. Variação anual acima de 20%  indicador de acesso à 
    coleta de esgoto", 
    desc_ind = "Proporção da população que utiliza serviços de 
        saneamento gerenciados de forma segura", 
    desc_validacao = "Variações entre dois anos consecutivos acima de 20% 
    devem ser consideradas suspeitas pois é pouco provável que 
    esta variação seja real.", 
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
    titulo = "3. Variação anual acima de 20% no indicador de perdas totais", 
    desc_ind = "Índice percentual de perdas de água na rede de distribuição", 
    desc_validacao = "Variações entre dois anos consecutivos acima de 20% devem
    ser consideradas suspeitas pois é pouco provável que esta variação
    seja real.", 
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
    titulo = "4. Variação anual acima de 20% no indicador de 
    consumo média per capita", 
    desc_ind = "Consumo médio per capito efetivo", 
    desc_validacao = "Variações entre dois anos consecutivos acima de 
    20% devem ser consideradas suspeitas pois é pouco provável que 
    esta variação seja real, excetuando em situações críticas.", 
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

class_disp_pc <- function(value) {
  if (value == "Boa") {
    bgcolor <- "#3cab3c"
    color <- "white"
  } else if (value == "Atenção") {
    bgcolor <- "#f9f906"
    color <- "black"
  } else if (value == "Crítica") {
    bgcolor <- "#ef5757"
    color <- "white"
  } else {
    bgcolor <- "white"
    color <- "black"
  }
  
  htmltools::css(
    color = color,
    backgroundColor = bgcolor
  )
}

tabela_class_disp_pc <- function() {
  tibble::tribble(
    ~ "Intervalo", ~ "Classificação",
    "> 2.500 m³/hab/ano", "Boa",
    "≥ 1.500 e ≤ 2.500 m³/hab/ano", "Atenção",
    "≤ 1.500 m³/hab/ano", "Crítica"
  ) |> 
    reactable::reactable(
      sortable = FALSE,
      fullWidth = FALSE,
      width = "500px",
      defaultColDef = reactable::colDef(
        align = "center",
        style = class_disp_pc
      ),
      theme = reactable::reactableTheme(
        headerStyle = list(
          backgroundColor = "grey",
          color = "white"
        )
      )
    )
}


class_balanco <- function(value) {
  value <- tolower(value)
  if (stringr::str_detect(value, "excelente")) {
    bgcolor <- "lightblue"
    color <- "black"
  } else if (stringr::str_detect(value, "confortável")) {
    bgcolor <- "#3cab3c"
    color <- "white"
  } else if (stringr::str_detect(value, "preocupante")) {
    bgcolor <- "#f9f906"
    color <- "black"
  } else if (stringr::str_detect(value, "muito crítica")) {
    bgcolor <- "purple"
    color <- "white"
  } else if (stringr::str_detect(value, "crítica")) {
    bgcolor <- "#ef5757"
    color <- "white"
  } else {
    bgcolor <- "white"
    color <- "black"
  }
  
  htmltools::css(
    color = color,
    backgroundColor = bgcolor
  )
}

tabela_class_disp_balanco <- function() {
  tibble::tribble(
    ~ "Intervalo", ~ "Classificação",
    "≤ 5%", "Excelente. Pouca ou nenhuma atividade de gerenciamento é necessária.",
    "> 5% e ≤ 30%", "A situação é confortável, podendo exigir gerenciamento para
    solução de problemas locais de abastecimento.",
    "> 30% e ≤ 50%", "Preocupante. A atividade de gerenciamento é indispensável,
    exigindo a realização de investimentos médios.",
    "> 50% e ≤ 100%", "A situação é crítica, exigindo atividade de gerenciamento 
    e grandes investimentos.",
    "> 100%", "A situação é muito crítica."
  ) |> 
    reactable::reactable(
      sortable = FALSE,
      fullWidth = FALSE,
      width = "600px",
      defaultColDef = reactable::colDef(
        align = "center",
        style = class_balanco
      ),
      theme = reactable::reactableTheme(
        headerStyle = list(
          backgroundColor = "grey",
          color = "white"
        )
      )
    )
}
