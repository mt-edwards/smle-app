############################
# Temp NetCDF.             #
############################

# Libraries.
# =======================
package_names = c("tidyverse", "plyr", "RNetCDF")
lapply(package_names, library, character.only = TRUE)

# Source functions.
# =======================
source("scripts/temp_fun.R")

# Load data.
# =======================
file_names = c("models/temp_pars.R", "data/lon.R", "data/lat.R")
map(file_names, load, .GlobalEnv)

# Save NetCDF files.
# =======================
map2(alply(pars, 1), first(dimnames(pars)), save_ncdf, lon = lon, lat = lat)

# Clear workspace.
# =======================
rm(list = ls())
