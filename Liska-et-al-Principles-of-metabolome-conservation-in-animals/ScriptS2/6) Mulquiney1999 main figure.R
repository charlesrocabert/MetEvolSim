#!/usr/bin/env Rscript

#***************************************************************************
# © 2018-2022 Charles Rocabert, Gábor Boross, Orsolya Liska, Balázs Papp
# Web: https://github.com/charlesrocabert/MetEvolSim
#
# 6) Mulquiney1999 main figure.R
# ------------------------------
# Create the main figure for the Mulquiney (1999) model.
#***************************************************************************

library("tidyverse")
library("cowplot")
library("reshape2")
library("ggcorrplot")
library("corrplot")
library("ppcor")
library("ggpubr")

### Build the enzyme essentiality score dataset, given the drop coefficient and the dist threshold ###
build_enzyme_essentiality_score_dataset <- function( drop_coefficient, dist_threshold )
{
  #----------------------------------------#
  # 1) Load and prepare data               #
  #----------------------------------------#
  sim           = read.table("Mulquiney1999_simulations.txt", h=T, sep=" ")
  sens          = read.table("Mulquiney1999_random_sensitivity_analysis.txt", h=T, sep=" ")
  sens          = sens[2:length(sens[,1]),]
  drift         = sim[sim$threshold==Inf,]
  select        = sim[sim$threshold==1e-5,]
  metabolites   = select$species_id
  outliers      = read.table("Mulquiney1999_outliers.txt", sep=" ")
  metabolites   = metabolites[!(metabolites%in%unlist(outliers))]
  target_fluxes = c("vatpase", "vox", "vbpgsp7")
  coupling      = cor(abs(sens[,c(metabolites,target_fluxes)]), method="spearman")
  coupling      = rowMeans(coupling[metabolites,target_fluxes])
  drift         = drift[drift$species_id%in%metabolites,]
  select        = select[select$species_id%in%metabolites,]
  #----------------------------------------#
  # 2) Build the dataset                   #
  #----------------------------------------#
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
  dataset$Name   = metabolites
  names(dataset) = c("CS_drift", "CS_selection", "Abundance", "Fitness_coupling", "Name")
  #----------------------------------------#
  # 3) Build the flux drop data            #
  #----------------------------------------#
  flux_drop    = read.table("Mulquiney1999_flux_drop_analysis.txt", h=T, sep=" ")
  flux_drop    = flux_drop[flux_drop$drop_value < 1.01*drop_coefficient & flux_drop$drop_value > 0.99*drop_coefficient,]
  fluxes       = unique(flux_drop$reaction)
  flux_to_met  = read.table("Mulquiney1999_reaction_to_species_map.txt", h=F, sep=" ")
  REACTION     = c()
  METABOLITE   = c()
  MOMA         = c()
  ABUNDANCE    = c()
  COUPLING     = c()
  CS_DRIFT     = c()
  CS_SELECTION = c()
  for (flux in fluxes)
  {
    reaction = flux
    moma     = flux_drop[flux_drop$reaction==reaction,"dist"]
    if (!is.na(moma))
    {
      ### Initialization ###
      Lmap = flux_to_met[flux_to_met[,1]==flux,]
      for (i in 1:length(Lmap[,1]))
      {
        pos = Lmap[i,2]
        met = Lmap[i,3]
        if (met %in% dataset$Name & !(met %in% unlist(outliers)))
        {
          REACTION     = c(REACTION, reaction)
          METABOLITE   = c(METABOLITE, met)
          MOMA         = c(MOMA, moma)
          ABUNDANCE    = c(ABUNDANCE, dataset[dataset$Name==met,"Abundance"])
          COUPLING     = c(COUPLING, dataset[dataset$Name==met,"Fitness_coupling"])
          CS_DRIFT     = c(CS_DRIFT, dataset[dataset$Name==met,"CS_drift"])
          CS_SELECTION = c(CS_SELECTION, dataset[dataset$Name==met,"CS_selection"])
        }
      }
    }
  }
  ess_analysis            = data.frame(MOMA, ABUNDANCE, COUPLING, CS_DRIFT, CS_SELECTION)
  names(ess_analysis)     = c("Dist", "Abundance", "Fitness_coupling", "CS_drift", "CS_selection")
  ess_analysis$Reaction   = REACTION
  ess_analysis$Metabolite = METABOLITE
  ess_analysis$Drop_coef  = rep(drop_coefficient, length(ess_analysis[,1]))
  ess_analysis$Dist[ess_analysis$Dist < dist_threshold] = 0
  ess_analysis$Dist[ess_analysis$Dist >= dist_threshold] = 1
  ess_analysis$Dist = as.factor(ess_analysis$Dist)
  #----------------------------------------#
  # 4) Re-organize the data per metabolite #
  #----------------------------------------#
  res            = as.data.frame.matrix(table(ess_analysis$Metabolite, ess_analysis$Dist))
  res$Metabolite = rownames(res)
  rownames(res)  = c()
  res            = res[,c(3,2)]
  names(res)     = c("Metabolite", "Essential")
  res$Essential[res$Essential>0] = 1
  res$Essential = as.factor(res$Essential)
  Abundance     = c()
  CS_selection  = c()
  CS_drift      = c()
  for(met in res$Metabolite)
  {
    Abundance    = c(Abundance, select[select$species_id==met,"wild_type_X"])
    CS_selection = c(CS_selection, select[select$species_id==met,"mean_CS"])
    CS_drift     = c(CS_drift, drift[drift$species_id==met,"mean_CS"])
  }
  res$Abundance    = Abundance
  res$CS_selection = CS_selection
  res$CS_drift     = CS_drift
  return(res)
}

### Plot the abundance/CS figure  ###
plot_abund_CS <- function( D, title, y_range, stat_line_x, stat_line_y )
{
  cort      = cor.test(D$wild_type_X, D$mean_CS, method="spearman")
  cor_pval  = formatC(cort$p.value, format="e", digits=2)
  cor_rho   = round(cort$estimate[[1]],2)
  stat_line = paste("Spearman ρ = ", cor_rho, "\n(p-value = ", cor_pval, ")", sep="")
  p = ggplot(D, aes(x=wild_type_X, y=mean_CS)) +
    geom_smooth(color="#3497a9", fill="#3497a9", span=0.9) +
    geom_point() +
    geom_errorbar(aes(ymin=mean_CS-sd_CS, ymax=mean_CS+sd_CS), width=.2) +
    annotate(geom="text", x=stat_line_x, y=stat_line_y, label=stat_line, hjust=0, size=3.5) +
    ylim(y_range[1], y_range[2]) +
    xlab("Metabolite abundance (log-scale)") +
    ylab("Metabolite conservation score\n(log-scale)") +
    ggtitle(title) +
    theme_minimal()
  return(p)
}

### Plot the Essentiality/CS figure  ###
plot_ES_CS <- function( D, title, y_range, selection )
{
  my_comp = list(c("0", "1"))
  my_samp = table(D$Essential)
  my_samp = as.data.frame(cbind(c("0","1"),c(my_samp[[1]],my_samp[[2]])))
  names(my_samp) = c("Essential", "n")
  if (selection == "Selection")
  {
    p = ggplot(D, aes(Essential, CS_selection, group=Essential)) +
      geom_boxplot(fill=rgb(81,149,167,max=255)) +
      geom_jitter(width=0.2) +
      xlab("") +
      ylab("Metabolite conservation score\n(log-scale)") +
      ggtitle("Stabilizing selection") +
      scale_x_discrete(labels=c("Non essential\nreaction","Essential\nreaction")) +
      scale_y_continuous(expand=expansion()) +
      geom_text(data=my_samp, aes(label = sprintf('n = %s', n), y=-4), vjust=1.5) +
      stat_compare_means(comparisons=my_comp, method="wilcox.test", vjust=-0.5) +
      ylim(y_range[1], y_range[2]+1.5) +
      theme_minimal() +
      theme(axis.text=element_text(size=10))
    return(p)
  }
  if (selection == "Drift")
  {
    p = ggplot(D, aes(Essential, CS_drift, group=Essential)) +
      geom_boxplot(fill=rgb(81,149,167,max=255)) +
      geom_jitter(width=0.2) +
      xlab("") +
      ylab("Metabolite conservation score\n(log-scale)") +
      ggtitle("Genetic drift") +
      scale_x_discrete(labels=c("Non essential\nreaction","Essential\nreaction")) +
      #scale_y_continuous(expand=expansion()) +
      geom_text(data=my_samp, aes(label = sprintf('n = %s', n), y=-3.5), vjust=1.5) +
      stat_compare_means(comparisons=my_comp, method="wilcox.test", vjust=-0.5) +
      ylim(y_range[1], y_range[2]+1.5) +
      theme_minimal() +
      theme(axis.text=element_text(size=10))
    return(p)
  }
}

### Plot the fitness coupling ###
plot_fitness_coupling <- function( D )
{
  reg         = lm(D$Fitness_coupling~D$Abundance)
  cort        = cor.test(D$Abundance, D$Fitness_coupling, method="spearman")
  reg_pval    = formatC(summary(reg)$coefficients[2,4], format="e", digits=2)
  reg_rsquare = round(summary(reg)$r.squared,2)
  cor_pval    = formatC(cort$p.value, format="e", digits=2)
  cor_rho     = round(cort$estimate[[1]],2)
  stat_line   = paste("Spearman ρ = ", cor_rho, "\n(p-value = ", cor_pval, ")", sep="")
  p = ggplot(D, aes(x=Abundance, y=Fitness_coupling)) +
    geom_smooth(color="tan1", fill="tan1", span=0.9) +
    geom_point() +
    annotate(geom="text", x=-9, y=0.43, label=stat_line, hjust=0, size=3.5) +
    xlab("Metabolite abundance (log-scale)") +
    ylab("Fitness coupling") +
    ggtitle("Fitness coupling") +
    theme_minimal()
  return(p)
}

### Plot the fitness coupling distribution ###
plot_fitness_coupling_distribution <- function( filename, title )
{
  coupling = read.table(filename, sep=" ", h=T)
  ratio    = length(coupling[coupling[,1]<coupling$Rho[[1]],"Rho"])/length(coupling$Rho)
  Target   = paste("> ",round(ratio*100,2),"%", sep="")
  p = ggplot(coupling, aes(Rho)) +
    geom_histogram(alpha=0.8, fill="#3497a9") +
    geom_vline(xintercept=coupling$Rho[[1]], color="tan1", size=1.5) +
    annotate(geom="label", x=coupling$Rho[[1]], y=2200, label=Target, fill="white") +
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
  test1       = cor.test(log10(d$mean), log10(1/d$ER), method="spearman")
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
  test2 = cor.test(log10(1/d$ER), coupling, method="spearman")
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
      res       = compute_correlation(paste("Mulquiney1999_fitness_coupling_simulations/statistics_",i,".txt", sep=""), index_max, outliers, sens, target)
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
    annotate(geom="text", x=0.1, y=0.52, label=stat_line, hjust=0, size=3.5) +
    geom_point() +
    geom_smooth(method="lm", color="#3497a9", fill="#3497a9") +
    geom_point(aes(x=dataset$Rho[1], y=dataset$EvoRho[1]), size=3, color="tan1") +
    xlab("Abundance/Fitness coupling\nSpearman ρ") +
    ylab("Abundance/MCS\nSpearman ρ (1 simulation)") +
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

#-------------------------#
# 1) Load simulation data #
#-------------------------#
sim           = read.table("Mulquiney1999_simulations.txt", h=T, sep=" ")
sens          = read.table("Mulquiney1999_random_sensitivity_analysis.txt", h=T, sep=" ")
sens          = sens[2:length(sens[,1]),]
drift         = sim[sim$threshold==Inf,]
select        = sim[sim$threshold==1e-5,]
metabolites   = select$species_id
outliers      = read.table("Mulquiney1999_outliers.txt", sep=" ")
metabolites   = metabolites[!(metabolites%in%unlist(outliers))]
target_fluxes = c("vatpase", "vox", "vbpgsp7")
coupling      = cor(abs(sens[,c(metabolites,target_fluxes)]), method="spearman")
coupling      = rowMeans(coupling[metabolites,target_fluxes])
drift         = drift[drift$species_id%in%metabolites,]
select        = select[select$species_id%in%metabolites,]
y_range1      = range(c(drift$mean_CS-drift$sd_CS, drift$mean_CS+drift$sd_CS, select$mean_CS-select$sd_CS, select$mean_CS+select$sd_CS))

#-------------------------#
# 2) Build the dataset    #
#-------------------------#
dataset1 = c()
for(met in metabolites)
{
  CS_drift     = drift[drift$species_id==met,"mean_CS"]
  CS_selection = select[select$species_id==met,"mean_CS"]
  Abundance    = drift[drift$species_id==met,"wild_type_X"]
  Coupling     = coupling[met][[1]]
  dataset1     = rbind(dataset1, c(CS_drift, CS_selection, Abundance, Coupling))
}
dataset1        = as.data.frame(dataset1)
names(dataset1) = c("CS_drift", "CS_selection", "Abundance", "Fitness_coupling")

#-------------------------#
# 3) Load flux drop data  #
#-------------------------#
dataset2 = build_enzyme_essentiality_score_dataset(1e-2, 1.1)
y_range2 = c(3, 15)

#-------------------------#
# 4) Create the figure    #
#-------------------------#
p1 = plot_abund_CS(select, "Stabilizing selection", y_range1, -6.5, 3)
p2 = plot_abund_CS(drift, "Genetic drift", y_range1, -6.5, 11)
p3 = plot_fitness_coupling(dataset1)
p4 = plot_ES_CS(dataset2, "Stabilizing selection", y_range2, "Selection")
p5 = plot_ES_CS(dataset2, "Genetic drift", y_range2, "Drift")
p6 = plot_fitness_coupling_distribution("Mulquiney1999_fitness_coupling_exploration.txt", "Exploration of 10,000 random\ncombinations of target fluxes")

nb_evals    = 100
exploration = read.table("Mulquiney1999_fitness_coupling_exploration.txt", sep=" ", h=T)
exploration = exploration[1:nb_evals,]
index_max   = 56
constants   = c()
outliers    = read.table("Mulquiney1999_outliers.txt", sep=" ")
sens        = read.table("Mulquiney1999_random_sensitivity_analysis.txt", h=T, sep=" ")
sens        = sens[2:length(sens[,1]),]

p7 = plot_simulation_dataset(exploration, nb_evals, index_max, outliers, sens, "Stabilizing selection simulations for 100\nrandom combinations of target fluxes")

p = plot_grid(p1, p2, p3, p4, p5, p6, p7, ncol=3, labels="AUTO")

ggsave("Mulquiney1999_main_figure.png", p, dpi=600, bg="white", scale=3.5, width=3.5, height=3)

#-------------------------#
# 5) Additional analyses  #
#-------------------------#
wilcox.test(dataset2[dataset2$Essential==0,"CS_selection"],dataset2[dataset2$Essential==1,"CS_selection"])
wilcox.test(dataset2[dataset2$Essential==0,"CS_drift"],dataset2[dataset2$Essential==1,"CS_drift"])

model = lm(CS_selection ~ Essential+Abundance, data=dataset2)
summary(model)

