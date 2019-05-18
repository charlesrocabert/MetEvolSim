library("ggplot2")

setwd("/Users/charlesrocabert/git/MetEvolSim-development/example")

d = read.table("output/statistics.txt", h=T, sep=" ")
names(d)

ggplot(d, aes(x=log10(WT), y=log10(ER))) +
geom_jitter() +
geom_smooth(method="lm") +
#geom_hline(yintercept=log10(CV), linetype=2) +
#geom_label(aes(x=log10(WT), y=log10(ER), label=species_id)) +
theme_classic()

cor.test(log10(d$WT), log10(d$ER), method="spearman")
