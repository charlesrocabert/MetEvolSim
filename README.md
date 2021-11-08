<p align="center">
    <img src="https://github.com/charlesrocabert/MetEvolSim/raw/master/pic/metevolsim_logo.png" width=300>
</p>
<p align="center">
    <em>Metabolome Evolution Simulator</em>
    <br/><br/>
    A Python package to simulate the long-term evolution of metabolic levels.
    <br/><br/>
    <a href="https://pypi.python.org/pypi/MetEvolSim/"><img src="https://badge.fury.io/py/metevolsim.svg" /></a>
    <a href="https://github.com/charlesrocabert/MetEvolSim/actions"><img src="https://github.com/charlesrocabert/MetEvolSim/workflows/Upload Python Package/badge.svg" /></a>&nbsp;
    <a href="https://github.com/charlesrocabert/MetEvolSim/LICENSE.html"><img src="https://img.shields.io/badge/License-GPLv3-blue.svg" /></a>
</p>

-----------------

<p align="justify">
MetEvolSim (<em>Metabolome Evolution Simulator</em>) is a Python package providing numerical tools to simulate the long-term evolution of all metabolic abundances in a metabolic network.
MetEvolSim takes as an input a <a href="http://sbml.org/Main_Page" target="_blank">SBML-formatted</a> metabolic network model. Kinetic parameters and initial metabolic concentrations must be specified, and the model must reach a stable steady-state. Steady-state concentrations are computed thanks to <a href="http://copasi.org/" target="_blank">Copasi</a> software.
</p>

<p align="justify">
MetEvolSim is being developed by Charles Rocabert, Gábor Boross and Balázs Papp.
</p>

<p align="center">
<img src="https://github.com/charlesrocabert/MetEvolSim/raw/master/pic/BRC_logo.png" height="100px"></a>&nbsp;&nbsp;&nbsp;<img src="https://github.com/charlesrocabert/MetEvolSim/raw/master/pic/MTA_logo.png" height="100px"></a>
</p>

## Table of contents
- [Publications](#publications)
- [Dependencies](#dependencies)
- [Installation](#installation)
- [First usage](#first_usage)
- [Help](#help)
- [Ready-to-use examples](#examples)
- [List of tested metabolic models](#tested_models)
- [Copyright](#copyright)
- [License](#license)

## Publications <a name="publications"></a>
• Project cited in O’Shea & Misra (2020) (https://doi.org/10.1007/s11306-020-01657-3).

## Dependencies <a name="dependencies"></a>
- Python &ge; 3,
- Numpy &ge; 1.21 (automatically installed when using pip),
- Python-libsbml &ge; 5.19 (automatically installed when using pip),
- NetworkX &ge; 2.6 (automatically installed when using pip),
- CopasiSE &ge; 4.27 (to be installed separately),
- pip &ge; 21.3.1 (optional).

## Installation <a name="installation"></a>
&bullet; To install Copasi software, visit http://copasi.org/. You will need the command line version named CopasiSE.

&bullet; To install the latest release of MetEvolSim:
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
MetEvolSim has been tested with tens of publicly available metabolic networks, but we cannot guarantee it will work with any model (see the <a href="">list of tested metabolic models</a>).
The package provides a class to manipulate SBML models: the class <code>Model</code>. It is also necessary to define an objective function (a list of target reactions and their coefficients), and to provide the path of <a href="http://copasi.org/">CopasiSE</a> software. Please note that coefficients are not functional in the current version of MetEvolSim.

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

# Compute a flux drop analysis to measure the contribution of each flux to the fitness
# (in this example, each flux is dropped at 1% of its original value)
model.flux_drop_analysis(drop_coefficient=0.01, filename="flux_drop_analysis.txt", owerwrite=True)
```

MetEvolSim offers two specific numerical approaches to analyze the evolution of metabolic abundances:
- <strong>Evolution experiments</strong>, based on a Markov Chain Monte Carlo (MCMC) algorithm,
- <strong>Sensitivity analysis</strong>, either by exploring every kinetic parameters in a given range and recording associated fluxes and metabolic abundances changes (One-At-a-Time sensitivity analysis), or by exploring the kinetic parameters space at random, by mutating a single kinetic parameter at random many times (random sensitivity analysis).

All numerical analyses output files are saved in a subfolder <code>output</code>.

### Evolution experiments:
<p align="center">
<img src="https://github.com/charlesrocabert/MetEvolSim/raw/master/pic/mcmc_algorithm.png">
</p>
<p align="justify">
<strong>Algorithm overview:</strong> <strong>A.</strong> The model of interest is loaded as a wild-type from a SBML file (kinetic equations, kinetic parameter values and initial metabolic concentrations must be specified). <strong>B.</strong> At each iteration <em>t</em>, a single kinetic parameter is selected at random and mutated through a log10-normal distribution of standard deviation &sigma;. <strong>C.</strong> The new steady-state is computed using Copasi software, and the MOMA distance <em>z</em> between the mutant and the wild-type target fluxes is computed. <strong>D.</strong> If <em>z</em> is under a given selection threshold &omega;, the mutation is accepted. Else, the mutation is discarded. <strong>E.</strong> A new iteration <em>t+1</em> is computed.
</p>

<br/>
Six types of selection are available:

- <code>MUTATION_ACCUMULATION</code>: Run a mutation accumulation experiment by accepting all new mutations without any selection threshold,
- <code>ABSOLUTE_METABOLIC_SUM_SELECTION</code>: Run an evolution experiment by applying a stabilizing selection on the sum of absolute metabolic abundances,
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

## Ready-to-use examples <a name="examples"></a>
Ready-to-use examples are included in the Python package.
They can also be downloaded here: https://github.com/charlesrocabert/MetEvolSim/raw/master/example/example.zip.

## List of tested metabolic models <a name="tested_models"></a>

| **Reference**           | **Model**                            | **Running with MetEvolSim** |
|-------------------------|--------------------------------------|-----------------------------|
| Bakker et al. (1997)    | _Trypanosoma brucei_ glycolysis      | :x:                         |
| Curto et al. (1998)     | Human purine metabolism              | :x:                         |
| Mulquiney et al. (1999) | Human erythrocyte                    | :white_check_mark:          |
| Jamshidi et al. (2001)  | Red blood cell                       | :x:                         |
| Bali et al. (2001)      | Red blood cell glycolysis            | :white_check_mark:          |
| Lambeth et al. (2002)   | Skeletal muscle glycogenolysis       | :white_check_mark:          |
| Holzhutter et al. (2004)| Human erythrocyte                    | :white_check_mark:          |
| Beard et al. (2005)     | Mitochondrial respiration            | :x:                         |
| Banaji et al. (2005)    | Cerebral blood flood control         | :white_check_mark:          |
| Bertram et al. (2006)   | Mitochondrial ATP production         | :x:                         |
| Bruck et al. (2008)     | Yeast glycolysis                     | :white_check_mark:          |
| Reed et al. (2008)      | Glutathione metabolism               | :x:                         |
| Curien et al. (2009)    | Aspartame metabolism                 | :x:                         |
| Jerby et al. (2010)     | Human liver metabolism               | :x:                         |
| Li et al. (2010)        | Yeast glycolysis                     | :x:                         |
| Bekaert et al. (2010)   | Mouse metabolism reconstruction      | :x:                         |
| Bordbar et al. (2011)   | Human multi-tissues                  | :x:                         |
| Koenig et al. (2012)    | Hepatocyte glucose metabolism        | :white_check_mark:          |
| Messiha et al. (2013)   | Yeast glycolysis + pentose phosphate | :white_check_mark:          |
| Mitchell et al. (2013)  | Liver iron metabolism                | :x:                         |
| Stanford et al. (2013)  | Yeast whole cell model               | :x:                         |
| Bordbar et al. (2015)   | Red blood cell                       | :x:                         |
| Costa et al. (2016)     | E. coli core metabolism              | :white_check_mark:          |
| Millard et al. (2016)   | E. coli core metabolism              | :white_check_mark:          |
| Bulik et al. (2016)     | Hepatic glucose metabolism           | :white_check_mark:          |

## Copyright <a name="copyright"></a>
Copyright &copy; 2018-2021 Charles Rocabert, Gábor Boross and Balázs Papp.
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
