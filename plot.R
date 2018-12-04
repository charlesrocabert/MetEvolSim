setwd("/Users/charlesrocabert/git/MetEvolSim/output")

d = read.table("mutation_accumulation.txt", sep=" ", h=T)
names(d)

S_START = 6
S_END   = 50

ancs = t(d[1,S_START:S_END])
sds  = t(t(apply(d[,S_START:S_END], 2, sd)))
D    = cbind(ancs, sds)
D    = D[D[,2]>0,]
X    = log10(D[,1])
Y    = log10(D[,2]/D[,1])

par(mfrow=c(3,2), mar=c(2,2,2,2))

plot(X, Y, pch=20, main="[S] vs. CV([S])", xlab="[S]", ylab="CV")
abline(lm(Y~X), col="cornflowerblue", lty=2)
test = cor.test(X, Y, method="spearman")
legend("bottomleft", legend=c(paste("Spearman rho =", test$estimate[[1]]), paste("p.value =", test$p.value)))

hist(d$param_index, col="grey", main="Param index distribution")

hist(d$mutant_tflux-d$wt_tflux, col="grey", main="Tflux distribution")
abline(v=0.0, col="tomato", lty=2, lwd=2)

tflux_diff = d$mutant_tflux-d$wt_tflux
mut_count = c(sum(tflux_diff<0), sum(tflux_diff>0))
barplot(mut_count, col=c("tomato", "darkolivegreen3"))

plot(d$mutant_csum-d$wt_csum, pch=20)
abline(h=0.0, col="tomato", lty=2, lwd=2, main="Csum")

plot(d$mutant_tflux-d$wt_tflux, pch=20)
abline(h=0.0, col="tomato", lty=2, lwd=2, main="Csum")

