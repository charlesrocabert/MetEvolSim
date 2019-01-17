#!/usr/bin/env python
# coding: utf-8

import os
import sys
import numpy as np
import subprocess

### Save parameters in a local file ###
def write_parameters( folder, arguments ):
    f = open(folder+"/parameters.txt", "w")
    f.write("model_filename iterations mutation_size selection_scheme selection_threshold seed\n")
    f.write(str(arguments["model_filename"])+" ")
    f.write(str(arguments["iterations"])+" ")
    f.write(str(arguments["mutation_size"])+" ")
    f.write(str(arguments["selection_scheme"])+" ")
    f.write(str(arguments["selection_threshold"])+" ")
    f.write(str(arguments["seed"])+"\n")
    f.close()

### Build command line ###
def build_command_line( folder, arguments ):
    cmd_line  = ""
    cmd_line += "python ../../MetEvolSim_run.py"
    cmd_line += " -model-filename "+str(arguments["model_filename"])
    cmd_line += " -iterations "+str(arguments["iterations"])
    cmd_line += " -mutation-size "+str(arguments["mutation_size"])
    cmd_line += " -selection-scheme "+arguments["selection_scheme"]
    cmd_line += " -selection-threshold "+str(arguments["selection_threshold"])
    cmd_line += " -seed "+str(arguments["seed"])
    cmd_line += " > /dev/null &\n"
    print cmd_line
    return cmd_line

### Run a thread ###
def run_thread( folder, arguments ):
    os.system("rm -rf "+folder)
    os.mkdir(folder)
    write_parameters(folder, arguments)
    os.mkdir(folder+"/output")
    os.system("cp -r resources "+folder+"/.")
    cmd_line = build_command_line(folder, arguments)
    os.chdir(folder)
    os.system(cmd_line)
    os.chdir("..")


##################
#      MAIN      #
##################

ARGUMENTS   = {"model_filename":"holzhutter2004.xml", "iterations":10000, "mutation_size":0.01, "selection_scheme":"MUTATION_ACCUMULATION", "selection_threshold":0.0, "seed":0}
REPETITIONS = 1
FOLDER      = 1

if __name__ == '__main__':
    for rep in range(REPETITIONS):
        print "> Running thread "+str(FOLDER)+"..."
        ARGUMENTS["seed"] = np.random.randint(10, 100000000)
        run_thread(str(FOLDER), ARGUMENTS)
        FOLDER += 1
