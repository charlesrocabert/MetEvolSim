#!/usr/bin/env python
# coding: utf-8

import os
import sys
import numpy as np
import matplotlib.pyplot as plt

### Read parameters file ###
def read_parameter_file( index ):
    f = open("collected/parameters_"+str(index)+".txt", "r")
    l = f.readline()
    l = f.readline().strip("\n").split(" ")
    parameters                        = {}
    parameters["iterations"]          = l[0]
    parameters["log_mutation_size"]   = l[1]
    parameters["selection_scheme"]    = l[2]
    parameters["selection_threshold"] = l[3]
    parameters["model_name"]          = l[4]
    f.close()
    return parameters

### Load parameters map ###
def load_parameters( index_min, index_max ):
    PARAMETERS = {}
    for index in range(index_min, index_max+1):
        params = read_parameter_file(index)
        if params["selection_scheme"] == "NO_SELECTION":
            if "NO_SELECTION" not in PARAMETERS.keys():
                PARAMETERS["NO_SELECTION"]     = {}
                PARAMETERS["NO_SELECTION"][1] = index
            else:
                reps = max(PARAMETERS["NO_SELECTION"].keys())
                PARAMETERS["NO_SELECTION"][reps+1] = index
        else:
            if params["selection_threshold"] not in PARAMETERS.keys():
                PARAMETERS[params["selection_threshold"]]    = {}
                PARAMETERS[params["selection_threshold"]][1] = index
            else:
                reps = max(PARAMETERS[params["selection_threshold"]].keys())
                PARAMETERS[params["selection_threshold"]][reps+1] = index
    return PARAMETERS

### Compute CV ###
def get_ancestor_concentration_and_CV( index ):
    f         = open("collected/experiment_"+str(index)+".txt", "r")
    header    = f.readline().strip("\n").split(" ")
    l         = f.readline()
    NAMES     = []
    MEAN      = []
    SD        = []
    CV        = []
    read_data = False
    for i in range(len(header)):
        if header[i] == "ADPf":
            read_data = True
        if header[i] == "v_1":
            read_data = False
        if read_data:
            NAMES.append(header[i])
    nb_lines = 0.0
    while l:
        l         = l.strip("\n").split(" ")
        read_data = False
        counter   = 0
        for i in range(len(header)):
            ### Check variable name ###
            if header[i] == "ADPf":
                read_data = True
            elif header[i] == "v_1":
                read_data = False
            ### Save data ###
            if read_data and nb_lines == 0.0:
                val = float(l[i])
                MEAN.append(val)
                SD.append(val*val)
                CV.append(val*val)
            elif read_data and nb_lines > 0.0:
                val            = float(l[i])
                MEAN[counter] += val
                SD[counter]   += val*val
                CV[counter]   += val*val
                counter       += 1
        nb_lines += 1.0
        l         = f.readline()
    f.close()
    for i in range(len(NAMES)):
        MEAN[i] /= nb_lines
        SD[i]   /= nb_lines
        CV[i]   /= nb_lines
        SD[i]   -= MEAN[i]*MEAN[i]
        CV[i]   -= MEAN[i]*MEAN[i]
        SD[i]    = np.sqrt(SD[i])
        CV[i]    = np.sqrt(CV[i])
        CV[i]   /= MEAN[i]
    return MEAN, SD, CV

### Get WT and mutant target fluxes sums ###
def get_wt_mutant_tflux( index ):
    # wt_tflux mutant_tflux
    f         = open("collected/experiment_"+str(index)+".txt", "r")
    header    = f.readline().strip("\n").split(" ")
    l         = f.readline()
    WT_TFLUX  = []
    MUT_TFLUX = []
    while l:
        l = l.strip("\n").split(" ")
        for i in range(len(header)):
            if header[i] == "wt_tflux":
                WT_TFLUX.append(float(l[i]))
            elif header[i] == "mutant_tflux":
                MUT_TFLUX.append(float(l[i]))
        l = f.readline()
    f.close()
    return WT_TFLUX, MUT_TFLUX

### Save parameters map in a file ###
def save_parameters_map( parameters ):
    f = open("parameter_map.txt", "w")
    f.write("threshold rep index\n")
    for th in parameters.keys():
        for rep in parameters[th].keys():
            f.write(str(th)+" "+str(rep)+" "+str(parameters[th][rep])+"\n")
    f.close()
        

##################
#      MAIN      #
##################
#plt.ion()

INDEX_MIN  = 1
INDEX_MAX  = 90
PARAMETERS = load_parameters(INDEX_MIN, INDEX_MAX)

save_parameters_map(PARAMETERS)

# ANC_MEAN, ANC_SD, ANC_CV = get_ancestor_concentration_and_CV(1)
# 
# for item in PARAMETERS.items():
#     MUTANT_MEAN = [0.0]*len(ANC_MEAN)
#     MUTANT_CV   = [0.0]*len(ANC_CV)
#     counter     = 0.0
#     for rep in item[1].keys():
#         index = item[1][rep]
#         MUT_MEAN, MUT_SD, MUT_CV = get_ancestor_concentration_and_CV(index)
#         for i in range(len(MUT_MEAN)):
#             MUTANT_MEAN[i] += MUT_MEAN[i]
#             MUTANT_CV[i]   += MUT_CV[i]
#         counter += 1.0
#     for i in range(len(MUTANT_MEAN)):
#         MUTANT_MEAN[i] /= counter
#         MUTANT_CV[i] /= counter
#     plt.clf()
#     plt.loglog(MUTANT_MEAN, MUTANT_CV, "o")
#     plt.title("Threshold = "+item[0])
#     plt.draw()









###
