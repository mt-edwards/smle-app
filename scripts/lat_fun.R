##########################
# Latitudinal functions. #
##########################

# Coherence function
# =======================
coh_fun = function(par, c, L) {
  
  # Return coherence mass function.
  return(plogis(par[1]) * (1 + 4 * sin(pi * c / L) ^ 2) ^ -exp(par[2]))
  
}

# Coherence matrix.
# =======================
coh_matrix = function(par, c, L, M) {
  
  # Return coherence mass function.
  return(coh_fun(par, c, L) ^ as.matrix(dist(seq_len(M))))
  
}

# Quadratic form.
# =======================
# - A is the inverse transpose cholesky triangle.
quad_form = function(x, Rinv) {
  
  # Return negative log-likelihood.
  return(sum(Mod(crossprod(Rinv, x)) ^ 2))
  
}

# Latitudianal negative log-likelihood.
# =======================
lat_neg_log_like = function(X, Rinvs, LD) {
  
  # Quadratic form.
  quad_form = sum(sapply(seq_along(Rinvs), function(i) quad_form(X[i, ], Rinvs[[i]])))
  
  # Negative log-likelhood.
  return(LD + 0.5 * quad_form)
  
}

# Full latitiudinal ngative log-likelihood.
# =======================
full_lat_neg_log_like = function(par, nspec) {
  
  # Invesre Cholesky factors.
  Rinvs  = lapply(seq_len(dim(nspec)[2]), function(c) solve(chol(coh_matrix(par, c - 1, dim(nspec)[2], dim(nspec)[3]))))
  
  # Log-determinant.
  LD = sum(sapply(Rinvs, function(Rinv) log(1 / prod(diag(Rinv)))))
  
  # Force evaluation.
  nspec = nspec; Rinvs = Rinvs; LD = LD
  
  # Cluster computation.
  return(sum(parApply(cl, nspec, 1, function(X) lat_neg_log_like(X, Rinvs, LD))))
  
}

# Latitudinal model fitting.
# ========================
lat_fit = function(nspec) {
  
  # Return latitudinal model fit.
  return(optim(par = rep(0, 2), fn = full_lat_neg_log_like, nspec = nspec, method = "Nelder-Mead"))
  
}

# Cross-spectral mass function.
# ========================
lat_csmf = function(smf, coh) {
  
  # Return cross-spectral mass function.
  return(sqrt(smf[, -ncol(smf)]) * matrix(coh, length(coh), ncol(smf) - 1) * sqrt(smf[, -1]))
  
}

# Spectrum concatinate.
# ========================
spec_con = function(spec) {
  
  # Return concatinated spectrum.
  return(abind(spec[, -ncol(spec)], spec[, -1], along = 0))
  
}

# Cross-periodogram.
# ========================
lat_cpgram = function(spec) {
  
  return(spec[1, ] * Conj(spec[2, ]))
  
} 

# Cross-periodogram title.
# ========================
cpgram_title = function(indx, lat) {
  
  # Title latitude.
  title_lat = round(lat[indx])
  
  # Return periodogram title.
  paste0("Cross-periodogram (", abs(title_lat), ifelse(title_lat < 0, "S", "N"), ")")
  
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
