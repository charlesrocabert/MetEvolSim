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
	arguments                        = {}
	arguments["sbml-filename"]       = ""
	arguments["objective-function"]  = ""
	arguments["nb-iterations"]       = 0
	arguments["selection-sigma"]     = 0.0
	arguments["selection-scheme"]    = ""
	arguments["selection-threshold"] = 0.0
	arguments["seed"]                = 0
	arguments["copasi-path"]         = ""
	for i in range(len(argv)):
		if argv[i] == "-h" or argv[i] == "--help":
			printHelp()
			exit_thread()
		if argv[i] == "-sbml-filename" or argv[i] == "--sbml-filename":
			arguments["sbml-filename"] = argv[i+1]
		if argv[i] == "-objective-function" or argv[i] == "--objective-function":
			arguments["objective-function"] = argv[i+1]
		if argv[i] == "-nb-iterations" or argv[i] == "--nb-iterations":
			arguments["nb-iterations"] = int(argv[i+1])
		if argv[i] == "-selection-sigma" or argv[i] == "--selection-sigma":
			arguments["selection-sigma"] = float(argv[i+1])
		if argv[i] == "-selection-scheme" or argv[i] == "--selection-scheme":
			arguments["selection-scheme"] = argv[i+1]
		if argv[i] == "-selection-threshold" or argv[i] == "--selection-threshold":
			arguments["selection-threshold"] = float(argv[i+1])
		if argv[i] == "-seed" or argv[i] == "--seed":
			arguments["seed"] = int(argv[i+1])
		if argv[i] == "-copasi-path" or argv[i] == "--copasi-path":
			arguments["copasi-path"] = argv[i+1]
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
	if not os.path.isfile(arguments["objective-function"]):
		print("The objective function file \""+arguments["objective-function"]+"\" does not exist. Exit.")
		exit_thread()
	if arguments["nb-iterations"] <= 0:
		print("Error: argument '-nb-iterations' only admits positive integer values (iterations > 0).")
		print("(current value: "+str(arguments["nb-iterations"])+")")
		exit_thread()
	if arguments["selection-sigma"] <= 0.0:
		print("Error: argument '-selection-sigma' only admits positive decimal values (selection-sigma > 0.0).")
		print("(current value: "+str(arguments["selection-sigma"])+")")
		exit_thread()
	# METABOLIC_SUM_SELECTION / TARGET_FLUXES_SELECTION
	if not arguments["selection-scheme"] in ["MUTATION_ACCUMULATION", "ABSOLUTE_METABOLIC_SUM_SELECTION", "RELATIVE_METABOLIC_SUM_SELECTION", "ABSOLUTE_TARGET_FLUXES_SELECTION", "RELATIVE_TARGET_FLUXES_SELECTION"]:
		print("Error: argument '-selection-scheme' only admits 3 options (MUTATION_ACCUMULATION / ABSOLUTE_METABOLIC_SUM_SELECTION / RELATIVE_METABOLIC_SUM_SELECTION / ABSOLUTE_TARGET_FLUXES_SELECTION / RELATIVE_TARGET_FLUXES_SELECTION).")
		print("(current value: "+str(arguments["selection-scheme"])+")")
		exit_thread()
	if arguments["seed"] <= 0:
		print("Error: argument '-seed' only admits positive integer values (seed > 0).")
		print("(current value: "+str(arguments["seed"])+")")
		exit_thread()
	if not os.path.isfile(arguments["copasi-path"]):
		print("The executable \""+arguments["copasi-path"]+"\" does not exist. Exit.")
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
	print("Usage: python3 run_mcmc.py -h or --help")
	print("   or: python3 run_mcmc.py [list of mandatory arguments]")
	print("Options are:")
	print("  -h, --help")
	print("        print this help, then exit")
	print("  -sbml-filename, --sbml-filename <SBML_filename> (mandatory)")
	print("        Specify the SBML model filename")
	print("  -objective-function, --objective-function <objective_function> (mandatory)")
	print("        Specify the objective function filename")
	print("  -nb-iterations, --nb-iterations <nb_iterations> (mandatory)")
	print("        Specify the number of MCMC iterations (integer > 0)")
	print("  -selection-sigma, --selection-sigma <selection_sigma> (mandatory)")
	print("        Specify the log10 mutation size (float > 0.0)")
	print("  -selection-scheme, --selection-scheme <selection_scheme> (mandatory)")
	print("        Specify the selection scheme")
	print("        (MUTATION_ACCUMULATION / ABSOLUTE_METABOLIC_SUM_SELECTION / RELATIVE_METABOLIC_SUM_SELECTION / ABSOLUTE_TARGET_FLUXES_SELECTION / RELATIVE_TARGET_FLUXES_SELECTION)")
	print("  -selection-threshold, --selection-threshold <selection_threshold> (mandatory)")
	print("        Specify the selection threshold (float > 0.0).")
	print("  -seed, --seed <prng_seed> (mandatory)")
	print("        Specify the prng seed (integer > 0.0)")
	print("  -copasi-path, --copasi-path <copasi_path> (mandatory)")
	print("        Specify the location of Copasi executable.")
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
	print("MCMC parameters are:")
	print("--------------------")
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

### Load the objective function ###
def load_objective_function( filename ):
	"""
	Load the objective function from a file.
	
	Parameters
	----------
	None
	
	Returns
	-------
	None
	"""
	objective_function = []
	f = open(filename, "r")
	l = f.readline()
	l = f.readline()
	while l:
		l = l.strip("\n").split(" ")
		objective_function.append([l[0], float(l[1])])
		l = f.readline()
	return objective_function


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
	
	arguments["sbml-filename"]       = "../example/model/holzhutter2004.xml"
	arguments["objective-function"]  = "../example/model/holzhutter2004_objective_function.txt"
	arguments["nb-iterations"]       = 10000
	arguments["selection-sigma"]     = 0.01
	arguments["selection-scheme"]    = "RELATIVE_TARGET_FLUXES_SELECTION"
	arguments["selection-threshold"] = 1e-4
	arguments["seed"]                = 1234
	arguments["copasi-path"]         = "/Applications/COPASI/CopasiSE"
	
	assertArgs(arguments)
	printHeader(arguments)
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 3) Seed the numpy prng             #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	np.random.seed(arguments["seed"])
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 4) Load the objective function     #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	objective_function = load_objective_function(arguments["objective-function"])
	
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 5) Run the MCMC algorithm          #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	mcmc       = MetEvolSim.MCMC(arguments["sbml-filename"], objective_function, arguments["nb-iterations"], arguments["selection-sigma"], arguments["selection-scheme"], arguments["selection-threshold"], arguments["copasi-path"])
	stop_mcmc  = False
	start_time = time.time()
	mcmc.initialize()
	while not stop_mcmc:
		stop_mcmc = mcmc.iterate()
		mcmc.write_output_file()
		mcmc.write_statistics()
		ongoing_time   = time.time()
		estimated_time = (ongoing_time-start_time)*float(arguments["nb-iterations"]-mcmc.nb_iterations)/float(mcmc.nb_iterations)
		print("   Estimated remaining time "+str(int(round(estimated_time/60)))+" min.")
		
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	# 6) Exit the thread                 #
	#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#
	exit_thread()
