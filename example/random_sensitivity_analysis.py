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
sbml   = "model/holzhutter2004.xml"
copasi = "/Applications/COPASI/CopasiSE"
model  = metevolsim.Model(sbml, [], copasi)

sa = metevolsim.SensitivityAnalysis(sbml, copasi)
sa.run_random_analysis(sigma=0.01, nb_iterations=1000)
