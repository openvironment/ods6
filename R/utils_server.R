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
  scales::percent(x, accuracy = 0.1, scale = 1)
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

#' Pipe
`%>%` <- dplyr::`%>%`

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