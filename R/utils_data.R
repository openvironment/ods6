limpar_nome_cidade <- function(nome) {
  nome %>% 
    abjutils::rm_accent() %>% 
    stringr::str_to_lower() %>% 
    stringr::str_replace_all(" ", "_")
}