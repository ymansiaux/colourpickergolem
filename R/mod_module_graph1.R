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
mod_module_graph1_server <- function(id, r_global){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observe(print(reactiveValuesToList(input)))
    observeEvent(input$pause, browser())

    data <- reactive(iris)

    distinct_values_for_which_colors_are_required <- reactive(as.character(unique(data()[["Species"]])))

    cleaned_values_to_create_inputs <- reactive(
      distinct_values_for_which_colors_are_required() %>%
        gsub(x = .,
             pattern = " ",
             replacement = "_espacevide_") %>%
        gsub(x = .,
             pattern = "\\(",
             replacement = "_parentheseouverte_") %>%
        gsub(x = .,
             pattern = "\\)",
             replacement = "_parenthesefermee_")
      # peut etre d'autres cas de figure ...
    )


  output$distPlot2 <- renderPlot({

    ggplot(iris) +
      aes(Sepal.Length, Sepal.Width) +
      geom_line()

  })




    output$distPlot <- renderPlot({

      # browser()
      input_list <- reactiveValuesToList(input)

      distinct_product_values <- distinct_values_for_which_colors_are_required() %>%
        gsub(x = .,
             pattern = " ",
             replacement = "_espacevide_") %>%
        gsub(x = .,
             pattern = "\\(",
             replacement = "_parentheseouverte_") %>%
        gsub(x = .,
             pattern = "\\)",
             replacement = "_parenthesefermee_")

      req(all(
        distinct_product_values %in% names(input_list)
      ))

      color_vec <-
        data.frame("product" = names(input_list[distinct_product_values]),
                   "color" = unlist(input_list[distinct_product_values]))

      # on rettoie a posteriori le nom des produits
      color_vec$product <- color_vec$product %>%
        gsub(x = .,
             pattern = "_espacevide_",
             replacement = " ") %>%
        gsub(x = .,
             pattern = "_parentheseouverte_",
             replacement = "(") %>%
        gsub(x = .,
             pattern = "_parenthesefermee_",
             replacement = ")")


      ggplot(iris) +
        aes(x = Sepal.Length, y = Sepal.Width, colour = Species) +
        geom_point() +
        scale_color_manual(values = color_vec$color, breaks = color_vec$name)

    })

    mypalette <- sample(colors(), 20, replace = FALSE)

    output$select_colors <- renderUI({
      # distinct_values <- as.character(unique(data()[["Species"]]))

      # browser()

      nvalues <-
        length(distinct_values_for_which_colors_are_required())

      lapply(1:nvalues, function(i) {
        colourInput(
          inputId = session$ns(cleaned_values_to_create_inputs()[i]),
          paste("Colour for:", distinct_values_for_which_colors_are_required()[i]),
          palette = "limited",
          allowedCols = mypalette,
          value = mypalette[i]

          # colors()[i * sample(2:20, size = 1)]
        )

      })

    })

  })
}

## To be copied in the UI
# mod_module_graph1_ui("module_graph1_1")

## To be copied in the server
# mod_module_graph1_server("module_graph1_1")
