#!/usr/bin/env Rscript

#***************************************************************************
# © 2018-2022 Charles Rocabert, Gábor Boross, Orsolya Liska, Balázs Papp
# Web: https://github.com/charlesrocabert/MetEvolSim
#
# 3) Holzhutter2004 main figure.R
# -------------------------------
# Create the main figure for the Holzhutter (2004) model.
#***************************************************************************

library("tidyverse")
library("cowplot")
library("reshape2")
library("ggcorrplot")
library("corrplot")
library("ppcor")
library("ggpubr")
library("MASS")
library("patchwork")

### Build the enzyme essentiality score dataset, given the drop coefficient and the dist threshold ###
build_enzyme_essentiality_score_dataset <- function( drop_coefficient, dist_threshold )
{
  #----------------------------------------#
  # 1) Load and prepare data               #
  #----------------------------------------#
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
  #----------------------------------------#
  # 2) Build the dataset                   #
  #----------------------------------------#
  dataset = c()
  for(met in metabolites)
  {
    mean_CS_drift     = drift[drift$species_id==met,"mean_CS"]
    mean_CS_selection = select[select$species_id==met,"mean_CS"]
    sd_CS_drift       = drift[drift$species_id==met,"sd_CS"]
    sd_CS_selection   = select[select$species_id==met,"sd_CS"]
    Abundance         = drift[drift$species_id==met,"wild_type_X"]
    Coupling          = coupling[met][[1]]
    dataset           = rbind(dataset, c(mean_CS_drift, mean_CS_selection, sd_CS_drift, sd_CS_selection, Abundance, Coupling))
  }
  dataset        = as.data.frame(dataset)
  dataset$Name   = metabolites
  names(dataset) = c("mean_CS_drift", "mean_CS_selection", "sd_CS_drift", "sd_CS_selection", "Abundance", "Fitness_coupling", "Name")
  #----------------------------------------#
  # 3) Build the flux drop data            #
  #----------------------------------------#
  flux_drop         = read.table("Holzhutter2004_flux_drop_analysis.txt", h=T, sep=" ")
  flux_drop         = flux_drop[flux_drop$drop_value < 1.01*drop_coefficient & flux_drop$drop_value > 0.99*drop_coefficient,]
  fluxes            = unique(flux_drop$reaction)
  flux_to_met       = read.table("Holzhutter2004_reaction_to_species_map.txt", h=F, sep=" ")
  REACTION          = c()
  METABOLITE        = c()
  MOMA              = c()
  ABUNDANCE         = c()
  COUPLING          = c()
  MEAN_CS_DRIFT     = c()
  MEAN_CS_SELECTION = c()
  SD_CS_DRIFT       = c()
  SD_CS_SELECTION   = c()
  print(paste0(">>> ", unique(flux_drop$drop_value)))
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
          REACTION          = c(REACTION, reaction)
          METABOLITE        = c(METABOLITE, met)
          MOMA              = c(MOMA, moma)
          ABUNDANCE         = c(ABUNDANCE, dataset[dataset$Name==met,"Abundance"])
          COUPLING          = c(COUPLING, dataset[dataset$Name==met,"Fitness_coupling"])
          MEAN_CS_DRIFT     = c(MEAN_CS_DRIFT, dataset[dataset$Name==met,"mean_CS_drift"])
          MEAN_CS_SELECTION = c(MEAN_CS_SELECTION, dataset[dataset$Name==met,"mean_CS_selection"])
          SD_CS_DRIFT       = c(SD_CS_DRIFT, dataset[dataset$Name==met,"sd_CS_drift"])
          SD_CS_SELECTION   = c(SD_CS_SELECTION, dataset[dataset$Name==met,"sd_CS_selection"])
        }
      }
    }
  }
  ess_analysis            = data.frame(MOMA, ABUNDANCE, COUPLING, MEAN_CS_DRIFT, MEAN_CS_SELECTION, SD_CS_DRIFT, SD_CS_SELECTION)
  names(ess_analysis)     = c("Dist", "Abundance", "Fitness_coupling", "mean_CS_drift", "mean_CS_selection", "sd_CS_drift", "sd_CS_selection")
  ess_analysis$Reaction   = REACTION
  ess_analysis$Metabolite = METABOLITE
  ess_analysis$Drop_coef  = rep(drop_coefficient, length(ess_analysis[,1]))
  ess_analysis$Dist[ess_analysis$Dist < dist_threshold]  = 0
  ess_analysis$Dist[ess_analysis$Dist >= dist_threshold] = 1
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
plot_abund_CS_both <- function(D){

  D$D_sd_pl <- D$sd_CS
  
  p = ggplot(D, aes(x=wild_type_X, y=mean_CS, color = dataset, fill = dataset)) +
    geom_smooth(span=0.9, color = 'black', size = 0.5) +
    geom_errorbar(aes(ymin=mean_CS-sd_CS, ymax=mean_CS+sd_CS),
                  width=.2, color = 'black') +
    geom_point(shape = 21, color = 'black') +
    scale_color_manual(values = c('tan1', "#3497a9")) +
    scale_fill_manual(values = c('tan1', "#3497a9")) +
    xlab("Metabolite abundance (log-scale)") +
    ylab("MCS (1log-scale)") +
    theme_minimal() +
    theme(legend.position = 'top',
          legend.title = element_blank(),
          legend.text = element_text(size = 10),
          plot.margin = unit(c(0.3,0,0,0.1), units = 'in'))
  return(p)
}

### Plot the Essentiality/CS figure  ###
plot_ES_CS_both <- function(D)
{
  
  D_pl <- D %>%
    rename("Stabilizing selection" = CS_selection,
           "Genetic drift" = CS_drift) %>%
    gather(key = dataset, value = CS, -Metabolite, -Essential, -Abundance) %>%
    mutate(Essential_f = ifelse(Essential=='1',
                                'Essential\nreaction',
                                'Non-essential\nreaction'))
  
  D_pl_groupNums <- group_by(D_pl, dataset, Essential_f) %>%
    summarise(n = n()) %>%
    ungroup()
  
  p = ggplot(D_pl, aes(x=Essential_f, y=CS)) +
    facet_wrap(.~dataset) +
    geom_boxplot(aes(fill = dataset)) +
    geom_jitter(width=0.2) +
    geom_text(data = D_pl_groupNums,
              aes(label = paste0('n = ', n), y = 13.5)) +
    scale_fill_manual(values = c('tan1', "#3497a9")) +
    xlab("") +
    ylab("MCS (log-scale)") +
    ggsignif::geom_signif(comparisons=list(c('Essential\nreaction', 'Non-essential\nreaction')),
                          test="wilcox.test",
                          y_position = 14) +
    theme_minimal() +
    theme(axis.text=element_text(size=10),
          legend.position = 'top',
          legend.title = element_blank(),
          legend.text = element_text(size = 10),
          strip.text = element_blank(),
          plot.margin = unit(c(0.3,0,0,0.1), units = 'in'))
  return(p)
}

### Plot the fitness coupling ###
plot_fitness_coupling <- function(D)
{
  p = ggplot(D, aes(x=Abundance, y=Fitness_coupling)) +
    geom_smooth(color="black", fill="#B9B8BA", span=0.9, size = 0.5) +
    geom_point(color="black") +
    xlab("Metabolite abundance (log-sclae)") +
    ylab("Fitness coupling") +
    theme_minimal() +
    theme(plot.margin = unit(c(0.3,0,0,0.1), units = 'in'))
  return(p)
}

### Plot MCS vs. fitness couling for both datasets ###
plot_fitnessCoupling_CS_both <- function(D){

  p = ggplot(D, aes(y=mean_CS, x=Fitness_coupling,
                       color=dataset, fill=dataset)) +
    geom_smooth(span=0.9, color = 'black', size = 0.5) +
    geom_errorbar(aes(ymin=mean_CS-sd_CS, ymax=mean_CS+sd_CS),
                  width=.01, color = 'black') +
    geom_point(shape = 21, color = 'black') +
    scale_color_manual(values = c('tan1', "#3497a9")) +
    scale_fill_manual(values = c('tan1', "#3497a9")) +
    ylab("MCS (log-scale)") +
    xlab("Fitness coupling") +
    theme_minimal() +
    theme(legend.position = 'top',
          legend.title = element_blank(),
          plot.margin = unit(c(0.3,0,0,0.1), units = 'in'))
  return(p)
}


##################
#      MAIN      #
##################

# Indicate here the location of the folder DataS3 on your computer.
setwd(Path to DataS3)

#-----------------------------#
# 1) Load simulation data     #
#-----------------------------#
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
y_range1      = range(c(drift$mean_CS-drift$sd_CS, drift$mean_CS+drift$sd_CS,
                        select$mean_CS-select$sd_CS, select$mean_CS+select$sd_CS))
y_range1[1]   = y_range1[1]-1
y_range1[2]   = y_range1[2]#+0.5

#-----------------------------#
# 2) Build the dataset        #
#-----------------------------#
dataset1 = c()
for(met in metabolites){
  CS_drift     = drift[drift$species_id==met,"mean_CS"]
  CS_selection = select[select$species_id==met,"mean_CS"]
  Abundance    = drift[drift$species_id==met,"wild_type_X"]
  Coupling     = coupling[met][[1]]
  dataset1     = rbind(dataset1, c(met, CS_drift, CS_selection, Abundance, Coupling))
}

dataset1        = as.data.frame(dataset1)
names(dataset1) = c("species_id", "CS_drift", "CS_selection", "Abundance", "Fitness_coupling")

dataset1 <- tibble(dataset1) %>% 
  mutate_at(.vars = c('CS_drift','CS_selection','Abundance','Fitness_coupling'),
            .funs = as.numeric)

# C               = cor(dataset1[,2:ncol(dataset1)], method="spearman")
# pC              = cor_pmat(dataset1, method="spearman")
# C               = C[c(2,1), c(3,4)]
# pC              = pC[c(2,1), c(3,4)]
# rownames(C)     = c("MCS under\nselection", "MCS under\ngenetic drift")
# colnames(C)     = c("Metabolite\nabundance", "Fitness\ncoupling")
# rownames(pC)    = c("MCS under\nselection", "MCS under\ngenetic drift")
# colnames(pC)    = c("Metabolite\nabundance", "Fitness\ncoupling")

#-----------------------------#
# 3) Build the flux drop data #
#-----------------------------#
flux_drop         = read.table("Holzhutter2004_flux_drop_analysis.txt", h=T, sep=" ")
drop_coefficients = unique(flux_drop$drop_value)
dataset2          = build_enzyme_essentiality_score_dataset(1e-5, 1.1)
y_range2          = c(4, 13)

#-----------------------------#
# 4) Create the figure        #
#-----------------------------#
select1 <- mutate(select, dataset = 'Stabilizing selection')
drift1 <- mutate(drift, dataset = 'Genetic drift')

cs_abund_all_tbl <- bind_rows(select1, drift1)
cs_essential_all_tbl <- dataset2


p1 = plot_abund_CS_both(cs_abund_all_tbl)
p2 = plot_ES_CS_both(cs_essential_all_tbl)
p3 = plot_fitness_coupling(dataset1)

MCS_fitnessCoupling_tbl <- cs_abund_all_tbl %>% 
  dplyr::select(species_id, dataset, mean_CS , sd_CS) %>% 
  left_join(dplyr::select(dataset1, species_id, Fitness_coupling), by = "species_id") %>% 
  mutate(Fitness_coupling = as.numeric(Fitness_coupling))

p4 = plot_fitnessCoupling_CS_both(MCS_fitnessCoupling_tbl)

p = p1 + p2 + p3 + p4 + plot_annotation(tag_levels = 'A')

ggsave("Holzhutter2004_main_figure.png", p, dpi=600, bg="white", scale=0.8, width = 11, height = 11)

#-----------------------------#
# 5) Additional analyses      #
#-----------------------------#
wilcox.test(dataset2[dataset2$Essential==0,"CS_selection"],dataset2[dataset2$Essential==1,"CS_selection"])
wilcox.test(dataset2[dataset2$Essential==0,"CS_drift"],dataset2[dataset2$Essential==1,"CS_drift"])

model = lm(CS_selection ~ Essential+Abundance, data=dataset2)
summary(model)

