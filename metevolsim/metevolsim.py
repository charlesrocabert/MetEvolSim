#!/usr/bin/env python3
# coding: utf-8

#***************************************************************************
# MetEvolSim (Metabolome Evolution Simulator)
# -------------------------------------------
# MetEvolSim is a numerical framework dedicated to the study of metabolic
# abundances evolution.
#
# Copyright (c) 2018-2019 Charles Rocabert, Gábor Boross, Balázs Papp
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
import subprocess
import libsbml
import numpy as np

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
	Manipulations include kinetic parameter mutations and steady-state computing
	with Copasi software.
	Some constraints exist on the SBML model format:
	- Species identifiers and names must be unique. All names must be specied,
	  or none of them (in this case, identifiers will be used as names).
	- Reaction identifiers and names must be unique,
	- Kinetic parameters must be specified (globally, and/or for each reaction).
	  All kinetic parameters will be mutable.
	- If a species is a boundary condition, it is considered constant and its
	  statistics will not be tracked.
	- The Model class rebuilds the list of metaids, even if metaids are not
	  defined in the original model.
	
	Attributes
	----------
	> sbml_filename : str
		Name of the SBML model file.
	> reader : libsbml.SBMLReader
		SBML model reader.
	> WT_document : libsbml.SBMLDocument
		SBML document of the wild-type model.
	> mutant_document : libsbml.SBMLDocument
		SBML document of the mutant model.
	> WT_model : libsbml.Model
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
	> WT_SUM : float
		Sum of evolvable metabolic abundances in wild-type.
	> mutant_SUM : float
		Sum of evolvable metabolic abundances in mutant.
	> SUM_distance : float
		Absolute distance between wild-type and mutant metabolic sums.
	> objective_function : list of [str, float]
		Objective function (list of reaction identifiers and coefficients).
	> MOMA_distance : float
		Distance between the wild-type and the mutant, based on the
		Minimization Of Metabolic Adjustment (MOMA).
	
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
	> get_WT_species_value(species_id)
		Get WT species value.
	> get_mutant_species_value(species_id)
		Get mutant species value.
	> get_WT_parameter_value(param_metaid)
		Get WT parameter value.
	> get_mutant_parameter_value(param_metaid)
		Get mutant parameter value.
	> set_species_initial_value(species_id, value)
		Set a species initial value.
	> set_WT_parameter_value(param_metaid, value)
		Set WT parameter value.
	> set_mutant_parameter_value(param_metaid, value)
		Set mutant parameter value.
	> get_random_parameter()
		Get a random parameter.
	> deterministic_parameter_mutation(param_metaid, factor)
		Make a deterministic parameter mutation by a given log-scale factor,
		centered on the WT value.
	> random_parameter_mutation(param_metaid, sigma)
		Make a random parameter mutation by a given log-scale mutation size
		sigma, centered on the previous mutant value.
	> write_WT_SBML_file()
		Write WT SBML file.
	> write_mutant_SBML_file()
		Write mutant SBML file.
	> create_WT_cps_file()
		Create ancestor CPS file.
	> create_mutant_cps_file()
		Create mutant CPS file.
	> edit_WT_cps_file()
		Edit ancestor CPS file to schedule steady-state calculation.
	> edit_mutant_cps_file()
		Edit mutant CPS file to schedule steady-state calculation.
	> run_copasi_for_WT()
		Run Copasi for the WT model.
	> run_copasi_for_mutant()
		Run Copasi for the mutant model.
	> parse_copasi_output(filename)
		Parse Copasi output file.
	> compute_WT_steady_state()
		Compute WT steady-state.
	> compute_mutant_steady_state()
		Compute mutant steady-state.	
	> update_initial_concentrations()
		Update species initial concentrations.
	> compute_SUM_distance()
		Compute the metabolic sum distance between the WT and the mutant.
	> compute_MOMA_distance()
		Compute the MOMA distance between the WT and the mutant, based on target
		fluxes (MOMA: Minimization Of Metabolic Adjustment).
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
		self.sbml_filename   = sbml_filename
		self.reader          = libsbml.SBMLReader()
		self.WT_document     = self.reader.readSBMLFromFile(self.sbml_filename)
		self.mutant_document = self.reader.readSBMLFromFile(self.sbml_filename)
		self.WT_model        = self.WT_document.getModel()
		self.mutant_model    = self.mutant_document.getModel()
		self.copasi_path     = copasi_path
		
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
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Model evaluation                                         #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.WT_SUM             = 0.0
		self.mutant_SUM         = 0.0
		self.SUM_distance       = 0.0
		self.objective_function = objective_function
		self.MOMA_distance      = 0.0
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
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Rebuild WT metaids     #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		metaid = 0
		for species in self.WT_model.getListOfSpecies():
			species.setMetaId("_"+str(metaid))
			metaid += 1
		for parameter in self.WT_model.getListOfParameters():
			parameter.setMetaId("_"+str(metaid))
			metaid += 1
		for reaction in self.WT_model.getListOfReactions():
			for elmt in reaction.getListOfAllElements():
				if elmt.getElementName() == "parameter" or elmt.getElementName() == "localParameter":
					parameter        = elmt
					parameter.setMetaId("_"+str(metaid))
					metaid += 1
		for reaction in self.WT_model.getListOfReactions():
			reaction.setMetaId("_"+str(metaid))
			metaid += 1
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Rebuild mutant metaids #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
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
		for species in self.WT_model.getListOfSpecies():
			species_metaid = species.getMetaId()
			species_id     = species.getId()
			species_name   = species.getName()
			isConstant     = species.getBoundaryCondition()
			if species_name == "":
				species_name = species_id
			assert species_id not in list(self.species)
			self.species[species_id]                  = {"metaid":"", "id":"", "name":"", "constant":False, "initial_value":0.0, "WT_value":0.0, "mutant_value":0.0}
			self.species[species_id]["metaid"]        = species_metaid
			self.species[species_id]["id"]            = species_id
			self.species[species_id]["name"]          = species_name
			self.species[species_id]["constant"]      = isConstant
			self.species[species_id]["initial_value"] = species.getInitialConcentration()
			self.species[species_id]["WT_value"]      = species.getInitialConcentration()
			self.species[species_id]["mutant_value"]  = species.getInitialConcentration()
			assert species_name not in self.species_name_to_id
			self.species_name_to_id[species_name] = species_id
	
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
		for parameter in self.WT_model.getListOfParameters():
			parameter_metaid = parameter.getMetaId()
			parameter_id     = parameter.getId()
			self.parameters[parameter_metaid]                 = {"metaid":"", "id":"", "WT_value":0.0, "mutant_value":0.0}
			self.parameters[parameter_metaid]["metaid"]       = parameter_metaid
			self.parameters[parameter_metaid]["id"]           = parameter_id
			self.parameters[parameter_metaid]["WT_value"]     = parameter.getValue()
			self.parameters[parameter_metaid]["mutant_value"] = parameter.getValue()
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Parse parameters for each reaction #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		for reaction in self.WT_model.getListOfReactions():
			for elmt in reaction.getListOfAllElements():
				if elmt.getElementName() == "parameter" or elmt.getElementName() == "localParameter":
					parameter        = elmt
					parameter_metaid = parameter.getMetaId()
					parameter_id     = parameter.getId()
					self.parameters[parameter_metaid]                 = {"metaid":"", "id":"", "WT_value":0.0, "mutant_value":0.0}
					self.parameters[parameter_metaid]["metaid"]       = parameter_metaid
					self.parameters[parameter_metaid]["id"]           = parameter_id
					self.parameters[parameter_metaid]["WT_value"]     = parameter.getValue()
					self.parameters[parameter_metaid]["mutant_value"] = parameter.getValue()
	
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
		for reaction in self.WT_model.getListOfReactions():
			reaction_metaid = reaction.getMetaId()
			reaction_id     = reaction.getId()
			reaction_name   = reaction.getName()
			if reaction_name == "":
				reaction_name = reaction_id
			assert reaction_id not in list(self.reactions)
			self.reactions[reaction_id]           = {"metaid":"", "id":"", "name":"", "WT_value":0.0, "mutant_value":0.0}
			self.reactions[reaction_id]["metaid"] = reaction_metaid
			self.reactions[reaction_id]["id"]     = reaction_id
			assert reaction_name not in self.reaction_name_to_id
			self.reaction_name_to_id[reaction_name] = reaction_id
	
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
	def get_WT_species_value( self, species_id ):
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
		return self.species[species_id]["WT_value"]
	
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
	def get_WT_parameter_value( self, param_metaid ):
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
		assert self.parameters[param_metaid]["WT_value"] == self.WT_model.getElementByMetaId(param_metaid).getValue()
		return self.parameters[param_metaid]["WT_value"]
	
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
	def get_WT_species_array( self ):
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
				vec.append(self.species[species_id]["WT_value"])
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
	def get_WT_reaction_array( self ):
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
			vec.append(self.reactions[reaction_id]["WT_value"])
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
		self.species[species_id]["WT_value"] = value
		self.mutant_model.getListOfSpecies().get(species_id).setInitialConcentration(value)
	
	### Set wild-type parameter value ###
	def set_WT_parameter_value( self, param_metaid, value ):
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
		self.parameters[param_metaid]["WT_value"] = value
		self.WT_model.getElementByMetaId(param_metaid).setValue(value)
	
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
		wt_value     = self.get_WT_parameter_value(param_metaid)
		mutant_value = wt_value*10.0**factor
		self.set_mutant_parameter_value(param_metaid, mutant_value)
		return wt_value, mutant_value

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
		factor       = np.random.normal(0.0, sigma, 1)
		wt_value     = self.get_mutant_parameter_value(param_metaid)
		mutant_value = wt_value*10**factor[0]
		self.set_mutant_parameter_value(param_metaid, mutant_value)
		return wt_value, mutant_value
		
	### Write wild-type SBML file ###
	def write_WT_SBML_file( self ):
		"""
		Write the wild-type model in a SBML file.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		libsbml.writeSBMLToFile(self.WT_document, "output/WT.xml")

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
	def create_WT_cps_file( self ):
		"""
		Create a CPS file from the wild-type SBML file.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		cmd_line = self.copasi_path+" -i ./output/WT.xml"
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
	def edit_WT_cps_file( self ):
		"""
		Edit wild-type CPS file to schedule steady-state calculation.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		f = open("./output/WT.cps", "r")
		cps = f.read()
		f.close()
		upper_text  = cps.split("<ListOfTasks>")[0]
		lower_text  = cps.split("</ListOfTasks>")[1]
		edited_file = ""
		edited_file += upper_text
		edited_file += '  <ListOfTasks>\n'
		edited_file += '    <Task key="Task_14" name="Steady-State" type="steadyState" scheduled="true" updateModel="false">\n'
		edited_file += '      <Report reference="Report_9" target="WT_output.txt" append="1" confirmOverwrite="1"/>\n'
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
		edited_file += lower_text
		f = open("./output/WT.cps", "w")
		f.write(edited_file)
		f.close()

	### Edit mutant CPS file to schedule steady-state calculation ###
	def edit_mutant_cps_file( self ):
		"""
		Edit mutant CPS file to schedule steady-state calculation.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		f = open("./output/mutant.cps", "r")
		cps = f.read()
		f.close()
		upper_text  = cps.split("<ListOfTasks>")[0]
		lower_text  = cps.split("</ListOfTasks>")[1]
		edited_file = ""
		edited_file += upper_text
		edited_file += '  <ListOfTasks>\n'
		edited_file += '    <Task key="Task_14" name="Steady-State" type="steadyState" scheduled="true" updateModel="false">\n'
		edited_file += '      <Report reference="Report_9" target="mutant_output.txt" append="1" confirmOverwrite="1"/>\n'
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
		edited_file += lower_text
		f = open("./output/mutant.cps", "w")
		f.write(edited_file)
		f.close()

	### Run Copasi for the wild-type model ###
	def run_copasi_for_WT( self ):
		"""
		Run Copasi to compute the wild-type steady-state and update model state.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		if os.path.isfile("./output/WT_output.txt"):
			os.system("rm ./output/WT_output.txt")
		cmd_line = self.copasi_path+" ./output/WT.cps"
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
	def parse_copasi_output( self, filename ):
		"""
		Parse the Copasi output 'filename'.
		
		Parameters
		----------
		filename: str
			Name of the Copasi output (txt file).
		
		Returns
		-------
		list of [str, float] lists, list of [str, float] lists
		"""
		assert os.path.isfile(filename), "The Copasi output \""+filename+"\" does not exist. Exit."
		concentrations       = []
		fluxes               = []
		parse_concentrations = False
		parse_fluxes         = False
		f = open(filename, "r")
		l = f.readline()
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
		return concentrations, fluxes
	
	### Compute wild-type steady-state ###
	def compute_WT_steady_state( self ):
		"""
		Compute and save the wild-type steady-state.
		
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
		self.write_WT_SBML_file()
		self.create_WT_cps_file()
		self.edit_WT_cps_file()
		self.run_copasi_for_WT()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Extract steady-state                 #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		concentrations, fluxes = self.parse_copasi_output("./output/WT_output.txt")
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Update model and lists               #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.WT_SUM = 0.0
		for elmt in concentrations:
			species_name  = elmt[0]
			species_value = float(elmt[1])
			species_id    = self.species_name_to_id[species_name]
			assert species_id in self.species
			if not self.species[species_id]["constant"]:
				self.species[species_id]["WT_value"]      = species_value
				self.species[species_id]["mutant_value"]  = species_value
				self.WT_SUM                              += species_value
		for elmt in fluxes:
			reaction_name  = elmt[0]
			reaction_value = float(elmt[1])
			reaction_id    = self.reaction_name_to_id[reaction_name]
			assert reaction_id in self.reactions
			self.reactions[reaction_id]["WT_value"]     = reaction_value
			self.reactions[reaction_id]["mutant_value"] = reaction_value
		
	### Compute mutant steady-state ###
	def compute_mutant_steady_state( self ):
		"""
		Compute and save the mutant steady-state.
		
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
		self.edit_mutant_cps_file()
		self.run_copasi_for_mutant()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Extract steady-state                 #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		concentrations, fluxes = self.parse_copasi_output("./output/mutant_output.txt")
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Update model and lists               #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.mutant_SUM = 0.0
		for elmt in concentrations:
			species_name  = elmt[0]
			species_value = float(elmt[1])
			species_id    = self.species_name_to_id[species_name]
			assert species_id in self.species
			if not self.species[species_id]["constant"]:
				self.species[species_id]["mutant_value"]  = species_value
				self.mutant_SUM                          += species_value
		for elmt in fluxes:
			reaction_name  = elmt[0]
			reaction_value = float(elmt[1])
			reaction_id    = self.reaction_name_to_id[reaction_name]
			assert reaction_id in self.reactions
			self.reactions[reaction_id]["mutant_value"] = reaction_value
	
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
	def compute_SUM_distance( self ):
		"""
		Compute the metabolic sum distance between the WT and the mutant.
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		self.SUM_distance = abs(self.WT_SUM-self.mutant_SUM)
	
	### Compute the MOMA distance between the wild-type and the mutant ###
	def compute_MOMA_distance( self ):
		"""
		Compute the MOMA distance between the WT and the mutant, based on
		target fluxes.
		(MOMA: Minimization Of Metabolic Adjustment)
		
		Parameters
		----------
		None
		
		Returns
		-------
		None
		"""
		self.MOMA_distance = 0.0
		for target_flux in self.objective_function:
			reaction_id  = target_flux[0]
			coefficient  = target_flux[1]
			wt_value     = self.reactions[reaction_id]["WT_value"]
			mutant_value = self.reactions[reaction_id]["mutant_value"]
			self.MOMA_distance += (wt_value-mutant_value)*(wt_value-mutant_value)
		self.MOMA_distance = np.sqrt(self.MOMA_distance)
		
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
		Selection scheme ('MUTATION_ACCUMULATION'/'METABOLIC_SUM_SELECTION'/'TARGET_FLUXES_SELECTION').
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
	> WT_abund : numpy array
		Wild-type abundances tracker.
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
	> mean_abund : numpy array
		Mean abundances tracker.
	> var_abund : numpy array
		Variance of abundances tracker.
	> CV_abund : numpy array
		Coefficient of variation of abundances tracker.
	> ER_abund : numpy array
		Evolution rate of abundances tracker.
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
			Selection scheme ('MUTATION_ACCUMULATION'/'METABOLIC_SUM_SELECTION'/'TARGET_FLUXES_SELECTION').
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
		assert selection_scheme in ["MUTATION_ACCUMULATION", "METABOLIC_SUM_SELECTION", "TARGET_FLUXES_SELECTION"], "The selection scheme takes two values only (MUTATION_ACCUMULATION/METABOLIC_SUM_SELECTION/TARGET_FLUXES_SELECTION). Exit."
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
		self.param_metaid   = "_"
		self.param_id       = "WT"
		self.param_value    = 0.0
		self.param_previous = 0.0
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Statistics             #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		### Array lengths ###
		self.N_abund = self.model.get_number_of_variable_species()
		self.N_flux  = self.model.get_number_of_reactions()
		
		### Arrays ###
		self.WT_abund     = np.zeros(self.N_abund)
		self.mutant_abund = np.zeros(self.N_abund)
		self.mutant_flux  = np.zeros(self.N_flux)
		
		### Sum vectors ###
		self.sum_abund      = np.zeros(self.N_abund)
		self.relsum_abund   = np.zeros(self.N_abund)
		self.sqsum_abund    = np.zeros(self.N_abund)
		self.relsqsum_abund = np.zeros(self.N_abund)
		
		### Final statistics ###
		self.mean_abund = np.zeros(self.N_abund)
		self.var_abund  = np.zeros(self.N_abund)
		self.CV_abund   = np.zeros(self.N_abund)
		self.ER_abund   = np.zeros(self.N_abund)
		
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
		header += " wt_sum mutant_sum sum_dist moma_dist\n"
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
		# 3) Write MOMA distance      #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		line += " "+str(self.model.WT_SUM)+" "+str(self.model.mutant_SUM)+" "+str(self.model.SUM_distance)+" "+str(self.model.MOMA_distance)
		
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
		self.sum_abund      += self.mutant_abund
		self.sqsum_abund    += self.mutant_abund*self.mutant_abund
		self.relsum_abund   += (self.mutant_abund/self.WT_abund)
		self.relsqsum_abund += (self.mutant_abund/self.WT_abund)*(self.mutant_abund/self.WT_abund)
		
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
		### Compute mean ###
		self.mean_abund  = np.copy(self.sum_abund)
		self.mean_abund /= float(self.nb_iterations)
		### Compute variance ###
		self.var_abund  = np.copy(self.sqsum_abund)
		self.var_abund /= float(self.nb_iterations)
		self.var_abund -= self.mean_abund*self.mean_abund
		### Compute coefficient of variation ###
		self.CV_abund  = np.copy(self.sqsum_abund)
		self.CV_abund /= float(self.nb_iterations)
		self.CV_abund -= self.mean_abund*self.mean_abund
		self.CV_abund  = np.sqrt(self.CV_abund)/self.mean_abund
		### Compute evolution rate ###
		self.ER_abund  = np.copy(self.relsqsum_abund)
		self.ER_abund /= float(self.nb_iterations)
		self.ER_abund -= (self.relsum_abund/float(self.nb_iterations))*(self.relsum_abund/float(self.nb_iterations))
		self.ER_abund /= float(self.nb_iterations)

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
		f.write("species_id WT mean var CV ER\n")
		index = 0
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				line   = species_id+" "
				line  += str(self.WT_abund[index])+" "
				line  += str(self.mean_abund[index])+" "
				line  += str(self.var_abund[index])+" "
				line  += str(self.CV_abund[index])+" "
				line  += str(self.ER_abund[index])+"\n"
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
		self.model.compute_WT_steady_state()
		self.model.compute_mutant_steady_state()
		self.model.compute_SUM_distance()
		self.model.compute_MOMA_distance()
		self.initialize_output_file()
		self.WT_abund     = self.model.get_WT_species_array()
		self.mutant_abund = self.model.get_mutant_species_array()
		self.mutant_flux  = self.model.get_mutant_reaction_array()
		
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
		# 2) Copy back previous values     #
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
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Save previous state             #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.previous_abund = np.copy(self.mutant_abund)
		self.previous_flux  = np.copy(self.mutant_flux)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Introduce a new random mutation #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.param_metaid                     = self.model.get_random_parameter()
		self.param_id                         = self.model.parameters[self.param_metaid]["id"]
		self.param_previous, self.param_value = self.model.random_parameter_mutation(self.param_metaid, self.sigma)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Compute the new steady-state    #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.model.compute_mutant_steady_state()
		self.model.compute_SUM_distance()
		self.model.compute_MOMA_distance()
		self.mutant_abund = self.model.get_mutant_species_array()
		self.mutant_flux  = self.model.get_mutant_reaction_array()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Select the new iteration event  #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		
		#-----------------------------------------------------------------#
		# 4.1) If the simulation is a mutation accumulation experiment,   #
		#      keep all the mutational events.                            #
		#-----------------------------------------------------------------#
		if self.selection_scheme == "MUTATION_ACCUMULATION":
			self.nb_iterations += 1
			self.nb_accepted   += 1
			self.update_statistics()
			self.compute_statistics()
			#self.model.update_initial_concentrations()
		#-----------------------------------------------------------------#
		# 4.2) If the simulation is a metabolic sum selection experiment, #
		#      keep only mutations for which the SUM distance is lower    #
		#      than a given selection threshold.                          #
		#-----------------------------------------------------------------#
		elif self.selection_scheme == "METABOLIC_SUM_SELECTION" and self.model.SUM_distance < self.selection_threshold:
			print(self.model.SUM_distance, "(", self.model.WT_SUM, ",", self.model.mutant_SUM, ")")
			self.nb_iterations += 1
			self.nb_accepted   += 1
			self.update_statistics()
			self.compute_statistics()
			#self.model.update_initial_concentrations()
		elif self.selection_scheme == "METABOLIC_SUM_SELECTION" and self.model.SUM_distance >= self.selection_threshold:
			print(self.model.SUM_distance, "(", self.model.WT_SUM, ",", self.model.mutant_SUM, ")")
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
		# 4.3) If the simulation is a target fluxes selection experiment, #
		#      keep only mutations for which the MOMA distance is lower   #
		#      than a given selection threshold.                          #
		#-----------------------------------------------------------------#
		elif self.selection_scheme == "TARGET_FLUXES_SELECTION" and self.model.MOMA_distance < self.selection_threshold:
			self.nb_iterations += 1
			self.nb_accepted   += 1
			self.update_statistics()
			self.compute_statistics()
			#self.model.update_initial_concentrations()
		elif self.selection_scheme == "TARGET_FLUXES_SELECTION" and self.model.MOMA_distance >= self.selection_threshold:
			self.nb_iterations += 1
			self.nb_rejected   += 1
			self.reload_previous_state()
			self.update_statistics()
			self.compute_statistics()
			self.param_metaid   = "_"
			self.param_id       = "_"
			self.param_value    = 0.0
			self.param_previous = 0.0
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 5) Check the number of iterations  #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		print("> Current iteration = "+str(self.nb_iterations)+" (accepted = "+str(self.nb_accepted)+", rejected = "+str(self.nb_rejected)+")")
		if self.nb_iterations == self.total_iterations:
			return True
		return False

#********************************************************************
# SensitivityAnalysis class
# -------------------------
# This class runs a sensitivity analysis by exploring a range of
# values for each kinetic parameter and tracking the change for all
# fluxes and species.
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
	> factor_range : float > 0.0
		Half-range of the log10-scaling factor (total range=2*factor_range)
	> factor_step : float > 0.0
		Exploration step of the log10-scaling factor.
		x' = x*10^(factor)
	> copasi_path : str
		Location of Copasi executable.
	> model : Model
		SBML model (automatically loaded).
	> param_index : int
		Current parameter index.
	> param_metaid : str
		Current parameter meta identifier.
	> param_id : str
		Current parameter identifier.
	> param_wt : 0.0
		Current parameter wild-type value.
	> param_val : 0.0
		Current parameter mutant value.
	> output_file : file
		Output file.
	
	Methods
    -------
	> __init__(sbml_filename, factor_range, factor_step, copasi_path)
		SensitivityAnalysis class constructor.
	> initialize_output_file()
		Initialize the output file (write the header).
	> write_output_file()
		Write the current sensitivity analysis state in the output file.
	> initialize()
		Initialize the sensitivity analysis algorithm.
	> reload_WT_state()
		Reload the wild-type state into the mutant model.
	> explore_next_parameter()
		Run a full parameter exploration for the next kinetic parameter.
	"""
	
	### Constructor ###
	def __init__( self, sbml_filename, factor_range, factor_step, copasi_path ):
		"""
		SensitivityAnalysis class constructor.
		
		Parameters
		----------
		sbml_filename : str
			Path of the SBML model file. The SBML model is automatically loaded.
		factor_range : float > 0.0
			Half-range of the log10-scaling factor (total range=2*factor_range)
		factor_step : float > 0.0
			Exploration step of the log10-scaling factor.
			x' = x*10^(factor)
		copasi_path : str
			Location of Copasi executable.
		
		Returns
		-------
		None
		"""
		assert os.path.isfile(sbml_filename), "The SBML file \""+sbml_filename+"\" does not exist. Exit."
		assert factor_range > 0.0, "The factor range 'factor_range' must be a positive nonzero value. Exit."
		assert factor_step > 0.0, "The factor step 'factor_step' must be a positive nonzero value. Exit."
		assert os.path.isfile(copasi_path), "The executable \""+copasi_path+"\" does not exist. Exit."
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Main sensitivity analysis parameters #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.sbml_filename = sbml_filename
		self.factor_range  = factor_range
		self.factor_step   = factor_step
		self.copasi_path   = copasi_path
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) SBML model                           #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.model = Model(sbml_filename, [], copasi_path)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Parameter tracking                   #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.param_index  = 0
		self.param_metaid = "WT"
		self.param_id     = "WT"
		self.param_wt     = 0.0
		self.param_val    = 0.0
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Output file                          #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.output_file = open("output/sensitivity_analysis.txt", "w")
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
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Write the header                 #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		header = "param_metaid param_id param_wt param_val param_dln"
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				header += " "+species_id
		for reaction_id in self.model.reactions:
			header += " "+reaction_id
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Write the wild-type steady-state #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		first_line = "WT WT 0.0 0.0 0.0"
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				first_line += " "+str(self.model.species[species_id]["WT_value"])
		for reaction_id in self.model.reactions:
			first_line += " "+str(self.model.reactions[reaction_id]["WT_value"])
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Save in output file              #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.output_file = open("output/sensitivity_analysis.txt", "a")
		self.output_file.write(header+"\n"+first_line+"\n")
		self.output_file.close()
	
	### Write the sensitivity analysis state in the output file ###
	def write_output_file( self ):
		"""
		Write the current sensitivity analysis state in the output file.
	
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
		line += str(self.param_metaid)+" "
		line += str(self.param_id)+" "
		line += str(self.param_wt)+" "
		line += str(self.param_val)+" "
		line += str((self.param_val-self.param_wt)/self.param_wt)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Write steady-state       #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		for species_id in self.model.species:
			if not self.model.species[species_id]["constant"]:
				wt_val  = self.model.species[species_id]["WT_value"]
				mut_val = self.model.species[species_id]["mutant_value"]
				dln_val = "NA"
				if wt_val != 0.0:
					dln_val = (mut_val-wt_val)/wt_val
				line   += " "+str(dln_val)
		for reaction_id in self.model.reactions:
			wt_val  = self.model.reactions[reaction_id]["WT_value"]
			mut_val = self.model.reactions[reaction_id]["mutant_value"]
			dln_val = "NA"
			if wt_val != 0.0:
				dln_val = (mut_val-wt_val)/wt_val
			line   += " "+str(dln_val)
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Write in file            #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.output_file = open("output/sensitivity_analysis.txt", "a")
		self.output_file.write(line+"\n")
		self.output_file.close()
	
	### Initialize sensitivity analysis algorithm ###
	def initialize( self ):
		"""
		Initialize the sensitivity analysis algorithm.
	
		Parameters
		----------
		None
	
		Returns
		-------
		None
		"""
		self.model.compute_WT_steady_state()
		self.model.compute_mutant_steady_state()
		self.initialize_output_file()
		self.param_index = 0
	
	### Reload the wild-type state into the mutant model ###
	def reload_WT_state( self ):
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
			self.model.species[species_id]["initial_value"] = self.model.species[species_id]["WT_value"]
			self.model.species[species_id]["mutant_value"]  = self.model.species[species_id]["WT_value"]
			#if not self.model.species[species_id]["constant"]:
			#	self.model.set_species_initial_value(species_id, self.model.species[species_id]["mutant_value"])
		for parameter_metaid in self.model.parameters:
			self.model.set_mutant_parameter_value(parameter_metaid, self.model.get_WT_parameter_value(parameter_metaid))
		for reaction_id in self.model.reactions:
			self.model.reactions[reaction_id]["mutant_value"] = self.model.reactions[reaction_id]["WT_value"]
		
	### Explore the next parameter ###
	def explore_next_parameter( self ):
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
		self.param_metaid = list(self.model.parameters)[self.param_index]
		self.param_id     = self.model.parameters[self.param_metaid]["id"]
		self.param_wt     = self.model.parameters[self.param_metaid]["WT_value"]
		self.param_val    = 0.0
		print("> Current parameter: "+str(self.param_id))
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Explore the upper range       #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		factor = 0.0
		while factor <= self.factor_range+self.factor_step/2.0: # +step/2 for precision errors
			self.param_val = self.param_wt*10**factor
			self.model.set_mutant_parameter_value(self.param_metaid, self.param_val)
			self.model.compute_mutant_steady_state()
			self.write_output_file()
			#self.model.update_initial_concentrations()
			factor += self.factor_step
		self.reload_WT_state()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 3) Explore the lower range       #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		factor = -self.factor_step
		while factor >= -self.factor_range-self.factor_step/2.0: # -step/2 for precision errors
			self.param_val = self.param_wt*10**factor
			self.model.set_mutant_parameter_value(self.param_metaid, self.param_val)
			self.model.compute_mutant_steady_state()
			self.write_output_file()
			#self.model.update_initial_concentrations()
			factor -= self.factor_step
		self.reload_WT_state()
		
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 4) Increment the parameter index #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
		self.param_index += 1
		if self.param_index == len(self.model.parameters):
			return True
		return False
