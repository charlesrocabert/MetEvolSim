#!/usr/bin/env python
# coding: utf-8

import os
import sys
import numpy as np
import subprocess
import threading
from threading import Thread

### Build command line ###
def build_command_line( folder, arguments ):
    cmd_line  = ""
    cmd_line += "cd "+folder+"\n"
    cmd_line += "python ../../SelectionThreshold.py"
    cmd_line += " -iterations "+str(arguments["iterations"])
    cmd_line += " -mutation-size "+str(arguments["mutation_size"])
    cmd_line += " -selection-scheme "+arguments["selection_scheme"]
    cmd_line += " -selection-threshold "+str(arguments["selection_threshold"])
    cmd_line += " -model-name "+arguments["model_name"]
    cmd_line += "\n"
    cmd_line += "cd ..\n"
    return cmd_line

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

### MetEvolSim thread ###
class MetEvolSim_thread(Thread):
    ### Constructor ###
    def __init__(self, folder, arguments):
        Thread.__init__(self)
        self.folder    = folder
        self.arguments = arguments.copy()
    ### Run thread ###
    def run( self ):
        print "> Running thread "+self.folder
        os.system("rm -rf "+self.folder)
        os.mkdir(self.folder)
        os.mkdir(self.folder+"/output")
        os.system("cp -r resources "+self.folder+"/.")
        write_parameters(self.folder, self.arguments)
        cmd_line = build_command_line(self.folder, self.arguments)
        os.system(cmd_line)

### Run thread ###
# def run_thread( folder, arguments ):
#     print "> Running thread "+folder
#     os.system("rm -rf "+folder)
#     os.mkdir(folder)
#     os.mkdir(folder+"/output")
#     os.system("cp -r resources "+folder+"/.")
#     write_parameters(folder, arguments)
#     cmd_line = build_command_line(folder, arguments)
#     os.system(cmd_line)

##################
#      MAIN      #
##################

ARGUMENTS           = {"iterations":10000, "mutation_size":0.1, "selection_scheme":"TFLUX", "selection_threshold":0.0, "model_name":"Holzhutter2004"}
SELECTION_THRESHOLD = [2.0, 1.0, 0.0, -1.0, -2.0, -3.0, -4.0, -5.0, -6.0, -7.0]

if __name__ == '__main__':
    
    threading.Semaphore(value=4)
    
    THREADS = {}
    N       = len(SELECTION_THRESHOLD)
    for i in range(1, N+1):
        FOLDER                           = str(i)
        ARGUMENTS["selection_threshold"] = SELECTION_THRESHOLD[(i-1)]
        #thread = threading.Thread(target=run_thread, args=(FOLDER,ARGUMENTS,))
        #THREADS.append(thread)
        THREADS[i] = MetEvolSim_thread(FOLDER, ARGUMENTS)
    for i in range(1, N+1):
        THREADS[i].start()
    for i in range(1, N+1):
        THREADS[i].join()
    
