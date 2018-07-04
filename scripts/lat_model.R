##########################
# Latitudinal Model.     #
##########################

# Libraries.
# ========================
package_names = c("tidyverse", "parallel")
lapply(package_names, library, character.only = TRUE)

# Source functions.
# ========================
source("scripts/lat_fun.R")

# Load files.
# ========================
file_names = c("data/nspec.R")
map(file_names, load, .GlobalEnv)

# Latitudinal model fitting.
# ========================
cl = makeCluster(detectCores() - 1)
clusterExport(cl, list("nspec", "lat_neg_log_like", "quad_form"))
lat_model = lat_fit(nspec)
stopCluster(cl)

# Save files.
# ========================
save(lat_model, file = "models/lat_model.R")

# Slear workspace.
# ========================
rm(list = ls())
