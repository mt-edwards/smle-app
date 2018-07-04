############################
# Long Data.               #
############################

package_names = c("tidyverse", "plyr")
lapply(package_names, library, character.only = TRUE)

# Source functions.
# =======================
source("scripts/long_fun.R")

# Load data.
# =======================
file_names = c("models/long_model.R", "data/spec.R", "data/pgram.R", "data/lon.R")
map(file_names, load, .GlobalEnv)

# Longitudinal parameters.
# ========================
pars = simplify2array(map(long_model, ~ .$par))

# Modified Matern SMF.
# ========================
smf = apply(pars, 2, mod_Matern, L = length(lon))

# Normalised spectrum.
# ========================
nspec = aaply(spec, 1, long_nspec, smf = smf)

# Mean periodogram.
# ========================
mpgram = apply(pgram, 2:3, mean)
  
# Save files.
# =======================
save(pars, file = "models/long_pars.R")
save(smf, file = "data/smf.R")
save(nspec, file = "data/nspec.R")
save(mpgram, file = "data/mpgram.R")

# Clear workspace.
# =======================
rm(list = ls())
