############################
# Temp Functions.          #
############################

# Temporal selection function.
# =======================
temp_fit = function(y, year) {
  
  # Return temporal model.
  return(auto.arima(y, stationary = TRUE, ic = "aic", max.p = 3, max.q = 0, xreg = year))
  
}

# Temporal parameters.
# ========================
temp_pars = function(mod) {
  
  # Parameters.
  mean  = unname(mod[[1]]$coef["intercept"])
  trend = unname(mod[[1]]$coef["year"])
  ar1   = unname(mod[[1]]$coef["ar1"])
  std   = unname(sqrt(mod[[1]]$sigma2))
  
  # Return parameters.
  return(c(mean  = ifelse(is.na(mean), 0, mean) + 2018 * ifelse(is.na(trend), 0, trend),
           trend = ifelse(is.na(trend), 0, trend * 10),
           ar1   = ifelse(is.na(ar1), 0, ar1), 
           std   = std))
  
}

#  Residual function.
# =======================
temp_resid = function(mod, year) {
  
  # Return residuals.
  return(scale(mod[[1]]$residuals) * sqrt(length(year) / (length(year) - 1)))
  
} 

# Fourier transform function.
# ========================
temp_fft = function(resid) {
  
  # Return normalised FFT.
  return(fft(resid) / sqrt(length(resid)))
  
}

# Periodogram function.
# ========================
temp_pgram = function(spec) {
  
  # Return periodogram.
  return(Mod(spec) ^ 2)
  
}

# Save NetCDF file.
# =======================
save_ncdf = function(var, lon, lat, name) {
  
  # Create NetCDF file.
  nc = create.nc(paste0("data_ncdf/", name, ".nc"))
  
  # Define dimensions.
  dim.def.nc(nc, "lon", length(lon))
  dim.def.nc(nc, "lat", length(lat))
  
  # Define variables.
  var.def.nc(nc, "lon", "NC_DOUBLE", 0)
  var.def.nc(nc, "lat", "NC_DOUBLE", 1)
  var.def.nc(nc, "var", "NC_FLOAT", c(0, 1))
  
  # Put attributes.
  att.put.nc(nc, "var", "coordinates", "NC_CHAR", "long lat")
  
  # Put variables.
  var.put.nc(nc, "lon", lon)
  var.put.nc(nc, "lat", lat)
  var.put.nc(nc, "var", var)
  
  # Close NetCDF file.
  close.nc(nc)
  
}
