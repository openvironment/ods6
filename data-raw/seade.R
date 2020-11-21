## code to prepare `seade` dataset goes here

`%>%` <- magrittr::`%>%`

load("data/ibge.rda")

baixar_dados_seade <- function(cod_local, url, faixa_etaria, 
                               localidade, sexo, anos) {
  url <- paste(url, faixa_etaria, localidade, sexo, cod_local, anos, sep = "/")
  
  httr::GET(url) %>% 
    httr::content() %>% 
    purrr::pluck("dados") %>% 
    purrr::map_dfr(tibble::as_tibble)
}

url <- "http://api-projpop.seade.gov.br/v1/dados"
faixa_etaria <- "sf"
localidade <- "mun"
sexo <- "t"
cod_localidade <- ibge$munip_cod
anos <- "all"

tab <- purrr::map_dfr(
  cod_localidade,
  baixar_dados_seade,
  url = url,
  faixa_etaria = faixa_etaria,
  localidade = localidade,
  sexo = sexo,
  anos = anos
)

seade <- tab %>%
  dplyr::select(
    ano, 
    munip_cod = cod_municipio, 
    pop_masc = total_polpulacao_homem, 
    pop_fem = total_polpulacao_mulher,
    pop_total = total_geral_polpulacao
  ) %>% 
  dplyr::mutate(dplyr::across(
    -munip_cod,
    as.numeric
  )) %>% 
  dplyr::filter(ano <= 2020)

usethis::use_data(seade, overwrite = TRUE)
