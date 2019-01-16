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


class SBML_Model:
	
	#### Constructor ###
	def __init__( self, filename ):
		self.filename              = filename
		self.reader                = libsbml.SBMLReader()
		self.WT_document           = self.reader.readSBMLFromFile("resources/"+filename)
		self.mutant_document       = self.reader.readSBMLFromFile("resources/"+filename)
		self.WT_model              = self.WT_document.getModel()
		self.mutant_model          = self.mutant_document.getModel()
		self.list_of_parameters    = []
		self.reaction_to_param_map = {}
	
	### Get the number of metabolites ###
	def get_number_of_metabolites( self ):
		return self.WT_model.getNumSpecies()
	
	### Get the number of reactions ###
	def get_number_of_reactions( self ):
		return self.WT_model.getNumReactions()
	
	### Get the number of parameters ###
	def get_number_of_parameters( self ):
		return self.WT_model.getNumParameters()
		
	### Load the reaction-to-parameters map ###
	def load_reaction_to_param_map( self ):
		self.list_of_parameters    = []
		self.reaction_to_param_map = {}
		f = open("resources/reaction_to_param_map.txt", "r")
		l = f.readline()
		while l:
			l = l.strip(" ;\n").split("[")
			reaction = "v"+l[1].split("]")[0]
			param    = l[2].split("\"")[1]
			if param not in self.list_of_parameters:
				self.list_of_parameters.append(param)
			if reaction not in self.reaction_to_param_map.keys():
				self.reaction_to_param_map[reaction] = [param]
			else:
				self.reaction_to_param_map[reaction].append(param)
			l = f.readline()
		f.close()
	
	### Get a random parameter uniformly among parameters ###
	def get_random_param_uniform_params( self ):
		param_index = np.random.randint(0, len(self.list_of_parameters))
		param_name  = self.list_of_parameters[param_index]
		return param_name
	
	### Get a random parameter uniformly among reactions ###
	def get_random_param_uniform_reactions( self ):
		reaction_index = np.random.randint(0, len(self.reaction_to_param_map.keys()))
		reaction_name  = self.reaction_to_param_map.keys()[reaction_index]
		param_index    = np.random.randint(0, len(self.reaction_to_param_map[reaction_name]))
		param_name     = self.reaction_to_param_map[reaction_name][param_index]
		return param_name
	
	### Get WT parameter value ###
	def get_WT_parameter_value( self, param ):
		return self.WT_model.getListOfParameters().get(param).getValue()
	
	### Get mutant parameter value ###
	def get_mutant_parameter_value( self, param ):
		return self.mutant_model.getListOfParameters().get(param).getValue()
	
	### Set mutant parameter value ###
	def set_mutant_parameter_value( self, param, value ):
		self.mutant_model.getListOfParameters().get(param).setValue(value)
	
	### Make a deterministic parameter mutation by a given factor, centered on WT value ###
	def deterministic_parameter_change( self, param, factor ):
		old_val = self.get_WT_parameter_value(param)
		log_val = np.log10(old_val)
		new_val = np.power(10.0, log_val+factor)
		new_val = new_val[0]
		self.set_mutant_parameter_value(param, new_val)
		return old_val, new_val

	### Make a random parameter mutation by a given std sigma, centered on WT value  ###
	def random_parameter_change( self, param, sigma ):
		factor = np.random.normal(1.0, sigma, 1)
		old_val = self.get_WT_parameter_value(param)
		new_val = old_val*factor
		new_val = new_val[0]
		self.set_mutant_parameter_value(param, new_val)
		return old_val, new_val

	### Make a drifting random parameter mutation by a given std sigma, centered on previous mutant value ###
	def random_drift_parameter_change( self, param, sigma ):
		factor  = np.random.normal(1.0, sigma, 1)
		old_val = self.get_mutant_parameter_value(param)
		new_val = old_val*factor
		new_val = new_val[0]
		self.set_mutant_parameter_value(param, new_val)
		return old_val, new_val
		
	### Write WT SBML file ###
	def write_WT_SBML_file( self ):
		libsbml.writeSBMLToFile(self.WT_document, "output/WT.xml")

	### Write mutant SBML file ###
	def write_mutant_SBML_file( self ):
		libsbml.writeSBMLToFile(self.mutant_document, "output/mutant.xml")

	### Create ancestor CPS file ###
	def create_WT_cps_file( self ):
		cmd_line = "./resources/CopasiSE -i ./output/WT.xml"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Create mutant CPS file ###
	def create_mutant_cps_file( self ):
		cmd_line = "./resources/CopasiSE -i ./output/mutant.xml"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Edit ancestor CPS file to schedule steady-state calculation ###
	def edit_WT_cps_file( self ):
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

	### Compute steady-state for ancestor model ###
	def run_copasi_for_WT( self ):
		os.system("rm ./output/WT_output.txt")
		cmd_line = "./resources/CopasiSE ./output/WT.cps"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Compute steady-state for mutant model ###
	def run_copasi_for_mutant( self ):
		os.system("rm ./output/mutant_output.txt")
		cmd_line = "./resources/CopasiSE ./output/mutant.cps"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)
	
	### Compute WT steady-state ###
	def compute_WT_steady_state( self ):
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
		concentrations       = []
		fluxes               = []
		parse_concentrations = False
		parse_fluxes         = False
		f = open("./output/WT_output.txt", "r")
		l = f.readline()
		while l:
			if l == "\n" and parse_concentrations:
				 parse_concentrations = False
			if l == "\n" and parse_fluxes:
				 parse_fluxes = False
			if parse_concentrations:
				name = l.split("\t")[0].replace(" ", "-")
				val  = l.split("\t")[1]
				concentrations.append([name, val])
			if parse_fluxes:
				name = l.split("\t")[0].replace(" ", "-")
				val  = l.split("\t")[1]
				fluxes.append([name, val])
			if l.startswith("Species"):
				parse_concentrations = True
			if l.startswith("Reaction"):
				parse_fluxes = True
			l = f.readline()
		f.close()
		return concentrations, fluxes
	
	### Compute mutant steady-state ###
	def compute_mutant_steady_state( self ):
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
		concentrations       = []
		fluxes               = []
		parse_concentrations = False
		parse_fluxes         = False
		f = open("./output/mutant_output.txt", "r")
		l = f.readline()
		while l:
			if l == "\n" and parse_concentrations:
				 parse_concentrations = False
			if l == "\n" and parse_fluxes:
				 parse_fluxes = False
			if parse_concentrations:
				name = l.split("\t")[0].replace(" ", "-")
				val  = l.split("\t")[1]
				concentrations.append([name, val])
			if parse_fluxes:
				name = l.split("\t")[0].replace(" ", "-")
				val  = l.split("\t")[1]
				fluxes.append([name, val])
			if l.startswith("Species"):
				parse_concentrations = True
			if l.startswith("Reaction"):
				parse_fluxes = True
			l = f.readline()
		f.close()
		return concentrations, fluxes
	
	
##################
#      MAIN      #
##################

if __name__ == '__main__':
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 1) Load the SBML model     #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	print "> Loading Holzhutter (2004) model ..."
	model = SBML_Model("resources/holzhutter2004.xml")
	model.load_reaction_to_param_map()
	print "  - number of species: "+str(model.get_number_of_metabolites())
	print "  - number of reactions: "+str(model.get_number_of_reactions())
	print "  - number of parameters: "+str(model.get_number_of_parameters())
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 2) Compute WT steady-state #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	print "> Computing Holzhutter (2004) WT steady-state..."
	concentrations, reactions = model.compute_WT_steady_state()
	print "> Printing metabolic concentrations at steady-state..."
	for item in concentrations:
		print "["+item[0]+"] = "+str(item[1])
	print "> Printing metabolic fluxes at steady-state..."
	for item in reactions:
		print "["+item[0]+"] = "+str(item[1])
