############################
# Longitudinal Model.      #
############################

# Libraries.
# =======================
package_names = c("parallel")
lapply(package_names, library, character.only = TRUE)

# Source functions.
# =======================
source("scripts/long_fun.R")

# Load data.
# =======================
load("data/pgram.R")

# Longitudinal model fitting. 
# =======================
cl = makeCluster(detectCores() - 1)
clusterExport(cl, list("long_fit", "full_Whittle_neg_log_like", "Whittle_neg_log_like", "mod_Matern"))
long_model = parApply(cl, pgram, 3, long_fit)
stopCluster(cl)

# Save longitudinal model.
# =======================
save(long_model, file = "models/long_model.R")

# Clear workspace.
# =======================
rm(list = ls())
