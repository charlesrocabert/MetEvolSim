setwd("/Users/charlesrocabert/git/MetEvolSim/ToyModels/example")

d = read.table("population/fitness.txt", h=T, sep=" ")
means = read.table("population/mean_s.txt", h=T, sep=" ", check.names=F)
vars = read.table("population/var_s.txt", h=T, sep=" ", check.names=F)

pdf(file="figures/mean_fitness.pdf")
d$var_w[d$var_w<0.0] = 0.0
XRG = range(d$g)
YRG = range(c(d$mean_w-sqrt(d$var_w),d$mean_w+sqrt(d$var_w)))
plot(x=NULL, xlim=XRG, ylim=YRG, xlab="Generations", ylab="Mean fitness")
polygon(c(d$g, rev(d$g)), c(d$mean_w-sqrt(d$var_w), rev(d$mean_w+sqrt(d$var_w))), border=F, col=adjustcolor("blue", alpha.f=0.2))
lines(d$g, d$mean_w, lwd=2)
dev.off()

pdf(file="figures/mean_c.pdf")
d$var_c[d$var_c<0.0] = 0.0
XRG = range(d$g)
YRG = range(c(d$mean_c-sqrt(d$var_c),d$mean_c+sqrt(d$var_c)))
plot(x=NULL, xlim=XRG, ylim=YRG, xlab="Generations", ylab="Mean sum of concentrations")
polygon(c(d$g, rev(d$g)), c(d$mean_c-sqrt(d$var_c), rev(d$mean_c+sqrt(d$var_c))), border=F, col=adjustcolor("blue", alpha.f=0.2))
lines(d$g, d$mean_c, lwd=2)
dev.off()

pdf(file="figures/mean_s.pdf")
N = length(means[,1])
M = length(means[1,])
colors = rainbow(M-1)

XRG = range(means$g)
YRG = range(means[,2:M])

plot(x=NULL, xlim=XRG, ylim=YRG, xlab="Generations", ylab="Mean metabolic abundances", log="y")
for (i in seq(2,M))
{
	lines(means$g, means[,i], col=colors[i-1], lwd=2)
}
dev.off()

