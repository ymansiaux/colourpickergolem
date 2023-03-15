#' module_graph1 UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import ggplot2
#' @import colourpicker
#' @importFrom dplyr filter
mod_module_graph1_ui <- function(id){
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

#' module_graph1 Server Functions
#'
#' @noRd
mod_module_graph1_server <- function(id, r_global, data, col_used_to_color){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe(print(reactiveValuesToList(input)))
    observeEvent(input$pause, browser())

    r_local <- reactiveValues()

    observeEvent(TRUE, once = TRUE, {

      r_local$distinct_values_for_which_colors_are_required <- as.character(unique(data[[col_used_to_color]]))
      r_local$input_names <- remove_special_characters_in_input(r_local$distinct_values_for_which_colors_are_required)

      # injecter ca dans le global_rv
      ### PENSER A REMPLACER fake_product_colors par r_global$product_colors
      fake_product_colors <- data.frame("inputId"="setosa", "product"="setosa", "color"=NA_character_)

      # produits manquants dans la liste des produits déjà traités
      indices_of_missings_products <- which(!r_local$distinct_values_for_which_colors_are_required %in% fake_product_colors$product)

      df_to_rbind_to_products_list <- data.frame("inputId"=r_local$input_names[indices_of_missings_products],
                                                 "product"=r_local$distinct_values_for_which_colors_are_required[indices_of_missings_products],
                                                 "color"=NA_character_)

      r_global$product_colors <- rbind(fake_product_colors,
                                       df_to_rbind_to_products_list)
    })


    output$select_colors <- renderUI({

      nvalues <- nrow(r_global$product_colors)

      indices_of_missing_colors <- which(is.na(r_global$product_colors$color))
      r_global$product_colors$color[indices_of_missing_colors] <- r_global$default_palette[indices_of_missing_colors]

      lapply(1:nvalues, function(i) {
        colourInput(
          inputId = session$ns(r_global$product_colors$inputId[i]),
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

      if(all(r_global$product_colors$inputId %in% names(list_of_inputs))) {

        list_of_color_inputs <- list_of_inputs[r_global$product_colors$inputId]

        r_global$product_colors$color <- unlist(list_of_color_inputs)

      }

    })



    output$distPlot <- renderPlot({
      ggplot(iris) +
        aes(x = Sepal.Length, y = Sepal.Width, colour = Species) +
        geom_point() +
        scale_color_manual(values = r_global$product_colors$color, breaks = r_global$product_colors$product) +
        theme_bw()

    })


  })
}

## To be copied in the UI
# mod_module_graph1_ui("module_graph1_1")

## To be copied in the server
# mod_module_graph1_server("module_graph1_1")
