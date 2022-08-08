#!/usr/bin/env Rscript

#***************************************************************************
# © 2018-2022 Charles Rocabert, Gábor Boross, Orsolya Liska, Balázs Papp
# Web: https://github.com/charlesrocabert/MetEvolSim
#
# plot_figure.R
# -------------
# Create the figure showing MCS with replicate noise.
#***************************************************************************

library("tidyverse")
library("cowplot")

##################
#      MAIN      #
##################

# Indicate here the location of the folder DataS2 on your computer.
#setwd(Path to DataS2)
setwd("/Users/charlesrocabert/git/MetEvolSim-development/Liska-et-al-Principles-of-metabolome-conservation-in-animals/DataS2")

#----------------------------------#
# 1) Load the list of lipids       #
#----------------------------------#
load('lipids.rdata')
d = read.table("ER_estimates.csv", sep=";", h=T)
d = d[!(d$Metabolite%in%lipid_list[lipid_list$lipidEvolRate==1,"name_evolRate"]),]

#----------------------------------#
# 2) Make figure for brain tissue  #
#----------------------------------#
df     = d[d$Tissue=="Brain",]
df$Rep = as.factor(df$Rep)
model  = lm(log10(1/df$ER)~(df$Metabolite))
R2     = summary(model)$r.squared
annot  = paste("One-way ANOVA test R-squared =", round(R2, 3))
p1     = ggplot(df, aes(x=reorder(Metabolite,log10(1/ER)), y=log10(1/ER))) +
  geom_boxplot() +
  annotate(geom="text", x=20, y=2, label=annot) +
  xlab("") +
  ylab("Metabolic conservation score (log-scale)") +
  ggtitle("Brain (100 repetitions)") +
  theme_classic() +
  theme(legend.position="none", axis.text.x = element_text(angle=90, vjust=0.5, hjust=1))

#----------------------------------#
# 3) Make figure for heart tissue  #
#----------------------------------#
df     = d[d$Tissue=="Heart",]
df$Rep = as.factor(df$Rep)
model  = lm(log10(1/df$ER)~(df$Metabolite))
R2     = summary(model)$r.squared
annot  = paste("One-way ANOVA test R-squared =", round(R2, 3))
p2     = ggplot(df, aes(x=reorder(Metabolite,log10(1/ER)), y=log10(1/ER))) +
  geom_boxplot() +
  annotate(geom="text", x=20, y=2, label=annot) +
  xlab("") +
  ylab("Metabolic conservation score (log-scale)") +
  ggtitle("Heart (100 repetitions)") +
  theme_classic() +
  theme(legend.position="none", axis.text.x=element_text(angle=90, vjust=0.5, hjust=1))

#----------------------------------#
# 4) Make figure for liver tissue  #
#----------------------------------#
df     = d[d$Tissue=="Liver",]
df$Rep = as.factor(df$Rep)
model  = lm(log10(1/df$ER)~(df$Metabolite))
R2     = summary(model)$r.squared
annot  = paste("One-way ANOVA test R-squared =", round(R2, 3))
p3     = ggplot(df, aes(x=reorder(Metabolite,log10(1/ER)), y=log10(1/ER))) +
  geom_boxplot() +
  annotate(geom="text", x=20, y=2, label=annot) +
  xlab("") +
  ylab("Metabolic conservation score (log-scale)") +
  ggtitle("Liver (100 repetitions)") +
  theme_classic() +
  theme(legend.position="none", axis.text.x=element_text(angle=90, vjust=0.5, hjust=1))

#----------------------------------#
# 5) Make figure for kidney tissue #
#----------------------------------#
df     = d[d$Tissue=="Kidney",]
df$Rep = as.factor(df$Rep)
model  = lm(log10(1/df$ER)~(df$Metabolite))
R2     = summary(model)$r.squared
annot  = paste("One-way ANOVA test R-squared =", round(R2, 3))
p4     = ggplot(df, aes(x=reorder(Metabolite,log10(1/ER)), y=log10(1/ER))) +
  geom_boxplot() +
  annotate(geom="text", x=20, y=2, label=annot) +
  xlab("") +
  ylab("Metabolic conservation score (log-scale)") +
  ggtitle("Kidney (100 repetitions)") +
  theme_classic() +
  theme(legend.position="none", axis.text.x=element_text(angle=90, vjust=0.5, hjust=1))

#----------------------------------#
# 6) Generate the final plot       #
#----------------------------------#
pA = plot_grid(p1, p2, ncol=1, labels=c("A", "B"), label_size=20)
pB = plot_grid(p3, p4, ncol=1, labels=c("C", "D"), label_size=20)

ggsave("ER_estimates_1.png", pA, dpi=600, bg="white", scale=1, width=13, height=20)
ggsave("ER_estimates_2.png", pB, dpi=600, bg="white", scale=1, width=13, height=20)

