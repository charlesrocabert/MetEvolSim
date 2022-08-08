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
setwd("charles/Liska-et-al-Principles-of-metabolome-conservation-in-animals/Liska-et-al-Principles-of-metabolome-conservation-in-animals/DataS2")

#----------------------------------#
# 1) Load the list of lipids       #
#----------------------------------#
load('lipids.rdata')
d = read.table("ER_estimates.csv", sep=";", h=T)
d = d[!(d$Metabolite%in%lipid_list[lipid_list$lipidEvolRate==1,"name_evolRate"]),]

#----------------------------------#
# 2) Make figure for brain tissue  #
#----------------------------------#
df_br     = d[d$Tissue=="Brain",]
df_br$Rep = as.factor(df_br$Rep)
model_br  = lm(log10(1/df_br$ER)~(df_br$Metabolite))
R2_br     = summary(model_br)$r.squared
annot_br  = paste("One-way ANOVA test R-squared =", round(R2_br, 3))
p1     = ggplot(df_br, aes(x=reorder(Metabolite,log10(1/ER)), y=log10(1/ER))) +
  geom_boxplot() +
  annotate(geom="text", x=5, y=2, label=annot_br, size = 20/.pt, hjust = 0) +
  xlab("") +
  ylab("MCS (log-scale)") +
  ggtitle("Brain (100 repetitions)") +
  theme_classic() +
  theme(legend.position="none",
        axis.text.x = element_text(angle=90, vjust=0.5, hjust=1),
        axis.title = element_text(size = 20),
        plot.title = element_text(size = 20))

#----------------------------------#
# 3) Make figure for heart tissue  #
#----------------------------------#
df_ht     = d[d$Tissue=="Heart",]
df_ht$Rep = as.factor(df_ht$Rep)
model_ht  = lm(log10(1/df_ht$ER)~(df_ht$Metabolite))
R2_ht     = summary(model_ht)$r.squared
annot_ht  = paste("One-way ANOVA test R-squared =", round(R2_ht, 3))
p2     = ggplot(df_ht, aes(x=reorder(Metabolite,log10(1/ER)), y=log10(1/ER))) +
  geom_boxplot() +
  annotate(geom="text", x=5, y=1.5, label=annot_ht, size = 20/.pt, hjust = 0) +
  xlab("") +
  ylab("MCS (log-scale)") +
  ggtitle("Heart (100 repetitions)") +
  theme_classic() +
  theme(legend.position="none",
        axis.text.x=element_text(angle=90, vjust=0.5, hjust=1),
        axis.title = element_text(size = 20),
        plot.title = element_text(size = 20))

#----------------------------------#
# 4) Make figure for liver tissue  #
#----------------------------------#
df_li     = d[d$Tissue=="Liver",]
df_li$Rep = as.factor(df_li$Rep)
model_li  = lm(log10(1/df_li$ER)~(df_li$Metabolite))
R2_li     = summary(model_li)$r.squared
annot_li  = paste("One-way ANOVA test R-squared =", round(R2_li, 3))
p3     = ggplot(df_li, aes(x=reorder(Metabolite,log10(1/ER)), y=log10(1/ER))) +
  geom_boxplot() +
  annotate(geom="text", x=5, y=1.5, label=annot_li, size = 20/.pt, hjust = 0) +
  xlab("") +
  ylab("MCS (log-scale)") +
  ggtitle("Liver (100 repetitions)") +
  theme_classic() +
  theme(legend.position="none",
        axis.text.x=element_text(angle=90, vjust=0.5, hjust=1),
        axis.title = element_text(size = 20),
        plot.title = element_text(size = 20))

#----------------------------------#
# 5) Make figure for kidney tissue #
#----------------------------------#
df_kd     = d[d$Tissue=="Kidney",]
df_kd$Rep = as.factor(df_kd$Rep)
model_kd  = lm(log10(1/df_kd$ER)~(df_kd$Metabolite))
R2_kd     = summary(model_kd)$r.squared
annot_kd  = paste("One-way ANOVA test R-squared =", round(R2_kd, 3))
p4     = ggplot(df_kd, aes(x=reorder(Metabolite,log10(1/ER)), y=log10(1/ER))) +
  geom_boxplot() +
  annotate(geom="text", x=5, y=1.5, label=annot_kd, size = 20/.pt, hjust = 0) +
  xlab("") +
  ylab("MCS (log-scale)") +
  ggtitle("Kidney (100 repetitions)") +
  theme_classic() +
  theme(legend.position="none",
        axis.text.x=element_text(angle=90, vjust=0.5, hjust=1),
        axis.title = element_text(size = 20),
        plot.title = element_text(size = 20))

#----------------------------------#
# 6) Generate the final plot       #
#----------------------------------#
pA = plot_grid(p1, p2, ncol=1, labels=c("A", "B"), label_size=20)
pB = plot_grid(p4, p3, ncol=1, labels=c("C", "D"), label_size=20)

ggsave("ER_estimates_1_new.png", pA, dpi=600, bg="white", scale=1, width=13, height=20)
ggsave("ER_estimates_2_new.png", pB, dpi=600, bg="white", scale=1, width=13, height=20)

