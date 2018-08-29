options(warn=-1)

setwd("/Users/charlesrocabert/git/MetEvolSim/ToysModels/example")

library("RColorBrewer")
library("caTools")

####################
# 1) Read the data #
####################
param = read.table("parameters/parameters.txt", sep=" ", h=T)
d1    = read.table("ancestor/ancestor_individual.txt", sep=" ", h=T)
d2    = read.table("best/best_evolrate.txt", sep=" ", h=T)
d3    = read.table("best/mean_evolrate.txt", sep=" ", h=T)
d4    = read.table("best/best_individual.txt", sep=" ", h=T)
d     = cbind(d1, d3[,2:3])
#d$s   = d3$s

W     = param$w
SIGMA = param$sigma
MU    = param$mu
COPT  = d4$copt[1]
M     = param$m

SIGMAC  = SIGMA*d$s/COPT
FITNESS = W/sqrt(W^2+SIGMAC^2)

relfit = cbind(d$s, FITNESS/sum(FITNESS))
relfit = relfit[order(relfit[,2], decreasing=T),]

relevolrate = sqrt(d$evolrate)/sum(sqrt(d$evolrate))
XRG = range(d$s)
YRG = range(relevolrate)

####################
# 2) Raw evol rate #
####################
print("> Raw evol rate")
dl = d[d$evolrate!=0,]
pdf(file="figures/raw_evol_rate.pdf")
plot(log10(dl$s), log10(dl$evolrate), pch=20, xlab="Abundance", ylab="Evolution rate", main="Abundance vs Evolution rate")
abline(lm(log10(dl$evolrate)~log10(dl$s)), lty=2)
dev.off()

#####################
# 3) Ordered by KMf #
#####################
print("> Ordered by KMf")
pdf(file="figures/evol_rate_by_kmf.pdf")
d = d[order(d$mean_km_f),]
colors = colorRampPalette(c("blue", "red"))(n=M)
plot(d$s, sqrt(d$evolrate)/sum(sqrt(d$evolrate)), pch=20, log="xy", col=colors, xlab="Abundance", ylab="Relative evolution rate", main="Abundance vs Relative evolution rate")
lines(relfit[,1], relfit[,2], col="grey", lwd=2)
legend("bottomleft", legend=c("Theoretical prediction", "Lowest KM_f", "Highest KM_f"), lwd=c(2,NA,NA,NA), pch=c(NA,20,20), col=c("grey",4,2))
dev.off()

#######################
# 4) Ordered by Vmaxf #
#######################
print("> Ordered by Vmaxf")
pdf(file="figures/evol_rate_by_vmaxf.pdf")
d = d[order(d$mean_vmax_f),]
colors = colorRampPalette(c("blue", "red"))(n=M)
plot(d$s, sqrt(d$evolrate)/sum(sqrt(d$evolrate)), pch=20, log="xy", col=colors, xlab="Abundance", ylab="Relative evolution rate", main="Abundance vs Relative evolution rate")
lines(relfit[,1], relfit[,2], col="grey", lwd=2)
legend("bottomleft", legend=c("Theoretical prediction", "Lowest Vmax_f", "Highest Vmax_f"), lwd=c(2,NA,NA,NA), pch=c(NA,20,20), col=c("grey",4,2))
dev.off()

#########################
# 5) Ordered by [S]/KMf #
#########################
print("> Ordered by [S]/KMf")
pdf(file="figures/evol_rate_by_skmf.pdf")
d = d[order(d$s/d$mean_km_f),]
colors = colorRampPalette(c("blue", "red"))(n=M)
plot(d$s, sqrt(d$evolrate)/sum(sqrt(d$evolrate)), pch=20, log="xy", col=colors, xlab="Abundance", ylab="Relative evolution rate", main="Abundance vs Relative evolution rate")
lines(relfit[,1], relfit[,2], col="grey", lwd=2)
legend("bottomleft", legend=c("Theoretical prediction", "Lowest [S]/KMf", "Highest [S]/KMf"), lwd=c(2,NA,NA,NA), pch=c(NA,20,20), col=c("grey",4,2))
dev.off()

#####################
# 3) Ordered by KMb #
#####################
print("> Ordered by KMb")
pdf(file="figures/evol_rate_by_kmb.pdf")
d = d[order(d$mean_km_b),]
colors = colorRampPalette(c("blue", "red"))(n=M)
plot(d$s, sqrt(d$evolrate)/sum(sqrt(d$evolrate)), pch=20, log="xy", col=colors, xlab="Abundance", ylab="Relative evolution rate", main="Abundance vs Relative evolution rate")
lines(relfit[,1], relfit[,2], col="grey", lwd=2)
legend("bottomleft", legend=c("Theoretical prediction", "Lowest KM_b", "Highest KM_b"), lwd=c(2,NA,NA,NA), pch=c(NA,20,20), col=c("grey",4,2))
dev.off()

#######################
# 4) Ordered by Vmaxb #
#######################
print("> Ordered by Vmaxb")
pdf(file="figures/evol_rate_by_vmaxb.pdf")
d = d[order(d$mean_vmax_b),]
colors = colorRampPalette(c("blue", "red"))(n=M)
plot(d$s, sqrt(d$evolrate)/sum(sqrt(d$evolrate)), pch=20, log="xy", col=colors, xlab="Abundance", ylab="Relative evolution rate", main="Abundance vs Relative evolution rate")
lines(relfit[,1], relfit[,2], col="grey", lwd=2)
legend("bottomleft", legend=c("Theoretical prediction", "Lowest Vmax_b", "Highest Vmax_b"), lwd=c(2,NA,NA,NA), pch=c(NA,20,20), col=c("grey",4,2))
dev.off()

######################
# 4) Ordered by REV  #
######################
print("> Ordered by REV")
pdf(file="figures/evol_rate_by_rev.pdf")
d = d[order(d$s/d$mean_km_b),]
SUM = sum(sqrt(d$evolrate))
plot(d$s, sqrt(d$evolrate)/sum(sqrt(d$evolrate)), pch=NA, log="xy", xlab="Abundance", ylab="Relative evolution rate", main="Abundance vs Relative evolution rate")
dl = d[d$mean_km_b==0,]
points(dl$s, sqrt(dl$evolrate)/SUM, pch=20, col="red")
dl = d[d$mean_km_b>0,]
points(dl$s, sqrt(dl$evolrate)/SUM, pch=20, col="blue")
lines(relfit[,1], relfit[,2], col="grey", lwd=2)
legend("bottomleft", legend=c("Theoretical prediction", "Irreversible reactions", "Reversible reactions"), lwd=c(2,NA,NA,NA), pch=c(NA,20,20), col=c("grey",2,4))
dev.off()

#######################
# 4) DEGREES          #
#######################
print("> DEGREES")
pdf(file="figures/evol_rate_by_totald.pdf")
d = d[order(d$degree),]
colors = colorRampPalette(c("blue", "red"))(n=M)
plot(d$s, sqrt(d$evolrate)/sum(sqrt(d$evolrate)), pch=20, log="xy", col=colors, xlab="Abundance", ylab="Relative evolution rate", main="Abundance vs Relative evolution rate")
text(d$s*1.2, sqrt(d$evolrate)/sum(sqrt(d$evolrate))*1.2, d$degree)
lines(relfit[,1], relfit[,2], col="grey", lwd=2)
legend("bottomleft", legend=c("Theoretical prediction", "Lowest total degree", "Highest total degree"), lwd=c(2,NA,NA,NA), pch=c(NA,20,20), col=c("grey",4,2))
dev.off()

pdf(file="figures/evol_rate_by_ind.pdf")
d = d[order(d$in_degree),]
colors = colorRampPalette(c("blue", "red"))(n=M)
plot(d$s, sqrt(d$evolrate)/sum(sqrt(d$evolrate)), pch=20, log="xy", col=colors, xlab="Abundance", ylab="Relative evolution rate", main="Abundance vs Relative evolution rate")
text(d$s*1.2, sqrt(d$evolrate)/sum(sqrt(d$evolrate))*1.2, d$in_degree)
lines(relfit[,1], relfit[,2], col="grey", lwd=2)
legend("bottomleft", legend=c("Theoretical prediction", "Lowest in-degree", "Highest in-degree"), lwd=c(2,NA,NA,NA), pch=c(NA,20,20), col=c("grey",4,2))
dev.off()

pdf(file="figures/evol_rate_by_outd.pdf")
d = d[order(d$out_degree),]
colors = colorRampPalette(c("blue", "red"))(n=M)
plot(d$s, sqrt(d$evolrate)/sum(sqrt(d$evolrate)), pch=20, log="xy", col=colors, xlab="Abundance", ylab="Relative evolution rate", main="Abundance vs Relative evolution rate")
text(d$s*1.2, sqrt(d$evolrate)/sum(sqrt(d$evolrate))*1.2, d$out_degree)
lines(relfit[,1], relfit[,2], col="grey", lwd=2)
legend("bottomleft", legend=c("Theoretical prediction", "Lowest out-degree", "Highest out-degree"), lwd=c(2,NA,NA,NA), pch=c(NA,20,20), col=c("grey",4,2))
dev.off()

######################
# 4) DEGREE STATS    #
######################
print("> DEGREE STATS")
dl = d[d$evolrate!=0,]

pdf(file="figures/evolrate_vs_totald.pdf")
plot(log10(dl$evolrate),(dl$degree), pch=20, xlab="Evol rate (log10)", ylab="Total degree", main="Evol rate vs. Total degree")
abline(lm((dl$degree)~log10(dl$evolrate)), lty=2)
dev.off()

pdf(file="figures/evolrate_vs_ind.pdf")
plot(log10(dl$evolrate),(dl$in_degree), pch=20, xlab="Evol rate (log10)", ylab="In-degree", main="Evol rate vs. In-degree")
abline(lm((dl$in_degree)~log10(dl$evolrate)), lty=2)
dev.off()

pdf(file="figures/evolrate_vs_outd.pdf")
plot(log10(dl$evolrate),(dl$out_degree), pch=20, xlab="Evol rate (log10)", ylab="Out-degree", main="Evol rate vs. Out-degree")
abline(lm((dl$out_degree)~log10(dl$evolrate)), lty=2)
dev.off()

pdf(file="figures/evolrate_vs_skmf.pdf")
plot(log10(dl$s/dl$mean_km_f), log10(dl$evolrate), pch=20, xlab="[S]/Mean(KMf) (log10)", ylab="Evol rate (log10)", main="[S]/Mean(KMf) vs. Evol rate")
abline(lm(log10(dl$evolrate)~log10(dl$s/dl$mean_km_f)), lty=2)
dev.off()

######################
# 4) REV boxplots    #
######################
print("> REV boxplots")

dl = d[d$mean_km_b==0,]
irrs = dl$s
irrevolrate = dl$evolrate
dl = d[d$mean_km_b>0,]
revs = dl$s
revevolrate = dl$evolrate

pdf(file="figures/s_boxplot.pdf")
boxplot(log10(irrs), log10(revs), names=c("Ireversible reactions", "Reversible reactions"), ylab="Metabolic abundance (log10)", col="bisque")
dev.off()

pdf(file="figures/evolrate_boxplot.pdf")
boxplot(log10(irrevolrate), log10(revevolrate), names=c("Ireversible reactions", "Reversible reactions"), ylab="Evolution rate (log10)", col="bisque")
dev.off()

######################
# 6) Various stats   #
######################
print("> Various stats")

pdf(file="figures/s_vs_kmf.pdf")
plot(log10(d$s), log10(d$mean_km_f), pch=20, xlab="Abundance (log10)", ylab="Mean KMf per metabolite (log10)", main="Abundance vs. Mean KMf per metabolite")
abline(lm(log10(d$mean_km_f)~log10(d$s)), lty=2)
dev.off()

pdf(file="figures/s_vs_vmaxf.pdf")
plot(log10(d$s), log10(d$mean_vmax_f), pch=20, xlab="Abundance (log10)", ylab="Mean Vmaxf per metabolite (log10)", main="Abundance vs. Mean Vmaxf per metabolite")
abline(lm(log10(d$mean_vmax_f)~log10(d$s)), lty=2)
dev.off()

pdf(file="figures/s_vs_skmf.pdf")
plot(log10(d$s), log10(d$s/d$mean_km_f), pch=20, xlab="Abundance (log10)", ylab="Abundance/KMf (log10)", main="Abundance vs. Abundance/KMf")
abline(lm(log10(d$s/d$mean_km_f)~log10(d$s)), lty=2)
dev.off()

pdf(file="figures/hist_totald.pdf")
hist(d$degree)
dev.off()
pdf(file="figures/hist_ind.pdf")
hist(d$in_degree)
dev.off()
pdf(file="figures/hist_outd.pdf")
hist(d$out_degree)
dev.off()

pdf(file="figures/skm_vs_totald.pdf")
plot(log10(d$s/d$mean_km_f),(d$degree), pch=20, xlab="[S]/mean(KM_f) (log10)", ylab="Total degree (log10)", main="[S]/mean(KM_f) vs. Total degree")
abline(lm((d$degree)~log10(d$s/d$mean_km_f)), lty=2)
dev.off()
pdf(file="figures/skm_vs_ind.pdf")
plot(log10(d$s/d$mean_km_f),(d$in_degree), pch=20, xlab="[S]/mean(KM_f) (log10)", ylab="In-degree (log10)", main="[S]/mean(KM_f) vs. In-degree")
abline(lm((d$in_degree)~log10(d$s/d$mean_km_f)), lty=2)
dev.off()
pdf(file="figures/skm_vs_outd.pdf")
plot(log10(d$s/d$mean_km_f),(d$out_degree), pch=20, xlab="[S]/mean(KM_f) (log10)", ylab="Out-degree (log10)", main="[S]/mean(KM_f) vs. Out-degree")
abline(lm((d$out_degree)~log10(d$s/d$mean_km_f)), lty=2)
dev.off()

pdf(file="figures/s_vs_totald.pdf")
plot(log10(d$s), (d$degree), pch=20, xlab="Abundance (log10)", ylab="Total degree", main="Abundance vs. Total degree")
abline(lm((d$degree)~log10(d$s)), lty=2)
dev.off()

pdf(file="figures/s_vs_ind.pdf")
plot(log10(d$s),(d$in_degree), pch=20, xlab="Abundance (log10)", ylab="In-degree", main="Abundance vs. In-degree")
abline(lm((d$in_degree)~log10(d$s)), lty=2)
dev.off()

pdf(file="figures/s_vs_outd.pdf")
plot(log10(d$s),(d$out_degree), pch=20, xlab="Abundance (log10)", ylab="Out-degree", main="Abundance vs. Out-degree")
abline(lm((d$out_degree)~log10(d$s)), lty=2)
dev.off()

d = d[d$mean_km_b!=0,]
pdf(file="figures/s_vs_kmb.pdf")
plot(log10(d$s), log10(d$mean_km_b), pch=20, xlab="Abundance (log10)", ylab="Mean KMb per metabolite (log10)", main="Abundance vs. Mean KMb per metabolite")
abline(lm(log10(d$mean_km_b)~log10(d$s)), lty=2)
dev.off()

pdf(file="figures/s_vs_vmaxb.pdf")
plot(log10(d$s), log10(d$mean_vmax_b), pch=20, xlab="Abundance (log10)", ylab="Mean Vmaxb per metabolite (log10)", main="Abundance vs. Mean Vmaxb per metabolite")
abline(lm(log10(d$mean_vmax_b)~log10(d$s)), lty=2)
dev.off()

