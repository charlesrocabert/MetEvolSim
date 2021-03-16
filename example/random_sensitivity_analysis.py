#!/usr/bin/env python3
# coding: utf-8

#***************************************************************************
# MetEvolSim (Metabolome Evolution Simulator)
# -------------------------------------------
# MetEvolSim is a numerical framework dedicated to the study of metabolic
# abundances evolution.
#
# Copyright (c) 2018-2021 Charles Rocabert, Gábor Boross, Balázs Papp
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

################################################################################
# This Python script computes a random sensitivity analysis on the erythrocyte
# metabolism model from Holzhutter et al. (2004).
# See https://github.com/charlesrocabert/MetEvolSim/blob/master/README.md
# for a detailed explanation of the random sensitivity analysis approach.
#
# Prior to the usage of this script, the user must intall MetEvolSim python
# package using the following commande line:
#     > pip install MetEvolSim
# and also download CopasiSE define the path to CopasiSE below.
################################################################################

sbml   = "./model/erythrocyte_metabolism.xml"
copasi = "Path to CopasiSE" # Define here the path to CopasiSE

# Load a sensitivity analysis instance
sa = metevolsim.SensitivityAnalysis(sbml, copasi)

# Run the random sensitivity analysis
sa.run_random_analysis(sigma=0.01, nb_iterations=1000)
