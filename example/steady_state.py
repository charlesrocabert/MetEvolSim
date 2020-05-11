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

print("> Number of species: "+str(model.get_number_of_species()))
print("> Number of variable species: "+str(model.get_number_of_variable_species()))
print("> Number of reactions: "+str(model.get_number_of_reactions()))
print("> Number of kinetic parameters: "+str(model.get_number_of_parameters()))

model.compute_wild_type_steady_state()
