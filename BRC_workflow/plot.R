setwd("/Users/charlesrocabert/git/MetEvolSim/workflow")

get_wt_tflux <- function( index )
{
	d = read.table(paste("collected/experiment_", index, ".txt", sep=""), h=T, sep=" ")
	return(d$wt_tflux)
}

get_mutant_tflux <- function( index )
{
	filename = paste("collected/experiment_", index, ".txt", sep="")
	d = read.table(filename, h=T, sep=" ")
	return(d$mutant_tflux)
}

get_wt_csum <- function( index )
{
	d = read.table(paste("collected/experiment_", index, ".txt", sep=""), h=T, sep=" ")
	return(d$wt_csum)
}

get_mutant_csum <- function( index )
{
	filename = paste("collected/experiment_", index, ".txt", sep="")
	d = read.table(filename, h=T, sep=" ")
	return(d$mutant_csum)
}

plot_tflux <- function( threshold, param_map )
{
	indexes = unique(param_map[param_map$threshold==threshold,3])
	vec1  = get_mutant_tflux(indexes[1])
	vec2  = get_mutant_tflux(indexes[2])
	vec3  = get_mutant_tflux(indexes[3])
	vec4  = get_mutant_tflux(indexes[4])
	vec5  = get_mutant_tflux(indexes[5])
	vec6  = get_mutant_tflux(indexes[6])
	vec7  = get_mutant_tflux(indexes[7])
	vec8  = get_mutant_tflux(indexes[8])
	vec9  = get_mutant_tflux(indexes[9])
	vec10 = get_mutant_tflux(indexes[10])
	total = c(vec1, vec2, vec3, vec4, vec5, vec6, vec7, vec8, vec9, vec10)
	N     = c(length(vec1), length(vec2), length(vec3), length(vec4), length(vec5), length(vec6), length(vec7), length(vec8), length(vec9), length(vec10))
	total = (total-vec1[1])/vec1[1]
	XRG   = c(0, max(N))
	YRG   = range(total)
	colors = rainbow(10)
	plot(x=NULL, xlim=XRG, ylim=YRG, xlab="Iterations", ylab="Target flux shift", main="Sum of target fluxes (relative to WT)")
	lines((vec1-vec1[1])/vec1[1], col=colors[1])
	lines((vec2-vec1[1])/vec1[1], col=colors[2])
	lines((vec3-vec1[1])/vec1[1], col=colors[3])
	lines((vec4-vec1[1])/vec1[1], col=colors[4])
	lines((vec5-vec1[1])/vec1[1], col=colors[5])
	lines((vec6-vec1[1])/vec1[1], col=colors[6])
	lines((vec7-vec1[1])/vec1[1], col=colors[7])
	lines((vec8-vec1[1])/vec1[1], col=colors[8])
	lines((vec9-vec1[1])/vec1[1], col=colors[9])
	lines((vec10-vec1[1])/vec1[1], col=colors[10])
	abline(h=0, lty=2)
	hist(total, col="grey", nclass=50, xlab="Sum of target fluxes (relative to WT)", main="Sum of target flux (relative to WT)")
	abline(v=0.0, lty=2, col="red", lwd=2)
}

plot_csum <- function( threshold, param_map )
{
	indexes = unique(param_map[param_map$threshold==threshold,3])
	vec1  = get_mutant_csum(indexes[1])
	vec2  = get_mutant_csum(indexes[2])
	vec3  = get_mutant_csum(indexes[3])
	vec4  = get_mutant_csum(indexes[4])
	vec5  = get_mutant_csum(indexes[5])
	vec6  = get_mutant_csum(indexes[6])
	vec7  = get_mutant_csum(indexes[7])
	vec8  = get_mutant_csum(indexes[8])
	vec9  = get_mutant_csum(indexes[9])
	vec10 = get_mutant_csum(indexes[10])
	total = c(vec1, vec2, vec3, vec4, vec5, vec6, vec7, vec8, vec9, vec10)
	N     = c(length(vec1), length(vec2), length(vec3), length(vec4), length(vec5), length(vec6), length(vec7), length(vec8), length(vec9), length(vec10))
	total = (total-vec1[1])/vec1[1]
	XRG   = c(0, max(N))
	YRG   = range(total)
	colors = rainbow(10)
	plot(x=NULL, xlim=XRG, ylim=YRG, xlab="Iterations", ylab="Metabolic load shift", main="Metabolic load (relative to WT)")
	lines((vec1-vec1[1])/vec1[1], col=colors[1])
	lines((vec2-vec1[1])/vec1[1], col=colors[2])
	lines((vec3-vec1[1])/vec1[1], col=colors[3])
	lines((vec4-vec1[1])/vec1[1], col=colors[4])
	lines((vec5-vec1[1])/vec1[1], col=colors[5])
	lines((vec6-vec1[1])/vec1[1], col=colors[6])
	lines((vec7-vec1[1])/vec1[1], col=colors[7])
	lines((vec8-vec1[1])/vec1[1], col=colors[8])
	lines((vec9-vec1[1])/vec1[1], col=colors[9])
	lines((vec10-vec1[1])/vec1[1], col=colors[10])
	abline(h=0, lty=2)
	hist(total, col="grey", nclass=50, xlab="Metabolic load (relative to WT)", main="Metabolic load (relative to WT)")
	abline(v=0.0, lty=2, col="red", lwd=2)
}


param_map = read.table("parameter_map.txt", sep=" ", h=T)

thresholds = unique(param_map$threshold)
thresholds = sort(thresholds, decreasing=T)

for (th in thresholds)
{
	filename = paste("figure_th", th, ".png", sep="")
	png(filename)
	par(mfrow=c(2,2))
	plot_tflux(th, param_map)
	plot_csum(th, param_map)
	dev.off()
}


##
