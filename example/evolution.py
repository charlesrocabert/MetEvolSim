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
sys.path.append("/Users/charlesrocabert/git/MetEvolSim-development/metevolsim/")
import metevolsim

##################
#      MAIN      #
##################

sbml    = "model/holzhutter2004.xml"
copasi  = "/Applications/COPASI/CopasiSE"
targets = [["v_9", 1.0], ["v_16", 1.0], ["v_21", 1.0], ["v_26", 1.0]]

# Load a Markov Chain Monte Carlo (MCMC) instance
mcmc = metevolsim.MCMC(sbml_filename=sbml, objective_function=targets, total_iterations=10000, sigma=0.01, selection_scheme="RELATIVE_TARGET_FLUXES_SELECTION", selection_threshold=1e-4, copasi_path=copasi)

# Initialize the MCMC instance 
mcmc.initialize()

# Compute the successive iterations and write output files
stop_MCMC = False
while not stop_MCMC:
    stop_mcmc = mcmc.iterate()
    mcmc.write_output_file()
    mcmc.write_statistics()