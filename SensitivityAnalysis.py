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
def write_steady_state( FILE, PARAMETER, PARAMETER_VALUE, PARAMETER_FACTOR, CONCENTRATIONS, FLUXES ):
	line = PARAMETER+" "+str(PARAMETER_VALUE)+" "+str(PARAMETER_FACTOR)
	for item in CONCENTRATIONS:
		line += " "+item[1]
	for item in FLUXES:
		line += " "+item[1]
	f.write(line+"\n")
	f.flush()

def load_model( NAME ):
	if NAME == "Holzhutter2004":
		model = Holzhutter2004()
		return model
	elif NAME == "Smallbone2013":
		model = Smallbone2013()
		return model


##################
#      MAIN      #
##################

EXPLORATION_RANGE = 0.5
EXPLORATION_STEP  = 0.01
MODEL_NAME        = "Smallbone2013"

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
	f = open("exploration.txt", "w")
	header     = "param_name param_val param_factor"
	first_line = "ancestor 0.0 0.0"
	for item in ancestor_conc:
		header     += " "+item[0]
		first_line += " "+item[1]
	for item in ancestor_flux:
		header     += " "+item[0]
		first_line += " "+item[1]
	f.write(header+"\n")
	f.write(first_line+"\n")
	f.flush()

	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 4) Run the parametric exploration                       #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	PARAMETERS = model.get_parameters_list()
	START      = -EXPLORATION_RANGE
	END        = EXPLORATION_RANGE
	
	for param in PARAMETERS:
		if model.get_parameter_valuation(param):
			print "> Exploring parameter "+param
			factor  = START
			counter = 0
			while factor <= END:
				if counter%10 == 0:
					print "    -> factor = "+str(factor)
				counter += 1
				model.deterministic_parameter_change(param, factor)
				param_value = model.get_parameter_mutant_value(param)
				model.write_mutant_SBML_file()
				model.create_mutant_cps_file()
				model.edit_mutant_cps_file()
				model.run_copasi_for_mutant()
				concentrations, fluxes = model.get_mutant_steady_state()
				write_steady_state(f, param, param_value, factor, concentrations, fluxes)
				model.deterministic_parameter_change(param, 0.0)
				factor += EXPLORATION_STEP
