#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  output$diamonds <- renderPlot({
    ggplot(diamonds, aes(.data[[input$x]], .data[[input$y]])) + 
      geom_point()
  }) %>% bindCache(input$x, input$y)
}
