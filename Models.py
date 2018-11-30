#!/usr/bin/env python
# coding: utf-8

import os
import sys
import numpy as np
import subprocess


#################################################
# Class Holzhutter2004:
# ---------------------
# This class manages Holzhutter (2004) SBML model
# and run Copasi steady-state algorithm.
#################################################
class Holzhutter2004:

	#### Default constructor ###
	def __init__( self ):
		self.upper_text = ""
		self.lower_text = ""
		self.upper_tag  = "<listOfParameters>"
		self.lower_tag  = "</listOfParameters>"
		self.parameters = {}

	### Load the SBML model ###
	def load_sbml( self ):
		#~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 1) Read SBML file        #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~#
		f = open("resources/holzhutter2004.xml", "r")
		xml = f.read()
		f.close()
		xml = xml.split(self.upper_tag)
		self.upper_text = xml[0]
		xml = xml[1].split(self.lower_tag)
		self.lower_text = xml[1]
		param_list = xml[0]
		#~~~~~~~~~~~~~~~~~~~~~~~~~~#
		# 2) Create parameter list #
		#~~~~~~~~~~~~~~~~~~~~~~~~~~#
		param_list = param_list.split("\n")
		for line in param_list:
			line = line.strip(" ")
			if line.startswith("<parameter"):
				param = line.split("id=\"")[2].split("\"")[0]
				value = line.split("value=\"")[1].split("\"")[0]
				headline = line.split("value=\"")[0]+"value=\""
				tailline = "\" constant=\"false\"/>"
				self.parameters[param] = {}
				self.parameters[param]["ancestor"] = float(value)
				self.parameters[param]["mutant"]   = float(value)
				self.parameters[param]["head"]     = headline
				self.parameters[param]["tail"]     = tailline
	
	### Get the list of kinetic parameters ###
	def get_parameters_list( self ):
		return self.parameters.keys()

	### Get the parameter ancestral value ###
	def get_parameter_valuation( self, param ):
		return True

	### Get the parameter ancestral value ###
	def get_parameter_ancestral_value( self, param ):
		return self.parameters[param]["ancestor"]

	### Get the parameter mutant value ###
	def get_parameter_mutant_value( self, param ):
		return self.parameters[param]["mutant"]

	### Change a parameter mutant value ###
	def set_parameter_mutant_value( self, param, value ):
		self.parameters[param]["mutant"] = value

	### Make a deterministic parameter mutation by a given factor ###
	def deterministic_parameter_change( self, param, factor ):
		log_val = np.log10(self.parameters[param]["ancestor"])
		self.parameters[param]["mutant"] = np.power(10.0, log_val+factor)

	### Make a random parameter mutation by a given std sigma ###
	def random_parameter_change( self, param, sigma ):
		factor  = np.random.normal(0.0, sigma, 1)
		log_val = np.log10(self.parameters[param]["ancestor"])
		self.parameters[param]["mutant"] = np.power(10.0, log_val+factor)
	
	### Mutate a random parameter ###
	def mutate( self, sigma ):
		index   = np.random.randint(len(self.parameters.keys()), size=1)[0]
		param_name   = self.parameters.keys()[index]
		anc_value    = self.parameters[param_name]["mutant"]
		factor       = np.random.normal(0.0, sigma, 1)[0]
		self.parameters[param_name]["mutant"] *= np.power(10.0, factor)
		mut_value    = self.parameters[param_name]["mutant"]
		return param_name, anc_value, mut_value, factor
	
	### Write ancestor SBML file ###
	def write_ancestor_SBML_file( self ):
		f = open("output/ancestor.xml", "w")
		f.write(self.upper_text)
		f.write(self.upper_tag+"\n")
		for param in self.parameters.keys():
			f.write("      "+self.parameters[param]["head"]+str(self.parameters[param]["ancestor"])+self.parameters[param]["tail"]+"\n")
		f.write(self.lower_tag+"\n")
		f.write(self.lower_text)
		f.close()

	### Write mutant SBML file ###
	def write_mutant_SBML_file( self ):
		f = open("output/mutant.xml", "w")
		f.write(self.upper_text)
		f.write(self.upper_tag+"\n")
		for param in self.parameters.keys():
			f.write("      "+self.parameters[param]["head"]+str(self.parameters[param]["mutant"])+self.parameters[param]["tail"]+"\n")
		f.write(self.lower_tag+"\n")
		f.write(self.lower_text)
		f.close()

	### Create ancestor CPS file ###
	def create_ancestor_cps_file( self ):
		cmd_line = "./resources/CopasiSE -i ./output/ancestor.xml"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Create mutant CPS file ###
	def create_mutant_cps_file( self ):
		cmd_line = "./resources/CopasiSE -i ./output/mutant.xml"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Edit ancestor CPS file to schedule steady-state calculation ###
	def edit_ancestor_cps_file( self ):
		f = open("./output/ancestor.cps", "r")
		cps = f.read()
		f.close()
		upper_text  = cps.split("<ListOfTasks>")[0]
		lower_text  = cps.split("</ListOfTasks>")[1]
		edited_file = ""
		edited_file += upper_text
		edited_file += '  <ListOfTasks>\n'
		edited_file += '    <Task key="Task_14" name="Steady-State" type="steadyState" scheduled="true" updateModel="false">\n'
		edited_file += '      <Report reference="Report_9" target="ancestor_output.txt" append="1" confirmOverwrite="1"/>\n'
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
		f = open("./output/ancestor.cps", "w")
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
	def run_copasi_for_ancestor( self ):
		os.system("rm ./output/ancestor_output.txt")
		cmd_line = "./resources/CopasiSE ./output/ancestor.cps"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Compute steady-state for mutant model ###
	def run_copasi_for_mutant( self ):
		os.system("rm ./output/mutant_output.txt")
		cmd_line = "./resources/CopasiSE ./output/mutant.cps"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Get ancestor steady-state values from Copasi output ###
	def get_ancestor_steady_state( self ):
		metabolites = []
		reactions   = []
		parse_metabolites = False
		parse_reactions   = False
		f = open("./output/ancestor_output.txt", "r")
		l = f.readline()
		while l:
			if l == "\n" and parse_metabolites:
				 parse_metabolites = False
			if l == "\n" and parse_reactions:
				 parse_reactions = False
			if parse_metabolites:
				name = l.split("\t")[0]
				val  = l.split("\t")[1]
				metabolites.append([name, val])
			if parse_reactions:
				name = l.split("\t")[0]
				val  = l.split("\t")[1]
				reactions.append([name, val])
			if l.startswith("Species"):
				parse_metabolites = True
			if l.startswith("Reaction"):
				parse_reactions = True
			l = f.readline()
		f.close()
		return metabolites, reactions

	### Get mutant steady-state values from Copasi output ###
	def get_mutant_steady_state( self ):
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
				name = l.split("\t")[0]
				val  = l.split("\t")[1]
				metabolites.append([name, val])
			if parse_reactions:
				name = l.split("\t")[0]
				val  = l.split("\t")[1]
				reactions.append([name, val])
			if l.startswith("Species"):
				parse_metabolites = True
			if l.startswith("Reaction"):
				parse_reactions = True
			l = f.readline()
		f.close()
		return metabolites, reactions

#################################################
# Class Smallbone2013:
# --------------------
# This class manages Smallbone (2013) SBML model
# and run Copasi steady-state algorithm.
#################################################
class Smallbone2013:

	#### Default constructor ###
	def __init__( self ):
		self.text_blocks = {}
		self.nb_blocks   = 0
		self.parameters  = {}

	### Load the SBML model ###
	def load_sbml( self ):
		self.text_blocks        = {}
		self.parameters         = {}
		self.block_to_param_map = {}
		self.nb_blocks          = 1
		readParameters          = False
		f                       = open("resources/smallbone2013.xml", "r")
		l                       = f.readline()
		self.text_blocks[self.nb_blocks]        = ""
		self.block_to_param_map[self.nb_blocks] = []
		while l:
			#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
			# Case 1) Parse XML content                          #
			#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
			if not readParameters and not "<listOfParameters>" in l:
				self.text_blocks[self.nb_blocks] += l
			#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
			# Case 2) Detect the beginning of a parameters block #
			#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
			elif not readParameters and "<listOfParameters>" in l:
				self.text_blocks[self.nb_blocks] += l
				readParameters                   = True
			#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
			# Case 3) Parse kinetic parameters                   #
			#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
			elif readParameters and not "</listOfParameters>" in l:
				# <parameter metaid="_505b9acb_c0af_4181_ab17_09a7ffa75169" id="Keq_ADH" value="14492.7536231884" units="dimensionless"/>
				param_name = l.split(" id=")[1].split("\"")[1]
				key_name   = param_name
				if key_name == "k":
					key_name += "_"+str(self.nb_blocks)
				valued      = False
				param_value = 0.0
				if "value=" in l:
					valued = True
					param_value = float(l.split(" value=")[1].split("\"")[1])
				param_header = l.split(" id=")[0]
				param_tail   = " units="+l.split(" units=")[1]
				self.parameters[key_name]             = {}
				self.parameters[key_name]["name"]     = param_name
				self.parameters[key_name]["valued"]   = valued
				self.parameters[key_name]["ancestor"] = param_value
				self.parameters[key_name]["mutant"]   = param_value
				self.parameters[key_name]["head"]     = param_header
				self.parameters[key_name]["tail"]     = param_tail
				self.block_to_param_map[self.nb_blocks].append(key_name)
			#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
			# Case 4) Detect the end of a parameters block       #
			#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
			elif readParameters and "</listOfParameters>" in l:
				self.nb_blocks += 1
				readParameters = False
				self.text_blocks[self.nb_blocks] = l
				self.block_to_param_map[self.nb_blocks] = []
			l = f.readline()
		f.close()
	
	### Get the list of kinetic parameters ###
	def get_parameters_list( self ):
		return self.parameters.keys()

	### Get the parameter ancestral value ###
	def get_parameter_valuation( self, param ):
		return self.parameters[param]["valued"]

	### Get the parameter ancestral value ###
	def get_parameter_ancestral_value( self, param ):
		return self.parameters[param]["ancestor"]

	### Get the parameter mutant value ###
	def get_parameter_mutant_value( self, param ):
		return self.parameters[param]["mutant"]

	### Change a parameter mutant value ###
	def set_parameter_mutant_value( self, param, value ):
		self.parameters[param]["mutant"] = value

	### Make a deterministic parameter mutation by a given factor ###
	def deterministic_parameter_change( self, param, factor ):
		#self.parameters[param]["mutant"] = self.parameters[param]["ancestor"]*factor
		log_val = np.log10(self.parameters[param]["ancestor"])
		self.parameters[param]["mutant"] = np.power(10.0, log_val+factor)

	### Make a random parameter mutation by a given std sigma ###
	def random_parameter_change( self, param, sigma ):
		factor = np.random.normal(1.0, sigma, 1)
		self.parameters[param]["mutant"] = self.parameters[param]["ancestor"]*factor

	### Make a drifting random parameter mutation by a given std sigma ###
	def random_drift_parameter_change( self, param, sigma ):
		factor = np.random.normal(1.0, sigma, 1)
		self.parameter[param]["mutant"] *= factor

	### Write ancestor SBML file ###
	def write_ancestor_SBML_file( self ):
		f = open("output/ancestor.xml", "w")
		for block_id in range(1, self.nb_blocks+1):
			f.write(self.text_blocks[block_id])
			for param_key in self.block_to_param_map[block_id]:
				# <parameter metaid="_505b9acb_c0af_4181_ab17_09a7ffa75169" id="Keq_ADH" value="14492.7536231884" units="dimensionless"/>
				f.write(self.parameters[param_key]["head"])
				f.write(" id=\""+self.parameters[param_key]["name"]+"\"")
				if self.parameters[param_key]["valued"]:
					f.write(" value=\""+str(self.parameters[param_key]["ancestor"])+"\"")
				f.write(self.parameters[param_key]["tail"])
		f.close()

	### Write mutant SBML file ###
	def write_mutant_SBML_file( self ):
		f = open("output/mutant.xml", "w")
		for block_id in range(1, self.nb_blocks+1):
			f.write(self.text_blocks[block_id])
			for param_key in self.block_to_param_map[block_id]:
				# <parameter metaid="_505b9acb_c0af_4181_ab17_09a7ffa75169" id="Keq_ADH" value="14492.7536231884" units="dimensionless"/>
				f.write(self.parameters[param_key]["head"])
				f.write(" id=\""+self.parameters[param_key]["name"]+"\"")
				if self.parameters[param_key]["valued"]:
					f.write(" value=\""+str(self.parameters[param_key]["mutant"])+"\"")
				f.write(self.parameters[param_key]["tail"])
		f.close()

	### Create ancestor CPS file ###
	def create_ancestor_cps_file( self ):
		cmd_line = "./resources/CopasiSE -i ./output/ancestor.xml"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Create mutant CPS file ###
	def create_mutant_cps_file( self ):
		cmd_line = "./resources/CopasiSE -i ./output/mutant.xml"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Edit ancestor CPS file to schedule steady-state calculation ###
	def edit_ancestor_cps_file( self ):
		f = open("./output/ancestor.cps", "r")
		cps = f.read()
		f.close()
		upper_text  = cps.split("<ListOfTasks>")[0]
		lower_text  = cps.split("</ListOfTasks>")[1]
		edited_file = ""
		edited_file += upper_text
		edited_file += '  <ListOfTasks>\n'
		edited_file += '    <Task key="Task_14" name="Steady-State" type="steadyState" scheduled="true" updateModel="false">\n'
		edited_file += '      <Report reference="Report_9" target="ancestor_output.txt" append="1" confirmOverwrite="1"/>\n'
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
		f = open("./output/ancestor.cps", "w")
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
	def run_copasi_for_ancestor( self ):
		os.system("rm ./output/ancestor_output.txt")
		cmd_line = "./resources/CopasiSE ./output/ancestor.cps"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Compute steady-state for mutant model ###
	def run_copasi_for_mutant( self ):
		os.system("rm ./output/mutant_output.txt")
		cmd_line = "./resources/CopasiSE ./output/mutant.cps"
		process = subprocess.call([cmd_line], stdout=subprocess.PIPE, shell=True)

	### Get ancestor steady-state values from Copasi output ###
	def get_ancestor_steady_state( self ):
		metabolites = []
		reactions   = []
		parse_metabolites = False
		parse_reactions   = False
		f = open("./output/ancestor_output.txt", "r")
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

	### Get mutant steady-state values from Copasi output ###
	def get_mutant_steady_state( self ):
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
				name = l.split("\t")[0]
				val  = l.split("\t")[1]
				metabolites.append([name, val])
			if parse_reactions:
				name = l.split("\t")[0]
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
	#model = Holzhutter2004()
	#model.load_sbml()
	#print model.parameters.keys()

	model = Smallbone2013()
	model.load_sbml()
	model.write_ancestor_SBML_file()
	model.write_mutant_SBML_file()
	model.create_ancestor_cps_file()
	model.create_mutant_cps_file()
	model.edit_ancestor_cps_file()
	model.edit_mutant_cps_file()

	model.run_copasi_for_ancestor()
	model.run_copasi_for_mutant()
	print model.get_ancestor_steady_state()
