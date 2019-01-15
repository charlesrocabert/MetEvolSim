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
import libsbml

class Model:
	
	#### Constructor ###
	def __init__( self, filename ):
		self.filename              = filename
		self.reader                = libsbml.SBMLReader()
		self.WT_document           = self.reader.readSBMLFromFile(filename)
		self.mutant_document       = self.reader.readSBMLFromFile(filename)
		self.WT_model              = self.WT_document.getModel()
		self.mutant_model          = self.mutant_document.getModel()
		self.reaction_to_param_map = {}
	
	### Load the reaction-to-parameters map ###
	def load_reaction_to_param_map( self ):
		self.reaction_to_param_map = {}
		f = open("resources/reaction_to_param_map.txt", "r")
		l = f.readline()
		while l:
			l = l.strip(" ;\n").split("[")
			reaction = "v"+l[1].split("]")[0]
			param    = l[2].split("\"")[1]
			if reaction not in self.reaction_to_param_map.keys():
				self.reaction_to_param_map[reaction] = [param]
			else:
				self.reaction_to_param_map[reaction].append(param)
			l = f.readline()
		f.close()
		
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
		log_val = np.log10(self.get_WT_parameter_value(param))
		self.set_mutant_parameter_value(np.power(10.0, log_val+factor))

	### Make a random parameter mutation by a given std sigma, centered on WT value  ###
	def random_parameter_change( self, param, sigma ):
		factor = np.random.normal(1.0, sigma, 1)
		val    = self.get_WT_parameter_value(param)
		self.set_mutant_parameter_value(val*factor)

	### Make a drifting random parameter mutation by a given std sigma, centered on previous mutant value ###
	def random_drift_parameter_change( self, param, sigma ):
		factor = np.random.normal(1.0, sigma, 1)
		val    = self.get_mutant_parameter_value(param)
		self.set_mutant_parameter_value(val*factor)

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
		#-----------------------------------------#
		# 1) Compute the steady-state with Copasi #
		#-----------------------------------------#
		self.write_WT_SBML_file()
		self.create_WT_cps_file()
		self.edit_WT_cps_file()
		self.run_copasi_for_WT()
		#-----------------------------------------#
		# 2) Extract steady-state                 #
		#-----------------------------------------#
		metabolites = []
		reactions   = []
		parse_metabolites = False
		parse_reactions   = False
		f = open("./output/WT_output.txt", "r")
		l = f.readline()
		while l:
			if l == "\n" and parse_metabolites:
				 parse_metabolites = False
			if l == "\n" and parse_reactions:
				 parse_reactions = False
			if parse_metabolites:
				name = l.split("\t")[0].replace(" ", "-")
				val  = l.split("\t")[1]
				metabolites.append([name, val])
			if parse_reactions:
				name = l.split("\t")[0].replace(" ", "-")
				val  = l.split("\t")[1]
				reactions.append([name, val])
			if l.startswith("Species"):
				parse_metabolites = True
			if l.startswith("Reaction"):
				parse_reactions = True
			l = f.readline()
		f.close()
		return metabolites, reactions
	
	### Compute mutant steady-state ###
	def compute_mutant_steady_state( self ):
		#-----------------------------------------#
		# 1) Compute the steady-state with Copasi #
		#-----------------------------------------#
		self.write_mutant_SBML_file()
		self.create_mutant_cps_file()
		self.edit_mutant_cps_file()
		self.run_copasi_for_mutant()
		#-----------------------------------------#
		# 2) Extract steady-state                 #
		#-----------------------------------------#
		metabolites = []
		reactions   = []
		parse_metabolites = False
		parse_reactions   = False
		f = open("./output/mutant_output.txt", "r")
		l = f.readline()
		while l:
			if l == "\n" and parse_metabolites:
				 parse_metabolites = False
			if l == "\n" and parse_reactions:
				 parse_reactions = False
			if parse_metabolites:
				name = l.split("\t")[0].replace(" ", "-")
				val  = l.split("\t")[1]
				metabolites.append([name, val])
			if parse_reactions:
				name = l.split("\t")[0].replace(" ", "-")
				val  = l.split("\t")[1]
				reactions.append([name, val])
			if l.startswith("Species"):
				parse_metabolites = True
			if l.startswith("Reaction"):
				parse_reactions = True
			l = f.readline()
		f.close()
		return metabolites, reactions
	
	
##################
#      MAIN      #
##################

if __name__ == '__main__':
	model = Model("resources/holzhutter2004.xml")
	print "> Computing Holzhutter (2004) WT steady-state..."
	metabolites, reactions = model.compute_WT_steady_state()
	print "> Printing metabolic concentrations at steady-state..."
	for item in metabolites:
		print "["+item[0]+"] = "+str(item[1])
	print "> Printing metabolic fluxes at steady-state..."
	for item in reactions:
		print "["+item[0]+"] = "+str(item[1])
