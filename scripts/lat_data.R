##########################
# Lat Data.              #
##########################

# Source functions.
# =======================
source("scripts/lat_fun.R")

# Load data.
# =======================
file_names = c("models/lat_model.R", "data/smf.R", "data/spec.R", "data/lon.R")
map(file_names, load, .GlobalEnv)

# Latitudinal model parameters.
# ========================
pars = lat_model$par

# Coherence function.
# ========================
coh = coh_fun(pars, seq_along(lon) - 1, length(lon))

# Cross-spectral mass function.
# ========================
csmf = lat_csmf(smf, coh)
  
# Mean cross-meriodogram.
# ========================
mcpgram = apply(apply(aaply(spec, 1, spec_con), c(1, 4), lat_cpgram), c(1, 3), mean)

# Save files.
# =======================
save(pars, file = "models/lat_pars.R")
save(csmf, file = "data/csmf.R")
save(mcpgram, file = "data/mcpgram.R")

# Clear workspace.
# =======================
rm(list = ls())
