#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinipsum
#' @importFrom magrittr %>%
#' @importFrom dplyr filter
#' @noRd
app_server <- function(input, output, session) {

  output$how_to_use <- renderText({
    HTML(paste0("<b> How to read this plot </b> Each row shows results for a different protein that was screened against the paDSF dye library. Each column contains results for an individual dye. Dark green dots: DSF-compatible dye-protein pairs ('hit'). Light green dots: dye-protein pairs with protein- and temperature-dependent signal, but not an expected unfolding curve ('sensitive'). No dot (exposed line): neither hit nor sensitive ('none'). White regions: untested. This plot is a reproduction of Fig. 1E from Wu et. al. ")
    )
  })
  
  output$mock_heatmap <-
    renderPlot({
      heatmap_ggproto ## loaded as package data
      # for ipsum app
    ##random_ggplot(type = "tile")
  })
  
  dye_protein_hover <- 
    reactive({

      point <- nearPoints(heatmap, # internal package object
                          input$plot_hover, # takes reactive dependency
                          threshold = 5, 
                          maxpoints = 1, 
                          addDist = TRUE)

    })
  
  
  #### report panel title
  output$protein_title <-  # appears in bold above the panel
    renderText({
     if(is.null(input$plot_hover)) { "Mouse over plot to view results"
      } else { # 
        protein_f_read <- 
          reactive(gsub(pattern = "_", 
                        replacement = " ", 
                        dye_protein_hover()$protein_f))
        
        protein_header <- 
          reactive(paste0(protein_f_read(),
                          " with dye ", 
                          dye_protein_hover()$dye_f))
  
        if(dye_protein_hover()$assignment == "untested") { #  note untested tested combos
          paste0(protein_header()," (not tested)")
        } else {
          protein_header()
        } 
      }
    })
  
  output$protein_header <-  ### appears below the "methods" heading
    renderText({
     req(input$plot_hover) # hidden until mouseover data 
    
      protein_f_read <- # reader-friendly protein name withought "_"
        reactive(gsub(pattern = "_", 
                      replacement = " ", 
                      dye_protein_hover()$protein_f))
      
      if(dye_protein_hover()$assignment == "untested") {
        HTML(paste0(protein_f_read()," was not tested with dye ", dye_protein_hover()$dye_f))
      } else {
        HTML(paste0( "<b> Full protein name </b>", dye_protein_hover()$full_protein_name, 
                     " (nearest UNIPROT ID: ", dye_protein_hover()$uniprot_id,") <br/>",
                     "<b> Conditions </b>",  dye_protein_hover()$screening_conc , 
                     " µM ", protein_f_read(), 
                     " with <b> dye </b>", dye_protein_hover()$dye_f, "<br/>",
                     "<b>paDSF compatibiliy assignment </b>",  
                     dye_protein_hover()$assignment, "<br/>"))
      }
    })
  
  protein_dye_raw <- reactive({
    req(input$plot_hover) # hidden until mouseover data 
    exp_num <- reactive(dye_protein_hover()$exp_num)
    dye <- reactive(as.character(dye_protein_hover()$dye_f))
    
    if(dye_protein_hover()$assignment == "untested") { #  note untested tested combos
      NULL
    } else {
      if (exp_num() %in% raw_screens$exp_num) {
        if(dye() %in% raw_screens$dye) {
          raw_data <- 
            raw_screens %>%
            filter(exp_num == exp_num(),
                   dye == dye()) #
        }
      } else {
        NULL
      }
    } 
  })
  
  
  output$mock_raw_plot <- 
    renderPlot({
      req(input$plot_hover) # hidden until mouseover data 
      req(protein_dye_raw())

      protein_dye_raw() %>%
            plot_raw(  . ,
                       .line_size = 0.6) 
    })
  
  
  
  output$protein_source <-  ### appears below the "methods" heading
    renderText({
      req(input$plot_hover) # hidden until mouseover data 
      
      protein_f_read <- # reader-friendly protein name withought "_"
        reactive(gsub(pattern = "_", 
                      replacement = " ", 
                      dye_protein_hover()$protein_f))
      
          
          HTML(paste0("<b> Protein source </b>", dye_protein_hover()$protein_source , "<br/>",
                      "<b> Construct details </b>", dye_protein_hover()$construct_details , "<br/>",
                      "<b> Construct citation </b>", dye_protein_hover()$relevant_citation , "<br/>",
                      "<br/>"))

    })
  
  output$methods <- 
    renderText({
      req(input$plot_hover) # hidden until mouseover data 
      
      protein_f_read <- # reader-friendly protein name withought "_"
        reactive(gsub(pattern = "_", 
                      replacement = " ", 
                      dye_protein_hover()$protein_f))
      
      
      if(dye_protein_hover()$assignment == "untested") {
        "" # show nothing
      } else {
        HTML(paste0("<b> Methods </b> A stock solution of ", protein_f_read(), 
                    " was diluted in the chosen buffer (" , dye_protein_hover()$screening_buffer,
                    ") to create a 5X protein solution of ", 5*dye_protein_hover()$screening_conc, 
                    "  µM. In the same buffer, a 5 mM DMSO stock of dye ", dye_protein_hover()$dye_f ,
                    " was diluted to 1.25X final screening concentration. To a well of a white, low-volume 384-well qPCR plate (Axygen PCR-284-LC480WNFBC, lot 23517000), 2 µL of 5X protein solution was dispensed, followed by 8 uL of 1.25X dye, for a final well volume of 10 µL, and final protein concentration of ", dye_protein_hover()$screening_conc,
                    " µM. The qPCR plate was sealed with optically clear sealing film (Applied Biosystems MicroAmp Optical Adhesive Film 4311971) and spun for 30 seconds to settle droplets into the bottoms of wells and remove bubbles. The qPCR plate was placed in an Analytik Jena 384G qTower qPCR and heated from 25 ºC to 94 ºC in 69 increments of 1 ºC every 30 seconds with lid heating to 98 ºC, and fluorescence measurements were taken at each degree in six channels (FAM, JOE, TAMRA, ROX, Cy5, and Cy5.5). This heating and measuring procedure results in a heating rate of 1 ºC per 1 minute, and a total runtime of approximately 70 minutes.<br/>"))
      }
    })

  # ### tooltip for raw data mouseovers
  # # from https://gitlab.com/-/snippets/16220
  # output$raw_hover_info <- renderUI({
  #   req(dye_protein_hover()) # only show if right panel is active
  #   req(input$raw_plot_hover) # only show if tooltip data are there
  #   
  #   point_raw <- 
  #     nearPoints(protein_dye_raw(), # filtered data for raw plot panel
  #                input$raw_plot_hover, # takes reactive dependency
  #                threshold = 5, 
  #                maxpoints = 1, 
  #                addDist = TRUE)
  # 
  #     style <- paste0("position:absolute; z-index:100; background-color: rgba(245, 245, 245, 0.2); ",
  #                     "left:", input$raw_plot_hover$range$left, "px; top:", 
  #                     input$raw_plot_hover$range$top+50, "px;")
  # 
  #     # actual tooltip created as wellPanel
  #     wellPanel(
  #       style = style,
  #       p(HTML(paste0("<b> Channel </b>", point_raw$channel_f, "<br/>",
  #                     "<b> Dye </b>", point_raw$dye, "<br/>",
  #                     "<b> Sample </b>", point_raw$type, "<br/>",
  #                     "<b> Temperature </b>", point_raw$Temperature, " ºC"))))
  #   })


# ##### download report
# # https://shiny.rstudio.com/articles/generating-reports.html
# # https://shiny.rstudio.com/gallery/generating-reports.html
# output$download_report <- downloadHandler(
#   # For PDF output, change this to "report.pdf"
#   filename = "report.pdf",
#   content = function(file) {
#     # Copy the report file to a temporary directory before processing it, in
#     # case we don't have write permissions to the current working dir (which
#     # can happen when deployed).
#     tempReport <- file.path(tempdir(), "report.Rmd")
#     file.copy("report.Rmd", tempReport, overwrite = TRUE)
#     
#     # Set up parameters to pass to Rmd document
#     params <- list(n =  10)
#     
#     # Knit the document, passing in the `params` list, and eval it in a
#     # child of the global environment (this isolates the code in the document
#     # from the code in this app).
#     rmarkdown::render(tempReport, output_file = file,
#                       params = params,
#                       envir = new.env(parent = globalenv())
#     )
#   }
# )

  
}
