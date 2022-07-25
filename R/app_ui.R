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
    fluidPage(
      h2("Random title"),
      tableOutput("mock_text_header"),
      fluidRow(column(6,

                      div(
                        div(style="display: inline-block; width: 40%;",
                            h2("Mock heatmap")
                           ),
                        div(style="display: inline-block; width: 20%;",
                            downloadButton(label = "Download heatmap data", "download_heatmap_data")
                            )),

                      plotOutput("mock_heatmap", hover = hoverOpts("plot_hover", delay = 500, nullOutside = FALSE))
                      
                      ),
               column(6,
                      div(
                        div(style="display: inline-block; width: 40%;",
                            h2(tableOutput("mock_protein_title"))
                        ),
                        div(style="display: inline-block; width: 20%;",
                            downloadButton(label = "Download displayed report", "download_report")
                        )),
                      
                      
                       
                      panel(style = "overflow-y:scroll; max-height: 600px; position:relative; align: centre",
                            plotOutput("mock_raw_plot", hover = hoverOpts("raw_plot_hover", delay = 200, nullOutside = TRUE)), 
                            uiOutput("raw_hover_info"),
                           
                            h3("Methods"),
                            tableOutput("mock_text")
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

