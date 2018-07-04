############################
# Temporal Model.          #
############################

# Load libraries.
# =======================
package_names = c("tidyverse", "forecast", "parallel")
lapply(package_names, library, character.only = TRUE)

# Source functions.
# =======================
source("scripts/temp_fun.R")

# Load data.
# =======================
file_names = c("data/var.R", "data/year.R")
map(file_names, load, .GlobalEnv)

# Temporal Model.
# =======================
cl = makeCluster(detectCores() - 1)
clusterExport(cl, list("var", "temp_fit", "auto.arima", "year"))
temp_model = parApply(cl, var, 2:3, temp_fit, year = year)
stopCluster(cl)

# Save files.
# =======================
save(temp_model, file = "models/temp_model.R")

# Clear workspace.
# =======================
rm(list = ls())
