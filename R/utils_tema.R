tema_gg_blank <- function() {
  ggplot2::theme(
    rect = ggplot2::element_blank(),
    panel.grid = ggplot2::element_blank(),
    text = ggplot2::element_blank(),
    axis.ticks = ggplot2::element_blank()
  )
}