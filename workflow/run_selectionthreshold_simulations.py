#!/usr/bin/env python
# coding: utf-8

import os
import sys
import numpy as np
import subprocess

### Save parameters in a file ###
def write_parameters( folder, arguments ):
    f = open(folder+"/parameters.txt", "w")
    f.write("iterations log_mutation_size selection_scheme selection_threshold model_name\n")
    f.write(str(arguments["iterations"])+" ")
    f.write(str(arguments["mutation_size"])+" ")
    f.write(str(arguments["selection_scheme"])+" ")
    f.write(str(arguments["selection_threshold"])+" ")
    f.write(str(arguments["model_name"])+"\n")
    f.close()

### Build command line ###
def build_command_line( folder, arguments ):
    cmd_line  = ""
    cmd_line += "python ../../SelectionThreshold.py"
    cmd_line += " -iterations "+str(arguments["iterations"])
    cmd_line += " -mutation-size "+str(arguments["mutation_size"])
    cmd_line += " -selection-scheme "+arguments["selection_scheme"]
    cmd_line += " -selection-threshold "+str(arguments["selection_threshold"])
    cmd_line += " -model-name "+arguments["model_name"]
    cmd_line += " > /dev/null &\n"
    return cmd_line

### Run a thread ###
def run_thread( folder, arguments ):
    print "> Run thread "+folder
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

ARGUMENTS           = {"iterations":10000, "mutation_size":0.1, "selection_scheme":"TFLUX", "selection_threshold":0.0, "model_name":"Holzhutter2004"}
SELECTION_THRESHOLD = [2.0, 1.0, 0.0, -1.0, -2.0, -3.0, -4.0, -5.0, -6.0, -7.0]

if __name__ == '__main__':
    N = len(SELECTION_THRESHOLD)
    for i in range(1, N+1):
        FOLDER                           = str(i)
        ARGUMENTS["selection_threshold"] = SELECTION_THRESHOLD[(i-1)]
        run_thread(FOLDER, ARGUMENTS)
