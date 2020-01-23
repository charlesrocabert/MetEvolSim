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
import numpy as np
import metevolsim

### Read command line arguments ###
def readArgs( argv ):
	"""
	Read command line arguments.
	
	Parameters
	----------
	argv : list of str
		Command line arguments.
	
	Returns
	-------
	dict
		Parsed arguments.
	"""
	arguments                  = {}
	arguments["sbml-filename"] = ""
	arguments["copasi-path"]   = ""
	arguments["factor-range"]  = 0.0
	arguments["factor-step"]   = 0.0
	for i in range(len(argv)):
		if argv[i] == "-h" or argv[i] == "--help":
			printHelp()
			exit_thread()
		if argv[i] == "-sbml-filename" or argv[i] == "--sbml-filename":
			arguments["sbml-filename"] = argv[i+1]
		if argv[i] == "-copasi-path" or argv[i] == "--copasi-path":
			arguments["copasi-path"] = argv[i+1]
		if argv[i] == "-factor-range" or argv[i] == "--factor-range":
			arguments["factor-range"] = float(argv[i+1])
		if argv[i] == "-factor-step" or argv[i] == "--factor-step":
			arguments["factor-step"] = float(argv[i+1])
	return arguments

### Assert arguments consistency ###
def assertArgs( arguments ):
	"""
	Assert argument values.
	
	Parameters
	----------
	arguments : dict
		Parsed arguments.
	
	Returns
	-------
	None
	"""
	if not os.path.isfile(arguments["sbml-filename"]):
		print("The SBML file \""+arguments["sbml-filename"]+"\" does not exist. Exit.")
		exit_thread()
	if not os.path.isfile(arguments["copasi-path"]):
		print("The executable \""+arguments["copasi-path"]+"\" does not exist. Exit.")
		exit_thread()
	if arguments["factor-range"] <= 0:
		print("Error: argument '-factor-range' only admits positive decimal values (factor_range > 0.0).")
		print("(current value: "+str(arguments["factor-range"])+")")
		exit_thread()
	if arguments["factor-step"] <= 0:
		print("Error: argument '-factor-step' only admits positive decimal values (factor_step > 0.0).")
		print("(current value: "+str(arguments["factor-step"])+")")
		exit_thread()
		
### Print help ###
def printHelp():
	"""
	Print this executable help and exit.
	
	Parameters
	----------
	None
	
	Returns
	-------
	None
	"""
	print("")
	print("#***************************************************************************")
	print("# MetEvolSim (Metabolome Evolution Simulator)")
	print("# -------------------------------------------")
	print("# MetEvolSim is a numerical framework dedicated to the study of metabolic")
	print("# abundances evolution.")
	print("#")
	print("# Copyright (c) 2018-2020 Charles Rocabert, Gábor Boross, Balázs Papp")
	print("# Web: https://github.com/charlesrocabert/MetEvolSim")
	print("#")
	print("# This program is free software: you can redistribute it and/or modify")
	print("# it under the terms of the GNU General Public License as published by")
	print("# the Free Software Foundation, either version 3 of the License, or")
	print("# (at your option) any later version.")
	print("#")
	print("# This program is distributed in the hope that it will be useful,")
	print("# but WITHOUT ANY WARRANTY; without even the implied warranty of")
	print("# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the")
	print("# GNU General Public License for more details.")
	print("#")
	print("# You should have received a copy of the GNU General Public License")
	print("# along with this program.  If not, see <http://www.gnu.org/licenses/>.")
	print("#***************************************************************************")
	print("Usage: python3 run_sensitivity_analysis.py -h or --help")
	print("   or: python3 run_sensitivity_analysis.py [list of mandatory arguments]")
	print("Options are:")
	print("  -h, --help")
	print("        print this help, then exit")
	print("  -sbml-filename, --sbml-filename <SBML_filename> (mandatory)")
	print("        Specify the SBML model filename")
	print("  -copasi-path, --copasi-path <copasi_path> (mandatory)")
	print("        Specify the location of copasiSE executable.")
	print("  -factor-range, --factor-range <factor_range> (mandatory)")
	print("        Specify the half-range of the parameter exploration factor (float > 0.0)")
	print("        (full exploration range of parameter x is [x*10^(-range), x*10^(range)])")
	print("  -factor-step, --factor-step <factor_step> (mandatory)")
	print("        Specify the step of the parameter exploration factor (float > 0.0)")
	print("        (factor' = factor -+ step)")
	print("")

### Print header ###
def printHeader( arguments ):
	"""
	Print this executable header.
	
	Parameters
	----------
	arguments : dict
		Parsed arguments.
	
	Returns
	-------
	None
	"""
	print("")
	print("#***************************************************************************")
	print("# MetEvolSim (Metabolome Evolution Simulator)")
	print("# -------------------------------------------")
	print("# MetEvolSim is a numerical framework dedicated to the study of metabolic")
	print("# abundances evolution.")
	print("#")
	print("# Copyright (c) 2018-2020 Charles Rocabert, Gábor Boross, Balázs Papp")
	print("# Web: https://github.com/charlesrocabert/MetEvolSim")
	print("#")
	print("# This program is free software: you can redistribute it and/or modify")
	print("# it under the terms of the GNU General Public License as published by")
	print("# the Free Software Foundation, either version 3 of the License, or")
	print("# (at your option) any later version.")
	print("#")
	print("# This program is distributed in the hope that it will be useful,")
	print("# but WITHOUT ANY WARRANTY; without even the implied warranty of")
	print("# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the")
	print("# GNU General Public License for more details.")
	print("#")
	print("# You should have received a copy of the GNU General Public License")
	print("# along with this program.  If not, see <http://www.gnu.org/licenses/>.")
	print("#***************************************************************************")
	print("Sensitivity analysis parameters are:")
	print("------------------------------------")
	for arg in arguments:
		print("• "+arg+": "+str(arguments[arg]))
	print("")

### Write the waiting signal for this thread ###
def write_waiting_thread_signal():
	"""
	Write the waiting signal for this thread.
	
	Parameters
	----------
	None
	
	Returns
	-------
	None
	"""
	f = open("thread_signal.txt", "w")
	f.write("WAIT\n")
	f.close()

### Write the ending signal for this thread ###
def write_ending_thread_signal():
	"""
	Write the ending signal for this thread.
	
	Parameters
	----------
	None
	
	Returns
	-------
	None
	"""
	f = open("thread_signal.txt", "w")
	f.write("END\n")
	f.close()

### Exit thread ###
def exit_thread():
	"""
	Exit this thread.
	
	Parameters
	----------
	None
	
	Returns
	-------
	None
	"""
	write_ending_thread_signal()
	sys.exit()


##################
#      MAIN      #
##################

if __name__ == '__main__':
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 1) Write the waiting thread signal #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	write_waiting_thread_signal()
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 2) Read command line arguments     #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	arguments = readArgs(sys.argv)
	
	arguments["sbml-filename"] = "../example/model/holzhutter2004.xml"
	arguments["copasi-path"]   = "/Applications/COPASI/CopasiSE"
	arguments["factor-range"]  = 0.01
	arguments["factor-step"]   = 0.001
	
	assertArgs(arguments)
	printHeader(arguments)
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 3) Run the sensitivity analysis    #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	sa = metevolsim.SensitivityAnalysis(arguments["sbml-filename"], arguments["copasi-path"])
	sa.run_OAT_analysis(factor_range=arguments["factor-range"], factor_step=arguments["factor-step"])
		
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 4) Exit the thread                 #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	exit_thread()
