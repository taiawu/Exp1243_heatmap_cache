#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinipsum
#' @import ggplot2
#' @import DT
#' @importFrom magrittr `%>%`
#' @import ChemmineR 
#' @noRd
app_server <- function(input, output, session) {

  output$mock_heatmap <- 
    renderPlot({
      heatmap_ggproto ## loaded as package data
      # for ipsum app
    ##random_ggplot(type = "tile")
  })
  
  output$mock_raw_plot <- 
    renderPlot({
      req(input$plot_hover) # take reactive dependency 
      random_ggplot(type = "line") +
        labs(title = input$plot_hover)
    })
  
  output$mock_text <- 
    renderText({
      random_text(nwords = 50)
    })
  
  #### report panel title
  output$mock_protein_title <- 
    renderText({
      if(!is.null(input$plot_hover)){
        input$plot_hover$x} else {
          ""
        }
    })
  
  output$mock_text_header <- 
    renderText({
      random_text(nwords = 50)
    })
  
  output$data_table <- 
    DT::renderDT({
      random_DT(5, 5, options = list(dom = 't'))
      
    })
  
  output$hover_info <- renderPrint({input$plot_hover
    if(!is.null(input$plot_hover)){
      input$plot_hover}
  
  })
  
  ### plot dye structure
  output$chem_struc <- 
    renderPlot({
      x <- runif(1, min = 1, max = 100)
      data(sdfsample) 
      sdfset <- sdfsample
      plotStruc(sdfset[[x]], atomcex = 1)
    })
  
  ### tooltip for raw data mouseovers
  # from https://gitlab.com/-/snippets/16220
  output$raw_hover_info <- renderUI({

    if(!is.null(input$raw_plot_hover)){
      hover <- input$raw_plot_hover

      # calculate point position INSIDE the image as percent of total dimensions
      # from left (horizontal) and from top (vertical)
      left_pct <- (hover$x - hover$domain$left) / (hover$domain$right - hover$domain$left)
      top_pct <- (hover$domain$top - hover$y) / (hover$domain$top - hover$domain$bottom)

      # calculate distance from left and bottom side of the picture in pixels
      left_px <- hover$range$left + left_pct * (hover$range$right - hover$range$left)
      top_px <- hover$range$top + top_pct * (hover$range$bottom - hover$range$top)

      # create style property fot tooltip
      # background color is set so tooltip is a bit transparent
      # z-index is set so we are sure are tooltip will be on top
      # style <- paste0("position:absolute; z-index:100; background-color: rgba(245, 245, 245, 0.85); ",
      #                 "left:", left_px + 2, "px; top:", top_px + 2, "px;")

      style <- paste0("position:absolute; z-index:100; background-color: rgba(245, 245, 245, 0.2); ",
                      "left:", hover$range$left, "px; top:", hover$range$top, "px;")


      # actual tooltip created as wellPanel
      wellPanel(
        style = style,
        p(HTML(paste0("<b> Protein: </b>",  input$raw_plot_hover$x, "<br/>",
                      "<b> Channel: </b>", input$raw_plot_hover$y, "<br/>",
                      "<b> Dye: </b>",top_pct, "<br/>",
                      "<b> Distance from left: </b>", left_px, "<b>, from top: </b>", top_px)))
      )
    }
  
    })


##### download report
# https://shiny.rstudio.com/articles/generating-reports.html
# https://shiny.rstudio.com/gallery/generating-reports.html
output$download_report <- downloadHandler(
  # For PDF output, change this to "report.pdf"
  filename = "report.pdf",
  content = function(file) {
    # Copy the report file to a temporary directory before processing it, in
    # case we don't have write permissions to the current working dir (which
    # can happen when deployed).
    tempReport <- file.path(tempdir(), "report.Rmd")
    file.copy("report.Rmd", tempReport, overwrite = TRUE)
    
    # Set up parameters to pass to Rmd document
    params <- list(n =  10)
    
    # Knit the document, passing in the `params` list, and eval it in a
    # child of the global environment (this isolates the code in the document
    # from the code in this app).
    rmarkdown::render(tempReport, output_file = file,
                      params = params,
                      envir = new.env(parent = globalenv())
    )
  }
)

  
}
