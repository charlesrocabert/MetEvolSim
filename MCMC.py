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
    def __init__( self, model_filename, iterations, log_mutation_size, selection_scheme, selection_threshold ):
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
    	# 5) Create output file            #
    	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.output_file = open("output/iterations.txt", "w")
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 6) Current state informations    #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.current_iteration = 0
        self.param_name        = "WT"
        self.param_value       = 0.0
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 7) Statistics                    #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        ### Array lengths ###
        self.Nconc     = self.model.get_number_of_metabolites()
        self.Nflux     = self.model.get_number_of_reactions()
        ### WT values ###
        self.WT_conc   = np.zeros(self.Nconc)
        self.WT_flux   = np.zeros(self.Nflux)
        ### Sum vectors ###
        self.sum_conc      = np.zeros(self.Nconc)
        self.sqsum_conc    = np.zeros(self.Nconc)
        self.relsqsum_conc = np.zeros(self.Nconc)
        self.sum_flux      = np.zeros(self.Nflux)
        self.sqsum_flux    = np.zeros(self.Nflux)
        self.relsqsum_flux = np.zeros(self.Nflux)
        ### Final statistics ###
        self.mean_conc = np.zeros(self.Nconc)
        self.var_conc  = np.zeros(self.Nconc)
        self.CV_conc   = np.zeros(self.Nconc)
        self.EV_conc   = np.zeros(self.Nconc)
        self.mean_flux = np.zeros(self.Nflux)
        self.var_flux  = np.zeros(self.Nflux)
        self.CV_flux   = np.zeros(self.Nflux)
        self.EV_flux   = np.zeros(self.Nflux)
    
    ### Convert a list of items into a numpy array ###
    def item_to_array( self ):
        conc_vec = np.zeros(self.Nconc)
        for i in range(self.Nconc):
            conc_vec[i] = float(self.mutant_concentrations[i][1])
        flux_vec = np.zeros(self.Nflux)
        for i in range(self.Nflux):
            flux_vec[i] = float(self.mutant_fluxes[i][1])
        return conc_vec, flux_vec
        
    ### Initialize statistics ###
    def initialize_statistics( self ):
        #~~~~~~~~~~~~~~~~~~~~~~~~#
        # 1) Set arrays to zero  #
        #~~~~~~~~~~~~~~~~~~~~~~~~#
        ### WT values ###
        self.WT_conc   = np.zeros(self.Nconc)
        self.WT_flux   = np.zeros(self.Nflux)
        ### Sum vectors ###
        self.sum_conc      = np.zeros(self.Nconc)
        self.sqsum_conc    = np.zeros(self.Nconc)
        self.relsum_conc   = np.zeros(self.Nconc)
        self.relsqsum_conc = np.zeros(self.Nconc)
        self.sum_flux      = np.zeros(self.Nflux)
        self.sqsum_flux    = np.zeros(self.Nflux)
        self.relsum_flux   = np.zeros(self.Nflux)
        self.relsqsum_flux = np.zeros(self.Nflux)
        ### Final statistics ###
        self.mean_conc = np.zeros(self.Nconc)
        self.var_conc  = np.zeros(self.Nconc)
        self.CV_conc   = np.zeros(self.Nconc)
        self.EV_conc   = np.zeros(self.Nconc)
        self.mean_flux = np.zeros(self.Nflux)
        self.var_flux  = np.zeros(self.Nflux)
        self.CV_flux   = np.zeros(self.Nflux)
        self.EV_flux   = np.zeros(self.Nflux)
        #~~~~~~~~~~~~~~~~~~~~~~~~#
        # 2) Set WT steady-state #
        #~~~~~~~~~~~~~~~~~~~~~~~~#
        conc_vec, flux_vec = self.item_to_array()
        self.WT_conc = np.copy(conc_vec)
        self.WT_flux = np.copy(flux_vec)
    
    ### Update statistics ###
    def update_statistics( self ):
        conc_vec, flux_vec = self.item_to_array()
        ### Concentrations ###
        self.sum_conc      += conc_vec
        self.sqsum_conc    += conc_vec*conc_vec
        self.relsum_conc   += (conc_vec/self.WT_conc)
        self.relsqsum_conc += (conc_vec/self.WT_conc)*(conc_vec/self.WT_conc)
        ### Fluxes ###
        #self.sum_flux      += flux_vec
        #self.sqsum_flux    += flux_vec*flux_vec
        #self.relsum_flux   += (flux_vec/self.WT_flux)
        #self.relsqsum_flux += (flux_vec/self.WT_flux)*(flux_vec/self.WT_flux)
    
    ### Compute statistics for the current iteration ###
    def compute_statistics( self ):
        self.mean_conc  = np.copy(self.sum_conc)
        self.mean_conc /= float(self.current_iteration)
        self.var_conc   = np.copy(self.sqsum_conc)
        self.var_conc  /= float(self.current_iteration)
        self.var_conc  -= self.mean_conc*self.mean_conc
        self.CV_conc    = np.copy(self.sqsum_conc)
        self.CV_conc   /= float(self.current_iteration)
        self.CV_conc   -= self.mean_conc*self.mean_conc
        self.CV_conc    = np.sqrt(self.CV_conc)/(self.WT_conc)
        self.EV_conc    = np.copy(self.relsqsum_conc)
        self.EV_conc   /= float(self.current_iteration)
        self.EV_conc   -= (self.relsum_conc/float(self.current_iteration))*(self.relsum_conc/float(self.current_iteration))
        self.EV_conc   /= float(self.current_iteration)
    
    ### Write statistics ###
    def write_statistics( self ):
        f = open("output/statistics.txt", "w")
        f.write("name WT mean var CV EV\n")
        for i in range(len(self.WT_concentrations)):
            line  = self.WT_concentrations[i][0]+" "
            line += str(self.WT_concentrations[i][1])+" "
            line += str(self.mean_conc[i])+" "
            line += str(self.var_conc[i])+" "
            line += str(self.CV_conc[i])+" "
            line += str(self.EV_conc[i])+"\n"
            f.write(line)
        f.close()
        
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
        self.initialize_statistics()
        
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
        ### 4.2) If the selection is on the total metabolic load  ###
        elif self.selection_scheme == "METABOLIC_LOAD" and np.log10(self.concentration_sum_dist) < self.selection_threshold:
            self.write_current_state()
            self.flush_output_file()
        elif self.selection_scheme == "METABOLIC_LOAD" and np.log10(self.concentration_sum_dist) >= self.selection_threshold:
            model.set_mutant_parameter_value(self.param_name, old_param_value)
        ### 4.3) Selection on the sum of target fluxes ###
        elif self.selection_scheme == "BIOMASS_FUNCTION" and np.log10(self.biomass_function_dist) < self.selection_threshold:
            self.write_current_state()
            self.flush_output_file()
        elif self.selection_scheme == "BIOMASS_FUNCTION" and np.log10(self.biomass_function_dist) >= self.selection_threshold:
            self.model.set_mutant_parameter_value(self.param_name, old_param_value)
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 5) Compute statistics              #
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        self.update_statistics()
        self.compute_statistics()
        self.write_statistics()
        #~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
        # 6) Check the number of iterations  #
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
    algo = MCMC(model_filename, iterations, log_mutation_size, selection_scheme, selection_threshold)
    algo.initialize()
    print algo.item_to_array()
    sys.exit()
    for it in range(iterations):
        algo.iterate()
