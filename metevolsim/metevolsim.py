#!/usr/bin/env python3
# coding: utf-8

#***************************************************************************
# MetEvolSim (Metabolome Evolution Simulator)
# -------------------------------------------
# MetEvolSim is a numerical framework dedicated to the study of metabolic
# abundances evolution.
#
# Copyright (c) 2018-2020 Charles Rocabert, Gábor Boross, Balázs Papp
# Web: https://github.com/charlesrocabert/MetEvolSim
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#***************************************************************************

import os
import sys
import time
import subprocess
import libsbml
import numpy as np
import networkx as nx


MAX_UNSTABLE_INTERATIONS = 10

#********************************************************************
# Model class
# -----------
# This class loads, saves and manipulates SBML models with specified
# kinetic parameters and initial metabolic concentrations.
# Manipulations include kinetic parameter mutations and steady-state
# computing with Copasi software.
#********************************************************************
class Model:
	"""
	The Model class loads, saves and manipulates SBML models.
	Manipulations include kinetic parameter mutations, steady-state computing,
	metabolic control analysis (MCA) and species shortest paths analysis.
	Some constraints exist on the SBML model format:
	- Species and reactions identifiers must be specified and unique.
	- Kinetic parameters must be specified (globally, and/or for each reaction).
	  All kinetic parameters will be mutable.
	- The Model class rebuilds the list of metaids, even if metaids are not
	  defined in the original model.
	
	Attributes
	----------
	> sbml_filename : str
		Name of the SBML model file.
	> reader : libsbml.SBMLReader
		SBML model reader.
	> wild_type_document : libsbml.SBMLDocument
		SBML document of the wild-type model.
	> mutant_document : libsbml.SBMLDocument
		SBML document of the mutant model.
	> wild_type_model : libsbml.Model
		Wild-type model.
	> mutant_model : libsbml.Model
		Mutant model.
	> copasi_path: str
		Location of Copasi executable.
	> species : dict
		List of model species.
	> parameters : dict
		List of model kinetic parameters.
	> reactions : dict
		List of model reactions.
	> species_name_to_id : dict
		Map of species identifiers from species names.
	> reaction_name_to_id : dict
		Map of reaction identifiers from reaction names.
	> species_graph: networkx.Graph
		A networkx Graph describing the metabolite-to-metabolite network.
	> objective_function : list of [str, float]
		Objective function (list of reaction identifiers and coefficients).
	> wild_type_absolute_sum : float
		Sum of evolvable metabolic absolute abundances in wild-type.
	> mutant_absolute_sum : float
		Sum of evolvable metabolic abundances in mutant.
	> wild_type_relative_sum : float
		Sum of evolvable metabolic relative abundances in wild-type.
	> mutant_relative_sum : float
		Sum of evolvable metabolic relative in mutant.
	> absolute_sum_distance : float
		Distance between wild-type and mutant absolute metabolic sums.
	> relative_sum_distance : float
		Distance between wild-type and mutant relative metabolic sums.
	> absolute_moma_distance : float
		Distance between the wild-type and the mutant, based on the
		Minimization Of Metabolic Adjustment on absolute target fluxes.
	> relative_moma_distance : float
		Distance between the wild-type and the mutant, based on the
		Minimization Of Metabolic Adjustment on relative target fluxes.
	> absolute_moma_all_distance : float
		Distance between the wild-type and the mutant, based on the
		Minimization Of Metabolic Adjustment on ALL absolute fluxes.
	> relative_moma_all_distance : float
		Distance between the wild-type and the mutant, based on the
		Minimization Of Metabolic Adjustment on ALL relative fluxes.
	
	Methods
	-------
	> __init__(sbml_filename, objective_function, copasi_path)
		Constructor.
	> rebuild_metaids()
		Rebuild unique metaids for all model variables.
	> build_species_list()
		Build the list of metabolites.
	> build_parameter_list()
		Build the list of parameters.
	> build_reaction_list()
		Build the list of reactions.
	> get_number_of_species()
		Get the number of species.
	> get_number_of_variable_species()
		Get the number of variable species.
	> get_number_of_parameters()
		Get the number of parameters.
	> get_number_of_reactions()
		Get the number of reactions.
	> get_wild_type_species_value(species_id)
		Get wild-type species value.
	> get_mutant_species_value(species_id)
		Get mutant species value.
	> get_wild_type_parameter_value(param_metaid)
		Get wild-type parameter value.
	> get_mutant_parameter_value(param_metaid)
		Get mutant parameter value.
	> set_species_initial_value(species_id, value)
		Set a species initial value.
	> set_wild_type_parameter_value(param_metaid, value)
		Set wild-type parameter value.
	> set_mutant_parameter_value(param_metaid, value)
		Set mutant parameter value.
	> get_random_parameter()
		Get a random parameter.
	> deterministic_parameter_mutation(param_metaid, factor)
		Make a deterministic parameter mutation by a given log-scale factor,
		centered on the wild-type value.
	> random_parameter_mutation(param_metaid, sigma)
		Make a random parameter mutation by a given log-scale mutation size
		sigma, centered on the previous mutant value.
	> write_list_of_variables()
		Write the list of variable names, identifiers and compartment in the
		file "output/variables.txt".
	> write_wild_type_SBML_file()
		Write wild-type SBML file.
	> write_mutant_SBML_file()
		Write mutant SBML file.
	> create_wild_type_cps_file()
		Create ancestor CPS file.
	> create_mutant_cps_file()
		Create mutant CPS file.
	> edit_wild_type_cps_file(task)
		Edit ancestor CPS file to schedule steady-state calculation.
	> edit_mutant_cps_file(task)
		Edit mutant CPS file to schedule steady-state calculation.
	> run_copasi_for_wild_type()
		Run Copasi for the wild-type model.
	> run_copasi_for_mutant()
		Run Copasi for the mutant model.
	> parse_copasi_output(filename, task)
		Parse Copasi output file.
	> compute_wild_type_steady_state()
		Compute wild-type steady-state.
	> compute_mutant_steady_state()
		Compute mutant steady-state.	
	> update_initial_concentrations()
		Update species initial concentrations.
	> compute_sum_distance()
		Compute the metabolic sum distance between the wild-type and the mutant.
	> compute_moma_distance()
		Compute the MOMA distance between the wild-type and the mutant, based on target
		fluxes (MOMA: Minimization Of Metabolic Adjustment).
	> compute_wild_type_metabolic_control_analysis()
		Compute and save the wild-type metabolic control analysis (MCA).
	> compute_mutant_metabolic_control_analysis()
		Compute and save the mutant metabolic control analysis (MCA).
	> build_species_graph():
		Build the metabolite-to-metabolite graph (mainly to compute shortest
		paths afterward).
	> save_shortest_paths(filename):
		Save the matrix of all pairwise metabolites shortest paths (assuming an
		undirected graph).
	"""
	
	### Constructor ###
	def __init__( self, sbml_filename, objective_function, copasi_path ):
		"""
		Model class constructor.
		
		Parameters
		----------
		sbml_filename : str
			Path of the SBML model file. The SBML model is automatically loaded.
		objective_function : list of [str, float]
			Objective function (list of reaction identifiers and coefficients).
		copasi_path : str
			Location of Copasi executable.
		
		Returns
		-------
		None
		"""
		assert os.path.isfile(sbml_filename), "The SBML file \""+sbml_filename+"\" does not exist. Exit."
		assert os.path.isfile(copasi_path), "The executable \""+copasi_path+"\" does not exist. Exit."
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Main SBML data                                           #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.sbml_filename      = sbml_filename
		self.reader             = libsbml.SBMLReader()
		self.wild_type_document = self.reader.readSBMLFromFile(self.sbml_filename)
		self.mutant_document    = self.reader.readSBMLFromFile(self.sbml_filename)
		self.wild_type_model    = self.wild_type_document.getModel()
		self.mutant_model       = self.mutant_document.getModel()
		self.copasi_path        = copasi_path
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) List of model variables (species, reactions, parameters) #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.species             = {}
		self.parameters          = {}
		self.reactions           = {}
		self.species_name_to_id  = {}
		self.reaction_name_to_id = {}
		self.rebuild_metaids()
		self.build_species_list()
		self.build_parameter_list()
		self.build_reaction_list()
		self.write_list_of_variables()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Graph analysis                                           #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.species_graph = nx.Graph()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Model evaluation                                         #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.objective_function         = objective_function
		self.wild_type_absolute_sum     = 0.0
		self.mutant_absolute_sum        = 0.0
		self.wild_type_relative_sum     = 0.0
		self.mutant_relative_sum        = 0.0
		self.absolute_sum_distance      = 0.0
		self.relative_sum_distance      = 0.0
		self.absolute_moma_distance     = 0.0
		self.relative_moma_distance     = 0.0
		self.absolute_moma_all_distance = 0.0
		self.relative_moma_all_distance = 0.0
		for target_flux in objective_function:
			assert target_flux[0] in self.reactions
		
	### Rebuilt the unique metaids for all the model variables ###
	def rebuild_metaids( self ):
		"""
		Rebuild the unique metaids for all model variables.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Rebuild wild_type metaids #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		metaid = 0
		for species in self.wild_type_model.getListOfSpecies():
			species.setMetaId("_"+str(metaid))
			metaid += 1
		for parameter in self.wild_type_model.getListOfParameters():
			parameter.setMetaId("_"+str(metaid))
			metaid += 1
		for reaction in self.wild_type_model.getListOfReactions():
			for elmt in reaction.getListOfAllElements():
				if elmt.getElementName() == "parameter" or elmt.getElementName() == "localParameter":
					parameter        = elmt
					parameter.setMetaId("_"+str(metaid))
					metaid += 1
		for reaction in self.wild_type_model.getListOfReactions():
			reaction.setMetaId("_"+str(metaid))
			metaid += 1
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Rebuild mutant metaids    #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		metaid = 0
		for species in self.mutant_model.getListOfSpecies():
			species.setMetaId("_"+str(metaid))
			metaid += 1
		for parameter in self.mutant_model.getListOfParameters():
			parameter.setMetaId("_"+str(metaid))
			metaid += 1
		for reaction in self.mutant_model.getListOfReactions():
			for elmt in reaction.getListOfAllElements():
				if elmt.getElementName() == "parameter" or elmt.getElementName() == "localParameter":
					parameter        = elmt
					parameter.setMetaId("_"+str(metaid))
					metaid += 1
		for reaction in self.mutant_model.getListOfReactions():
			reaction.setMetaId("_"+str(metaid))
			metaid += 1
			
	### Build the list of metabolites ###
	def build_species_list( self ):
		"""
		Build the species list.
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		self.species            = {}
		self.species_name_to_id = {}
		for species in self.wild_type_model.getListOfSpecies():
			species_metaid = species.getMetaId()
			species_id     = species.getId()
			species_name   = species.getName()
			isConstant     = species.getBoundaryCondition()
			compartment    = species.getCompartment()
			if species_name == "":
				species_name = species_id
			species.setName(species_id)
			assert species_id not in list(self.species)
			self.species[species_id]                    = {"metaid":"", "id":"", "name":"", "constant":False, "initial_value":0.0, "wild_type_value":0.0, "mutant_value":0.0}
			self.species[species_id]["metaid"]          = species_metaid
			self.species[species_id]["id"]              = species_id
			self.species[species_id]["name"]            = species_name
			self.species[species_id]["constant"]        = isConstant
			self.species[species_id]["initial_value"]   = species.getInitialConcentration()
			self.species[species_id]["wild_type_value"] = species.getInitialConcentration()
			self.species[species_id]["mutant_value"]    = species.getInitialConcentration()
			assert species_name not in self.species_name_to_id
			self.species_name_to_id[species_name] = {"id":species_id, "compartment":compartment}
	
	### Build the list of parameters ###
	def build_parameter_list( self ):
		"""
		Build the parameters list.
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		self.parameters = {}
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Parse main parameters              #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		for parameter in self.wild_type_model.getListOfParameters():
			parameter_metaid = parameter.getMetaId()
			parameter_id     = parameter.getId()
			if parameter.getValue() != 0.0:
				self.parameters[parameter_metaid]                    = {"metaid":"", "id":"", "wild_type_value":0.0, "mutant_value":0.0}
				self.parameters[parameter_metaid]["metaid"]          = parameter_metaid
				self.parameters[parameter_metaid]["id"]              = parameter_id
				self.parameters[parameter_metaid]["wild_type_value"] = parameter.getValue()
				self.parameters[parameter_metaid]["mutant_value"]    = parameter.getValue()
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Parse parameters for each reaction #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		for reaction in self.wild_type_model.getListOfReactions():
			for elmt in reaction.getListOfAllElements():
				if elmt.getElementName() == "parameter" or elmt.getElementName() == "localParameter":
					parameter        = elmt
					parameter_metaid = parameter.getMetaId()
					parameter_id     = parameter.getId()
					if parameter.getValue() != 0.0:
						self.parameters[parameter_metaid]                    = {"metaid":"", "id":"", "wild_type_value":0.0, "mutant_value":0.0}
						self.parameters[parameter_metaid]["metaid"]          = parameter_metaid
						self.parameters[parameter_metaid]["id"]              = parameter_id
						self.parameters[parameter_metaid]["wild_type_value"] = parameter.getValue()
						self.parameters[parameter_metaid]["mutant_value"]    = parameter.getValue()
	
	### Build the list of reactions ###
	def build_reaction_list( self ):
		"""
		Build the reaction list.
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		self.reactions           = {}
		self.reaction_name_to_id = {}
		for reaction in self.wild_type_model.getListOfReactions():
			reaction_metaid = reaction.getMetaId()
			reaction_id     = reaction.getId()
			reaction_name   = reaction.getName()
			compartment     = reaction.getCompartment()
			if reaction_name == "":
				reaction_name = reaction_id
			reaction.setName(reaction_id)
			assert reaction_id not in list(self.reactions)
			self.reactions[reaction_id]           = {"metaid":"", "id":"", "name":"", "wild_type_value":0.0, "mutant_value":0.0}
			self.reactions[reaction_id]["metaid"] = reaction_metaid
			self.reactions[reaction_id]["id"]     = reaction_id
			self.reactions[reaction_id]["name"]   = reaction_name
			assert reaction_name not in self.reaction_name_to_id
			self.reaction_name_to_id[reaction_name] = {"id":reaction_id, "compartment":compartment}
	
	### Get the number of species ###
	def get_number_of_species( self ):
		"""
		Get the number of species.
		
		Parameters
		----------
		None
			
		Returns
		-------
		int
		"""
		return len(self.species)
	
	### Get the number of variable species ###
	def get_number_of_variable_species( self ):
		"""
		Get the number of variable species.
		
		Parameters
		----------
		None
			
		Returns
		-------
		int
		"""
		count = 0
		for species_id in self.species:
			if not self.species[species_id]["constant"]:
				count += 1
		return count
	
	### Get the number of parameters ###
	def get_number_of_parameters( self ):
		"""
		Get the number of kinetic parameters.
		
		Parameters
		----------
		None
			
		Returns
		-------
		int
		"""
		return len(self.parameters)
	
	### Get the number of reactions ###
	def get_number_of_reactions( self ):
		"""
		Get the number of reactions.
		
		Parameters
		----------
		None
			
		Returns
		-------
		int
		"""
		return len(self.reactions)
	
	### Get wild-type species value ###
	def get_wild_type_species_value( self, species_id ):
		"""
		Get the wild-type value of the species 'species_id'.
		
		Parameters
		----------
		species_id: str
			The identifier of the species (as defined in the SBML model).
			
		Returns
		-------
		float
		"""
		assert species_id in list(self.species)
		return self.species[species_id]["wild_type_value"]
	
	### Get mutant species value ###
	def get_mutant_species_value( self, species_id ):
		"""
		Get the wild-type value of the species 'species_id'.
		
		Parameters
		----------
		species_id: str
			The identifier of the species (as defined in the SBML model).
			
		Returns
		-------
		float
		"""
		assert species_id in list(self.species)
		return self.species[species_id]["mutant_value"]
	
	### Get wild-type parameter value ###
	def get_wild_type_parameter_value( self, param_metaid ):
		"""
		Get the wild-type value of the parameter 'param_metaid'
		
		Parameters
		----------
		param_metaid: str
			The meta identifier of the parameter (as defined in the SBML model).
			
		Returns
		-------
		float
		"""
		assert param_metaid in list(self.parameters)
		assert self.parameters[param_metaid]["wild_type_value"] == self.wild_type_model.getElementByMetaId(param_metaid).getValue()
		return self.parameters[param_metaid]["wild_type_value"]
	
	### Get mutant parameter value ###
	def get_mutant_parameter_value( self, param_metaid ):
		"""
		Get the mutant value of the parameter 'param_metaid'
		
		Parameters
		----------
		param_metaid: str
			The meta identifier of the parameter (as defined in the SBML model).
			
		Returns
		-------
		float
		"""
		assert param_metaid in list(self.parameters)
		assert self.parameters[param_metaid]["mutant_value"] == self.mutant_model.getElementByMetaId(param_metaid).getValue()
		return self.parameters[param_metaid]["mutant_value"]
	
	### Get wild-type species values array ###
	def get_wild_type_species_array( self ):
		"""
		Get a numpy array of wild-type species abundances.
		
		Parameters
		----------
		None
			
		Returns
		-------
		numpy array
		"""
		vec = []
		for species_id in self.species:
			if not self.species[species_id]["constant"]:
				vec.append(self.species[species_id]["wild_type_value"])
		return np.array(vec)
	
	### Get mutant species values array ###
	def get_mutant_species_array( self ):
		"""
		Get a numpy array of mutant species abundances.
		
		Parameters
		----------
		None
			
		Returns
		-------
		numpy array
		"""
		vec = []
		for species_id in self.species:
			if not self.species[species_id]["constant"]:
				vec.append(self.species[species_id]["mutant_value"])
		return np.array(vec)
	
	### Get wild-type reaction values array ###
	def get_wild_type_reaction_array( self ):
		"""
		Get a numpy array of wild-type reaction fluxes.
		
		Parameters
		----------
		None
			
		Returns
		-------
		numpy array
		"""
		vec = []
		for reaction_id in self.reactions:
			vec.append(self.reactions[reaction_id]["wild_type_value"])
		return np.array(vec)
	
	### Get mutant reaction values array ###
	def get_mutant_reaction_array( self ):
		"""
		Get a numpy array of mutant reaction fluxes.
		
		Parameters
		----------
		None
			
		Returns
		-------
		numpy array
		"""
		vec = []
		for reaction_id in self.reactions:
			vec.append(self.reactions[reaction_id]["mutant_value"])
		return np.array(vec)
	
	### Set a species initial value ###
	def set_species_initial_value( self, species_id, value ):
		"""
		Set the initial concentration of the species 'species_id' in the
		mutant model.
		
		Parameters
		----------
		species_id: str
			Species identifier (as defined in the SBML model).
		value: float >= 0.0
			Species abundance.
			
		Returns
		-------
		None
		"""
		assert species_id in list(self.species)
		if value < 0.0:
			value = 0.0
		self.species[species_id]["wild_type_value"] = value
		self.mutant_model.getListOfSpecies().get(species_id).setInitialConcentration(value)
	
	### Set wild-type parameter value ###
	def set_wild_type_parameter_value( self, param_metaid, value ):
		"""
		Set the wild-type value of the parameter 'param_metaid'.
		
		Parameters
		----------
		param_metaid: str
			Parameter meta identifier (as defined in the SBML model).
		value: float
			Parameter value.
		
		Returns
		-------
		None
		"""
		assert param_metaid in list(self.parameters)
		self.parameters[param_metaid]["wild_type_value"] = value
		self.wild_type_model.getElementByMetaId(param_metaid).setValue(value)
	
	### Set mutant parameter value ###
	def set_mutant_parameter_value( self, param_metaid, value ):
		"""
		Set the mutant value of the parameter 'param_metaid'.
		
		Parameters
		----------
		param_metaid: str
			Parameter meta identifier (as defined in the SBML model).
		value: float
			Parameter value.
		
		Returns
		-------
		None
		"""
		assert param_metaid in list(self.parameters)
		self.parameters[param_metaid]["mutant_value"] = value
		self.mutant_model.getElementByMetaId(param_metaid).setValue(value)
	
	### Get a random parameter ###
	def get_random_parameter( self ):
		"""
		Get a kinetic parameter at random.
		
		Parameters
		----------
		None
			
		Returns
		-------
		str
		"""
		param_index  = np.random.randint(0, len(self.parameters))
		param_metaid = list(self.parameters)[param_index]
		return param_metaid
	
	### Make a deterministic parameter mutation by a given log-scale factor, ###
	### centered on the wild-type value                                      ###
	def deterministic_parameter_mutation( self, param_metaid, factor ):
		"""
		Mutate a given parameter 'param_metaid' by a given log10-scale factor.
		The mutation is centered on the wild-type value.
		x' = x*10^(factor)
		
		Parameters
		----------
		param_metaid: str
			Parameter meta identifier (as defined in the SBML model).
		factor: float
			Log10-scale factor.
		
		Returns
		-------
		int, int
		"""
		assert param_metaid in list(self.parameters)
		wild_type_value = self.get_wild_type_parameter_value(param_metaid)
		mutant_value    = wild_type_value*10.0**factor
		self.set_mutant_parameter_value(param_metaid, mutant_value)
		return wild_type_value, mutant_value

	### Make a random parameter mutation by a given log-scale mutation size ###
	### sigma, centered on the previous mutant value                        ###
	def random_parameter_mutation( self, param_metaid, sigma ):
		"""
		Mutate a given parameter 'param_metaid' through a log10-normal law of
		variance of sigma^2.
		x' = x*10^(N(0,sigma))
		
		Parameters
		----------
		param_metaid: str
			Parameter meta identifier (as defined in the SBML model).
		sigma: float > 0.0
			Log10-scale standard deviation.
		
		Returns
		-------
		int, int
		"""
		assert param_metaid in list(self.parameters)
		assert sigma > 0.0
		factor          = np.random.normal(0.0, sigma, 1)
		wild_type_value = self.get_mutant_parameter_value(param_metaid)
		mutant_value    = wild_type_value*10**factor[0]
		self.set_mutant_parameter_value(param_metaid, mutant_value)
		return wild_type_value, mutant_value
	
	### Write the list of variable names, identifiers and compartment in the ###
	### file "output/species.txt"                                            ###
	def write_list_of_variables( self ):
		f = open("output/variables.txt", "w")
		f.write("name identifier compartment\n")
		for species_name in self.species_name_to_id.keys():
			f.write(species_name+" "+self.species_name_to_id[species_name]["id"]+" "+self.species_name_to_id[species_name]["compartment"]+"\n")
		f.close()
			
	### Write wild-type SBML file ###
	def write_wild_type_SBML_file( self ):
		"""
		Write the wild-type model in a SBML file.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		libsbml.writeSBMLToFile(self.wild_type_document, "output/wild_type.xml")

	### Write mutant SBML file ###
	def write_mutant_SBML_file( self ):
		"""
		Write the mutant model in a SBML file.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		libsbml.writeSBMLToFile(self.mutant_document, "output/mutant.xml")

	### Create wild-type CPS file ###
	def create_wild_type_cps_file( self ):
		"""
		Create a CPS file from the wild-type SBML file.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		cmd_line = self.copasi_path+" -i ./output/wild_type.xml"
		process  = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Create mutant CPS file ###
	def create_mutant_cps_file( self ):
		"""
		Create a CPS file from the mutant SBML file.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		cmd_line = self.copasi_path+" -i ./output/mutant.xml"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Edit wild-type CPS file to schedule steady-state calculation ###
	def edit_wild_type_cps_file( self, task ):
		"""
		Edit wild-type CPS file to schedule steady-state calculation.
		
		Parameters
		----------
		task: str
			Define Copasi task (STEADY_STATE/MCA).
		Returns
		-------
		None
		"""
		assert task in ["STEADY_STATE", "MCA"]
		f = open("./output/wild_type.cps", "r")
		cps = f.read()
		f.close()
		upper_text  = cps.split("<ListOfTasks>")[0]
		lower_text  = cps.split("</ListOfReports>")[1]
		edited_file = ""
		edited_file += upper_text
		if task == "STEADY_STATE":
			#~~~~~~~~~~~~~~~~~~#
			# Write the task   #
			#~~~~~~~~~~~~~~~~~~#
			edited_file += '  <ListOfTasks>\n'
			edited_file += '    <Task key="Task_1" name="Steady-State" type="steadyState" scheduled="true" updateModel="false">\n'
			edited_file += '      <Report reference="Report_1" target="wild_type_output.txt" append="1" confirmOverwrite="1"/>\n'
			edited_file += '      <Problem>\n'
			edited_file += '        <Parameter name="JacobianRequested" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="StabilityAnalysisRequested" type="bool" value="1"/>\n'
			edited_file += '      </Problem>\n'
			edited_file += '      <Method name="Enhanced Newton" type="EnhancedNewton">\n'
			edited_file += '        <Parameter name="Resolution" type="unsignedFloat" value="1.0000000000000001e-12"/>\n'
			edited_file += '        <Parameter name="Derivation Factor" type="unsignedFloat" value="0.001"/>\n'
			edited_file += '        <Parameter name="Use Newton" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Use Integration" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Use Back Integration" type="bool" value="0"/>\n'
			edited_file += '        <Parameter name="Accept Negative Concentrations" type="bool" value="0"/>\n'
			edited_file += '        <Parameter name="Iteration Limit" type="unsignedInteger" value="50"/>\n'
			edited_file += '        <Parameter name="Maximum duration for forward integration" type="unsignedFloat" value="1000000000"/>\n'
			edited_file += '        <Parameter name="Maximum duration for backward integration" type="unsignedFloat" value="1000000"/>\n'
			edited_file += '      </Method>\n'
			edited_file += '    </Task>\n'
			edited_file += '  </ListOfTasks>\n'
			#~~~~~~~~~~~~~~~~~~#
			# Write the report #
			#~~~~~~~~~~~~~~~~~~#
			edited_file += '  <ListOfReports>\n'
			edited_file += '    <Report key="Report_1" name="Steady-State" taskType="steadyState" separator="&#x09;" precision="6">\n'
			edited_file += '      <Comment>\n'
			edited_file += '        Automatically generated report.\n'
			edited_file += '      </Comment>\n'
			edited_file += '      <Footer>\n'
			edited_file += '        <Object cn="CN=Root,Vector=TaskList[Steady-State]"/>\n'
			edited_file += '      </Footer>\n'
			edited_file += '    </Report>\n'
			edited_file += '  </ListOfReports>\n'
		elif task == "MCA":
			#~~~~~~~~~~~~~~~~~~#
			# Write the task   #
			#~~~~~~~~~~~~~~~~~~#
			edited_file += '  <ListOfTasks>\n'
			edited_file += '    <Task key="Task_1" name="Steady-State" type="steadyState" scheduled="false" updateModel="false">\n'
			edited_file += '      <Report reference="Report_1" target="" append="1" confirmOverwrite="1"/>\n'
			edited_file += '      <Problem>\n'
			edited_file += '        <Parameter name="JacobianRequested" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="StabilityAnalysisRequested" type="bool" value="1"/>\n'
			edited_file += '      </Problem>\n'
			edited_file += '      <Method name="Enhanced Newton" type="EnhancedNewton">\n'
			edited_file += '        <Parameter name="Resolution" type="unsignedFloat" value="1.0000000000000001e-12"/>\n'
			edited_file += '        <Parameter name="Derivation Factor" type="unsignedFloat" value="0.001"/>\n'
			edited_file += '        <Parameter name="Use Newton" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Use Integration" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Use Back Integration" type="bool" value="0"/>\n'
			edited_file += '        <Parameter name="Accept Negative Concentrations" type="bool" value="0"/>\n'
			edited_file += '        <Parameter name="Iteration Limit" type="unsignedInteger" value="50"/>\n'
			edited_file += '        <Parameter name="Maximum duration for forward integration" type="unsignedFloat" value="1000000000"/>\n'
			edited_file += '        <Parameter name="Maximum duration for backward integration" type="unsignedFloat" value="1000000"/>\n'
			edited_file += '      </Method>\n'
			edited_file += '    </Task>\n'
			edited_file += '    <Task key="Task_2" name="Metabolic Control Analysis" type="metabolicControlAnalysis" scheduled="true" updateModel="false">\n'
			edited_file += '      <Report reference="Report_1" target="wild_type_output.txt" append="1" confirmOverwrite="1"/>\n'
			edited_file += '      <Problem>\n'
			edited_file += '        <Parameter name="Steady-State" type="key" value="Task_1"/>\n'
			edited_file += '      </Problem>\n'
			edited_file += '      <Method name="MCA Method (Reder)" type="MCAMethod(Reder)">\n'
			edited_file += '        <Parameter name="Modulation Factor" type="unsignedFloat" value="1.0000000000000001e-09"/>\n'
			edited_file += '        <Parameter name="Use Reder" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Use Smallbone" type="bool" value="1"/>\n'
			edited_file += '      </Method>\n'
			edited_file += '    </Task>\n'
			edited_file += '  </ListOfTasks>\n'
			#~~~~~~~~~~~~~~~~~~#
			# Write the report #
			#~~~~~~~~~~~~~~~~~~#
			edited_file += '  <ListOfReports>\n'
			edited_file += '    <Report key="Report_1" name="Metabolic Control Analysis" taskType="metabolicControlAnalysis" separator="&#x09;" precision="6">\n'
			edited_file += '      <Comment>\n'
			edited_file += '        Automatically generated report.\n'
			edited_file += '      </Comment>\n'
			edited_file += '      <Header>\n'
			edited_file += '        <Object cn="CN=Root,Vector=TaskList[Metabolic Control Analysis],Object=Description"/>\n'
			edited_file += '      </Header>\n'
			edited_file += '      <Footer>\n'
			edited_file += '        <Object cn="String=&#x0a;"/>\n'
			edited_file += '        <Object cn="CN=Root,Vector=TaskList[Metabolic Control Analysis],Object=Result"/>\n'
			edited_file += '      </Footer>\n'
			edited_file += '    </Report>\n'
			edited_file += '  </ListOfReports>\n'
		edited_file += lower_text
		f = open("./output/wild_type.cps", "w")
		f.write(edited_file)
		f.close()

	### Edit mutant CPS file to schedule steady-state calculation ###
	def edit_mutant_cps_file( self, task ):
		"""
		Edit mutant CPS file to schedule steady-state calculation.
		
		Parameters
		----------
		task: str
			Define Copasi task (STEADY_STATE/MCA).
		
		Returns
		-------
		None
		"""
		assert task in ["STEADY_STATE", "MCA"]
		f = open("./output/mutant.cps", "r")
		cps = f.read()
		f.close()
		upper_text  = cps.split("<ListOfTasks>")[0]
		lower_text  = cps.split("</ListOfReports>")[1]
		edited_file = ""
		edited_file += upper_text
		if task == "STEADY_STATE":
			#~~~~~~~~~~~~~~~~~~#
			# Write the task   #
			#~~~~~~~~~~~~~~~~~~#
			edited_file += '  <ListOfTasks>\n'
			edited_file += '    <Task key="Task_1" name="Steady-State" type="steadyState" scheduled="true" updateModel="false">\n'
			edited_file += '      <Report reference="Report_1" target="mutant_output.txt" append="1" confirmOverwrite="1"/>\n'
			edited_file += '      <Problem>\n'
			edited_file += '        <Parameter name="JacobianRequested" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="StabilityAnalysisRequested" type="bool" value="1"/>\n'
			edited_file += '      </Problem>\n'
			edited_file += '      <Method name="Enhanced Newton" type="EnhancedNewton">\n'
			edited_file += '        <Parameter name="Resolution" type="unsignedFloat" value="1.0000000000000001e-12"/>\n'
			edited_file += '        <Parameter name="Derivation Factor" type="unsignedFloat" value="0.001"/>\n'
			edited_file += '        <Parameter name="Use Newton" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Use Integration" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Use Back Integration" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Accept Negative Concentrations" type="bool" value="0"/>\n'
			edited_file += '        <Parameter name="Iteration Limit" type="unsignedInteger" value="50"/>\n'
			edited_file += '        <Parameter name="Maximum duration for forward integration" type="unsignedFloat" value="1000000000"/>\n'
			edited_file += '        <Parameter name="Maximum duration for backward integration" type="unsignedFloat" value="1000000"/>\n'
			edited_file += '      </Method>\n'
			edited_file += '    </Task>\n'
			edited_file += '  </ListOfTasks>\n'
			#~~~~~~~~~~~~~~~~~~#
			# Write the report #
			#~~~~~~~~~~~~~~~~~~#
			edited_file += '  <ListOfReports>\n'
			edited_file += '    <Report key="Report_1" name="Steady-State" taskType="steadyState" separator="&#x09;" precision="6">\n'
			edited_file += '      <Comment>\n'
			edited_file += '        Automatically generated report.\n'
			edited_file += '      </Comment>\n'
			edited_file += '      <Footer>\n'
			edited_file += '        <Object cn="CN=Root,Vector=TaskList[Steady-State]"/>\n'
			edited_file += '      </Footer>\n'
			edited_file += '    </Report>\n'
			edited_file += '  </ListOfReports>\n'
		elif task == "MCA":
			#~~~~~~~~~~~~~~~~~~#
			# Write the task   #
			#~~~~~~~~~~~~~~~~~~#
			edited_file += '  <ListOfTasks>\n'
			edited_file += '    <Task key="Task_1" name="Steady-State" type="steadyState" scheduled="false" updateModel="false">\n'
			edited_file += '      <Report reference="Report_1" target="" append="1" confirmOverwrite="1"/>\n'
			edited_file += '      <Problem>\n'
			edited_file += '        <Parameter name="JacobianRequested" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="StabilityAnalysisRequested" type="bool" value="1"/>\n'
			edited_file += '      </Problem>\n'
			edited_file += '      <Method name="Enhanced Newton" type="EnhancedNewton">\n'
			edited_file += '        <Parameter name="Resolution" type="unsignedFloat" value="1.0000000000000001e-09"/>\n'
			edited_file += '        <Parameter name="Derivation Factor" type="unsignedFloat" value="0.001"/>\n'
			edited_file += '        <Parameter name="Use Newton" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Use Integration" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Use Back Integration" type="bool" value="0"/>\n'
			edited_file += '        <Parameter name="Accept Negative Concentrations" type="bool" value="0"/>\n'
			edited_file += '        <Parameter name="Iteration Limit" type="unsignedInteger" value="50"/>\n'
			edited_file += '        <Parameter name="Maximum duration for forward integration" type="unsignedFloat" value="1000000000"/>\n'
			edited_file += '        <Parameter name="Maximum duration for backward integration" type="unsignedFloat" value="1000000"/>\n'
			edited_file += '      </Method>\n'
			edited_file += '    </Task>\n'
			edited_file += '    <Task key="Task_2" name="Metabolic Control Analysis" type="metabolicControlAnalysis" scheduled="true" updateModel="false">\n'
			edited_file += '      <Report reference="Report_1" target="mutant_output.txt" append="1" confirmOverwrite="1"/>\n'
			edited_file += '      <Problem>\n'
			edited_file += '        <Parameter name="Steady-State" type="key" value="Task_1"/>\n'
			edited_file += '      </Problem>\n'
			edited_file += '      <Method name="MCA Method (Reder)" type="MCAMethod(Reder)">\n'
			edited_file += '        <Parameter name="Modulation Factor" type="unsignedFloat" value="1.0000000000000001e-09"/>\n'
			edited_file += '        <Parameter name="Use Reder" type="bool" value="1"/>\n'
			edited_file += '        <Parameter name="Use Smallbone" type="bool" value="1"/>\n'
			edited_file += '      </Method>\n'
			edited_file += '    </Task>\n'
			edited_file += '  </ListOfTasks>\n'
			#~~~~~~~~~~~~~~~~~~#
			# Write the report #
			#~~~~~~~~~~~~~~~~~~#
			edited_file += '  <ListOfReports>\n'
			edited_file += '    <Report key="Report_1" name="Metabolic Control Analysis" taskType="metabolicControlAnalysis" separator="&#x09;" precision="6">\n'
			edited_file += '      <Comment>\n'
			edited_file += '        Automatically generated report.\n'
			edited_file += '      </Comment>\n'
			edited_file += '      <Header>\n'
			edited_file += '        <Object cn="CN=Root,Vector=TaskList[Metabolic Control Analysis],Object=Description"/>\n'
			edited_file += '      </Header>\n'
			edited_file += '      <Footer>\n'
			edited_file += '        <Object cn="String=&#x0a;"/>\n'
			edited_file += '        <Object cn="CN=Root,Vector=TaskList[Metabolic Control Analysis],Object=Result"/>\n'
			edited_file += '      </Footer>\n'
			edited_file += '    </Report>\n'
			edited_file += '  </ListOfReports>\n'
		edited_file += lower_text
		f = open("./output/mutant.cps", "w")
		f.write(edited_file)
		f.close()

	### Run Copasi for the wild-type model ###
	def run_copasi_for_wild_type( self ):
		"""
		Run Copasi to compute the wild-type steady-state and update model state.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		if os.path.isfile("./output/wild_type_output.txt"):
			os.system("rm ./output/wild_type_output.txt")
		cmd_line = self.copasi_path+" ./output/wild_type.cps"
		process  = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Run Copasi for the mutant model ###
	def run_copasi_for_mutant( self ):
		"""
		Run Copasi to compute the mutant steady-state and update model state.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		if os.path.isfile("./output/mutant_output.txt"):
			os.system("rm ./output/mutant_output.txt")
		cmd_line = self.copasi_path+" ./output/mutant.cps"
		process  = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)
	
	### Parse Copasi output file ###
	def parse_copasi_output( self, filename, task ):
		"""
		Parse the Copasi output 'filename'.
		
		Parameters
		----------
		filename: str
			Name of the Copasi output (txt file).
		task: str
			Define Copasi task (STEADY_STATE/MCA).
		
		Returns
		-------
		- boolean, list of [str, float] lists, list of [str, float] lists if task == "STEADY_STATE"
		- boolean, list of [str], list of [str], list of list of [str] if task == "MCA"
		"""
		assert os.path.isfile(filename), "The Copasi output \""+filename+"\" does not exist. Exit."
		assert task in ["STEADY_STATE", "MCA"]
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Parse to extract the steady-state #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		if task == "STEADY_STATE":
			concentrations       = []
			fluxes               = []
			parse_concentrations = False
			parse_fluxes         = False
			f = open(filename, "r")
			l = f.readline()
			if "No steady state with given resolution was found!" in l:
				return False, concentrations, fluxes
			while l:
				if l == "\n" and parse_concentrations:
					 parse_concentrations = False
				if l == "\n" and parse_fluxes:
					 parse_fluxes = False
				if parse_concentrations:
					name = l.split("\t")[0]
					val  = l.split("\t")[1]
					concentrations.append([name, val])
				if parse_fluxes:
					name = l.split("\t")[0]
					val  = l.split("\t")[1]
					fluxes.append([name, val])
				if l.startswith("Species"):
					parse_concentrations = True
				if l.startswith("Reaction"):
					parse_fluxes = True
				l = f.readline()
			f.close()
			return True, concentrations, fluxes
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Parse to extract the MCA result   #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		elif task == "MCA":
			colnames = []
			rownames = []
			unscaled = []
			scaled   = []
			N        = 0
			f = open(filename, "r")
			l = f.readline()
			while l:
				if l.startswith("Unscaled concentration control coefficients"):
					l        = f.readline()
					l        = f.readline()
					l        = f.readline()
					l        = f.readline()
					colnames = l.strip("\n\t").split("\t")
					N        = len(colnames)
					l        = f.readline()
					for i in range(len(colnames)):
						colnames[i] = colnames[i].strip("()")
					while l != "\n":
						l = l.strip("\n\t").split("\t")
						rownames.append(l[0])
						unscaled.append(l[1:(N+1)])
						l = f.readline()
				if l.startswith("Scaled concentration control coefficients"):
					l        = f.readline()
					l        = f.readline()
					l        = f.readline()
					l        = f.readline()
					l        = f.readline()
					while l != "\n":
						l = l.strip("\n\t").split("\t")
						scaled.append(l[1:(N+1)])
						l = f.readline()
					break
				l = f.readline()
			f.close()
			return rownames, colnames, unscaled, scaled
	
	### Compute wild-type steady-state ###
	def compute_wild_type_steady_state( self ):
		"""
		Compute and save the wild-type steady-state.
		
		Parameters
		----------
		None
		
		Returns
		-------
		Boolean
		"""
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Compute the steady-state with Copasi #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.write_wild_type_SBML_file()
		self.create_wild_type_cps_file()
		self.edit_wild_type_cps_file("STEADY_STATE")
		self.run_copasi_for_wild_type()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Extract steady-state                 #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		success, concentrations, fluxes = self.parse_copasi_output("./output/wild_type_output.txt", "STEADY_STATE")
		if not success:
			return False
		#assert success, "The model is unstable. Exit."
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Update model and lists               #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.wild_type_absolute_sum = 0.0
		self.wild_type_relative_sum = 0.0
		for elmt in concentrations:
			species_id    = elmt[0]
			species_value = float(elmt[1])
			assert species_id in self.species
			if not self.species[species_id]["constant"]:
				self.species[species_id]["wild_type_value"]  = species_value
				self.species[species_id]["mutant_value"]     = species_value
				self.wild_type_absolute_sum                 += species_value
				self.wild_type_relative_sum                 += 1.0
		for elmt in fluxes:
			reaction_id    = elmt[0]
			reaction_value = float(elmt[1])
			assert reaction_id in self.reactions
			self.reactions[reaction_id]["wild_type_value"] = reaction_value
			self.reactions[reaction_id]["mutant_value"]    = reaction_value
		return True
	
	### Compute mutant steady-state ###
	def compute_mutant_steady_state( self ):
		"""
		Compute and save the mutant steady-state.
		
		Parameters
		----------
		None
		
		Returns
		-------
		Boolean
		"""
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Compute the steady-state with Copasi #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.write_mutant_SBML_file()
		self.create_mutant_cps_file()
		self.edit_mutant_cps_file("STEADY_STATE")
		self.run_copasi_for_mutant()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Extract steady-state                 #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		success, concentrations, fluxes = self.parse_copasi_output("./output/mutant_output.txt", "STEADY_STATE")
		if not success:
			return False
		#assert success, "The model is unstable. Exit."
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Update model and lists               #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.mutant_absolute_sum = 0.0
		self.mutant_relative_sum = 0.0
		for elmt in concentrations:
			species_id    = elmt[0]
			species_value = float(elmt[1])
			assert species_id in self.species
			if not self.species[species_id]["constant"]:
				self.species[species_id]["mutant_value"]  = species_value
				self.mutant_absolute_sum                 += species_value
				self.mutant_relative_sum                 += species_value/self.species[species_id]["wild_type_value"]
		for elmt in fluxes:
			reaction_id    = elmt[0]
			reaction_value = float(elmt[1])
			assert reaction_id in self.reactions
			self.reactions[reaction_id]["mutant_value"] = reaction_value
		return True
	
	### Update species initial concentrations ###	
	def update_initial_concentrations( self ):
		"""
		Update initial concentrations in the mutant model.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		for species_item in self.species.items():
			species_id = species_item[0]
			if not self.species[species_id]["constant"]:
				self.set_species_initial_value(species_id, self.species[species_id]["mutant_value"])
	
	### Compute the metabolic sum distance between the wild-type and the mutant ###
	def compute_sum_distance( self ):
		"""
		Compute the metabolic sum distance between the wild-type and the mutant.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		self.absolute_sum_distance = abs(self.wild_type_absolute_sum-self.mutant_absolute_sum)
		self.relative_sum_distance = abs(self.wild_type_relative_sum-self.mutant_relative_sum)
	
	### Compute the MOMA distance between the wild-type and the mutant ###
	def compute_moma_distance( self ):
		"""
		Compute the MOMA distance between the wild-type and the mutant, based on
		target fluxes.
		(MOMA: Minimization Of Metabolic Adjustment)
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Compute absolute and relative MOMA distance on target fluxes  #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.absolute_moma_distance = 0.0
		self.relative_moma_distance = 0.0
		for target_flux in self.objective_function:
			reaction_id     = target_flux[0]
			coefficient     = target_flux[1]
			wild_type_value = self.reactions[reaction_id]["wild_type_value"]
			mutant_value    = self.reactions[reaction_id]["mutant_value"]
			self.absolute_moma_distance += (wild_type_value-mutant_value)*(wild_type_value-mutant_value)
			self.relative_moma_distance += (wild_type_value-mutant_value)/wild_type_value*(wild_type_value-mutant_value)/wild_type_value
		self.absolute_moma_distance = np.sqrt(self.absolute_moma_distance)
		self.relative_moma_distance = np.sqrt(self.relative_moma_distance)
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Compute absolute and relative MOMA distance on all the fluxes #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.absolute_moma_all_distance = 0.0
		self.relative_moma_all_distance = 0.0
		wild_type_flux_array            = self.get_wild_type_reaction_array()
		mutant_flux_array               = self.get_mutant_reaction_array()
		for i in range(self.get_number_of_reactions()):
			wild_type_value = wild_type_flux_array[i]
			mutant_value    = mutant_flux_array[i]
			if wild_type_value > 1e-10:
				self.absolute_moma_all_distance += (wild_type_value-mutant_value)*(wild_type_value-mutant_value)
				self.relative_moma_all_distance += (wild_type_value-mutant_value)/wild_type_value*(wild_type_value-mutant_value)/wild_type_value
		self.absolute_moma_all_distance = np.sqrt(self.absolute_moma_all_distance)
		self.relative_moma_all_distance = np.sqrt(self.relative_moma_all_distance)
	
	### Compute wild-type metabolic control analysis (MCA) ###
	def compute_wild_type_metabolic_control_analysis( self ):
		"""
		Compute and save the wild-type metabolic control analysis (MCA).
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Compute the steady-state with Copasi #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.write_wild_type_SBML_file()
		self.create_wild_type_cps_file()
		self.edit_wild_type_cps_file("MCA")
		self.run_copasi_for_wild_type()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Extract the MCA result               #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		rownames, colnames, unscaled, scaled = self.parse_copasi_output("./output/wild_type_output.txt", "MCA")
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Write control coefficients data      #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		f = open("./output/wild_type_MCA_unscaled.txt", "w")
		f.write("species_id species_value flux_id flux_value control_coef\n")
		for i in range(len(rownames)):
			for j in range(len(colnames)):
				species_id    = rownames[i]
				flux_id       = colnames[j]
				species_value = self.species[species_id]["wild_type_value"]
				flux_value    = self.reactions[flux_id]["wild_type_value"]
				control_coef  = unscaled[i][j]
				f.write(species_id+" "+str(species_value)+" "+flux_id+" "+str(flux_value)+" "+control_coef+"\n")
		f.close()
		f = open("./output/wild_type_MCA_scaled.txt", "w")
		f.write("species_id species_value flux_id flux_value control_coef\n")
		for i in range(len(rownames)):
			for j in range(len(colnames)):
				species_id    = rownames[i]
				flux_id       = colnames[j]
				species_value = self.species[species_id]["wild_type_value"]
				flux_value    = self.reactions[flux_id]["wild_type_value"]
				control_coef  = scaled[i][j]
				f.write(species_id+" "+str(species_value)+" "+flux_id+" "+str(flux_value)+" "+control_coef+"\n")
		f.close()
		
	### Compute mutant metabolic control analysis (MCA) ###
	def compute_mutant_metabolic_control_analysis( self ):
		"""
		Compute and save the mutant metabolic control analysis (MCA).
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Compute the steady-state with Copasi #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.write_mutant_SBML_file()
		self.create_mutant_cps_file()
		self.edit_mutant_cps_file("MCA")
		self.run_copasi_for_mutant()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Extract the MCA result               #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		rownames, colnames, unscaled, scaled = self.parse_copasi_output("./output/mutant_output.txt", "MCA")
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Write control coefficients matrices  #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		f = open("./output/mutant_MCA_unscaled.txt", "w")
		for colname in colnames:
			f.write(" "+colname)
		f.write("\n")
		for i in range(len(rownames)):
			f.write(rowname)
			for elmt in unscaled[i]:
				f.write(" "+elmt)
			f.write("\n")
		f.close()
		f = open("./output/mutant_MCA_scaled.txt", "w")
		for colname in colnames:
			f.write(" "+colname)
		f.write("\n")
		for i in range(len(rownames)):
			f.write(rowname)
			for elmt in scaled[i]:
				f.write(" "+elmt)
			f.write("\n")
		f.close()
		
	### Build the graph of species ###
	def build_species_graph( self ):
		"""
		Build the metabolite-to-metabolite graph (mainly to compute shortest
		paths afterward).
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		self.species_graph.clear()
		species_metaid = {}
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Create nodes from species names #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		for species_id in self.species.keys():
			self.species_graph.add_node(self.species[species_id]["name"])
			species_metaid[self.species[species_id]["metaid"]] = self.species[species_id]["name"]
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Create edges from reactions     #
		#   (All the species involved in the #
		#    reaction are connected)         #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		for reaction in self.wild_type_model.getListOfReactions():
			list_of_metabolites = []
			for reactant in reaction.getListOfReactants():
				list_of_metabolites.append(reactant.getSpecies())
			for product in reaction.getListOfProducts():
				list_of_metabolites.append(product.getSpecies())
			#for modifier in reaction.getListOfModifiers():
			#	list_of_metabolites.append(modifier.getSpecies())
			for i in range(len(list_of_metabolites)):
				for j in range(i+1, len(list_of_metabolites)):
					self.species_graph.add_edge(list_of_metabolites[i], list_of_metabolites[j])
		del species_metaid
	
	### Save shortest path lengths matrix ###
	def save_shortest_paths( self, filename ):
		"""
		Save the matrix of all pairwise metabolites shortest paths (assuming an
		undirected graph).
		
		Parameters
		----------
		filename: str
			Name of the Copasi output (txt file).
		
		Returns
		-------
		None
		"""
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Extract shortest path lengths      #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		sp = nx.shortest_path_length(self.species_graph)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Build the matrix of shortest paths #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		sp_dict             = {}
		list_of_metabolites = []
		header              = ""
		for line in sp:
			sp_dict[line[0]]  = {}
			list_of_metabolites.append(line[0])
			header           += line[0]+" "
			for species in line[1]:
				sp_dict[line[0]][species] = line[1][species]
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Write the file                     #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		f = open(filename, "w")
		f.write(header.strip(" ")+"\n")
		for sp1 in list_of_metabolites:
			line = sp1
			for sp2 in list_of_metabolites:
				line += " "+str(sp_dict[sp1][sp2])
			f.write(line+"\n")
		f.close()
		
#********************************************************************
# MCMC class
# ----------
# This class runs a Monte-Carlo Markov Chain (MCMC) evolution
# experiment on a SBML model, with cycles of mutations and fixations
# depending on a given selection threshold.
#********************************************************************
class MCMC:
	"""
	The MCMC class runs a Monte-Carlo Markov Chain (MCMC) evolution experiment
	on a SBML model, with cycles of mutations and fixations depending on a given
	selection threshold.
	
	Attributes
	----------
	> sbml_filename : str
		Name of the SBML model file.
	> total_iterations : int > 0
		Total number of MCMC iterations.
	> sigma : float > 0.0
		Standard deviation of the Log10-normal mutational distribution.
	> selection_scheme : str
		Selection scheme ('MUTATION_ACCUMULATION'/'ABSOLUTE_METABOLIC_SUM_SELECTION'/
		                  'RELATIVE_METABOLIC_SUM_SELECTION'/'ABSOLUTE_TARGET_FLUXES_SELECTION'/
		                  'RELATIVE_TARGET_FLUXES_SELECTION').
	> selection_threshold : str
		Selection threshold applied on the MOMA distance.
	> copasi_path : str
		Location of Copasi executable.
	> model : Model
		SBML Model (automatically loaded from the SBML file).
	> nb_iterations : int
		Current number of iterations.
	> nb_accepted : int
		Current number of accepted mutations.
	> nb_rejected : int
		Current number of rejected mutations.
	> param_metaid : str
		Last mutated parameter meta identifier.
	> param_id : str
		Last mutated parameter identifier.
	> param_value : float
		Last mutated parameter value.
	> param_previous : float
		Parameter value before mutation.
	> N_abund : float
		Number of variable species.
	> wild_type_abund : numpy array
		Wild-type abundances tracker.
	> wild_type_flux : numpy array
		Wild-type fluxes tracker.
	> mutant_abund : numpy array
		Mutant abundances tracker.
	> mutant_flux : numpy array
		Mutant fluxes tracker.
	> sum_abund : numpy array
		Sum of abundances tracker.
	> relsum_abund : numpy array
		Sum of abundances relatively to the wild-type tracker.
	> sqsum_abund : numpy array
		Square sum of abundances tracker.
	> relsqsum_abund : numpy array
		Square sum of abundances relatively to the wild-type tracker.
	> sum_flux : numpy array
		Sum of fluxes tracker.
	> relsum_flux : numpy array
		Sum of fluxes relatively to the wild-type tracker.
	> sqsum_flux : numpy array
		Square sum of fluxes tracker.
	> relsqsum_flux : numpy array
		Square sum of fluxes relatively to the wild-type tracker.
	> mean_abund : numpy array
		Mean abundances tracker.
	> var_abund : numpy array
		Variance of abundances tracker.
	> CV_abund : numpy array
		Coefficient of variation of abundances tracker.
	> ER_abund : numpy array
		Evolution rate of abundances tracker.
	> mean_flux : numpy array
		Mean fluxes tracker.
	> var_flux : numpy array
		Variance of fluxes tracker.
	> CV_flux : numpy array
		Coefficient of variation of fluxes tracker.
	> ER_flux : numpy array
		Evolution rate of fluxes tracker.
	> previous_abund : numpy array
		Previous abundances tracker.
	> previous_flux : numpy array
		Previous fluxes tracker.
	> output_file : file
		Output file tracking each MCMC algorithm iteration.
	
	Methods
	-------
	> __init__(sbml_filename, target_fluxes, total_iterations, sigma, selection_scheme, selection_threshold, copasi_path)
		MCMC class constructor.
	> initialize_output_file()
		Initialize the output file (write the header).
	> write_output_file()
		Write the current MCMC state in the output file.
	> update_statistics()
		Update statistics trackers for the current state.
	> compute_statistics()
		Compute final statistics.
	> write_statistics()
		Write final statistics in an output file (output/statistics.txt).
	> initialize()
		Initialize the MCMC algorithm.
	> reload_previous_state()
		Reload the previous MCMC state.
	> iterate()
		Iterate the MCMC algorithm.
	"""
	
	### Constructor ###
	def __init__( self, sbml_filename, objective_function, total_iterations, sigma, selection_scheme, selection_threshold, copasi_path ):
		"""
		MCMC class constructor.
		
		Parameters
		----------
		sbml_filename : str
			Path of the SBML model file. The SBML model is automatically loaded.
		objective_function : list of [str, float]
			Objective function (list of reaction identifiers and coefficients).
		total_iterations : int > 0
			Total number of MCMC iterations.
		sigma : float > 0.0
			Standard deviation of the Log10-normal mutational distribution.
		selection_scheme : str
			Selection scheme ('MUTATION_ACCUMULATION'/'ABSOLUTE_METABOLIC_SUM_SELECTION'/
			                  'RELATIVE_METABOLIC_SUM_SELECTION'/'ABSOLUTE_TARGET_FLUXES_SELECTION'/
			                  'RELATIVE_TARGET_FLUXES_SELECTION').
		selection_threshold : float > 0.0
			Selection threshold applied on the MOMA distance.
		copasi_path : str
			Location of Copasi executable.
		
		Returns
		-------
		None
		"""
		assert os.path.isfile(sbml_filename), "The SBML file \""+sbml_filename+"\" does not exist. Exit."
		assert len(objective_function) > 0, "You must provide at least one reaction in the objective function. Exit."
		assert total_iterations > 0, "The total number of iterations must be a positive nonzero value. Exit."
		assert sigma > 0.0, "The mutation size 'sigma' must be a positive nonzero value. Exit."
		assert selection_scheme in ["MUTATION_ACCUMULATION", "ABSOLUTE_METABOLIC_SUM_SELECTION", "RELATIVE_METABOLIC_SUM_SELECTION", "ABSOLUTE_TARGET_FLUXES_SELECTION", "RELATIVE_TARGET_FLUXES_SELECTION", "ABSOLUTE_ALL_FLUXES_SELECTION", "RELATIVE_ALL_FLUXES_SELECTION"], "The selection scheme takes two values only (MUTATION_ACCUMULATION / ABSOLUTE_METABOLIC_SUM_SELECTION / RELATIVE_METABOLIC_SUM_SELECTION / ABSOLUTE_TARGET_FLUXES_SELECTION / RELATIVE_TARGET_FLUXES_SELECTION / ABSOLUTE_ALL_FLUXES_SELECTION / RELATIVE_ALL_FLUXES_SELECTION). Exit."
		assert os.path.isfile(copasi_path), "The executable \""+copasi_path+"\" does not exist. Exit."
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Main MCMC parameters   #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.sbml_filename       = sbml_filename
		self.total_iterations    = total_iterations
		self.sigma               = sigma
		self.selection_scheme    = selection_scheme
		self.selection_threshold = selection_threshold
		self.copasi_path         = copasi_path
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) SBML model             #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.model = Model(sbml_filename, objective_function, copasi_path)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Current state tracking #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.nb_iterations  = 0
		self.nb_accepted    = 0
		self.nb_rejected    = 0
		self.nb_unstable    = 0
		self.param_metaid   = "_"
		self.param_id       = "wild_type"
		self.param_value    = 0.0
		self.param_previous = 0.0
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Statistics             #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		### Array lengths ###
		self.N_abund = self.model.get_number_of_variable_species()
		self.N_flux  = self.model.get_number_of_reactions()
		
		### Arrays ###
		self.wild_type_abund = np.zeros(self.N_abund)
		self.mutant_abund    = np.zeros(self.N_abund)
		self.wild_type_flux  = np.zeros(self.N_flux)
		self.mutant_flux     = np.zeros(self.N_flux)
		
		### Sum vectors ###
		self.sum_abund      = np.zeros(self.N_abund)
		self.relsum_abund   = np.zeros(self.N_abund)
		self.sqsum_abund    = np.zeros(self.N_abund)
		self.relsqsum_abund = np.zeros(self.N_abund)
		self.sum_flux       = np.zeros(self.N_flux)
		self.relsum_flux    = np.zeros(self.N_flux)
		self.sqsum_flux     = np.zeros(self.N_flux)
		self.relsqsum_flux  = np.zeros(self.N_flux)
		
		### Final statistics ###
		self.mean_abund = np.zeros(self.N_abund)
		self.var_abund  = np.zeros(self.N_abund)
		self.CV_abund   = np.zeros(self.N_abund)
		self.ER_abund   = np.zeros(self.N_abund)
		self.mean_flux  = np.zeros(self.N_flux)
		self.var_flux   = np.zeros(self.N_flux)
		self.CV_flux    = np.zeros(self.N_flux)
		self.ER_flux    = np.zeros(self.N_flux)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 5) Previous state         #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.previous_abund = np.copy(self.mutant_abund)
		self.previous_flux  = np.copy(self.mutant_flux)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 6) Output file            #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.output_file = open("output/iterations.txt", "w")
		self.output_file.close()
		
	### Initialize the output file ###
	def initialize_output_file( self ):
		"""
		Initialize the output file (write the header).
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		header = "nb_iterations nb_accepted nb_rejected param_metaid param_id param_previous param_val"
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				header += " "+species_id
		for reaction_id in self.model.reactions:
			header += " "+reaction_id
		header += " wild_type_absolute_sum mutant_absolute_sum wild_type_relative_sum mutant_relative_sum absolute_sum_dist relative_sum_dist absolute_moma_dist relative_moma_dist absolute_moma_all_dist relative_moma_all_dist\n"
		self.output_file = open("output/iterations.txt", "a")
		self.output_file.write(header)
		self.output_file.close()
	
	### Write the current MCMC state in the output file ###
	def write_output_file( self ):
		"""
		Write the current MCMC state in the output file.
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		line = ""
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Write current MCMC state #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		line += str(self.nb_iterations)+" "
		line += str(self.nb_accepted)+" "
		line += str(self.nb_rejected)+" "
		line += str(self.param_metaid)+" "
		line += str(self.param_id)+" "
		line += str(self.param_previous)+" "
		line += str(self.param_value)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Write steady-state       #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				line += " "+str(self.model.species[species_id]["mutant_value"])
		for reaction_id in self.model.reactions:
			line += " "+str(self.model.reactions[reaction_id]["mutant_value"])
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Write scores             #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		line += " "+str(self.model.wild_type_absolute_sum)+" "+str(self.model.mutant_absolute_sum)+" "+str(self.model.wild_type_relative_sum)+" "+str(self.model.mutant_relative_sum)+" "+str(self.model.absolute_sum_distance)+" "+str(self.model.relative_sum_distance)+" "+str(self.model.absolute_moma_distance)+" "+str(self.model.relative_moma_distance)+" "+str(self.model.absolute_moma_all_distance)+" "+str(self.model.relative_moma_all_distance)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Write in file            #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.output_file = open("output/iterations.txt", "a")
		self.output_file.write(line+"\n")
		self.output_file.close()
	
	### Update statistics ###
	def update_statistics( self ):
		"""
		Update statistics trackers for the current state.
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		###########
		self.sum_abund   += self.mutant_abund
		self.sqsum_abund += self.mutant_abund*self.mutant_abund
		for i in range(self.N_abund):
			if self.wild_type_abund[i] > 0.0:
				self.relsum_abund[i]   += (self.mutant_abund[i]/self.wild_type_abund[i])
				self.relsqsum_abund[i] += (self.mutant_abund[i]/self.wild_type_abund[i])*(self.mutant_abund[i]/self.wild_type_abund[i])
		###########
		self.sum_flux   += self.mutant_flux
		self.sqsum_flux += self.mutant_flux*self.mutant_flux
		for i in range(self.N_flux):
			if self.wild_type_flux[i] > 0.0:
				self.relsum_flux[i]   += (self.mutant_flux[i]/self.wild_type_flux[i])
				self.relsqsum_flux[i] += (self.mutant_flux[i]/self.wild_type_flux[i])*(self.mutant_flux[i]/self.wild_type_flux[i])
		
	### Compute statistics for the current iteration ###
	def compute_statistics( self ):
		"""
		Compute final statistics.
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Compute mean                     #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.mean_abund  = np.copy(self.sum_abund)
		self.mean_abund /= float(self.nb_iterations)
		###########
		self.mean_flux  = np.copy(self.sum_flux)
		self.mean_flux /= float(self.nb_iterations)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Compute variance                 #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.var_abund  = np.copy(self.sqsum_abund)
		self.var_abund /= float(self.nb_iterations)
		self.var_abund -= self.mean_abund*self.mean_abund
		###########
		self.var_flux  = np.copy(self.sqsum_flux)
		self.var_flux /= float(self.nb_iterations)
		self.var_flux -= self.mean_flux*self.mean_flux
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Compute coefficient of variation #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.CV_abund  = np.copy(self.sqsum_abund)
		self.CV_abund /= float(self.nb_iterations)
		self.CV_abund -= self.mean_abund*self.mean_abund
		for i in range(self.N_abund):
			if self.mean_abund[i] > 0.0:
				self.CV_abund[i] = np.sqrt(self.CV_abund[i])/self.mean_abund[i]
			else:
				self.CV_abund[i] = 0.0
		
		###########
		self.CV_flux  = np.copy(self.sqsum_flux)
		self.CV_flux /= float(self.nb_iterations)
		self.CV_flux -= self.mean_flux*self.mean_flux
		for i in range(self.N_flux):
			if self.mean_flux[i] > 0.0:
				self.CV_flux[i] = np.sqrt(self.CV_flux[i])/self.mean_flux[i]
			else:
				self.CV_flux[i] = 0.0
				
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Compute evolution rate           #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.ER_abund  = np.copy(self.relsqsum_abund)
		self.ER_abund /= float(self.nb_iterations)
		self.ER_abund -= (self.relsum_abund/float(self.nb_iterations))*(self.relsum_abund/float(self.nb_iterations))
		self.ER_abund /= float(self.nb_iterations)
		###########
		self.ER_flux  = np.copy(self.relsqsum_flux)
		self.ER_flux /= float(self.nb_iterations)
		self.ER_flux -= (self.relsum_flux/float(self.nb_iterations))*(self.relsum_flux/float(self.nb_iterations))
		self.ER_flux /= float(self.nb_iterations)

	### Write statistics in a file ###
	def write_statistics( self ):
		"""
		Write final statistics in an output file (output/statistics.txt).
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		f = open("output/statistics.txt", "w")
		f.write("species_id wild_type mean var CV ER\n")
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Write species statistics #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		index = 0
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				line   = species_id+" "
				line  += str(self.wild_type_abund[index])+" "
				line  += str(self.mean_abund[index])+" "
				line  += str(self.var_abund[index])+" "
				line  += str(self.CV_abund[index])+" "
				line  += str(self.ER_abund[index])+"\n"
				index += 1
				f.write(line)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Write fluxes statistics  #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		index = 0
		for reaction_id in self.model.reactions:
			line   = reaction_id+" "
			line  += str(self.wild_type_flux[index])+" "
			line  += str(self.mean_flux[index])+" "
			line  += str(self.var_flux[index])+" "
			line  += str(self.CV_flux[index])+" "
			line  += str(self.ER_flux[index])+"\n"
			index += 1
			f.write(line)
		f.close()
	
	### Initialize MCMC algorithm ###
	def initialize( self ):
		"""
		Initialize the MCMC algorithm.
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		success = self.model.compute_wild_type_steady_state()
		assert success, "Wild-type model is not stable. Exit."
		success = self.model.compute_mutant_steady_state()
		assert success, "Wild-type model is not stable. Exit."
		self.model.compute_sum_distance()
		self.model.compute_moma_distance()
		self.initialize_output_file()
		self.wild_type_abund = self.model.get_wild_type_species_array()
		self.mutant_abund    = self.model.get_mutant_species_array()
		self.wild_type_flux  = self.model.get_wild_type_reaction_array()
		self.mutant_flux     = self.model.get_mutant_reaction_array()
		
	### Reload the previous MCMC state ###
	def reload_previous_state( self ):
		"""
		Reload the previous MCMC state.
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Restore the mutated parameter #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.model.set_mutant_parameter_value(self.param_metaid, self.param_previous)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Retrieve previous values      #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.mutant_abund = np.copy(self.previous_abund)
		self.mutant_flux  = np.copy(self.previous_flux)
		index = 0
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				self.model.species[species_id]["mutant_value"] = self.mutant_abund[index]
				index += 1
		index = 0
		for reaction_id in self.model.reactions:
			self.model.reactions[reaction_id]["mutant_value"] = self.mutant_flux[index]
			index += 1
		
	### Iterate MCMC algorithm ###
	def iterate( self ):
		"""
		Iterate the MCMC algorithm.
		
		Parameters
		----------
		None
			
		Returns
		-------
		None
		"""
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Save previous state                                         #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.previous_abund = np.copy(self.mutant_abund)
		self.previous_flux  = np.copy(self.mutant_flux)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Introduce a new random mutation                             #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.param_metaid                     = self.model.get_random_parameter()
		self.param_id                         = self.model.parameters[self.param_metaid]["id"]
		self.param_previous, self.param_value = self.model.random_parameter_mutation(self.param_metaid, self.sigma)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Compute the new steady-state                                #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		success = self.model.compute_mutant_steady_state()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Evaluate model stability and select the new iteration event #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		if not success:
			self.reload_previous_state()
			self.nb_unstable    += 1
			self.param_metaid    = "_"
			self.param_id        = "_"
			self.param_value     = 0.0
			self.param_previous  = 0.0
		else:
			self.nb_unstable = 0
			self.model.compute_sum_distance()
			self.model.compute_moma_distance()
			self.mutant_abund = self.model.get_mutant_species_array()
			self.mutant_flux  = self.model.get_mutant_reaction_array()
			#-----------------------------------------------------------------#
			# 4.1) If the simulation is a mutation accumulation experiment,   #
			#      keep all the mutational events.                            #
			#-----------------------------------------------------------------#
			if self.selection_scheme == "MUTATION_ACCUMULATION":
				self.nb_iterations += 1
				self.nb_accepted   += 1
				self.update_statistics()
				self.compute_statistics()
			#-----------------------------------------------------------------#
			# 4.2) If the simulation is a absolute metabolic sum selection    #
			#      experiment, keep only mutations for which the SUM distance #
			#      is lower than a given selection threshold.                 #
			#-----------------------------------------------------------------#
			elif self.selection_scheme == "ABSOLUTE_METABOLIC_SUM_SELECTION" and self.model.absolute_sum_distance < self.selection_threshold:
				self.nb_iterations += 1
				self.nb_accepted   += 1
				self.update_statistics()
				self.compute_statistics()
			elif self.selection_scheme == "ABSOLUTE_METABOLIC_SUM_SELECTION" and self.model.absolute_sum_distance >= self.selection_threshold:
				self.nb_iterations += 1
				self.nb_rejected   += 1
				self.reload_previous_state()
				self.update_statistics()
				self.compute_statistics()
				self.param_metaid   = "_"
				self.param_id       = "_"
				self.param_value    = 0.0
				self.param_previous = 0.0
			#-----------------------------------------------------------------#
			# 4.3) If the simulation is a relative metabolic sum selection    #
			#      experiment, keep only mutations for which the SUM distance #
			#      is lower than a given selection threshold.                 #
			#-----------------------------------------------------------------#
			elif self.selection_scheme == "RELATIVE_METABOLIC_SUM_SELECTION" and self.model.relative_sum_distance < self.selection_threshold:
				self.nb_iterations += 1
				self.nb_accepted   += 1
				self.update_statistics()
				self.compute_statistics()
			elif self.selection_scheme == "RELATIVE_METABOLIC_SUM_SELECTION" and self.model.relative_sum_distance >= self.selection_threshold:
				self.nb_iterations += 1
				self.nb_rejected   += 1
				self.reload_previous_state()
				self.update_statistics()
				self.compute_statistics()
				self.param_metaid   = "_"
				self.param_id       = "_"
				self.param_value    = 0.0
				self.param_previous = 0.0
			#-----------------------------------------------------------------#
			# 4.4) If the simulation is a absolute target fluxes selection    #
			#      experiment, keep only mutations for which the MOMA         #
			#      distance is lower than a given selection threshold.        #
			#-----------------------------------------------------------------#
			elif self.selection_scheme == "ABSOLUTE_TARGET_FLUXES_SELECTION" and self.model.absolute_moma_distance < self.selection_threshold:
				self.nb_iterations += 1
				self.nb_accepted   += 1
				self.update_statistics()
				self.compute_statistics()
			elif self.selection_scheme == "ABSOLUTE_TARGET_FLUXES_SELECTION" and self.model.absolute_moma_distance >= self.selection_threshold:
				self.nb_iterations += 1
				self.nb_rejected   += 1
				self.reload_previous_state()
				self.update_statistics()
				self.compute_statistics()
				self.param_metaid   = "_"
				self.param_id       = "_"
				self.param_value    = 0.0
				self.param_previous = 0.0
			#-----------------------------------------------------------------#
			# 4.5) If the simulation is a relative target fluxes selection    #
			#      experiment, keep only mutations for which the MOMA         #
			#      distance is lower than a given selection threshold.        #
			#-----------------------------------------------------------------#
			elif self.selection_scheme == "RELATIVE_TARGET_FLUXES_SELECTION" and self.model.relative_moma_distance < self.selection_threshold:
				self.nb_iterations += 1
				self.nb_accepted   += 1
				self.update_statistics()
				self.compute_statistics()
			elif self.selection_scheme == "RELATIVE_TARGET_FLUXES_SELECTION" and self.model.relative_moma_distance >= self.selection_threshold:
				self.nb_iterations += 1
				self.nb_rejected   += 1
				self.reload_previous_state()
				self.update_statistics()
				self.compute_statistics()
				self.param_metaid   = "_"
				self.param_id       = "_"
				self.param_value    = 0.0
				self.param_previous = 0.0
			#-----------------------------------------------------------------#
			# 4.6) If the simulation is a absolute ALL fluxes selection       #
			#      experiment, keep only mutations for which the MOMA         #
			#      distance is lower than a given selection threshold.        #
			#-----------------------------------------------------------------#
			elif self.selection_scheme == "ABSOLUTE_ALL_FLUXES_SELECTION" and self.model.absolute_moma_all_distance < self.selection_threshold:
				self.nb_iterations += 1
				self.nb_accepted   += 1
				self.update_statistics()
				self.compute_statistics()
			elif self.selection_scheme == "ABSOLUTE_ALL_FLUXES_SELECTION" and self.model.absolute_moma_all_distance >= self.selection_threshold:
				self.nb_iterations += 1
				self.nb_rejected   += 1
				self.reload_previous_state()
				self.update_statistics()
				self.compute_statistics()
				self.param_metaid   = "_"
				self.param_id       = "_"
				self.param_value    = 0.0
				self.param_previous = 0.0
			#-----------------------------------------------------------------#
			# 4.7) If the simulation is a relative ALL fluxes selection       #
			#      experiment, keep only mutations for which the MOMA         #
			#      distance is lower than a given selection threshold.        #
			#-----------------------------------------------------------------#
			elif self.selection_scheme == "RELATIVE_ALL_FLUXES_SELECTION" and self.model.relative_moma_all_distance < self.selection_threshold:
				self.nb_iterations += 1
				self.nb_accepted   += 1
				self.update_statistics()
				self.compute_statistics()
			elif self.selection_scheme == "RELATIVE_ALL_FLUXES_SELECTION" and self.model.relative_moma_all_distance >= self.selection_threshold:
				self.nb_iterations += 1
				self.nb_rejected   += 1
				self.reload_previous_state()
				self.update_statistics()
				self.compute_statistics()
				self.param_metaid   = "_"
				self.param_id       = "_"
				self.param_value    = 0.0
				self.param_previous = 0.0
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 5) Check the number of iterations                              #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		print("> Current iteration = "+str(self.nb_iterations)+" (accepted = "+str(self.nb_accepted)+", rejected = "+str(self.nb_rejected)+", unstable = "+str(self.nb_unstable)+")")
		assert self.nb_unstable <= MAX_UNSTABLE_INTERATIONS, "Too many unstable trials. Exit."
		if self.nb_iterations == self.total_iterations:
			return True
		return False

#********************************************************************
# SensitivityAnalysis class
# -------------------------
# This class runs two types of sensitivity analysis:
# - "One-at-a-time analysis" (OAT): the program explores a range of
#   values independently for each kinetic parameter and tracks the
#   change for all fluxes and species.
# - "Random analysis": the program explores the parameters space by
#   performing many independent random draws where a single kinetic
#   parameter mutate at random.
#********************************************************************
class SensitivityAnalysis:
	"""
	The SensitivityAnalysis class runs a sensitivity analysis by exploring a
	range of values for each kinetic parameter and tracking the change for all
	fluxes and species.
	
	Attributes
	----------
	> sbml_filename : str
		Path of the SBML model file. The SBML model is automatically loaded.
	> copasi_path : str
		Location of Copasi executable.
	> model : Model
		SBML model (automatically loaded).
	> factor_range : float > 0.0
		Half-range of the log10-scaling factor (total range=2*factor_range)
	> factor_step : float > 0.0
		Exploration step of the log10-scaling factor.
		x' = x*10^(factor)
	> param_index : int
		Current parameter index.
	> param_metaid : str
		Current parameter meta identifier.
	> param_id : str
		Current parameter identifier.
	> param_wild_type : float
		Current parameter wild-type value.
	> param_val : float
		Current parameter mutant value.
	> sigma : float > 0.0
		Kinetic parameters mutation size.
	> nb_iterations : int > 0
		Number of iterations of the multivariate random analysis.
	> iteration : int > 0
		Current iteration of the multivariate random analysis.
	> OAT_output_file : file
		Output file for the One-at-a-time analysis.
	> random_output_file : file
		Output file for the multivariate random analysis.	
	
	Methods
	-------
	> __init__(sbml_filename, copasi_path)
		SensitivityAnalysis class constructor.
	> initialize_OAT_output_file()
		Initialize the One-At-a-Time sensitivity analysis output file (write the header).
	> initialize_random_output_file()
		Initialize the random sensitivity analysis output file (write the header).
	> write_OAT_output_file()
		Write the current One-At-a-Time sensitivity analysis state in the output file.
	> write_random_output_file()
		Write the current random sensitivity analysis state in the output file.
	> initialize_OAT_analysis(factor_range, factor_step)
		Initialize the One-At-a-Time sensitivity analysis algorithm.
	> initialize_random_analysis(sigma, nb_iterations)
		Initialize the random sensitivity analysis algorithm.
	> reload_wild_type_state()
		Reload the wild-type state into the mutant model.
	> next_parameter()
		Run a full parameter exploration for the next kinetic parameter.
	> next_iteration()
		Run the random parametric exploration for the next iteration.
	> run_OAT_analysis(factor_range, factor_step)
		Run the complete One-At-a-Time sensitivity analysis.
	> run_random_analysis(sigma, nb_iterations)
		Run the complete random sensitivity analysis.
	"""
	
	### Constructor ###
	def __init__( self, sbml_filename, copasi_path ):
		"""
		SensitivityAnalysis class constructor.
		
		Parameters
		----------
		sbml_filename : str
			Path of the SBML model file. The SBML model is automatically loaded.
		copasi_path : str
			Location of Copasi executable.
		
		Returns
		-------
		None
		"""
		assert os.path.isfile(sbml_filename), "The SBML file \""+sbml_filename+"\" does not exist. Exit."
		assert os.path.isfile(copasi_path), "The executable \""+copasi_path+"\" does not exist. Exit."
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Main sensitivity analysis parameters #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.sbml_filename = sbml_filename
		self.copasi_path   = copasi_path
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) SBML model                           #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.model = Model(sbml_filename, [], copasi_path)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) One-at-a-time analysis               #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.factor_range    = 0.0
		self.factor_step     = 0.0
		self.param_index     = 0
		self.param_metaid    = "wild_type"
		self.param_id        = "wild_type"
		self.param_wild_type = 0.0
		self.param_val       = 0.0
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Multivariate random analysis         #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.sigma         = 0.0
		self.nb_iterations = 0.0
		self.iteration     = 0
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 5) Output files                         #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.OAT_output_file = open("output/OAT_sensitivity_analysis.txt", "w")
		self.OAT_output_file.close()
		self.random_output_file = open("output/random_sensitivity_analysis.txt", "w")
		self.random_output_file.close()
		
	### Initialize the OAT output file ###
	def initialize_OAT_output_file( self ):
		"""
		Initialize the OAT output file (write the header).
	
		Parameters
		----------
		None
	
		Returns
		-------
		None
		"""
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Write the header                 #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		header = "param_metaid param_id param_wild_type param_val param_dln"
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				header += " "+species_id
		for reaction_id in self.model.reactions:
			header += " "+reaction_id
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Write the wild-type steady-state #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		first_line = "wild_type wild_type 0.0 0.0 0.0"
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				first_line += " "+str(self.model.species[species_id]["wild_type_value"])
		for reaction_id in self.model.reactions:
			first_line += " "+str(self.model.reactions[reaction_id]["wild_type_value"])
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Save in output file              #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.OAT_output_file = open("output/OAT_sensitivity_analysis.txt", "a")
		self.OAT_output_file.write(header+"\n"+first_line+"\n")
		self.OAT_output_file.close()
	
	### Initialize the multivariate random output file ###
	def initialize_random_output_file( self ):
		"""
		Initialize the multivariate random output file (write the header).
	
		Parameters
		----------
		None
	
		Returns
		-------
		None
		"""
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Write the header                 #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		header = "iteration"
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				header += " "+species_id
		for reaction_id in self.model.reactions:
			header += " "+reaction_id
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Write the wild-type steady-state #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		first_line = "wild_type"
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				first_line += " "+str(self.model.species[species_id]["wild_type_value"])
		for reaction_id in self.model.reactions:
			first_line += " "+str(self.model.reactions[reaction_id]["wild_type_value"])
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Save in output file              #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.output_file = open("output/random_sensitivity_analysis.txt", "a")
		self.output_file.write(header+"\n"+first_line+"\n")
		self.output_file.close()
	
	### Write the sensitivity analysis state in the OAT output file ###
	def write_OAT_output_file( self ):
		"""
		Write the current OAT sensitivity analysis state in the output file.
	
		Parameters
		----------
		None
	
		Returns
		-------
		None
		"""
		line = ""
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Write current OAT state #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		line += str(self.param_metaid)+" "
		line += str(self.param_id)+" "
		line += str(self.param_wild_type)+" "
		line += str(self.param_val)+" "
		line += str((self.param_val-self.param_wild_type)/self.param_wild_type)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Write steady-state      #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				wild_type_val = self.model.species[species_id]["wild_type_value"]
				mutant_val    = self.model.species[species_id]["mutant_value"]
				dln_val = "NA"
				if wild_type_val != 0.0:
					dln_val = (mutant_val-wild_type_val)/wild_type_val
				line   += " "+str(dln_val)
		for reaction_id in self.model.reactions:
			wild_type_val = self.model.reactions[reaction_id]["wild_type_value"]
			mutant_val    = self.model.reactions[reaction_id]["mutant_value"]
			dln_val = "NA"
			if wild_type_val != 0.0:
				dln_val = (mutant_val-wild_type_val)/wild_type_val
			line   += " "+str(dln_val)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Write in file           #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.OAT_output_file = open("output/OAT_sensitivity_analysis.txt", "a")
		self.OAT_output_file.write(line+"\n")
		self.OAT_output_file.close()
	
	### Write the sensitivity analysis state in the random output file ###
	def write_random_output_file( self ):
		"""
		Write the current multivariate random sensitivity analysis state in the output file.
	
		Parameters
		----------
		None
	
		Returns
		-------
		None
		"""
		line = ""
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Write current multivariate random state #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		line += str(self.iteration)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Write steady-state                      #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				wild_type_val = self.model.species[species_id]["wild_type_value"]
				mutant_val    = self.model.species[species_id]["mutant_value"]
				dln_val = "NA"
				if wild_type_val != 0.0:
					dln_val = (mutant_val-wild_type_val)/wild_type_val
				line   += " "+str(dln_val)
		for reaction_id in self.model.reactions:
			wild_type_val = self.model.reactions[reaction_id]["wild_type_value"]
			mutant_val    = self.model.reactions[reaction_id]["mutant_value"]
			dln_val = "NA"
			if wild_type_val != 0.0:
				dln_val = (mutant_val-wild_type_val)/wild_type_val
			line   += " "+str(dln_val)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Write in file                           #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.random_output_file = open("output/random_sensitivity_analysis.txt", "a")
		self.random_output_file.write(line+"\n")
		self.random_output_file.close()
	
	### Initialize OAT sensitivity analysis algorithm ###
	def initialize_OAT_analysis( self, factor_range, factor_step ):
		"""
		Initialize the OAT sensitivity analysis algorithm.
	
		Parameters
		----------
		factor_range : float > 0.0
			Half-range of the log10-scaling factor (total range=2*factor_range)
		factor_step : float > 0.0
			Exploration step of the log10-scaling factor.
			x' = x*10^(factor)
	
		Returns
		-------
		None
		"""
		assert factor_range > 0.0, "The factor range 'factor_range' must be a positive nonzero value. Exit."
		assert factor_step > 0.0, "The factor step 'factor_step' must be a positive nonzero value. Exit."
		self.factor_range = factor_range
		self.factor_step  = factor_step
		self.model.compute_wild_type_steady_state()
		self.model.compute_mutant_steady_state()
		self.initialize_OAT_output_file()
		self.param_index = 0
	
	### Initialize multivariate random sensitivity analysis algorithm ###
	def initialize_random_analysis( self, sigma, nb_iterations ):
		"""
		Initialize the multivariate random sensitivity analysis algorithm.
	
		Parameters
		----------
		sigma : float > 0.0
			Kinetic parameters mutation size.
		nb_iterations : int > 0
			Number of iterations of the multivariate random analysis.
		Returns
		-------
		None
		"""
		assert sigma > 0.0, "The mutation size sigma must be positive. Exit."
		assert nb_iterations > 0, "The number of iterations must be positive. Exit."
		self.sigma         = sigma
		self.nb_iterations = nb_iterations
		self.model.compute_wild_type_steady_state()
		self.model.compute_mutant_steady_state()
		self.initialize_random_output_file()
		self.iterations = 0
	
	### Reload the wild-type state into the mutant model ###
	def reload_wild_type_state( self ):
		"""
		Reload the wild-type state into the mutant model.
	
		Parameters
		----------
		None
	
		Returns
		-------
		None
		"""
		for species_id in self.model.species:
			self.model.species[species_id]["initial_value"] = self.model.species[species_id]["wild_type_value"]
			self.model.species[species_id]["mutant_value"]  = self.model.species[species_id]["wild_type_value"]
			#if not self.model.species[species_id]["constant"]:
			#	self.model.set_species_initial_value(species_id, self.model.species[species_id]["mutant_value"])
		for parameter_metaid in self.model.parameters:
			self.model.set_mutant_parameter_value(parameter_metaid, self.model.get_wild_type_parameter_value(parameter_metaid))
		for reaction_id in self.model.reactions:
			self.model.reactions[reaction_id]["mutant_value"] = self.model.reactions[reaction_id]["wild_type_value"]
	
	### Explore the next parameter (OAT analysis) ###
	def next_parameter( self ):
		"""
		Run a full parameter exploration for the next kinetic parameter.
		
		Parameters
		----------
		None
		
		Returns
		-------
		bool
			Returns True if the last parameter has been explored. Returns False
			else.
		"""
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Get the next parameter        #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.param_metaid    = list(self.model.parameters)[self.param_index]
		self.param_id        = self.model.parameters[self.param_metaid]["id"]
		self.param_wild_type = self.model.parameters[self.param_metaid]["wild_type_value"]
		self.param_val       = 0.0
		print("> Current parameter: "+str(self.param_id))
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Explore the upper range       #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		factor = 0.0
		while factor <= self.factor_range+self.factor_step/2.0: # +step/2 for precision errors
			self.param_val = self.param_wild_type*10**factor
			self.model.set_mutant_parameter_value(self.param_metaid, self.param_val)
			self.model.compute_mutant_steady_state()
			self.write_OAT_output_file()
			factor += self.factor_step
		self.reload_wild_type_state()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Explore the lower range       #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		factor = -self.factor_step
		while factor >= -self.factor_range-self.factor_step/2.0: # -step/2 for precision errors
			self.param_val = self.param_wild_type*10**factor
			self.model.set_mutant_parameter_value(self.param_metaid, self.param_val)
			self.model.compute_mutant_steady_state()
			self.write_OAT_output_file()
			factor -= self.factor_step
		self.reload_wild_type_state()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Increment the parameter index #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.param_index += 1
		if self.param_index == len(self.model.parameters):
			return True
		return False
	
	### Run the next iteration (multivariate random analysis) ###
	def next_iteration( self ):
		"""
		Run the next multivariate random iteration
		
		Parameters
		----------
		None
		
		Returns
		-------
		bool
			Returns True if the last iteration has been done. Returns False
			else.
		"""
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Mutate each parameter at random with mutation size "sigma" #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		print("> Current iteration: "+str(self.iteration+1)+"/"+str(self.nb_iterations))
		param_metaid = self.model.get_random_parameter()
		self.model.random_parameter_mutation(param_metaid, self.sigma)
		self.model.compute_mutant_steady_state()
		self.write_random_output_file()
		self.reload_wild_type_state()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Increment the current iteration                            #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.iteration += 1
		if self.iteration == self.nb_iterations:
			return True
		return False
	
	### Run the OAT sensitivity analysis ###
	def run_OAT_analysis( self, factor_range, factor_step ):
		"""
		Run the OAT sensitivity analysis algorithm.
	
		Parameters
		----------
		factor_range : float > 0.0
			Half-range of the log10-scaling factor (total range=2*factor_range)
		factor_step : float > 0.0
			Exploration step of the log10-scaling factor.
			x' = x*10^(factor)
	
		Returns
		-------
		None
		"""
		assert factor_range > 0.0, "The factor range 'factor_range' must be a positive nonzero value. Exit."
		assert factor_step > 0.0, "The factor step 'factor_step' must be a positive nonzero value. Exit."
		self.initialize_OAT_analysis(factor_range, factor_step)
		stop_sa    = False
		start_time = time.time()
		while not stop_sa:
			stop_sa        = self.next_parameter()
			ongoing_time   = time.time()
			estimated_time = (ongoing_time-start_time)*float(self.model.get_number_of_parameters()-self.param_index-1)/float(self.param_index+1)
			print("   Estimated remaining time "+str(int(round(estimated_time/60)))+" min.")
	
	### Run the multivariate random sensitivity analysis ###
	def run_random_analysis( self, sigma, nb_iterations ):
		"""
		Run the multivariate random sensitivity analysis algorithm.
	
		Parameters
		----------
		sigma : float > 0.0
			Kinetic parameters mutation size.
		nb_iterations : int > 0
			Number of iterations of the multivariate random analysis.
	
		Returns
		-------
		None
		"""
		assert sigma > 0.0, "The mutation size sigma must be positive. Exit."
		assert nb_iterations > 0, "The number of iterations must be positive. Exit."
		self.initialize_random_analysis(sigma, nb_iterations)
		stop_sa    = False
		start_time = time.time()
		while not stop_sa:
			stop_sa        = self.next_iteration()
			ongoing_time   = time.time()
			estimated_time = (ongoing_time-start_time)*float(self.nb_iterations-self.iteration)/float(self.iteration+1)
			print("   Estimated remaining time "+str((round(estimated_time/60,2)))+" min.")
