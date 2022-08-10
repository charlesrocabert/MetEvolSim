#!/usr/bin/env Rscript

#***************************************************************************
# © 2018-2022 Charles Rocabert, Gábor Boross, Orsolya Liska, Balázs Papp
# Web: https://github.com/charlesrocabert/MetEvolSim
#
# 4) Holzhutter2004 fitness coupling exploration.R
# ------------------------------------------------
# Create the figure showing the fitness coupling exploration for the
# Holzhutter (2004) model.
#***************************************************************************

library("tidyverse")
library("cowplot")

### Plot the fitness coupling distribution ###
plot_fitness_coupling_distribution <- function(filename, title)
{
  coupling = read.table(filename, sep=" ", h=T)
  ratio    = length(coupling[coupling[,1]<coupling$Rho[[1]],"Rho"])/length(coupling$Rho)
  Target   = paste("> ",round(ratio*100,2),"%", sep="")
  p = ggplot(coupling, aes(Rho)) +
    geom_histogram(alpha=0.8, fill="#3497a9") +
    geom_vline(xintercept=coupling$Rho[[1]], color="tan1", size=1.5) +
    annotate(geom="label", x=coupling$Rho[[1]], y=1100, label=Target, fill="white") +
    xlab("Estimates of the Spearman correlation between\nmetabolite abundances and their fitness coupling") +
    ylab("Count") +
    ggtitle(title) +
    theme_minimal()
  return(p)
}

### Compute the abundance/CS correlation for a given statistics file ###
compute_correlation <- function( filename, index_max, outliers, sens, target )
{
  #####################
  d           = read.table(filename, h=T, sep=" ")
  metabolites = d$species_id[1:index_max]
  metabolites = metabolites[!(metabolites%in%unlist(outliers))]
  d           = d[d$species_id%in%metabolites,]
  test1       = cor.test(log10(d$mean), 1/log10(d$ER), method="spearman")
  #####################
  coupling = cor(abs(sens[,c(metabolites,target)]), method="spearman")
  if (length(target) > 1)
  {
    coupling = rowMeans(coupling[metabolites,target])
  }
  if (length(target) == 1)
  {
    coupling = coupling[metabolites,target]
  }
  test2 = cor.test(1/log10(d$ER), coupling, method="spearman")
  return(c(test1$estimate[[1]], test1$p.value, test2$estimate[[1]], test2$p.value, mean(coupling)))
}

### Plot the simulation dataset ###
plot_simulation_dataset <- function( exploration, nb_evals, index_max, outliers, sens, title )
{
  Rho       = c()
  Pvalue    = c()
  EvoRho    = c()
  EvoPvalue = c()
  WCSCor    = c()
  MeanW     = c()
  Target    = c()
  for(i in seq(1, nb_evals))
  {
    rho       = exploration$Rho[i]
    pvalue    = exploration$Pvalue[i]
    target    = unlist(strsplit(exploration$Target[i], "-"))
    try({
      res       = compute_correlation(paste("Holzhutter2004_fitness_coupling_simulations/statistics_",i,".txt", sep=""), index_max, outliers, sens, target)
      print(res)
      Rho       = c(Rho, rho)
      Pvalue    = c(Pvalue, pvalue)
      EvoRho    = c(EvoRho, res[1])
      EvoPvalue = c(EvoPvalue, res[2])
      WCSCor    = c(WCSCor, res[3])
      MeanW     = c(MeanW, res[5])
      Target    = c(Target, exploration$Target[i])
    })
  }
  dataset        = as.data.frame(cbind(Rho, Pvalue, EvoRho, EvoPvalue, WCSCor, MeanW))
  dataset$Target = Target
  cort           = cor.test(dataset$Rho, dataset$EvoRho, method="spearman")
  cor_pval       = formatC(cort$p.value, format="e", digits=2)
  cor_rho        = round(cort$estimate[[1]],2)
  stat_line      = paste("Spearman ρ = ", cor_rho, "\n(p-value = ", cor_pval, ")", sep="")
  
  p = ggplot(dataset, aes(x=Rho, y=EvoRho)) +
    annotate(geom="text", x=-0.4, y=0.65, label=stat_line, hjust=0, size=3.5) +
    geom_point() +
    geom_smooth(method="lm", color="#3497a9", fill="#3497a9") +
    geom_point(aes(x=dataset$Rho[1], y=dataset$EvoRho[1]), size=3, color="tan1") +
    xlab("Abundance/Fitness coupling\nSpearman correlation estimate") +
    ylab("Abundance/MCS\nSpearman correlation estimate (1 simulation)") +
    ggtitle(title) +
    theme_minimal() +
    theme(legend.position="none")
  return(p)
}


##################
#      MAIN      #
##################

# Indicate here the location of the folder DataS3 on your computer.
setwd(Path to DataS3)

#--------------------------------------#
# 1) Plot the first panel              #
#--------------------------------------#
p1 = plot_fitness_coupling_distribution("Holzhutter2004_fitness_coupling_exploration.txt", "Exploration of 10,000 random combinations\nof key metabolic fluxes")

#--------------------------------------#
# 2) Compute and plot the second panel #
#--------------------------------------#
nb_evals    = 100
exploration = read.table("Holzhutter2004_fitness_coupling_exploration.txt", sep=" ", h=T)
exploration = exploration[1:nb_evals,]
index_max   = 45
outliers    = read.table("Holzhutter2004_outliers.txt", sep=" ")
sens        = read.table("Holzhutter2004_random_sensitivity_analysis.txt", h=T, sep=" ")
sens        = sens[2:length(sens[,1]),]

p2 = plot_simulation_dataset(exploration, nb_evals, index_max, outliers, sens, "Stabilizing selection simulations\nfor 100 random combinations of key metabolic fluxes")

#--------------------------------------#
# 3) Generate the figure               #
#--------------------------------------#
p = plot_grid(p1, p2, labels="AUTO")

ggsave("Holzhutter2004_fitness_coupling_exploration.png", p, dpi=600, bg="white", scale=2, width=6, height=2.7)

