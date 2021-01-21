hc_mapa <- function(tab, tab_geojson) {
  
  texto_tooltip <- paste0(
    '<span style="font-size:12px; font-weight: bold;">{point.munip_nome}</span><br/>',
    'População: <b>{point.populacao} habitantes</b><br/>',
    'Indicador: <b>{point.indicador}</b><br/>'
  )
  
  highcharter::highchart(type = "map") %>% 
    highcharter::hc_add_series(
      mapData = tab_geojson,
      states = list(hover = list(color = "#a4edba")),
      joinBy = c("municipio_cod", "munip_cod"),
      data = tab,
      name = "Selecionado",
      borderColor = "#0a0a0a"
    ) %>%
    highcharter::hc_colorAxis(
      tickPixelInterval = 100,
      dataClasses = highcharter::color_classes(
        breaks = c(0, 0, 1, 1),
        colors = c("#f5e9e7", "#f5e9e7", "#005180")
      )
    ) %>%
    highcharter::hc_legend(
      enabled = FALSE
    ) %>%
    highcharter::hc_tooltip(
      pointFormat = texto_tooltip,
      headerFormat = NULL
    ) %>% 
    highcharter::hc_mapNavigation(
      enabled = TRUE,
      enableDoubleClickZoom = TRUE,
      enableMouseWheelZoom = TRUE,
      buttonOptions = list(
        verticalAlign = "bottom"
      )
    ) %>%
    hc_custom_exporting(align = "left")
  
}

hc_cores_mapa <- c(
  "#fed98e", 
  "#fe9929", 
  "#d95f0e", 
  "#993404"
)

custom_color_classes <- function(breaks = NULL, 
                                 colors = c("#440154", "#21908C", "#FDE725"),
                                 unit = 1) {
  lbrks <- length(breaks)
  highcharter::list_parse(
    data.frame(
      from = breaks[-lbrks],
      to = c(breaks[-c(1, lbrks)] - unit, breaks[lbrks]),
      to = breaks[-1], 
      color = (grDevices::colorRampPalette(colors))(lbrks - 1), 
      stringsAsFactors = FALSE
    )
  )
}

hc_mapa_calor <- function(tab, tab_geojson, variavel, unit = 0.1,
                          label = FALSE) {
  
  texto_tooltip <- paste0(
    '<span style="font-size:12px; font-weight: bold;">{point.munip_nome}</span><br/>',
    'População: <b>{point.populacao} habitantes</b><br/>',
    'Indicador: <b>{point.indicador}</b><br/>'
  )
  
  acc <- ifelse(unit == 0.1, 1, 0)
  
  unidade_medida <- pegar_unidade_de_medida(variavel)
  
  tab <- tab %>% 
    dplyr::rename(value = variavel) %>% 
    dplyr::mutate(
      populacao = formatar_numero(proj_pop_total, accuracy = 1),
      value = ifelse(is.infinite(value), NA, value),
      value = round(value, acc),
      indicador = formatar_indicador(value, unidade_medida, label)
    ) %>% 
    dplyr::distinct(munip_cod, .keep_all = TRUE)

  quebras <- round(quantile(tab$value, na.rm = TRUE), acc)
  cores <- hc_cores_mapa[1:(length(quebras) - 1)]

  highcharter::highchart(type = "map") %>% 
    highcharter::hc_add_series(
      mapData = tab_geojson,
      states = list(hover = list(color = "#a4edba")),
      joinBy = c("municipio_cod", "munip_cod"),
      data = tab,
      name = "Selecionado",
      borderColor = "#0a0a0a"
    ) %>%
    highcharter::hc_colorAxis(
      tickPixelInterval = 100,
      dataClasses = custom_color_classes(
        breaks = quebras,
        colors = cores,
        unit = unit
      )
    ) %>%
    highcharter::hc_legend(
      itemStyle = list(textDecoration = "nome"),
      itemHoverStyle = list(textDecoration = "underline"),
      valueDecimals = 1
    ) %>% 
    highcharter::hc_tooltip(
      pointFormat = texto_tooltip,
      headerFormat = NULL
    ) %>% 
    highcharter::hc_mapNavigation(
      enabled = TRUE,
      enableDoubleClickZoom = TRUE,
      enableMouseWheelZoom = TRUE,
      buttonOptions = list(
        verticalAlign = "bottom"
      )
    ) %>%
    hc_custom_exporting(align = "left")
  
}

hc_custom_exporting <- function(hc, align = "right") {
  highcharter::hc_exporting(
    hc,
    enabled = TRUE,
    buttons = list(
      contextButton = list(
        align = align,
        menuItems = c(
          "printChart",
          "downloadPNG",
          "downloadJPEG",
          "downloadPDF",
          "separator",
          "downloadCSV",
          "downloadXLS"
        )
      )
    ),
    filename = "grafico-isdp"
  )
}

hc_serie <- function(dados, nome_formatado, unidade_de_medida) {
  
  perc <- ifelse(
    stringr::str_detect(formatar_indicador(1, unidade_de_medida), "%"),
    "%",
    ""
  )
  
  texto_tooltip <- paste0(
    'Indicador: <b>{point.y:.1f}', perc, " ", unidade_de_medida, '</b><br/>'
  )
  
  highcharter::highchart() %>% 
    highcharter::hc_chart(
      zoomType = "x"
    ) %>% 
    highcharter::hc_series(
      list(
        data = dados, 
        name = nome_formatado, 
        type = "line"
      )
    ) %>% 
    highcharter::hc_xAxis(
      type = "date"
    ) %>%
    highcharter::hc_yAxis(title = list(text = "Indicador")) %>% 
    highcharter::hc_tooltip(
      pointFormat = texto_tooltip,
      headerFormat = NULL
    ) %>% 
    highcharter::hc_legend(enabled = FALSE) %>% 
    highcharter::hc_colors(colors = "#005180")
  
}


