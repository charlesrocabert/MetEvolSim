#!/usr/bin/env python
# coding: utf-8

#*********************************************************************
# MetEvolSim (Metabolome Evolution Simulator)
# Copyright (c) 2018-2019 Charles Rocabert, Gábor Boross, Balázs Papp
# All rights reserved
#*********************************************************************

import os
import sys
import subprocess
import libsbml
import numpy as np
from SBML_Model import *


class MCMC:
    
    ### Constructor ###
    def __init__( self, model_filename, iterations, log_mutation_size, selection_scheme, selection_threshold, output_filename ):
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 1) Load parameters               #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.model_filename      = model_filename
        self.iterations          = iterations
        self.log_mutation_size   = log_mutation_size
        self.selection_scheme    = selection_scheme
        self.selection_threshold = selection_threshold
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 2) Create SBML model             #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.model = SBML_Model(self.model_filename)
        self.model.load_reaction_to_param_map()
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    	# 3) Create steady-state variables #
    	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.WT_concentrations     = []
        self.WT_fluxes             = []
        self.mutant_concentrations = []
        self.mutant_fluxes         = []
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    	# 4) Create scores                 #
    	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.WT_concentration_sum     = 0.0
        self.mutant_concentration_sum = 0.0
        self.concentration_sum_dist   = 0.0
        self.WT_biomass_function      = 0.0
        self.mutant_biomass_function  = 0.0
        self.biomass_function_dist    = 0.0
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    	# 4) Create output file            #
    	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.output_filename = output_filename
        self.output_file     = open("output/"+output_filename, "w")
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 5) Current state informations    #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.current_iteration = 0
        self.param_name        = "ancestor"
        self.param_value       = 0.0
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 6) Statistics                    #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    
    ### Compute WT steady-state ###
    def compute_WT_steady_state( self ):
        self.WT_concentrations, self.WT_fluxes = self.model.compute_WT_steady_state()
    
    ### Compute mutant steady-state ###
    def compute_mutant_steady_state( self ):
        self.mutant_concentrations, self.mutant_fluxes = self.model.compute_mutant_steady_state()
    
    ### Compute concentration sum score ###
    def compute_concentration_sum_score( self ):
        assert len(self.WT_concentrations)==len(self.mutant_concentrations)
    	self.WT_concentration_sum     = 0.0
    	self.mutant_concentration_sum = 0.0
        self.concentration_sum_dist   = 0.0
    	for i in range(len(self.WT_concentrations)):
    		self.WT_concentration_sum     += float(self.WT_concentrations[i][1])
    		self.mutant_concentration_sum += float(self.mutant_concentrations[i][1])
        self.concentration_sum_dist = abs(self.WT_concentration_sum-self.mutant_concentration_sum)
    
    ### Compute biomass function score ###
    def compute_biomass_function_score( self ):
        target_fluxes = ["v_9", "v_16", "v_21", "v_26"]
        assert len(self.WT_fluxes)==len(self.mutant_fluxes)
    	self.WT_biomass_function     = 0.0
    	self.mutant_biomass_function = 0.0
        self.biomass_function_dist   = 0.0
    	for i in range(len(self.WT_fluxes)):
            if self.WT_fluxes[i][0] in target_fluxes:
                wt_flux     = float(self.WT_fluxes[i][1])
                mutant_flux = float(self.mutant_fluxes[i][1])
                self.WT_biomass_function     += wt_flux
                self.mutant_biomass_function += mutant_flux
                self.biomass_function_dist   += (wt_flux-mutant_flux)*(wt_flux-mutant_flux)
        self.biomass_function_dist = np.sqrt(self.biomass_function_dist)
        
    ### Open the output file ###
    def init_output_file( self ):
    	header = "iteration param_name param_val"
    	for item in self.WT_concentrations:
    		header += " "+item[0]
    	for item in self.WT_fluxes:
    		header += " "+item[0]
    	header += " wt_csum mutant_csum csum_dist wt_tflux mutant_tflux tflux_dist"
    	self.output_file.write(header+"\n")
    
    ### Flush the output file ###
    def flush_output_file( self ):
        self.output_file.flush()
    
    ### Close the output file ###
    def close_ouput_file( self ):
        self.output_file.close()
        
    ### Write the current MCMC state ###
    def write_current_state( self ):
        line = ""
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 1) Write parameters information #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        line += str(self.current_iteration)+" "
        line += str(self.param_name)+" "
        line += str(self.param_value)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 2) Write steady-state           #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    	for item in self.mutant_concentrations:
    		line += " "+item[1]
    	for item in self.mutant_fluxes:
    		line += " "+item[1]
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 3) Write scores                 #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
    	line += " "+str(self.WT_concentration_sum)+" "+str(self.mutant_concentration_sum)+" "+str(self.concentration_sum_dist)
    	line += " "+str(self.WT_biomass_function)+" "+str(self.mutant_biomass_function)+" "+str(self.biomass_function_dist)
    	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 4) Write in file                #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.output_file.write(line+"\n")
    
    ### Initialize MCMC ###
    def initialize( self ):
        self.compute_WT_steady_state()
        self.compute_mutant_steady_state()
        self.compute_concentration_sum_score()
        self.compute_biomass_function_score()
        self.init_output_file()
        self.write_current_state()
        self.flush_output_file()
        
    ### Iterate MCMC ###
    def iterate( self ):
        self.current_iteration += 1
        print "> Current iteration = "+str(self.current_iteration)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 1) Introduce a new random mutation #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.param_name = self.model.get_random_param_uniform_reactions()
        old_param_value, self.param_value = self.model.random_drift_parameter_change(self.param_name, self.log_mutation_size)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Compute the new steady-state    #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.compute_mutant_steady_state()
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Compute the scores              #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.compute_concentration_sum_score()
        self.compute_biomass_function_score()
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 4) Select the new iteration event  #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        ### 4.1) If the simulation is a mutation accumulation experiment ###
        if self.selection_scheme == "MUTATION_ACCUMULATION":
            self.write_current_state()
            self.flush_output_file()
            #print "    drift."
        ### 4.2) If the selection is on the total metabolic load  ###
        elif self.selection_scheme == "METABOLIC_LOAD" and np.log10(self.concentration_sum_dist) < self.selection_threshold:
            self.write_current_state()
            self.flush_output_file()
            #print "    selected."
        elif self.selection_scheme == "METABOLIC_LOAD" and np.log10(self.concentration_sum_dist) >= self.selection_threshold:
            model.set_mutant_parameter_value(self.param_name, old_param_value)
            #print "    dropped."
        ### 4.3) Selection on the sum of target fluxes ###
        elif self.selection_scheme == "BIOMASS_FUNCTION" and np.log10(self.biomass_function_dist) < self.selection_threshold:
            self.write_current_state()
            self.flush_output_file()
            #print "    selected."
        elif self.selection_scheme == "BIOMASS_FUNCTION" and np.log10(self.biomass_function_dist) >= self.selection_threshold:
            self.model.set_mutant_parameter_value(self.param_name, old_param_value)
            #print "    dropped."
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 5) Check the number of iterations  #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        if self.current_iteration == self.iterations:
            return True
        return False
	
	
##################
#      MAIN      #
##################

if __name__ == '__main__':
    model_filename      = "holzhutter2004.xml"
    iterations          = 10
    log_mutation_size   = 0.01
    selection_scheme    = "MUTATION_ACCUMULATION" # MUTATION_ACCUMULATION / METABOLIC_LOAD / BIOMASS_FUNCTION
    selection_threshold = 0.0
    output_filename     = "mcmc_output.txt"
    algo = MCMC(model_filename, iterations, log_mutation_size, selection_scheme, selection_threshold, output_filename)
    algo.initialize()
    for it in range(iterations):
        algo.iterate()
