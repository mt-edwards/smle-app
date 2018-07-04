##########################
# Periodogram Plots.     #
##########################

# Libraries.
# ========================
package_names = c("tidyverse")
lapply(package_names, library, character.only = TRUE)

# Source functions.
# ========================
source("scripts/long_fun.R")
source("scripts/lat_fun.R")

# Load files.
# ========================
file_names = c("data/smf.R", "data/csmf.R", "data/mpgram.R", "data/mcpgram.R", "data/lat.R", "data/resid.R")
map(file_names, load, .GlobalEnv)

# Prediodogram data frame.
# ========================
indx = c(43, 86, 128, 160)
pgram_df = tibble(Periodogram  = as.vector(cbind(mpgram[, indx], mcpgram[, indx])),
                  SMF          = as.vector(cbind(smf[, indx], csmf[, indx])),
                  Type         = factor(rep(c("Auto-spectra", "Cross-spectra"), each = length(Periodogram) / 2)),
                  Location     = factor(rep(rep(pgram_title(indx, lat), each = nrow(mpgram)), 2), 
                                     levels = unique(pgram_title(indx, lat))),
                  Frequency    = rep(0:(nrow(mpgram) - 1) / nrow(mpgram), length(indx) * 2))

# title.
# ========================
pgram_title = function(indx, lat) {
  
  # Title latitude.
  title_lat = round(lat[indx])
  
  # Return periodogram title.
  paste(abs(title_lat), ifelse(title_lat < 0, "South", "North"))
  
}

# Periodogram plot.
# ========================
ggplot(pgram_df, aes(x = Frequency)) +
  geom_point(aes(y = Mod(Periodogram)), col = "blue", shape = 1) +
  geom_line(aes(y = SMF), col = "red", lwd = 1.1) +
  facet_grid(Type ~ Location, scales = "free_y") +
  scale_x_continuous(limits = c(0, 0.5)) +
  scale_y_continuous(labels = fancy_scientific,
                     trans = "log10") +
  ylab("Spectrum") +
  theme_bw()

# Save plot.
# ========================
ggsave("pgram_plot.png", path = "plots", width = 15, height = 8, units = "cm")

# Clear workspace.
# ========================
rm(list = ls())