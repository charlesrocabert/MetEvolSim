#!/usr/bin/env python
# coding: utf-8

#*********************************************************************
# MetEvolSim (Metabolome Evolution Simulator)
# Copyright (c) 2018-2019 Charles Rocabert, Gábor Boross, Balázs Papp
# All rights reserved
#*********************************************************************

import os
import sys
import numpy as np
from scipy import stats
import subprocess
from SBML_Model import *
from MCMC import *
#import matplotlib.pyplot as plt

### Read command line arguments ###
def readArgs( argv ):
	arguments                        = {}
	arguments["model_filename"]      = ""
	arguments["iterations"]          = 0
	arguments["mutation_size"]       = 0.0
	arguments["selection_scheme"]    = ""
	arguments["selection_threshold"] = 0.0
	arguments["seed"]                = 0
	for i in range(len(argv)):
		if argv[i] == "-h" or argv[i] == "--help":
			printHelp()
			sys.exit()
		if argv[i] == "-model-filename" or argv[i] == "--model-filename":
			arguments["model_filename"] = argv[i+1]
		if argv[i] == "-iterations" or argv[i] == "--iterations":
			arguments["iterations"] = int(argv[i+1])
		if argv[i] == "-mutation-size" or argv[i] == "--mutation-size":
			arguments["mutation_size"] = float(argv[i+1])
		if argv[i] == "-selection-scheme" or argv[i] == "--selection-scheme":
			arguments["selection_scheme"] = argv[i+1]
		if argv[i] == "-selection-threshold" or argv[i] == "--selection-threshold":
			arguments["selection_threshold"] = float(argv[i+1])
		if argv[i] == "-seed" or argv[i] == "--seed":
			arguments["seed"] = int(argv[i+1])
	return arguments

### Assert parameters consistency ###
def assertArgs( args ):
	#for item in args.items():
	#	if item[1] == "" or item[1] == 0 or item[1] == 0.0:
	#		print "Some argument values are missing."
	#		print "Use option -h (--help) to see the list of mandatory arguments."
	#		sys.exit()
	if arguments["iterations"] <= 0:
		print "Error: argument '-iterations' only admits positive integer values."
		print "(current value: "+str(arguments["iterations"])+")"
		sys.exit()
	if arguments["mutation_size"] <= 0.0:
		print "Error: argument '-mutation-size' only admits positive decimal values."
		print "(current value: "+str(arguments["mutation_size"])+")"
		sys.exit()
	if arguments["selection_scheme"] != "MUTATION_ACCUMULATION" and arguments["selection_scheme"] != "METABOLIC_LOAD" and arguments["selection_scheme"] != "BIOMASS_FUNCTION":
		print "Error: argument '-selection-scheme' only admits 3 options (MUTATION_ACCUMULATION / METABOLIC_LOAD / BIOMASS_FUNCTION)."
		print "(current value: "+str(arguments["selection_scheme"])+")"
		sys.exit()
	if arguments["seed"] <= 0:
		print "Error: argument '-seed' only admits positive integer values."
		print "(current value: "+str(arguments["seed"])+")"
		sys.exit()
		
### Print help ###
def printHelp():
	print ""
	print "#*********************************************************************"
	print "# MetEvolSim (Metabolome Evolution Simulator)"
	print "# Copyright (c) 2018-2019 Charles Rocabert, Gábor Boross, Balázs Papp"
	print "# All rights reserved"
	print "#*********************************************************************"
	print "Usage: python MetEvolSim_run.py -h or --help";
	print "   or: python MetEvolSim_run.py [list of mandatory arguments]";
	print "Options are:"
	print "  -h, --help"
	print "        print this help, then exit"
	print "  -model-filename, --model-filename <model_filename> (mandatory)"
	print "        Specify the SBML model filename (e.g. holzhutter2004.xml)"
	print "  -iterations, --iterations <iterations> (mandatory)"
	print "        Specify the number of iterations (integer > 0)"
	print "  -mutation-size, --mutation-size <mutation_size> (mandatory)"
	print "        Specify the log mutation size (float > 0.0)"
	print "  -selection-scheme, --selection-scheme <selection_scheme> (mandatory)"
	print "        Specify the selection scheme (MUTATION_ACCUMULATION / METABOLIC_LOAD / BIOMASS_FUNCTION)"
	print "  -selection-threshold, --selection-threshold <selection_threshold> (mandatory)"
	print "        Specify the selection threshold (float > 0.0)"
	print "  -seed, --seed <prng_seed> (mandatory)"
	print "        Specify the prng seed (integer > 0.0)"
	print ""

### Print header ###
def printHeader():
	print ""
	print "#*********************************************************************"
	print "# MetEvolSim (Metabolome Evolution Simulator)"
	print "# Copyright (c) 2018-2019 Charles Rocabert, Gábor Boross, Balázs Papp"
	print "# All rights reserved"
	print "#*********************************************************************"
	print ""
	
##################
#      MAIN      #
##################

#plt.ion()

if __name__ == '__main__':
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 1) Read command line arguments #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	arguments = readArgs(sys.argv)
	assertArgs(arguments)
	printHeader()
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 2) Seed the numpy prng         #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	np.random.seed(arguments["seed"])
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 3) Run the MCMC simulation     #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	sim = MCMC(arguments["model_filename"], arguments["iterations"], arguments["mutation_size"], arguments["selection_scheme"], arguments["selection_threshold"])
	sim.initialize()
	stop_MCMC = False
	while not stop_MCMC:
		stop_MCMC = sim.iterate()
		#static = ["Glcout", "Lacex", "PRPP", "Phiex", "Pyrex"]
		#X = []
		#Y = []
		#for i in range(len(sim.WT_concentrations)):
		#	if not sim.WT_concentrations[i][0] in static:
		#		X.append(np.log10(sim.WT_conc[i]))
		#		Y.append(np.log10(sim.EV_conc[i]))
		#Rho, Pval = stats.spearmanr(X,Y)
		#try:
		#	plt.clf()
		#	plt.plot(X, Y, "o")
		#	plt.text(-5.5,-11, "Spearman's rho="+str(round(Rho,5))+"\n(p-val="+str(round(Pval,5))+")", bbox=dict(facecolor='white', alpha=0.5))
		#	plt.draw()
		#except:
		#	no_plot = True
