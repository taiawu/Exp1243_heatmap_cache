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
      fluidRow(column(8,
                      div(
                           h4("Mouse over the plot below to browse and download dye screen data and conditions."),
                        tableOutput("how_to_use")

                        ),

                      plotOutput("mock_heatmap", height = "600px", 
                                 hover = hoverOpts("plot_hover",
                                                   delay = 500,
                                                   delayType = "debounce",
                                                   clip = TRUE, # stop updating outside plot area
                                                   nullOutside = FALSE)) # keep assignments after leaving plot
                      ),
               column(4,
                      h4(tableOutput("protein_title")),
                     
                      panel(style = "overflow-y:scroll; max-height: 600px; position:relative; align: centre",
                            tableOutput("protein_header"),
                             plotOutput("mock_raw_plot"),
                            #uiOutput("raw_hover_info"),
                           
                            #  plotOutput("mock_raw_plot", hover = hoverOpts("raw_plot_hover", 
                            #                                                delay = 50, 
                            #                                                clip = TRUE,
                            #                                                nullOutside = TRUE)), 
                            # uiOutput("raw_hover_info"),

                            tableOutput("protein_source"),
                            tableOutput("methods")
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

