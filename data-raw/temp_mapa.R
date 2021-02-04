## code to prepare `temp_mapa` dataset goes here

tab_mapa_estado <- geobr::read_municipality()

tab_mapa_estado <- tab_mapa_estado %>% 
  dplyr::filter(code_state == 35)

tab_mapa_estado %>% 
  dplyr::mutate(value = ifelse(code_muni == 3500105, "1", "0")) %>% 
  ggplot2::ggplot(ggplot2::aes(fill = value)) +
  ggplot2::geom_sf(show.legend = FALSE, size = 0.2) +
  ggplot2::scale_fill_manual(values = c("transparent", "#2aaee2")) +
  ggplot2::theme(
    panel.grid = ggplot2::element_blank(),
    text = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank(),
    panel.background = ggplot2::element_blank()
  )

usethis::use_data(temp_mapa, overwrite = TRUE)
