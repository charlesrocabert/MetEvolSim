#!/usr/bin/env python
# coding: utf-8

import os
import sys

### Collect data ###
def collect_data( repetitions, folder ):
    FOLDER = folder
    for rep in range(repetitions):
        print "> Collecting thread "+str(rep)+"..."
        os.system("cp "+str(FOLDER)+"/parameters.txt collected/parameters_"+str(FOLDER)+".txt")
        os.system("cp "+str(FOLDER)+"/output/iterations.txt collected/iterations_"+str(FOLDER)+".txt")
        os.system("cp "+str(FOLDER)+"/output/statistics.txt collected/statistics_"+str(FOLDER)+".txt")
        FOLDER += 1


##################
#      MAIN      #
##################

ARGUMENTS   = {"model_filename":"holzhutter2004.xml", "iterations":10000, "mutation_size":0.01, "selection_scheme":"MUTATION_ACCUMULATION", "selection_threshold":0.0, "seed":0}
REPETITIONS = 1
FOLDER      = 1

if __name__ == '__main__':
    collect_data(REPETITIONS, FOLDER)
