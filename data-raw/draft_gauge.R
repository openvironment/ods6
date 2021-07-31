tab <- base_ugrhi |> 
  dplyr::filter(nome == "Aguapeí", ano == max(ano)) |> 
  dplyr::mutate(
    iqa_label = dplyr::case_when(
      iqa <= 19 ~ "Péssimo",
      iqa <= 36 ~ "Ruim",
      iqa <= 51 ~ "Regular",
      iqa <= 79 ~ "Bom",
      TRUE ~ "Ótimo"
    ),
    iqa = round(iqa)
  )

highcharter::highchart() |> 
  highcharter::hc_series(
    list(
      name = "IQA",
      data = list(
        list(
          y = tab$iqa,
          dataLabels = list(
            padding = 17
          )
        )
      )
    )
  ) |>
  highcharter::hc_chart(
    type = "gauge"
  ) |> 
  highcharter::hc_pane(
    startAngle = -150,
    endAngle = 150,
    background = list(
      backgroundColor = "transparent",
      borderWidth = 0
    )
  ) |> 
  highcharter::hc_yAxis(
    min = 0,
    max = 100,
    minorTicks = FALSE,
    tickPositions = c(0, 19, 36, 51, 79, 100),
    tickLength = 20,
    title = list(
      text = tab$iqa_label,
      style = list(
        `font-size` = "25px",
        color = "black"
      )
    ),
    labels = list(
      distance = -35,
      style = list(fontSize = "12px")
    ),
    tickColor = "black",
    plotBands = list(
      list(
        from = 0,
        to = 19,
        color = "#9e32e6",
        thickness = 20
      ),
      list(
        from = 19,
        to = 36,
        color = "#eb5294",
        thickness = 20
      ),
      list(
        from = 36,
        to = 51,
        color = "#f0f564",
        thickness = 20
      ),
      list(
        from = 51,
        to = 79,
        color = "#3fba6c",
        thickness = 20
      ),
      list(
        from = 79,
        to = 100,
        color = "#7697e8",
        thickness = 20
      )
    )
  ) |> 
  highcharter::hc_plotOptions(
    series =  list(
      dataLabels = list(
        style = list(fontSize = "20px")
      )
    )
  )
