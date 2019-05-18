library("ggplot2")
library("cowplot")
library("corrplot")

setwd("/Users/charlesrocabert/git/MetEvolSim-development/example")

d = read.table("output/sensitivity_analysis.txt", h=T, sep=" ")
names(d)

#ggplot(d, aes(x=param_dln, y=v_1, color=param_id)) +
#geom_line() +
#theme_classic() +
#ylim(-0.03, 0.03) +
#theme(legend.position="none")

PARAM_IDS  = unique(d$param_id)
FLUX       = seq(46,83)
MET        = seq(6,45)
MCOR_FLUX  = c()
MCOR_MET   = c()
MSENS_FLUX = c()
MSENS_MET  = c()
index      = 1
names      = c()
for (param_id in PARAM_IDS)
{
	dl = d[d$param_id==param_id,]
	#----------------------#
	# COMPUTE CORRELATIONS #
	#----------------------#
	M1        = cor(dl[,c(5,FLUX)], method="spearman")
	M2        = cor(dl[,c(5,MET)], method="spearman")
	names     = c(names, paste(param_id," (",index,")",sep=""))
	MCOR_FLUX = rbind(MCOR_FLUX, M1[1,])
	MCOR_MET  = rbind(MCOR_MET, M2[1,])
	#-----------------------#
	# COMPUTE SENSITIVITIES #
	#-----------------------#
	dl = dl[dl$param_dln != 0.0,]
	S1 = colMeans(abs(dl[,FLUX])/abs(dl$param_dln))
	S2 = colMeans(abs(dl[,MET])/abs(dl$param_dln))
	MSENS_FLUX = rbind(MSENS_FLUX, S1)
	MSENS_MET  = rbind(MSENS_MET, S2)
	index      = index+1
}
rownames(MCOR_FLUX)         = names
rownames(MCOR_MET)          = names
rownames(MSENS_FLUX)        = names
rownames(MSENS_MET)         = names
MCOR_FLUX                   = t(MCOR_FLUX)
MCOR_MET                    = t(MCOR_MET)
MSENS_FLUX                  = t(MSENS_FLUX)
MSENS_MET                   = t(MSENS_MET)
MCOR_FLUX[is.na(MCOR_FLUX)] = 0.0
MCOR_MET[is.na(MCOR_MET)]   = 0.0
MCOR_FLUX                   = MCOR_FLUX[c(-1,-2),-1]
MCOR_MET                    = MCOR_MET[c(-1,-2),-1]
MSENS_FLUX                  = MSENS_FLUX[,-1]
MSENS_MET                   = MSENS_MET[,-1]
MCOR_FLUX                   = abs(MCOR_FLUX)
MCOR_MET                    = abs(MCOR_MET)

corrplot(MCOR_MET, tl.cex=0.3)

mean_cor  = rowSums(MCOR_MET)/length(colnames(MCOR_MET))
mean_sens = rowSums(MSENS_MET)/length(colnames(MSENS_MET))
estimator = mean_cor*mean_sens
mean_cor = sort(mean_cor)
mean_sens = sort(mean_sens)
#estimator = sort(estimator)

par(mfrow=c(2,2))
barplot(mean_cor, names=colnames(mean_cor), las=2, ylab="Mean Spearman correlation", main="Correlation between kinetic parameter changes and flux changes", col="cornflowerblue")
barplot(log10(mean_sens), names=colnames(mean_sens), las=2, ylab="Mean sensibility", main="Abundance sensibility to kinetic parameter changes", col="cornflowerblue")
barplot(log10(sort(estimator)), names=colnames(sort(estimator)), las=2, ylab="Mean sensibility", main="Abundance sensibility to kinetic parameter changes", col="cornflowerblue")
abline(h=log10((10^0.01-10^-0.01)/2))
abline(h=mean(log10(estimator)), col="red")
abline(h=mean(log10(estimator[estimator>1e-3])), col="green")
barplot(log10(estimator), names=colnames(estimator), las=2, ylab="Mean sensibility", main="Abundance sensibility to kinetic parameter changes", col="cornflowerblue")
abline(h=log10((10^0.01-10^-0.01)/2))
abline(h=mean(log10(estimator)), col="red")
abline(h=mean(log10(estimator[estimator>1e-3])), col="green")
