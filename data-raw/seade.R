## code to prepare `seade` dataset goes here

`%>%` <- magrittr::`%>%`

download.file(
  "http://produtos.seade.gov.br/produtos/projpop/download/Projpop.zip",
  destfile = "data-raw/seade/seade_completo.zip"
)

download.file(
  "http://produtos.seade.gov.br/produtos/projpop/download/Dicionario.zip",
  destfile = "data-raw/seade/seade_dir.zip"
)

unzip(
  "data-raw/seade/seade_completo.zip", 
  files = "tb_dados.txt", 
  exdir = "data-raw/seade/"
)

unzip("data-raw/seade/seade_dir.zip", exdir = "data-raw/seade/")

tab <- read.csv2("data-raw/seade/tb_dados.txt")

seade <- tab %>% 
  tibble::as_tibble() %>%
  dplyr::filter(!is.na(mun_id), ano <= 2020) %>% 
  dplyr::mutate(
    mun_id = as.character(mun_id),
    mun_id = stringr::str_sub(mun_id, 1, 6),
    proj_pop_total = PURB + PRUR,
  ) %>% 
  dplyr::select(
    munip_cod = mun_id,
    ano,
    proj_pop_urbana = PURB,
    proj_pop_rural = PRUR,
    proj_pop_total,
    proj_domicilios_total = DOM
  )

usethis::use_data(seade, overwrite = TRUE)
