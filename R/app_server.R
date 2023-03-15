#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  r_global <- reactiveValues(

    default_palette = sample(colors(), size = 25, replace = FALSE),

    product_colors = data.frame("inputId"=NULL, "product"=NULL, "color"=NULL)

  )

  mod_module_graph1_server("module_graph1_1", r_global = r_global)
  mod_module_graph2_server("module_graph2_1", r_global = r_global)




}
