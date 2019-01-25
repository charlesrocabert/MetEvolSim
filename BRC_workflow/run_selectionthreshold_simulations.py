#!/usr/bin/env python
# coding: utf-8

import os
import sys
import time
import numpy as np
import subprocess

### Save parameters in a local file ###
def write_parameters( folder, arguments ):
    f = open(str(folder)+"/parameters.txt", "w")
    f.write("model_filename iterations mutation_size selection_scheme selection_threshold seed\n")
    f.write(str(arguments["model_filename"])+" ")
    f.write(str(arguments["iterations"])+" ")
    f.write(str(arguments["mutation_size"])+" ")
    f.write(str(arguments["selection_scheme"])+" ")
    f.write(str(arguments["selection_threshold"])+" ")
    f.write(str(arguments["seed"])+"\n")
    f.close()

### Build command line ###
def build_command_line( arguments ):
    cmd_line  = ""
    cmd_line += "python ../../MetEvolSim_run.py"
    cmd_line += " -model-filename "+str(arguments["model_filename"])
    cmd_line += " -iterations "+str(arguments["iterations"])
    cmd_line += " -mutation-size "+str(arguments["mutation_size"])
    cmd_line += " -selection-scheme "+arguments["selection_scheme"]
    cmd_line += " -selection-threshold "+str(arguments["selection_threshold"])
    cmd_line += " -seed "+str(arguments["seed"])
    cmd_line += " > /dev/null &\n"
    return cmd_line

### Run a thread ###
def run_thread( folder, arguments ):
    os.system("rm -rf "+str(folder))
    os.mkdir(str(folder))
    write_parameters(folder, arguments)
    os.mkdir(str(folder)+"/output")
    os.system("cp -r resources "+str(folder)+"/.")
    cmd_line = build_command_line(arguments)
    os.chdir(str(folder))
    os.system(cmd_line)
    os.chdir("..")

### Check a thread ###
def check_thread( folder ):
    signal = ""
    try:
        f      = open(str(folder)+"/thread_signal.txt", "r")
        signal = f.read().strip("\n")
    except:
        signal = "NONE"
    return signal
    
### Generate the complete list of parameters to run ###
def generate_parameters_list( parameters_set, repetitions ):
    parameters_list = {}
    folder          = 1
    ### For each model filename ###
    for model_filename in parameters_set["model_filename"]:
        ### For each number of iterations ###
        for iterations in parameters_set["iterations"]:
            ### For each mutation size ###
            for mutation_size in parameters_set["mutation_size"]:
                ### For each selection scheme ###
                for selection_scheme in parameters_set["selection_scheme"]:
                    ##### If the selection scheme is MUTATION_ACCUMULATION, ignore the selection threshold #####
                    if selection_scheme == "MUTATION_ACCUMULATION":
                        for repetition in range(1,repetitions+1):
                            parameters_list[folder] = {"model_filename":model_filename, "iterations":iterations, "mutation_size":mutation_size, "selection_scheme": selection_scheme, "selection_threshold":0.0, "seed":np.random.randint(1,100000000), "repetition":repetition, "folder":folder}
                            folder += 1
                    ##### Else if the selection scheme is BIOMASS_FUNCTION or METABOLIC_LOAD, consider the selection threshold #####
                    elif selection_scheme == "BIOMASS_FUNCTION":
                        for selection_threshold in parameters_set["selection_threshold"]:
                            for repetition in range(1,repetitions+1):
                                parameters_list[folder] = {"model_filename":model_filename, "iterations":iterations, "mutation_size":mutation_size, "selection_scheme": selection_scheme, "selection_threshold":selection_threshold, "seed":np.random.randint(1,100000000), "repetition":repetition, "folder":folder}
                                folder += 1
                    elif selection_scheme == "METABOLIC_LOAD":
                        for selection_threshold in parameters_set["selection_threshold"]:
                            for repetition in range(1,repetitions+1):
                                parameters_list[folder] = {"model_filename":model_filename, "iterations":iterations, "mutation_size":mutation_size, "selection_scheme": selection_scheme, "selection_threshold":selection_threshold, "seed":np.random.randint(1,100000000), "repetition":repetition, "folder":folder}
                                folder += 1
    return parameters_list
    
### Generate thread vector ###
def generate_thread_vector( parameters_list ):
    thread_vector = {}
    for item in parameters_list.items():
        #~~~~~~~~~~~~~~~~~~~~~~~#
        # 1) Extract parameters #
        #~~~~~~~~~~~~~~~~~~~~~~~#
        folder     = item[0]
        repetition = item[1]["repetition"]
        arguments  = item[1]
        cmd_line   = build_command_line(arguments)
        #~~~~~~~~~~~~~~~~~~~~~~~#
        # 2) Fill thread vector #
        #~~~~~~~~~~~~~~~~~~~~~~~#
        thread_vector[folder]               = {}
        thread_vector[folder]["state"]      = "NONE"
        thread_vector[folder]["folder"]     = folder
        thread_vector[folder]["repetition"] = repetition
        thread_vector[folder]["arguments"]  = arguments
        thread_vector[folder]["cmd_line"]   = cmd_line
    return thread_vector

### Write the parameters list ###
def write_thread_vector( thread_vector ):
    f = open("threads.txt", "w")
    f.write("state folder repetition model_filename iterations mutation_size selection_scheme selection_threshold seed\n")
    for thread_item in thread_vector.items():
        line  = ""
        line += thread_item[1]["state"]+" "
        line += str(thread_item[1]["folder"])+" "
        line += str(thread_item[1]["repetition"])+" "
        line += thread_item[1]["arguments"]["model_filename"]+" "
        line += str(thread_item[1]["arguments"]["iterations"])+" "
        line += str(thread_item[1]["arguments"]["mutation_size"])+" "
        line += thread_item[1]["arguments"]["selection_scheme"]+" "
        line += str(thread_item[1]["arguments"]["selection_threshold"])+" "
        line += str(thread_item[1]["arguments"]["seed"])+"\n"
        f.write(line)
    f.close()


##################
#      MAIN      #
##################


MODEL_FILENAME      = np.array(["holzhutter2004.xml"])
ITERATIONS          = np.array([10000])
MUTATION_SIZE       = np.array([0.01])
SELECTION_SCHEME    = np.array(["MUTATION_ACCUMULATION", "BIOMASS_FUNCTION", "METABOLIC_LOAD"])
SELECTION_THRESHOLD = np.arange(2.0, -8.0, -1.0)
PARAMETERS_SET      = {"model_filename":MODEL_FILENAME, "iterations":ITERATIONS, "mutation_size":MUTATION_SIZE, "selection_scheme":SELECTION_SCHEME, "selection_threshold":SELECTION_THRESHOLD}
REPETITIONS         = 100
NB_MAX_THREADS      = 30

parameters_list = generate_parameters_list(PARAMETERS_SET, REPETITIONS)
thread_vector   = generate_thread_vector(parameters_list)

nb_running_threads = 0
end_of_task        = False

while not end_of_task:
    
    for thread_item in thread_vector.items():
        folder = thread_item[1]["folder"]
        signal = check_thread(folder)
        if thread_item[1]["state"] == "NONE" and nb_running_threads < NB_MAX_THREADS:
            run_thread(folder, thread_item[1]["arguments"])
            thread_item[1]["state"] = "WAIT"
            nb_running_threads += 1
        elif thread_item[1]["state"] == "WAIT" and signal == "END":
            thread_item[1]["state"] = "END"
            nb_running_threads -= 1
    if nb_running_threads == 0:
        end_of_task = True
    write_thread_vector(thread_vector)
    print "> Number of running threads: "+str(nb_running_threads)
    time.sleep(3)

print "> End of task."        
