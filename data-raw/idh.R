## code to prepare `idh` dataset goes here

library(tidyverse)

temp_dir <- tempdir()
temp_file <- paste0(temp_dir, "/base.zip")

url <- "https://dilxtq.dm.files.1drv.com/y4mLl3msS82sp3ccvgRoo_ntVPbzAJuS33DlgXnwVBRg6yyAalz_JSTa2Pi2ft5ubsclIBSFDx7NflTkgsb9qIw8Kq4S1oDwfypyBrSz8oj9wpL-tzYh3TZJNv5JJDNfoLYBL0H8p-XehLdEdjh80cgRiwesJXaPLA_pscwS9fqKM_sLWSN9y-7ZjDGL34DGAMjnXK6H0W0mKsc1KCdyUGXyg"

download.file(url, temp_file)

unzip(temp_file, exdir = "data-raw/idh")

tab <- readxl::read_excel(
  "data-raw/idh/Atlas 2013_municipal, estadual e Brasil.xlsx",
  sheet = 2
)

idh <- tab %>% 
  janitor::clean_names() %>%
  filter(uf == 35, ano == 2010) %>%
  select(
    ano,
    munip_cod = codmun7,
    munip_name = municipio,
    idh = idhm,
    starts_with("idhm_")
  ) %>% 
  mutate(munip_name = str_to_title(munip_name))

usethis::use_data(idh, overwrite = TRUE)
