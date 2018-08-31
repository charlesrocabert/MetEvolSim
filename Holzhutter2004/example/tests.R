setwd("/Users/charlesrocabert/git/MetEvolSim/Holzhutter2004/example")

d = read.table("ancestor/ancestor_ode_trajectories.txt", h=T, sep=" ")
N = length(d[,1])
M = length(d[1,])


XRG = range(d$t)
YRG = range(d[,3:M])
colors = rainbow(M-2)
plot(x=NULL, xlim=XRG, ylim=YRG, log="y")
for(i in seq(3,M))
{
	lines(d$t, d[,i], col=colors[i-2], lwd=2)
}
