#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  ## Check for data update and if new stuff, run data prep
  dev_environment <- Sys.getenv("DEVELOPMENT_ENVIRONMENT")
  dev_data_loc_type <- Sys.getenv("DEVELOPMENT_DATA_LOCATION_TYPE")
  dev_data_loc <- Sys.getenv("DEVELOPMENT_DATA_LOCATION")

  if (dev_environment == "DEV") {
    # Here, we'll be doing processing for various data storage

    # Local storage in data folder
    if (dev_data_loc_type == "LOCAL") {
      matte::run_data_prep_local_data_folder(dev_data_loc)
    }
  }

  metadata <- yaml::read_yaml("jobs/meta.yaml")
  metadata$data <- map(metadata$data, as.symbol)
  #metadata$modules$plot <- map(metadata$modules$plot, as.symbol)

  data <- readRDS("jobs/data.rds")

  plotServer("plot", data, metadata)
  tableServer("table", data, metadata)
}
