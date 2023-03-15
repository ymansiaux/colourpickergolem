#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(

      fluidRow(
        uiOutput(outputId = ("select_colors"))
      ),

      fluidRow(
        column(width = 6,
               h1("module 1 output"),
               mod_module_graph1_ui("module_graph1_1")

               ),

        column(width = 6,
               h1("module 2 output"),
               mod_module_graph2_ui("module_graph2_1")
        )
      )

    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "colorpickerbetweenmodules"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
