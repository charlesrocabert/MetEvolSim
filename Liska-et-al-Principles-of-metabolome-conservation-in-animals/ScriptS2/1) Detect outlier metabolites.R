#!/usr/bin/env Rscript

#***************************************************************************
# © 2018-2022 Charles Rocabert, Gábor Boross, Orsolya Liska, Balázs Papp
# Web: https://github.com/charlesrocabert/MetEvolSim
#
# 1) Detect outlier metabolites.R
# -------------------------------
# Detect outlier metabolites from sensitivity analysis.
#***************************************************************************

library("tidyverse")
library("cowplot")

### Detect outliers ###
detect_outliers <- function( model_name, index_max, to_remove, target, z_th )
{
  sens_filename = paste(model_name, "_random_sensitivity_analysis.txt", sep="")
  sens          = read.table(sens_filename, h=T, sep=" ")
  sens          = sens[2:length(sens[,1]),]
  met           = unique(names(sens))[2:(index_max+1)]
  met           = met[!(met %in% c(to_remove))]
  msens         = colMeans(abs(sens[,met]))
  coupling      = cor(abs(sens[,c(met,target)]), method="spearman")
  coupling      = rowMeans(coupling[met,target])
  metabolites_to_remove = c()
  ##########################
  X        = log10(msens)
  Z        = (X-mean(X))/sd(X)
  names(Z) = met
  metabolites_to_remove = c(metabolites_to_remove, names(Z[Z<(-z_th)]))
  ##########################
  X = coupling
  Z = (X-mean(X))/sd(X)
  metabolites_to_remove = c(metabolites_to_remove, names(Z[Z<(-z_th)]))
  ##########################
  return(unique(metabolites_to_remove))
}


##################
#      MAIN      #
##################

# Indicate here the location of the folder DataS3 on your computer.
setwd(Path to DataS3)

z_th = 1.96

#-----------------------------------#
# 1) Mulquiney et al. (1999)        #
#-----------------------------------#
model_name = "Mulquiney1999"
index_max  = 56
to_remove  = c()
target     = c("vatpase", "vox", "vbpgsp7")
outliers1  = detect_outliers(model_name, index_max, to_remove, target, z_th)
write.table(outliers1, file="Mulquiney1999_outliers.txt", sep=" ", row.names=F, col.names=F, quote=F)

#-----------------------------------#
# 2) Holzhutter et al. (2004)       #
#-----------------------------------#
model_name = "Holzhutter2004"
index_max  = 45
to_remove  = c("Glcout", "Lacex", "Phiex", "Pyrex", "PRPP")
target     = c("v_9", "v_16", "v_21", "v_26")
outliers2  = detect_outliers(model_name, index_max, to_remove, target, z_th)
write.table(outliers2, file="Holzhutter2004_outliers.txt", sep=" ", row.names=F, col.names=F, quote=F)

#-----------------------------------#
# 3) Koenig et al. (2012)           #
#-----------------------------------#
model_name = "Koenig2012"
index_max  = 49
to_remove  = c("amp", "cit_mito", "coa_mito", "glc_ext", "lac_ext", "phos", "phos_mito", "co2", "co2_mito", "atp", "atp_mito", "adp", "adp_mito", "nadh", "nadh_mito", "nad", "nad_mito", "h2o", "h2o_mito", "h", "h_mito", "acoa_mito", "gtp", "gdp", "oaa")
target     = c("GS", "GP", "PC", "PDH")
outliers3  = detect_outliers(model_name, index_max, to_remove, target, z_th)
write.table(outliers3, file="Koenig2012_outliers.txt", sep=" ", row.names=F, col.names=F, quote=F)

#-----------------------------------#
# 4) Show the metabolites to remove #
#-----------------------------------#
print("====== Mulquiney et al. (1999) outliers ======")
outliers1
print("====== Holzhutter et al. (2004) outliers ======")
outliers2
print("====== Koenig et al. (2012) outliers ======")
outliers3

