#!/usr/bin/env Rscript

#***************************************************************************
# © 2018-2022 Charles Rocabert, Gábor Boross, Orsolya Liska, Balázs Papp
# Web: https://github.com/charlesrocabert/MetEvolSim
#
# 8) Holhutter2004 dosage sensitivity.R
# --------------------------------------
# Analyze flux dosage sensitivities and make the figure.
#***************************************************************************

library("tidyverse")
library("cowplot")
library("reshape2")
library("ggcorrplot")
library("corrplot")
library("ppcor")
library("ggpubr")
library("MASS")


##################
#      MAIN      #
##################

# Indicate here the location of the folder DataS3 on your computer.
setwd(Path to DataS3)

#-----------------------------------------#
# 1) Load simulation data                 #
#-----------------------------------------#
sim           = read.table("Holzhutter2004_simulations.txt", h=T, sep=" ")
sens          = read.table("Holzhutter2004_random_sensitivity_analysis.txt", h=T, sep=" ")
sens          = sens[2:length(sens[,1]),]
drift         = sim[sim$threshold==Inf,]
select        = sim[sim$threshold==1e-4,]
metabolites   = select$species_id
outliers      = read.table("Holzhutter2004_outliers.txt", sep=" ")
metabolites   = metabolites[!(metabolites%in%unlist(outliers))]
target_fluxes = c("v_9", "v_16", "v_21", "v_26")
coupling      = cor(abs(sens[,c(metabolites,target_fluxes)]), method="spearman")
coupling      = rowMeans(coupling[metabolites,target_fluxes])
drift         = drift[drift$species_id%in%metabolites,]
select        = select[select$species_id%in%metabolites,]

#-----------------------------------------#
# 2) Build the dosage sensitivity dataset #
#-----------------------------------------#
drift       = drift[order(drift$wild_type_X),]
ordered_met = drift$species_id
dosage      = c()
flux        = c()
metabolite  = c()
abundance   = c()
for (met in ordered_met)
{
  for (flx in target_fluxes)
  {
    X          = abs(sens[,flx]/sens[,met])
    X          = X[!is.na(X) & !is.infinite(X)]
    dosage     = c(dosage, mean(X))
    flux       = c(flux, flx)
    metabolite = c(metabolite, met)
    abundance  = c(abundance, drift[drift$species_id==met,"wild_type_X"])
  }
}
dosage = data.frame(dosage, flux, metabolite, abundance)

#-----------------------------------------#
# 3) Generate the figure                  #
#-----------------------------------------#
test      = cor.test(dosage$abundance, dosage$dosage, method="spearman")
stat_line = paste("Spearman ρ = ", signif(test$estimate, 2), " (n = 35)\n(p-value = ", signif(test$p.value, 2), ")", sep="")

p = ggplot(dosage, aes(x=metabolite, y=log10(dosage))) +
  geom_boxplot(angle=90, fill=rgb(81,149,167,max=255)) +
  annotate(geom="text", x=3, y=3, label=stat_line, hjust=0, size=3.5) +
  xlab("Metabolites (ordered by increasing abundance)") +
  ylab("Dosage sensitivity (log-scale)") +
  ggtitle("Dosage sensitivity does not correlate with metabolite abundance") +
  theme_minimal() +
  theme(axis.text.x=element_text(angle=90, vjust=0.5, hjust=1))

ggsave("/Users/charlesrocabert/git/MetEvolSim-development/Model_analysis/Figures/Holzhutter2004_dosage_sensitivity.png", p, dpi=600, width=5, height=3, scale=2, bg="white")



