############################
# Load Data.               #
############################

# Load libraries.
# =======================
package_names = c("tidyverse", "ncdf4", "weathermetrics", "abind", "lubridate")
lapply(package_names, library, character.only = TRUE)

# List files.
# =======================
data_files = list.files("./data_raw", full.names = TRUE, pattern = ".nc")

# Open files.
# =======================
ncs = map(data_files, nc_open)

# Read variables (Celsius), times, longitudes, latitudes and attributes from files.
# =======================
var  = kelvin.to.celsius(abind(map(ncs, ncvar_get), along = 3))
lon  = ncvar_get(first(ncs), "lon")
lat  = ncvar_get(first(ncs), "lat")
time = as_date(unlist(map(ncs, ncvar_get, "time")), origin = "2006-01-01")

# Calculate years.
# =======================
year = unique(year(time))

# Annual means function.
# ======================
annual_means = function(x) {
  
  # Return annual means.
  return(colMeans(matrix(x, 12, length(x) / 12)))
  
}

# Calculate annual variables.
# =======================
var = apply(var, 1:2, annual_means)

# Save files.
# =======================
save(var, file = "data/var.R")
save(year, file = "data/year.R")
save(lon, file = "data/lon.R")
save(lat, file = "data/lat.R")

# Clear workspace.
# =======================
rm(list = ls())
