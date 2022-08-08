# Dataset organization

For each of the three kinetic models, the datasets are organized as following:
Each file as a prefix depending on the model name (Mulquiney1999,
Holzhutter2004 or Koenig2012). Using `XXX` as a prefix:
- Simulation results (genetic drift and stabilizing selection) are available in
  the file `XXX_simulations.txt` and the folders `XXX_simulations`;
- The random sensitivity analysis is available in the file
  `XXX_random_sensitivity_analysis.txt`;
- Filtered-out metabolites are listed in the file `XXX_outliers.txt`;
- The result of the exploration of 10,000 random combinations of target fluxes
  is available in the file `XXX_fitness_coupling_exploration.txt`;
- Simulation results for 100 random combinations of target fluxes is available
  in the folder `XXX_fitness_coupling_simulations`.
- The reaction-to-species map (the list of metabolites directly involved in each
  reaction - reactants and products) is available in the file
  `XXX_reaction_to_species_map.txt`.
- The result of the flux drop analysis is available in the file
  `XXX_flux_drop_analysis.txt`.
- Various other text files describing the content of the model are present.

# File content

- `XXX_simulations.txt` --- column names and description:
  - threshold: selection threshold,
  - `mean_X`: mean abundance for 10 repetitions,
  - `sd_X`: abundance standard deviation for 10 repetitions,
  - `mean_CV`: mean coefficient of variation for 10 repetitions,
  - `sd_CV`: coefficient of variation standard deviation for 10 repetitions,
  - `mean_ER`: mean evolution rate of variation for 10 repetitions,
  - `sd_ER`: evolution rate standard deviation for 10 repetitions,
  - `species_id`: metabolite and fluxes identifiers.

- `XXX_random_sensitivity_analysis.txt` --- column names and description:
  - `iteration`: current iteration of the random sensitivity analysis,
  - Other columns: relative change (compared to the wild-type) of each
    metabolic abundance or flux.
  - The first line contains wild-type values.

- `XXX_fitness_coupling_exploration.txt` --- column names and description:
  - `Rho`: Rho estimate of the Spearman correlation between abundances and their
    fitness coupling,
  - `Pvalue`: associated p-value,
  - `Target`: combination of target fluxes (separator: -).

- `XXX_flux_drop_analysis.txt` --- column names and description: drop_value reaction dist
  - `drop_value`: the drop coefficient by which the wild-type flux value is
    dropped,
  - `reaction`: the reaction under consideration,
  - `dist`: the deviation of the target fluxes relative to their wild-type levels
    caused by the flux drop.
