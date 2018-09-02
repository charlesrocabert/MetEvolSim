#!/usr/bin/env python
# coding: utf-8

import os
import sys
import subprocess
import random

### Get the command line ###
def get_command_line( exec_path, seed, generations, n, sigma, mu, w, alpha, beta, Q, PC ):
	line  = exec_path
	line += " -seed "+str(seed)
	line += " -generations "+str(generations)
	line += " -n "+str(n)
	line += " -sigma "+str(sigma)
	line += " -mu "+str(mu)
	line += " -w "+str(w)
	line += " -alpha "+str(alpha)
	line += " -beta "+str(beta)
	line += " -Q "+str(Q)
	if PC:
		line += " -PC"
	line += "\n"
	return line


##################
#      MAIN      #
##################

NB_REP      = 100
EXEC_PATH   = "../../build/bin/run"
GENERATIONS = 10000
N           = 1000
SIGMA       = 0.01
MU          = 1e-03
W           = 1e-05
ALPHA       = 0.5
BETA        = 0.0
Q           = 2.0
PC          = True

for rep in range(1, NB_REP+1):
	os.system("rm -rf "+str(rep))
	os.mkdir(str(rep))
	os.chdir(str(rep))
	os.mkdir("ancestor")
	os.mkdir("best")
	os.mkdir("parameters")
	os.mkdir("population")
	seed         = random.randint(10, 10000000)
	command_line = get_command_line(EXEC_PATH, seed, GENERATIONS, N, SIGMA, MU, W, ALPHA, BETA, Q, PC)
	print "> Launching repetition "+str(rep)+" ..."
	os.system(command_line)





