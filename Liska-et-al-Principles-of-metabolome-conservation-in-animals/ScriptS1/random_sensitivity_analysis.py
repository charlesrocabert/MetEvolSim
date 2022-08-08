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
#sbml = "model/mulquiney1999.xml"

#-----------------------------------------------#
# 2) Holzhutter et al. (2004) erythrocyte model #
#-----------------------------------------------#
sbml = "model/holzhutter2004.xml"

#-----------------------------------------------#
# 3) Koenig et al. (2012) hepatocyte model      #
#-----------------------------------------------#
#sbml = "model/koenig2012.xml"

# Provide here the path of CopasiSE
copasi = Path to CopasiSE

# Instanciate the model
model  = metevolsim.Model(sbml, [], copasi)

# Instanciate the sensitivity analysis and run a random analysis
sa = metevolsim.SensitivityAnalysis(sbml, copasi)
sa.run_random_analysis(sigma=0.01, nb_iterations=1000)

