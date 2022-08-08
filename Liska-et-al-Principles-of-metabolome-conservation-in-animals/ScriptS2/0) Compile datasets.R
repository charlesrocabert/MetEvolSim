#!/usr/bin/env Rscript

#***************************************************************************
# © 2018-2022 Charles Rocabert, Gábor Boross, Orsolya Liska, Balázs Papp
# Web: https://github.com/charlesrocabert/MetEvolSim
#
# 0) Compile datasets.R
# ---------------------
# Compile simulation datasets for next steps of the analysis.
#***************************************************************************

### Load the list of species ###
load_species <- function( model_name )
{
  return(read.table(paste0(model_name,"_list_of_species.txt"), h=T, sep=" ")[,1])
}

### Compile the simulation dataset for next steps ###
compile_dataset <- function( model_name, omega, constants )
{
  drift       = read.table(paste0(model_name,"_simulations/drift_statistics.txt"), h=T, sep=" ")
  selec       = read.table(paste0(model_name,"_simulations/selection_statistics.txt"), h=T, sep=" ")
  species     = load_species(model_name)
  species     = species[!species%in%constants]
  threshold   = c()
  wild_type_X = c()
  mean_CV     = c()
  sd_CV       = c()
  mean_ER     = c()
  sd_ER       = c()
  mean_CS     = c()
  sd_CS       = c()
  species_id  = c()
  ### Drift ###
  for (sp in species)
  {
    X           = drift[drift$species_id==sp,"mean"]
    CV          = drift[drift$species_id==sp,"CV"]
    ER          = drift[drift$species_id==sp,"ER"]
    threshold   = c(threshold, "Inf")
    wild_type_X = c(wild_type_X, mean(log10(X)))
    mean_CV     = c(mean_CV, mean(log10(CV)))
    sd_CV       = c(sd_CV, sd(log10(CV)))
    mean_ER     = c(mean_ER, mean(log10(ER)))
    sd_ER       = c(sd_ER, sd(log10(ER)))
    mean_CS     = c(mean_CS, mean(log10(1/ER)))
    sd_CS       = c(sd_CS, sd(log10(1/ER)))
    species_id  = c(species_id, sp)
  }
  ### Selection ###
  for (sp in species)
  {
    X           = selec[selec$species_id==sp & selec$selection_threshold==omega,"mean"]
    CV          = selec[selec$species_id==sp & selec$selection_threshold==omega,"CV"]
    ER          = selec[selec$species_id==sp & selec$selection_threshold==omega,"ER"]
    threshold   = c(threshold, omega)
    wild_type_X = c(wild_type_X, mean(log10(X)))
    mean_CV     = c(mean_CV, mean(log10(CV)))
    sd_CV       = c(sd_CV, sd(log10(CV)))
    mean_ER     = c(mean_ER, mean(log10(ER)))
    sd_ER       = c(sd_ER, sd(log10(ER)))
    mean_CS     = c(mean_CS, mean(log10(1/ER)))
    sd_CS       = c(sd_CS, sd(log10(1/ER)))
    species_id  = c(species_id, sp)
  }
  res = data.frame(threshold, wild_type_X, mean_CV, sd_CV, mean_ER, sd_ER, mean_CS, sd_CS, species_id)
  return(res)
}


##################
#      MAIN      #
##################

# Indicate here the location of the folder DataS3 on your computer.
setwd(Path to DataS3)

#-----------------------------------#
# 1) Mulquiney et al. (1999)        #
#-----------------------------------#
model_name = "Mulquiney1999"
omega      = 1e-05
constants  = c("Glc", "CO2", "Lace", "Pyre", "Phose")
res        = compile_dataset(model_name, omega, constants)
write.table(res, file=paste0(model_name,"_simulations.txt"), col.names=T, row.names=F, sep=" ", quote=F)

#-----------------------------------#
# 2) Holzhutter et al. (2004)       #
#-----------------------------------#
model_name = "Holzhutter2004"
omega      = 1e-04
constants  = c("Glcout", "Lacex", "Phiex", "Pyrex", "PRPP")
res        = compile_dataset(model_name, omega, constants)
write.table(res, file=paste0(model_name,"_simulations.txt"), col.names=T, row.names=F, sep=" ", quote=F)

#-----------------------------------#
# 3) Koenig et al. (2012)           #
#-----------------------------------#
model_name = "Koenig2012"
omega      = 1e-02
constants  = c("atp", "adp", "amp", "gtp", "gdp", "nad", "nadh", "phos", "co2", "h2o", "h", "oaa", "glc_ext", "lac_ext", "co2_mito", "phos_mito", "acoa_mito", "cit_mito", "atp_mito", "adp_mito", "gtp_mito", "coa_mito", "nadh_mito", "nad_mito", "h2o_mito", "h_mito", "atp", "adp", "amp", "gtp", "gdp", "nad", "nadh", "phos", "co2", "h2o", "h", "oaa", "glc_ext", "lac_ext", "co2_mito", "phos_mito", "acoa_mito", "cit_mito", "atp_mito", "adp_mito", "gtp_mito", "coa_mito", "nadh_mito", "nad_mito", "h2o_mito", "h_mito")
res        = compile_dataset(model_name, omega, constants)
write.table(res, file=paste0(model_name,"_simulations.txt"), col.names=T, row.names=F, sep=" ", quote=F)


