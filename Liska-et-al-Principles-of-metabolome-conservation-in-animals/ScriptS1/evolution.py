#!/usr/bin/env python3
# coding: utf-8

#***************************************************************************
# MetEvolSim (Metabolome Evolution Simulator)
# -------------------------------------------
# MetEvolSim is a numerical framework dedicated to the study of metabolic
# abundances evolution.
#
# © 2018-2022 Charles Rocabert, Gábor Boross, Orsolya Liska and Balázs Papp
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
import metevolsim


##################
#      MAIN      #
##################

###################################################################
# USAGE:
# 1) Uncomment correct lines to select the kinetic model to run.
# 2) Set the CopasiSE path.
# Simulation outputs are saved in the folder "ouput".
###################################################################

#-----------------------------------------------#
# 1) Mulquiney et al. (1999) erythrocyte model  #
#-----------------------------------------------#
#sbml      = "model/mulquiney1999.xml"
#targets   = [["vatpase", 1.0], ["vox", 1.0], ["vbpgsp7", 1.0]]
#threshold = 1e-5

#-----------------------------------------------#
# 2) Holzhutter et al. (2004) erythrocyte model #
#-----------------------------------------------#
sbml      = "model/holzhutter2004.xml"
targets   = [["v_9", 1.0], ["v_16", 1.0], ["v_21", 1.0], ["v_26", 1.0]]
threshold = 1e-4

#-----------------------------------------------#
# 3) Koenig et al. (2012) hepatocyte model      #
#-----------------------------------------------#
#sbml      = "model/koenig2012.xml"
#targets   = [["GS", 1.0], ["GP", 1.0], ["PC", 1.0], ["PDH", 1.0]]
#threshold = 1e-2

# Provide here the path of CopasiSE
copasi  = Path to CopasiSE

# Load a Markov Chain Monte Carlo (MCMC) instance
mcmc = metevolsim.MCMC(sbml_filename=sbml, objective_function=targets, total_iterations=10000, sigma=0.01, selection_scheme="RELATIVE_TARGET_FLUXES_SELECTION", selection_threshold=threshold, copasi_path=copasi)

# Initialize the MCMC instance
mcmc.initialize()

# Compute the successive iterations and write output files
stop_MCMC = False
while not stop_MCMC:
    stop_mcmc = mcmc.iterate()
    mcmc.write_output_file()
    mcmc.write_statistics()

