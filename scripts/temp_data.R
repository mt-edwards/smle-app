############################
# Temp Data.               #
############################

# Libraries.
# =======================
package_names = c("tidyverse")
lapply(package_names, library, character.only = TRUE)

# Source functions.
# =======================
source("scripts/temp_fun.R")

# Load data.
# =======================
file_names = c("models/temp_model.R", "data/year.R")
map(file_names, load, .GlobalEnv)

# Temporal parameters.
# ========================
pars = apply(temp_model, 1:2, temp_pars)

# Residuals.
# =======================
resid = apply(temp_model, 1:2, temp_resid, year = year)
  
# Spectrum.
# =======================
spec = aperm(apply(resid, c(1, 3), temp_fft), c(2, 1, 3))

# Periodogram.
# =======================
pgram = aperm(apply(spec, c(1, 3), temp_pgram), c(2, 1, 3))

# Save files.
# =======================
save(pars, file = "models/temp_pars.R")
save(resid, file = "data/resid.R")
save(spec, file = "data/spec.R")
save(pgram, file = "data/pgram.R")

# Clear workspace.
# =======================
rm(list = ls())
