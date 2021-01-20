## code to prepare `geojson_munip` dataset goes here

tab_geo <- sf::read_sf("data-raw/shp/municipios/munip_sp.shp") %>% 
  dplyr::select(-NM_MUNICIP) %>% 
  dplyr::rename(municipio_cod = CD_GEOCODM) %>% 
  dplyr::mutate(municipio_cod = stringr::str_sub(municipio_cod, 1, 6))

tab_geo_simples <- sf::st_simplify(
  tab_geo, 
  preserveTopology = TRUE, 
  dTolerance = 0.01
)
tab_geo_simples <- sf::as_Spatial(tab_geo_simples)

geojson_munip <- geojsonio::geojson_json(tab_geo_simples)

usethis::use_data(geojson_munip, overwrite = TRUE)
