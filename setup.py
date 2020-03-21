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


"""MetEvolSim (Metabolome Evolution Simulator) Python Package.

See:
https://github.com/charlesrocabert/MetEvolSim
"""

from setuptools import setup, find_packages
from os import path

here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.md'), encoding='utf-8') as f:
	long_description = f.read()

setup(
	name                          = "MetEvolSim",
	version                       = "0.4.10",
	license                       = "GNU General Public License v3 (GPLv3)",
	description                   = "MetEvolSim (Metabolome Evolution Simulator) Python Package",
	long_description              = long_description,
	long_description_content_type = "text/markdown",
	url                           = "https://github.com/charlesrocabert/MetEvolSim",
	author                        = "Charles Rocabert, Gábor Boross, Balázs Papp",
	author_email                  = "",
	classifiers = [
		"Development Status :: 4 - Beta",
		"Programming Language :: Python :: 3",
		"License :: OSI Approved :: GNU General Public License v3 (GPLv3)",
		"Operating System :: OS Independent",
		"Intended Audience :: Science/Research",
		"Topic :: Scientific/Engineering :: Bio-Informatics",
	],
	keywords         = "metabolism abundances evolution metabolic-network kinetic-model evolution-rate",
	packages         = find_packages(exclude=["contrib", "docs", "tests"]),
	python_requires  = ">=3",
	install_requires = ["python-libsbml", "numpy", "networkx"],
	project_urls     = {
	"Source": "https://github.com/charlesrocabert/MetEvolSim"
	},
)
