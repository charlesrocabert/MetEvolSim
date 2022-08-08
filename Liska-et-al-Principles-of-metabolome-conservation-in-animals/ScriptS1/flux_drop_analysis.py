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
import libsbml
import numpy as np
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
#sbml    = "model/mulquiney1999.xml"
#targets = [["vatpase", 1.0], ["vox", 1.0], ["vbpgsp7", 1.0]]

#-----------------------------------------------#
# 2) Holzhutter et al. (2004) erythrocyte model #
#-----------------------------------------------#
sbml    = "model/holzhutter2004.xml"
targets = [["v_9", 1.0], ["v_16", 1.0], ["v_21", 1.0], ["v_26", 1.0]]

#-----------------------------------------------#
# 3) Koenig et al. (2012) hepatocyte model      #
#-----------------------------------------------#
#sbml    = "model/koenig2012.xml"
#targets = [["GS", 1.0], ["GP", 1.0], ["PC", 1.0], ["PDH", 1.0]]

# Provide here the path of CopasiSE
copasi  = Path to CopasiSE

# Run the flux drop analysis for a range of drop coefficients in [0, 1]
drop_coefficients = 10**np.arange(0.0, -5.1, -0.1)
for coef in drop_coefficients:
    print("> Computing flux drop for "+str(round(coef,6)))
    model = metevolsim.Model(sbml, targets, copasi)
    model.flux_drop_analysis(coef, "flux_drop_analysis_bis.txt", False)

