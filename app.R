# app.R

source("global.R")
source("R/sim_functions.R")
source("ui.R")
source("server.R")

shinyApp(ui = ui, server = server)