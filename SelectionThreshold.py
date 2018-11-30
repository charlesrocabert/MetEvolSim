#!/usr/bin/env python
# coding: utf-8

import os
import sys
import numpy as np
import subprocess
from Models import *

### Compute the ancestor steady-state ###
def get_ancestor_steady_state( MODEL ):
	MODEL.write_ancestor_SBML_file()
	MODEL.create_ancestor_cps_file()
	MODEL.edit_ancestor_cps_file()
	MODEL.run_copasi_for_ancestor()
	metabolites, reactions = MODEL.get_ancestor_steady_state()
	return metabolites, reactions

### Save the steady-state as a new line in the data file ###
def write_steady_state( FILE, ITERATION, PARAMETER_NAME, PARAMETER_VALUE, PARAMETER_FACTOR, CONCENTRATIONS, FLUXES, CSUM_DIST, TFLUX_DIST ):
	line = str(ITERATION)+" "+PARAMETER_NAME+" "+str(PARAMETER_VALUE)+" "+str(PARAMETER_FACTOR)
	for item in CONCENTRATIONS:
		line += " "+item[1]
	for item in FLUXES:
		line += " "+item[1]
	line += " "+str(CSUM_DIST)+" "+str(TFLUX_DIST)
	f.write(line+"\n")
	f.flush()

### Load the SBML model ###
def load_model( NAME ):
	if NAME == "Holzhutter2004":
		model = Holzhutter2004()
		return model
	elif NAME == "Smallbone2013":
		model = Smallbone2013()
		return model

### Compute the sum of concentrations distance ###
def compute_csum_distance( ANCESTOR_CONCENTRATIONS, MUTANT_CONCENTRATIONS ):
	anc_sum = 0.0
	mut_sum = 0.0
	for i in range(len(ANCESTOR_CONCENTRATIONS)):
		anc_conc = float(ANCESTOR_CONCENTRATIONS[i][1])
		mut_conc = float(MUTANT_CONCENTRATIONS[i][1])
		anc_sum += anc_conc
		mut_sum += mut_conc
	return abs(anc_sum-mut_sum)

### Compute the target fluxes distance ###
def compute_tflux_distance( ANCESTOR_FLUXES, MUTANT_FLUXES ):
	distance = 0.0
	for i in range(len(ANCESTOR_FLUXES)):
		reaction = ANCESTOR_FLUXES[i][0]
		if reaction in ["v_9", "v_16", "v_21", "v_26"]:
			anc_flux = float(ANCESTOR_FLUXES[i][1])
			mut_flux = float(MUTANT_FLUXES[i][1])
			distance += (anc_flux-mut_flux)*(anc_flux-mut_flux)
	return np.sqrt(distance)


##################
#      MAIN      #
##################

ITERATIONS          = 10000
LOG_MUTATION_SIZE   = 0.1
SELECTION_SCHEME    = "TFLUX"
SELECTION_THRESHOLD = -3.0
MODEL_NAME          = "Holzhutter2004"

if __name__ == '__main__':
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 1) Create the model                                     #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	model = load_model(MODEL_NAME)
	model.load_sbml()

	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 2) Get ancestor steady-state                            #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	ancestor_conc, ancestor_flux = get_ancestor_steady_state(model)
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 3) Create the output file and write header and ancestor #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	f          = open("output/mutation_accumulation.txt", "w")
	header     = "iteration param_name param_val param_factor"
	first_line = "0 ancestor 0.0 0.0"
	for item in ancestor_conc:
		header     += " "+item[0]
		first_line += " "+item[1]
	for item in ancestor_flux:
		header     += " "+item[0]
		first_line += " "+item[1]
	header     += " csum_dist tflux_sum"
	first_line += " 0.0 0.0"
	f.write(header+"\n")
	f.write(first_line+"\n")
	f.flush()

	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 4) Run the mutation accumulation experiment             #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	for iteration in range(1, ITERATIONS+1):
		print "> iteration "+str(iteration)
		param_name, param_anc, param_mut, param_factor = model.mutate(LOG_MUTATION_SIZE)
		model.write_mutant_SBML_file()
		model.create_mutant_cps_file()
		model.edit_mutant_cps_file()
		model.run_copasi_for_mutant()
		concentrations, fluxes = model.get_mutant_steady_state()
		csum_dist              = compute_csum_distance(ancestor_conc, concentrations)
		tflux_dist             = compute_tflux_distance(ancestor_flux, fluxes)
		if SELECTION_SCHEME == "CSUM" and np.log10(csum_dist) < SELECTION_THRESHOLD:
			write_steady_state(f, iteration, param_name, param_mut, param_factor, concentrations, fluxes, csum_dist, tflux_dist)
			print "    selected."
		elif SELECTION_SCHEME == "CSUM" and np.log10(csum_dist) >= SELECTION_THRESHOLD:
			model.set_parameter_mutant_value(param_name, param_anc)
			print "    dropped."
		elif SELECTION_SCHEME == "TFLUX" and np.log10(tflux_dist) < SELECTION_THRESHOLD:
			write_steady_state(f, iteration, param_name, param_mut, param_factor, concentrations, fluxes, csum_dist, tflux_dist)
			print "    selected."
		elif SELECTION_SCHEME == "TFLUX" and np.log10(tflux_dist) >= SELECTION_THRESHOLD:
			model.set_parameter_mutant_value(param_name, param_anc)
			print "    dropped."
			
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 5) Close output file                                    #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	f.close()
