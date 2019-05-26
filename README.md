<h1 align="center">MetEvolSim</h1>
<p align="center">
    Numerical tools dedicated to the evolution of metabolic concentrations
    <br/><br/>
    <a href="https://github.com/charlesrocabert/MetEvolSim/releases/latest"><img src="https://img.shields.io/badge/pypi package- 0.1.0-orange.svg" /></a>&nbsp;<a href="https://www.gnu.org/licenses/gpl-3.0"><img src="https://img.shields.io/badge/license-GPL v3-blue.svg" /></a>&nbsp;
    <br/>
    <img src="logo/metevolsim_logo.png" width=150>
</p>

-----------------

<p align="justify">
MetEvolSim is a Python package providing numerical tools to study the long-term evolution of metabolic concentrations.
MetEvolSim takes as an input any <a href="http://sbml.org/Main_Page">SBML</a> metabolic network model, as soon as kinetic parameters and initial metabolic concentrations are specified. Steady-state concentrations are computed thanks to <a href="http://copasi.org/">Copasi</a> software.
</p>

<p align="justify">
MetEvolSim is being developed by Charles Rocabert, Gábor Boross and Balázs Papp.
</p>

<p align="center">
<img src="logo/BRC_logo.png" height="100px"></a>&nbsp;&nbsp;&nbsp;<img src="logo/MTA_logo.png" height="100px"></a>
</p>

## Table of contents
- [Installation](#installation)
- [First usage](#first_usage)
- [Help](#help)
- [Copyright](#copyright)
- [License](#license)

## Installation <a name="installation"></a>
&bullet; To install Copasi software, visit http://copasi.org/.

&bullet; To install Python dependencies:
```
pip install numpy python-libsbml
```

&bullet; To install the current release of MetEvolSim:
<strike>
```
pip install metevolsim
```
</strike>

## First usage <a name="first_usage"></a>
MetEvolSim takes as an input any <a href="http://sbml.org/Main_Page">SBML</a> metabolic network model, as soon as kinetic parameters and initial metabolic concentrations are specified. MetEvolSim provides a class to manipulate SBML models: the class <code>Model</code>. It is also necessary to define an objective function (a list of reaction names and coefficients), and to provide the path of CopasiSE software.

```python
# Import metevolsim package
import metevolsim

# Create an objective function
objective_function = [['ATPase', 1.0], ['PDC', 1.0]]

# Load the SBML metabolic model
model = metevolsim.Model('glycolysis.xml', objective_function, '/Applications/COPASI/CopasiSE')

# Print some informations on the metabolic model
print(model.get_number_of_species())
print(model.get_WT_species_value('Glc'))

# Get a kinetic parameter at random
param = model.get_random_parameter()
print(param)

# Mutate this kinetic parameter with a log-scale mutation size 0.01
model.random_parameter_mutation(param, sigma=0.01)

# Compute wild-type and mutant steady-states
model.compute_WT_steady_state()
model.compute_mutant_steady_state()
```

MetEvolSim allows two types of numerical analyses on a SBML metabolic model:
- <strong>Evolution experiments</strong>, based on a Markov Chain Monte Carlo (MCMC) algorithm,
- <strong>Sensitivity analysis</strong>, by exploring every kinetic parameters in a given range and recording associated fluxes and metabolic abundances changes.

### Evolution experiments:
Three types of evolution experiments are availables:
- <code>MUTATION_ACCUMULATION</code>: Run a mutation accumulation experiment by keeping all new mutations without any selection,
- <code>METABOLIC_SUM_SELECTION</code>: Run an evolution experiment by applying a stabilizing selection on the sum of metabolic abundances,
- <code>TARGET_FLUXES_SELECTION</code>: Run an evolution experiment by applying a stabilizing selection on the objective function.

```python
# Load a Markov Chain Monte Carlo (MCMC) instance
mcmc = metevolsim.MCMC('glycolysis.xml', objective_function, total_iterations=10000, sigma=0.01, selection_scheme="MUTATION_ACCUMULATION", selection_threshold=1e-4)

# Initialize the MCMC instance 
mcmc.initialize()

# Compute the successive iterations and write output files
stop_MCMC = False
while not stop_MCMC:
    stop_mcmc = mcmc.iterate()
    mcmc.write_output_file()
    mcmc.write_statistics()
```

### Sensitivity analysis:
```python
# Load a sensitivity analysis instance
sa = metevolsim.SensitivityAnalysis('glycolysis.xml', factor_range=1.0, factor_step=0.01)

# Initialize the sensitivity analysis instance 
sa.initialize()

# Perform the sensitivity analysis for each kinetic parameter
stop_SA = False
while not stop_SA:
    stop_SA = sa.explore_next_parameter()
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
Copyright &copy; 2018-2019 Charles Rocabert, Gábor Boross and Balázs Papp.
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
