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
import subprocess
from Model import *

### Compute the ancestor steady-state ###
def get_ancestor_steady_state( model ):
	return model.compute_WT_steady_state()

### Save the steady-state as a new line in the data file ###
def write_steady_state( FILE, ITERATION, PARAMETER_INDEX, PARAMETER_NAME, PARAMETER_VALUE, PARAMETER_FACTOR, CONCENTRATIONS, FLUXES, WT_CSUM, MUTANT_CSUM, CSUM_DIST, WT_TFLUX, MUTANT_TFLUX, TFLUX_DIST ):
	line = str(ITERATION)+" "+str(PARAMETER_INDEX)+" "+PARAMETER_NAME+" "+str(PARAMETER_VALUE)+" "+str(PARAMETER_FACTOR)
	for item in CONCENTRATIONS:
		line += " "+item[1]
	for item in FLUXES:
		line += " "+item[1]
	line += " "+str(WT_CSUM)+" "+str(MUTANT_CSUM)+" "+str(CSUM_DIST)
	line += " "+str(WT_TFLUX)+" "+str(MUTANT_TFLUX)+" "+str(TFLUX_DIST)
	f.write(line+"\n")
	f.flush()

### Compute the sum of concentrations distance ###
def compute_csum_distance( ANCESTOR_CONCENTRATIONS, MUTANT_CONCENTRATIONS ):
	anc_sum = 0.0
	mut_sum = 0.0
	for i in range(len(ANCESTOR_CONCENTRATIONS)):
		anc_conc = float(ANCESTOR_CONCENTRATIONS[i][1])
		mut_conc = float(MUTANT_CONCENTRATIONS[i][1])
		anc_sum += anc_conc
		mut_sum += mut_conc
	return anc_sum, mut_sum, abs(anc_sum-mut_sum)

### Compute the target fluxes distance ###
def compute_tflux_distance( ANCESTOR_FLUXES, MUTANT_FLUXES ):
	anc_sum = 0.0
	mut_sum = 0.0
	for i in range(len(ANCESTOR_FLUXES)):
		anc_flux = float(ANCESTOR_FLUXES[i][1])
		mut_flux = float(MUTANT_FLUXES[i][1])
		anc_sum += anc_flux
		mut_sum += mut_flux
	return anc_sum, mut_sum, abs(anc_sum-mut_sum)

### Read command line arguments ###
def readArgs( argv ):
	arguments                        = {}
	arguments["iterations"]          = 0
	arguments["mutation_size"]       = 0.0
	arguments["selection_scheme"]    = ""
	arguments["selection_threshold"] = 0.0
	arguments["model_name"]          = ""
	for i in range(len(argv)):
		if argv[i] == "-h" or argv[i] == "--help":
			printUsage()
			sys.exit()
		if argv[i] == "-iterations" or argv[i] == "--iterations":
			arguments["iterations"] = int(argv[i+1])
		if argv[i] == "-mutation-size" or argv[i] == "--mutation-size":
			arguments["mutation_size"] = float(argv[i+1])
		if argv[i] == "-selection-scheme" or argv[i] == "--selection-scheme":
			arguments["selection_scheme"] = argv[i+1]
		if argv[i] == "-selection-threshold" or argv[i] == "--selection-threshold":
			arguments["selection_threshold"] = float(argv[i+1])
		if argv[i] == "-model-name" or argv[i] == "--model-name":
			arguments["model_name"] = argv[i+1]
	return arguments

### Print usage ###
def printUsage():
	print "Usage: python run_selectionthreshold_simulations.py -h or --help";
	print "   or: python run_selectionthreshold_simulations.py [list of mandatory parameters]";
	print "Options are:"
	print "  -h, --help"
	print "        print this help, then exit"
	print "  -iterations, --iterations <iterations>"
	print "        Specify the number of iterations"
	print "  -mutation-size, --mutation-size <mutation_size>"
	print "        Specify the log mutation size"
	print "  -selection-scheme, --selection-scheme <selection_scheme>"
	print "        Specify the selection scheme (NO_SELECTION/CSUM/TFLUX)"
	print "  -selection-threshold, --selection-threshold <selection_threshold>"
	print "        Specify the selection threshold"
	print "  -model-name, --model-name <model_name>"
	print "        Specify the model name (Holzhutter2004/Smallbone2013)"


##################
#      MAIN      #
##################

if __name__ == '__main__':
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 1) Read command line arguments                          #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	ARGUMENTS           = readArgs(sys.argv)
	ITERATIONS          = ARGUMENTS["iterations"]
	LOG_MUTATION_SIZE   = ARGUMENTS["mutation_size"]
	SELECTION_SCHEME    = ARGUMENTS["selection_scheme"]
	SELECTION_THRESHOLD = ARGUMENTS["selection_threshold"]
	MODEL_NAME          = ARGUMENTS["model_name"]
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 2) Create the model                                     #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	model = load_model(MODEL_NAME)
	model.load_sbml()
	model.load_reaction_to_param_map()
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 3) Get ancestor steady-state                            #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	ancestor_conc, ancestor_flux       = get_ancestor_steady_state(model)
	wt_csum, mutant_csum, csum_dist    = compute_csum_distance(ancestor_conc, ancestor_conc)
	wt_tflux, mutant_tflux, tflux_dist = compute_tflux_distance(ancestor_flux, ancestor_flux)
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 4) Create the output file and write header and ancestor #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	f          = open("output/experiment.txt", "w")
	header     = "iteration param_index param_name param_val param_factor"
	first_line = "0 0 ancestor 0.0 0.0"
	for item in ancestor_conc:
		header     += " "+item[0]
		first_line += " "+item[1]
	for item in ancestor_flux:
		header     += " "+item[0]
		first_line += " "+item[1]
	header     += " wt_csum mutant_csum csum_dist wt_tflux mutant_tflux tflux_dist"
	first_line += " "+str(wt_csum)+" "+str(mutant_csum)+" "+str(csum_dist)
	first_line += " "+str(wt_tflux)+" "+str(mutant_tflux)+" "+str(tflux_dist)
	f.write(header+"\n")
	f.write(first_line+"\n")
	f.flush()

	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 5) Run the mutation accumulation experiment             #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	for iteration in range(1, ITERATIONS+1):
		print "> iteration "+str(iteration)
		#param_index, param_name, param_anc, param_mut, param_factor = model.mutate_uniform_param(LOG_MUTATION_SIZE)
		param_index, param_name, param_anc, param_mut, param_factor = model.mutate_uniform_reaction(LOG_MUTATION_SIZE)
		model.write_mutant_SBML_file()
		model.create_mutant_cps_file()
		model.edit_mutant_cps_file()
		model.run_copasi_for_mutant()
		concentrations, fluxes             = model.get_mutant_steady_state()
		wt_csum, mutant_csum, csum_dist    = compute_csum_distance(ancestor_conc, concentrations)
		wt_tflux, mutant_tflux, tflux_dist = compute_tflux_distance(ancestor_flux, fluxes)
		### 5.1) No selection ###
		if SELECTION_SCHEME == "NO_SELECTION":
			write_steady_state(f, iteration, param_index, param_name, param_mut, param_factor, concentrations, fluxes, wt_csum, mutant_csum, csum_dist, wt_tflux, mutant_tflux, tflux_dist)
			print "    drift."
		### 5.2) Selection on the total metabolic load ###
		elif SELECTION_SCHEME == "CSUM" and np.log10(csum_dist) < SELECTION_THRESHOLD:
			write_steady_state(f, iteration, param_index, param_name, param_mut, param_factor, concentrations, fluxes, wt_csum, mutant_csum, csum_dist, wt_tflux, mutant_tflux, tflux_dist)
			print "    selected."
		elif SELECTION_SCHEME == "CSUM" and np.log10(csum_dist) >= SELECTION_THRESHOLD:
			model.set_parameter_mutant_value(param_name, param_anc)
			print "    dropped."
		### 5.3) Selection on the sum of target fluxes ###
		elif SELECTION_SCHEME == "TFLUX" and np.log10(tflux_dist) < SELECTION_THRESHOLD:
			write_steady_state(f, iteration, param_index, param_name, param_mut, param_factor, concentrations, fluxes, wt_csum, mutant_csum, csum_dist, wt_tflux, mutant_tflux, tflux_dist)
			print "    selected."
		elif SELECTION_SCHEME == "TFLUX" and np.log10(tflux_dist) >= SELECTION_THRESHOLD:
			model.set_parameter_mutant_value(param_name, param_anc)
			print "    dropped."
			
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 6) Close output file                                    #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	f.close()
