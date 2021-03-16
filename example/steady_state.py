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
# This Python script simply computes the steady-state of the erythrocyte
# metabolism model from Holzhutter et al. (2004).
#
# Prior to the usage of this script, the user must intall MetEvolSim python
# package using the following commande line:
#     > pip install MetEvolSim
# and also download CopasiSE define the path to CopasiSE below.
################################################################################

sbml   = "./model/erythrocyte_metabolism.xml"
copasi = "Path to CopasiSE" # Define here the path to CopasiSE

# Load the SBML model
model  = metevolsim.Model(sbml, [], copasi)

# Show some informations about the model
print("> Number of species: "+str(model.get_number_of_species()))
print("> Number of variable species: "+str(model.get_number_of_variable_species()))
print("> Number of reactions: "+str(model.get_number_of_reactions()))
print("> Number of kinetic parameters: "+str(model.get_number_of_parameters()))

# Compute the steady-state of the original (wild-type) model
model.compute_wild_type_steady_state()
