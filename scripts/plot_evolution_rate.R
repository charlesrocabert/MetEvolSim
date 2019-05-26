library("ggplot2")

setwd("/Users/charlesrocabert/git/MetEvolSim-development/example")

d = read.table("output/statistics.txt", h=T, sep=" ")
names(d)

d = d[order(d$WT),]

slope = 1e-4/(sqrt(3)*d$WT)
D = cbind(d$WT, slope)
D = as.data.frame(D)
names(D) = c("WT", "slope")

CV_MUT = (10^0.01-10^-0.01)/2
#CV_SEL = 1e-4/(sqrt(3)*1.99801)
# ggplot(d, aes(x=log10(WT), y=log10(ER), label=species_id)) +
# geom_jitter() +
# geom_smooth(method="lm") +
# geom_hline(yintercept=log10(CV_MUT), linetype=2) +
# geom_hline(yintercept=log10(CV_SEL), linetype=2, color="red") +
# geom_text() +
# theme_classic()

plot(log10(D$WT), log10(D$slope), type="l")
points(log10(d$WT), log10(d$CV), pch=20)
abline(h=log10(CV_MUT), col="red")
text(log10(d$WT), log10(d$CV), d$species_id)
