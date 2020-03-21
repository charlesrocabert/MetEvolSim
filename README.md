<h1 align="center">MetEvolSim</h1>
<p align="center">
    Python package dedicated to the evolution of metabolic concentrations
    <br/><br/>
    <a href="https://pypi.python.org/pypi/MetEvolSim/"><img src="https://badge.fury.io/py/MetEvolSim.svg" /></a>
    <a href="https://action-badges.now.sh/charlesrocabert/MetEvolSim"><img src="https://action-badges.now.sh/charlesrocabert/MetEvolSim" /></a>
    <a href="https://github.com/charlesrocabert/MetEvolSim/LICENSE.html"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg" /></a>
    <br/>
    <img src="https://github.com/charlesrocabert/MetEvolSim/raw/master/pic/metevolsim_logo.png" width=150>
</p>

-----------------

<p align="justify">
MetEvolSim is a Python package providing numerical tools to study the long-term evolution of metabolic concentrations.
MetEvolSim takes as an input any <a href="http://sbml.org/Main_Page">SBML</a> metabolic network model, as soon as the kinetic model is fully specified, and a stable steady-state exists. Steady-state concentrations are computed thanks to <a href="http://copasi.org/">Copasi</a> software.
</p>

<p align="justify">
MetEvolSim is being developed by <a href="https://github.com/charlesrocabert">Charles Rocabert</a>, <a href="https://scholar.google.com/citations?user=8ZmiMp4AAAAJ&hl=da">Gábor Boross</a> and <a href="group.szbk.u-szeged.hu › papp-balazs-lab-index">Balázs Papp</a>.
</p>

<p align="center">
<img src="https://github.com/charlesrocabert/MetEvolSim/raw/master/pic/BRC_logo.png" height="100px"></a>&nbsp;&nbsp;&nbsp;<img src="https://github.com/charlesrocabert/MetEvolSim/raw/master/pic/MTA_logo.png" height="100px"></a>
</p>

## Table of contents
- [Dependencies](#dependencies)
- [Installation](#installation)
- [First usage](#first_usage)
- [Help](#help)
- [Copyright](#copyright)
- [License](#license)

## Dependencies <a name="dependencies"></a>
- Python &ge; 3,
- Numpy &ge; 1.15 (automatically installed when using pip),
- Python-libsbml &ge; 5.17 (automatically installed when using pip),
- NetworkX &ge; 2.2 (automatically installed when using pip),
- pip &ge; 19.1 (optional).

## Installation <a name="installation"></a>
&bullet; To install Copasi software, visit http://copasi.org/.

&bullet; To install the current release of MetEvolSim:
```shell
pip install MetEvolSim
```

Alternatively, download the <a href="https://github.com/charlesrocabert/MetEvolSim/releases/latest">latest release</a> in the folder of your choice and unzip it. Then follow the instructions below:
```shell
# Navigate to the MetEvolSim folder
cd /path/to/MetEvolSim

# Install MetEvolSim Python package
python3 setup.py install
```

## First usage <a name="first_usage"></a>
MetEvolSim takes as an input any <a href="http://sbml.org/Main_Page">SBML</a> metabolic network model, as soon as kinetic parameters and initial metabolic concentrations are specified, and a stable steady-state exists. The package provides a class to manipulate SBML models: the class <code>Model</code>. It is also necessary to define an objective function (a list of reactions and their coefficients), and to provide the path of <a href="http://copasi.org/">CopasiSE</a> software.

```python
# Import MetEvolSim package
import metevolsim

# Create an objective function
target_fluxes = [['ATPase', 1.0], ['PDC', 1.0]]

# Load the SBML metabolic model
model = metevolsim.Model(sbml_filename='glycolysis.xml', objective_function=target_fluxes, copasi_path='/Applications/COPASI/CopasiSE')

# Print some informations on the metabolic model
print(model.get_number_of_species())
print(model.get_wild_type_species_value('Glc'))

# Get a kinetic parameter at random
param = model.get_random_parameter()
print(param)

# Mutate this kinetic parameter with a log-scale mutation size 0.01
model.random_parameter_mutation(param, sigma=0.01)

# Compute wild-type and mutant steady-states
model.compute_wild_type_steady_state()
model.compute_mutant_steady_state()

# Run a metabolic control analysis on the wild-type
model.compute_wild_type_metabolic_control_analysis()
# This function will output two datasets:
# - output/wild_type_MCA_unscaled.txt containing unscaled control coefficients,
# - output/wild_type_MCA_scaled.txt containing scaled control coefficients.

# Compute all pairwise metabolite shortest paths
model.build_species_graph()
model.save_shortest_paths(filename="glycolysis_shortest_paths.txt")
```

MetEvolSim offers two specific numerical approaches to analyze the evolution of metabolic abundances:
- <strong>Evolution experiments</strong>, based on a Markov Chain Monte Carlo (MCMC) algorithm,
- <strong>Sensitivity analysis</strong>, either by exploring every kinetic parameters in a given range and recording associated fluxes and metabolic abundances changes (One-At-a-Time sensitivity analysis), or by exploring the kinetic parameters space at random, by mutating a single kinetic parameter at random many times (random sensitivity analysis).

All numerical analyses output files are saved in a subfolder <code>output</code>.

### Evolution experiments:
<p align="center">
<img src="https://github.com/charlesrocabert/MetEvolSim/raw/master/pic/mcmc_algorithm.png" height="200px">
</p>
<p align="justify">
<strong>Algorithm overview:</strong> <strong>A.</strong> The model of interest is loaded as a wild-type from a SBML file (kinetic equations, kinetic parameter values and initial metabolic concentrations must be specified). <strong>B.</strong> At each iteration <em>t</em>, a single kinetic parameter is selected at random and mutated through a log10-normal distribution of standard deviation &sigma;. <strong>C.</strong> The new steady-state is computed using Copasi software, and the MOMA distance <em>z</em> between the mutant and the wild-type target fluxes is computed. <strong>D.</strong> If <em>z</em> is under a given selection threshold &omega;, the mutation is accepted. Else, the mutation is discarded. <strong>E.</strong> A new iteration <em>t+1</em> is computed.
</p>

<br/>
Six types of selection are available:

- <code>MUTATION_ACCUMULATION</code>: Run a mutation accumulation experiment by accepting all new mutations without any selection threshold,
- <code>ABSOLUTE_METABOLIC_SUM_SELECTION</code>: Run an evolution experiment by applying a stabilizing selection on the sum of absolute metabolic abundances,
- <code>RELATIVE_METABOLIC_SUM_SELECTION</code>: Run an evolution experiment by applying a stabilizing selection on the sum of relative metabolic abundances,
- <code>ABSOLUTE_TARGET_FLUXES_SELECTION</code>: Run an evolution experiment by applying a stabilizing selection on the MOMA distance of absolute target fluxes,
- <code>RELATIVE_TARGET_FLUXES_SELECTION</code>: Run an evolution experiment by applying a stabilizing selection on the MOMA distance of relative target fluxes.

```python
# Load a Markov Chain Monte Carlo (MCMC) instance
mcmc = metevolsim.MCMC(sbml_filename='glycolysis.xml', objective_function=target_fluxes, total_iterations=10000, sigma=0.01, selection_scheme="MUTATION_ACCUMULATION", selection_threshold=1e-4, copasi_path='/Applications/COPASI/CopasiSE')

# Initialize the MCMC instance 
mcmc.initialize()

# Compute the successive iterations and write output files
stop_MCMC = False
while not stop_MCMC:
    stop_mcmc = mcmc.iterate()
    mcmc.write_output_file()
    mcmc.write_statistics()
```

### One-At-a-Time (OAT) sensitivity analysis:
For each kinetic parameter p, each metabolic abundance [X<sub>i</sub>] and each flux &nu;<sub>j</sub>, the algorithm numerically computes relative derivatives and control coefficients.

```python
# Load a sensitivity analysis instance
sa = metevolsim.SensitivityAnalysis(sbml_filename='glycolysis.xml', copasi_path='/Applications/COPASI/CopasiSE')

# Run the full OAT sensitivity analysis
sa.run_OAT_analysis(factor_range=1.0, factor_step=0.01)
```

### Random sensitivity analysis:
At each iteration, a single kinetic parameter p is mutated at random in a log10-normal distribution of size &sigma;, and relative derivatives and control coefficients are computed.

```python
# Load a sensitivity analysis instance
sa = metevolsim.SensitivityAnalysis(sbml_filename='glycolysis.xml', copasi_path='/Applications/COPASI/CopasiSE')

# Run the full OAT sensitivity analysis
sa.run_random_analysis(sigma=0.01, nb_iterations=1000)
```

## Help <a name="help"></a>
To get some help on a MetEvolSim class or method, use the Python help function:
```python
help(metevolsim.Model.set_species_initial_value)
```
to obtain a quick description and the list of parameters and outputs:
```
Help on function set_species_initial_value in module metevolsim:

set_species_initial_value(self, species_id, value)
    Set the initial concentration of the species 'species_id' in the
    mutant model.
    
    Parameters
    ----------
    species_id: str
            Species identifier (as defined in the SBML model).
    value: float >= 0.0
            Species abundance.
            
    Returns
    -------
    None
(END)
```

## Copyright <a name="copyright"></a>
Copyright &copy; 2018-2020 Charles Rocabert, Gábor Boross and Balázs Papp.
All rights reserved.

## License <a name="license"></a>
<p align="justify">
This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
</p>

<p align="justify">
This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
</p>

<p align="justify">
You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.
</p>
