############################
# Longitudinal Functions.  #
############################

# Modified Matern SMF.
# ========================
mod_Matern = function(pars, L){
  
  # Modified Matern SMF.
  SMF = (exp(pars[1]) ^ 2 + 4 * sin(pi * 0:(L - 1) / L) ^ 2) ^ -(exp(pars[2]) + 0.5)
  
  # Return modified Matern SMF.
  return(SMF / mean(SMF))
  
}

# Whittle negative log-likelihood.
# ========================
Whittle_neg_log_like = function(pgram, SMF) {
  
  # Return negative log-likelihood.
  return(0.5 * sum(log(SMF)) + 0.5 * sum(pgram / SMF))
  
}

# Full Whittle negative log-likelihood.
# ========================
full_Whittle_neg_log_like = function(pgram, pars) {
  
  # Spectral mass function.
  SMF = mod_Matern(pars, ncol(pgram))
  
  # Return full Whittle negative log-likelihood.
  return(sum(apply(pgram, 1, Whittle_neg_log_like, SMF = SMF)))
  
}

# Longitudinal model fitting.
# ========================
long_fit = function(pgram) {
  
  optim(par = rep(0, 2), fn = full_Whittle_neg_log_like, pgram = pgram, method = "Nelder-Mead")
  
}

# Calculate normalized spectrum.
# ========================
long_nspec = function(spec, smf) {
  
  # Return NFC.
  return(spec / sqrt(smf))
  
}

# Periodogram title.
# ========================
pgram_title = function(indx, lat) {
  
  # Title latitude.
  title_lat = round(lat[indx])
  
  # Return periodogram title.
  paste0("Periodogram (", abs(title_lat), ifelse(title_lat < 0, "S", "N"), ")")
  
}

# Fancy scientific notation.
# ========================
fancy_scientific <- function(l) {
  
  # Fancify scientific notation.
  l <- format(l, scientific = TRUE)
  l <- gsub("^(.*)e", "'\\1'e", l)
  l <- gsub("e", "%*%10^", l)
  
  # Return scientific notation.
  return(parse(text = l))
  
}
