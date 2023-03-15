#' module_graph2 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_module_graph2_ui <- function(id){
  ns <- NS(id)
  tagList(
    fluidRow(
      column(width = 12,
             actionButton(ns("pause"), "Pause"),

             # Sidebar with a slider input for number of bins
             uiOutput(outputId = ns("select_colors"))
      )
    ) ,

    fluidRow(
      column(width = 12,
             plotOutput(ns("distPlot"), height = "1200px")
      )
    )

  )
}

#' module_graph2 Server Functions
#'
#' @noRd
mod_module_graph2_server <- function(id, r_global){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_module_graph2_ui("module_graph2_1")

## To be copied in the server
# mod_module_graph2_server("module_graph2_1")
