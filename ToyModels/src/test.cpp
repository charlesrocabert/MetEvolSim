
#include "../cmake/Config.h"

#include <iostream>
#include <assert.h>
#include <fstream>
#include <unordered_map>

#include "./lib/Macros.h"
#include "./lib/Enums.h"
#include "./lib/Structs.h"
#include "./lib/Prng.h"
#include "./lib/Parameters.h"
#include "./lib/ODESolver.h"
#include "./lib/Individual.h"
#include "./lib/Population.h"

void readArgs( int argc, char const** argv, Parameters* parameters );
void printUsage( void );
void printHeader( void );

/**
 * \brief    Main function
 * \details  --
 * \param    int argc
 * \param    char const** argv
 * \return   \e int
 */
int main( int argc, char const** argv )
{
  Parameters* parameters = new Parameters();
  readArgs(argc, argv, parameters);
  parameters->print_parameters();
  
  Individual* individual = new Individual(parameters);
  
  /*----------------------------------*/
  /* 1) Generate the meabolic network */
  /*----------------------------------*/
  
  /*** Generate linear pathway ***/
  if (parameters->get_structure() == LINEAR_PATHWAY)
  {
    individual->generate_linear_pathway_matrix();
  }
  /*** Or generate basic random network ***/
  else if (parameters->get_structure() == RANDOM_NETWORK)
  {
    individual->generate_random_network_matrix();
  }
  /*** Or generate scale-free network ***/
  else if (parameters->get_structure() == SCALE_FREE_NETWORK)
  {
    individual->generate_scale_free_network_matrix();
  }
  individual->print_stoichiometric_matrix();
  individual->save_stoichiometric_matrix("test_stoichiometric_matrix.txt");
  
  /*** Generate reaction list (no allocation) ***/
  individual->generate_random_reaction_list();
  individual->print_reaction_list();
  individual->save_reaction_list("test_reaction_list.txt", "ancestor/ancestor_adjacency_list.txt");
  individual->create_ode_solver();
  individual->initialize_concentration_vector();
  
  /*----------------------------------*/
  /* 2) Test the solver               */
  /*----------------------------------*/
  individual->compute_steady_state(true);
  individual->save_indidivual_state("test_individual.txt");
  
  /*----------------------------------*/
  /* 3) Free the memory               */
  /*----------------------------------*/
  delete individual;
  individual = NULL;
  delete parameters;
  parameters = NULL;
  
  return EXIT_SUCCESS;
}


/**
 * \brief    Read command line arguments
 * \details  --
 * \param    int argc
 * \param    char const** argv
 * \param    Parameters* parameters
 * \return   \e void
 */
void readArgs( int argc, char const** argv, Parameters* parameters )
{
  std::unordered_map<std::string, bool> options;
  options["seed"]        = false;
  options["struct"]      = false;
  options["m"]           = false;
  options["nbrandomit"]  = false;
  options["prev"]        = false;
  for (int i = 0; i < argc; i++)
  {
    if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0)
    {
      printUsage();
      exit(EXIT_SUCCESS);
    }
    if (strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "--version") == 0)
    {
      std::cout << PACKAGE << " (" << VERSION_MAJOR << "." << VERSION_MINOR << "." << VERSION_PATCH << ")\n";
      exit(EXIT_SUCCESS);
    }
    if (strcmp(argv[i], "-seed") == 0 || strcmp(argv[i], "--seed") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --seed parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_seed((unsigned long int)atoi(argv[i+1]));
        options["seed"] = true;
      }
    }
    if (strcmp(argv[i], "-struct") == 0 || strcmp(argv[i], "--struct") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --struct parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        if (strcmp(argv[i+1], "LINEAR_PATHWAY") == 0)
        {
          parameters->set_structure(LINEAR_PATHWAY);
        }
        else if (strcmp(argv[i+1], "RANDOM_NETWORK") == 0)
        {
          parameters->set_structure(RANDOM_NETWORK);
        }
        else if (strcmp(argv[i+1], "SCALE_FREE_NETWORK") == 0)
        {
          parameters->set_structure(SCALE_FREE_NETWORK);
        }
        else if (strcmp(argv[i+1], "LOAD_MODEL") == 0)
        {
          parameters->set_structure(LOAD_MODEL);
        }
        else
        {
          std::cout << "Error : --struct wrong parameter value at line:\n " << argv[i+1] << ".\n\n";
          exit(EXIT_FAILURE);
        }
      }
      
      
      options["struct"] = true;
    }
    if (strcmp(argv[i], "-m") == 0 || strcmp(argv[i], "--m") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --m parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_m(atoi(argv[i+1]));
        options["m"] = true;
      }
    }
    if (strcmp(argv[i], "-nbrandomit") == 0 || strcmp(argv[i], "--nbrandomit") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --nbrandomit parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_nb_random_iterations(atoi(argv[i+1]));
        options["nbrandomit"] = true;
      }
    }
    if (strcmp(argv[i], "-prev") == 0 || strcmp(argv[i], "--prev") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --prev parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_p_reversible(atof(argv[i+1]));
        options["prev"] = true;
      }
    }
  }
  bool parameter_lacking = false;
  for (auto it = options.begin(); it != options.end(); ++it)
  {
    if (!it->second)
    {
      std::cout << "-" << it->first << " option is mandatory.\n";
      parameter_lacking = true;
    }
  }
  if (parameter_lacking)
  {
    exit(EXIT_FAILURE);
  }
}

/**
 * \brief    Print usage
 * \details  --
 * \param    void
 * \return   \e void
 */
void printUsage( void )
{
  std::cout << "*************** ComplexMetabolicNetwork ***************\n";
  std::cout << "Usage: test -h or --help\n";
  std::cout << "   or: test [options]\n";
  std::cout << "Options are:\n";
  std::cout << "  -h, --help\n";
  std::cout << "        print this help, then exit (optional)\n";
  std::cout << "  -v, --version\n";
  std::cout << "        print the current version, then exit (optional)\n";
  std::cout << "  -seed, --seed\n";
  std::cout << "        specify the seed of the pseudorandom numbers generator\n";
  std::cout << "  -struct, --struct\n";
  std::cout << "        specify the metabolic network structure\n";
  std::cout << "  -m, --m\n";
  std::cout << "        specify the number of metabolites\n";
  std::cout << "  -nbrandomit, --nbrandomit\n";
  std::cout << "        specify the number of iterations used to generate the random network\n";
  std::cout << "  -prev, --prev\n";
  std::cout << "        specify the probability for a reaction to be reversible\n";
  std::cout << "\n";
}

/**
 * \brief    Print header
 * \details  --
 * \param    void
 * \return   \e void
 */
void printHeader( void )
{
  std::cout << "*************** ComplexMetabolicNetwork ***************\n";
}

