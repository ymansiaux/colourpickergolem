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

    product_colors = data.frame("inputId"=NA_character_, "product"=NA_character_, "color"=NA_character_)

  )

  output$select_colors <- renderUI({
    nvalues <- nrow(r_global$product_colors)

    indices_of_missing_colors <-
      which(is.na(r_global$product_colors$color))
    r_global$product_colors$color[indices_of_missing_colors] <-
      r_global$default_palette[indices_of_missing_colors]

    lapply(1:nvalues, function(i) {
      colourInput(
        inputId = (r_global$product_colors$inputId[i]),
        paste("Colour for:", r_global$product_colors$product[i]),
        palette = "limited",
        allowedCols = r_global$default_palette,
        value = r_global$product_colors$color[i]
      )
    })
  })

  # il faut MAJ la reactive values des couleurs en fonction de ce que l'utilisateur a selectionne
  observeEvent(reactiveValuesToList(input)[r_global$product_colors$inputId], {
    list_of_inputs <- reactiveValuesToList(input)

    if (all(r_global$product_colors$inputId %in% names(list_of_inputs))) {
      list_of_color_inputs <-
        list_of_inputs[r_global$product_colors$inputId]

      r_global$product_colors$color <-
        unlist(list_of_color_inputs)

    }

  })


  # implémentation de la sélection de couleur dans un niveau supérieur
  mod_module_graph1_server("module_graph1_1", r_global = r_global, data = iris, col_used_to_color = "Species")
  mod_module_graph2_server("module_graph2_1", r_global = r_global, data = iris, col_used_to_color = "Species")

}
