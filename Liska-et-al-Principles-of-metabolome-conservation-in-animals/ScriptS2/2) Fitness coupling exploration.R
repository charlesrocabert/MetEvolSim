#!/usr/bin/env Rscript

#***************************************************************************
# © 2018-2022 Charles Rocabert, Gábor Boross, Orsolya Liska, Balázs Papp
# Web: https://github.com/charlesrocabert/MetEvolSim
#
# 2) Fitness coupling exploration.R
# ---------------------------------
# Explore fitness coupling for the three models.
#***************************************************************************

library("tidyverse")
library("cowplot")
library("reshape2")
library("ggcorrplot")
library("corrplot")
library("ppcor")
library("iterpc")

### Compute the fitness coupling ###
compute_fitness_coupling <- function( sens, WT, metabolites, fluxes )
{
  fitness_coupling      = cor(abs(sens[,c(metabolites,fluxes)]), method="spearman")
  mean_fitness_coupling = c()
  if (length(fluxes)==1)
  {
    mean_fitness_coupling = (fitness_coupling[metabolites,fluxes])
  }
  if (length(fluxes)>1)
  {
    mean_fitness_coupling = rowMeans(fitness_coupling[metabolites,fluxes])
  }
  X         = t(WT)
  Y         = mean_fitness_coupling[metabolites]
  cort1     = cor.test(X, Y, method="spearman")
  cor_rho1  = cort1$estimate[[1]]
  cor_pval1 = cort1$p.value
  return(c(cor_rho1, cor_pval1))
}

### Explore the fitness coupling of the model ###
explore_fitness_coupling <- function( sens, WT, metabolites, fluxes, target, n_max, reps )
{
  default_w = compute_fitness_coupling(sens, WT, metabolites, target)
  count     = c()
  for(n in seq(1,n_max))
  {
    count = c(count, choose(length(fluxes),n))
  }
  DATA   = c(c(default_w[1], default_w[2]))
  TARGET = c(paste(target, collapse="-"))
  for(rep in seq(1,reps))
  {
    draw     = rmultinom(1, 1, count)
    n        = which(draw==1)
    selected = sample(fluxes, n, replace=F)
    w        = compute_fitness_coupling(sens, WT, metabolites, selected)
    DATA     = rbind(DATA, c(w[1], w[2]))
    TARGET   = c(TARGET, paste(selected, collapse="-"))
    print(rep)
  }
  rownames(DATA) = seq(1,length(DATA[,1]))
  DATA = as.data.frame(DATA)
  names(DATA) = c("Rho", "Pvalue")
  DATA$Target = TARGET
  return(DATA)
}


##################
#      MAIN      #
##################

# Indicate here the location of the folder DataS3 on your computer.
setwd(Path to DataS3)

#----------------------------------------#
# 1) Load Mulquiney et al. (1999) model  #
#----------------------------------------#
print("> Computing Mulquiney et al. (1999) distribution")
index_max   = 56
sens        = read.table("Mulquiney1999_random_sensitivity_analysis.txt", h=T, sep=" ")
metabolites = unique(names(sens))[2:(index_max+1)]
fluxes      = unique(names(sens))[58:110]
constants   = c()
outliers    = read.table("Mulquiney1999_outliers.txt", sep=" ")
metabolites = metabolites[!(metabolites%in%constants)]
metabolites = metabolites[!(metabolites%in%unlist(outliers))]
fluxes      = fluxes[!(fluxes%in%c("vphostransport", "vhbatp", "vhbbpg"))]
WT          = sens[1,metabolites]
sens        = sens[2:length(sens[,1]),]

DATA1 = explore_fitness_coupling(sens, WT, metabolites, fluxes, c("vatpase", "vox", "vbpgsp7"), 3, 10000)
write.table(DATA1, file="Mulquiney1999_fitness_coupling_exploration.txt", row.names=F, col.names=T, sep=" ", quote=F)

#----------------------------------------#
# 2) Load Holzhutter et al. (2004) model #
#----------------------------------------#
print("> Computing Holzhutter et al. (2004) distribution")
index_max   = 45
sens        = read.table("Holzhutter2004_random_sensitivity_analysis.txt", h=T, sep=" ")
metabolites = unique(names(sens))[2:(index_max+1)]
fluxes      = unique(names(sens))[47:84]
constants   = c("Glcout", "Lacex", "Phiex", "Pyrex", "PRPP")
outliers    = read.table("Holzhutter2004_outliers.txt", sep=" ")
metabolites = metabolites[!(metabolites%in%constants)]
metabolites = metabolites[!(metabolites%in%unlist(outliers))]
fluxes      = fluxes[!(fluxes%in%c("v_31", "v_34", "v_36", "v_38"))]
WT          = sens[1,metabolites]
sens        = sens[2:length(sens[,1]),]

DATA2 = explore_fitness_coupling(sens, WT, metabolites, fluxes, c("v_9", "v_16", "v_21", "v_26"), 4, 10000)
write.table(DATA2, file="Holzhutter2004_fitness_coupling_exploration.txt", row.names=F, col.names=T, sep=" ", quote=F)

#----------------------------------------#
# 3) Load Koenig et al. (2012) model     #
#----------------------------------------#
print("> Computing Koenig et al. (2012) distribution")
index_max   = 49
sens        = read.table("Koenig2012_random_sensitivity_analysis.txt", h=T, sep=" ")
metabolites = unique(names(sens))[2:(index_max+1)]
fluxes      = unique(names(sens))[51:86]
constants   = c("pep_mito", "pyr_mito", "amp", "cit_mito", "coa_mito", "glc_ext", "lac_ext", "phos", "phos_mito", "co2", "co2_mito", "atp", "atp_mito", "adp", "adp_mito", "nadh", "nadh_mito", "nad", "nad_mito", "h2o", "h2o_mito", "h", "h_mito", "acoa_mito", "gtp", "gdp", "oaa")
outliers    = read.table("Koenig2012_outliers.txt", sep=" ")
metabolites = metabolites[!(metabolites%in%constants)]
metabolites = metabolites[!(metabolites%in%unlist(outliers))]
fluxes      = fluxes[!(fluxes%in%c("NDKGTP", "AK", "PEPCK", "OAAFLX", "ACOAFLX", "CITFLX"))]
### Merge PYR AND PEP ###
pairs = rbind(
  c("pep", "pep_mito"),
  c("pyr", "pyr_mito")
)
for(i in seq(1,length(pairs[,1])))
{
  pair  = (pairs[i,])
  x1_wt = sens[1,pair[1]][[1]]
  x2_wt = sens[1,pair[2]][[1]]
  xtot  = x1_wt+x2_wt
  x1    = sens[2:length(sens[,1]),pair[1]]*x1_wt+x1_wt
  x2    = sens[2:length(sens[,1]),pair[2]]*x2_wt+x2_wt
  dlnX  = (x1+x2-xtot)/xtot
  sens[,pair[1]] = c(xtot, dlnX)
}
#########################
WT   = sens[1,metabolites]
sens = sens[2:length(sens[,1]),]

DATA3 = explore_fitness_coupling(sens, WT, metabolites, fluxes, c("GS", "GP", "PC", "PDH"), 4, 10000)
write.table(DATA3, file="Koenig2012_fitness_coupling_exploration.txt", row.names=F, col.names=T, sep=" ", quote=F)

