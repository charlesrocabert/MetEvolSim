#!/usr/bin/env Rscript

#***************************************************************************
# © 2018-2022 Charles Rocabert, Gábor Boross, Orsolya Liska, Balázs Papp
# Web: https://github.com/charlesrocabert/MetEvolSim
#
# 5) Holzhutter2004 MCS distribution.R
# ------------------------------------
# Create the figure showing the MCS distibution of the Holzhutter (2004)
# model.
#***************************************************************************

library("tidyverse")
library("cowplot")
library("reshape2")
library("ggcorrplot")
library("corrplot")
library("ppcor")
library("ggpubr")


##################
#      MAIN      #
##################

# Indicate here the location of the folder DataS3 on your computer.
setwd(Path to DataS3)

#-------------------------------------------------------#
# 1) Load simulation data                               #
#-------------------------------------------------------#
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
y_range       = range(c(drift$mean_CS-drift$sd_CS, drift$mean_CS+drift$sd_CS, select$mean_CS-select$sd_CS, select$mean_CS+select$sd_CS))
y_range[2]    = y_range[2]+0.9

#-------------------------------------------------------#
# 2) Build the dataset                                  #
#-------------------------------------------------------#
dataset = c()
for(met in metabolites)
{
	CS_drift     = drift[drift$species_id==met,"mean_CS"]
	CS_selection = select[select$species_id==met,"mean_CS"]
	Abundance    = drift[drift$species_id==met,"wild_type_X"]
	Coupling     = coupling[met][[1]]
	dataset      = rbind(dataset, c(CS_drift, CS_selection, Abundance, Coupling))
}
dataset        = as.data.frame(dataset)
names(dataset) = c("CS_drift", "CS_selection", "Abundance", "Fitness_coupling")

#-------------------------------------------------------#
# 3) Create the figure                                  #
#-------------------------------------------------------#
N = length(dataset[,1])
D = c(dataset$CS_drift, dataset$CS_selection)
D = as.data.frame(D)
D$Selection = c(rep("Genetic drift",N),rep("Stabilizing selection",N))
names(D) = c("MCS", "Experiment")
##################################
my_samp        = table(D$Experiment)
my_samp        = as.data.frame(cbind(c("Genetic drift","Stabilizing selection"),c(my_samp[[1]],my_samp[[2]])))
names(my_samp) = c("Experiment", "n")
my_comp        = list(c("Genetic drift", "Stabilizing selection"))
pvalue_size    = 2.5
##################################
p = ggplot(D, aes(x=Experiment, y=MCS))+
  geom_boxplot()+
  geom_jitter(width=0.2) +
  theme_minimal()+
  scale_fill_manual(values = c('tan1', "#3497a9")) +
  xlab("")+
  ylab("MCS")+
  ggtitle("Metabolite conservation score distributions under genetic drift and stabilizing selection")+
  stat_compare_means(comparisons=my_comp, method="t.test")+
  geom_text(data=my_samp, aes(label = sprintf('n = %s', n), y=13.5), vjust=1.5) +
  theme(axis.text.x=element_text(size=12),
        axis.text.y=element_text(size=12),
        legend.position = 'None')

ggsave("Holzhutter2004_MCS_distribution.png", p, dpi=600, bg="white", width = 9, height = 8)

#-------------------------------------------------------#
# 4) Show Welch two-sample t-test with unequal variance #
#-------------------------------------------------------#
t.test(D[D$Experiment=="Genetic drift","MCS"], D[D$Experiment=="Stabilizing selection","MCS"])

