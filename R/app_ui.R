#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinyjs
#' @import shinyWidgets
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic 
    useShinyjs(),
    fluidPage( # can't take height = "100%"
      h2("protein-adaptive DSF data explorer"),
      #tableOutput("mock_text_header"), ## description of the site
      fluidRow(column(8,
                      div(
                        #div(style="display: inline-block; width: 40%;",
                           h4("Mouse over the plot below to browse and download dye screen data and conditions."),
                          # ),
                        tableOutput("how_to_use")
                      
                      
                        ##### download button -- not used currently
                        # ,
                        # div(style="display: inline-block; width: 20%;",
                        #     downloadButton(label = "Download heatmap data", "download_heatmap_data")
                        #     )
                        ),

                      plotOutput("mock_heatmap", height = "800px", hover = hoverOpts("plot_hover", delay = 500, nullOutside = FALSE))
                      
                      ),
               column(4,
                      #div(
                        #div(style="display: inline-block; width: 40%;",
                        h2(tableOutput("protein_title")),
                        #)
                        
                        ##### download button -- not used currently
                        #,
                        # div(style="display: inline-block; width: 20%;",
                        #     downloadButton(label = "Download displayed report", "download_report")
                        # )
                        
                        #),
                      
                      panel(style = "overflow-y:scroll; max-height: 800px; position:relative; align: centre",
                            tableOutput("protein_header"),
                           
                             plotOutput("mock_raw_plot", hover = hoverOpts("raw_plot_hover", delay = 200, nullOutside = TRUE)), 
                            uiOutput("raw_hover_info"),
                           
                            #h3("Methods"),
                            tableOutput("protein_source"),
                            tableOutput("methods")#,
                            #tableOutput("mock_text")
                            # ,
                            #  plotOutput("chem_struc")
                            # ,
                            # heading = "Education", status = "primary")
                      ) # panel
                      ) # column
      ) # fluidRow
    ) # fluidPage
  ) #taglist
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'Exp1243_heatmap_cache'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

