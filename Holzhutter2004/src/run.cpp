
#include "../cmake/Config.h"

#include <iostream>
#include <assert.h>
#include <fstream>
#include <unordered_map>

#include "./lib/Macros.h"
#include "./lib/Enums.h"
#include "./lib/Structs.h"
#include "./lib/Parameters.h"
#include "./lib/Individual.h"
#include "./lib/Population.h"

void readArgs( int argc, char const** argv, Parameters* parameters );
void printUsage( void );
void printHeader( void );
void createFolders( void );


/**
 * \brief    Main function
 * \details  --
 * \param    int argc
 * \param    char const** argv
 * \return   \e int
 */
int main( int argc, char const** argv )
{
  createFolders();
  
  /*---------------------------------*/
  /* 1) Read command line parameters */
  /*---------------------------------*/
  Parameters* parameters = new Parameters();
  readArgs(argc, argv, parameters);
  
  parameters->print_parameters();
  parameters->save_parameters();
  
  /*---------------------------------*/
  /* 2) Initialize the population    */
  /*---------------------------------*/
  Population* pop = new Population(parameters);
  pop->initialize();
  pop->open_statistic_files();
  
  /*---------------------------------*/
  /* 2) Evolve the population        */
  /*---------------------------------*/
  while (pop->get_generation() < parameters->get_generations())
  {
    pop->next_generation();
    if (pop->get_generation()%STATISTICS_GENERATION_STEP == 0)
    {
      std::cout << "> Generation " << pop->get_generation() << "\n";
      pop->compute_statistics();
      pop->write_statistic_files();
      pop->write_best_individual();
      pop->get_tree()->prune();
      pop->get_tree()->compute_best_evolution_rate("best/best_evolrate.txt");
      pop->get_tree()->compute_mean_evolution_rate("best/mean_evolrate.txt");
      pop->get_tree()->recover_best_fixed_mutations("best/best_fixed_mutations.txt");
    }
  }
  pop->close_statistic_files();
  delete pop;
  pop = NULL;
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
  options["generations"] = false;
  options["n"]           = false;
  options["sigma"]       = false;
  options["mu"]          = false;
  options["w"]           = false;
  options["alpha"]       = false;
  options["beta"]        = false;
  options["Q"]           = false;
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
    if (strcmp(argv[i], "-generations") == 0 || strcmp(argv[i], "--generations") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --generations parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_generations(atoi(argv[i+1]));
        options["generations"] = true;
      }
    }
    if (strcmp(argv[i], "-n") == 0 || strcmp(argv[i], "--n") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --n parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_n(atoi(argv[i+1]));
        options["n"] = true;
      }
    }
    if (strcmp(argv[i], "-sigma") == 0 || strcmp(argv[i], "--sigma") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --sigma parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_sigma(atof(argv[i+1]));
        options["sigma"] = true;
      }
    }
    if (strcmp(argv[i], "-mu") == 0 || strcmp(argv[i], "--mu") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --mu parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_mu(atof(argv[i+1]));
        options["mu"] = true;
      }
    }
    if (strcmp(argv[i], "-w") == 0 || strcmp(argv[i], "--w") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --w parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_w(atof(argv[i+1]));
        options["w"] = true;
      }
    }
    if (strcmp(argv[i], "-alpha") == 0 || strcmp(argv[i], "--alpha") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --alpha parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_alpha(atof(argv[i+1]));
        options["alpha"] = true;
      }
    }
    if (strcmp(argv[i], "-beta") == 0 || strcmp(argv[i], "--beta") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --beta parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_beta(atof(argv[i+1]));
        options["beta"] = true;
      }
    }
    if (strcmp(argv[i], "-Q") == 0 || strcmp(argv[i], "--Q") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --Q parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_Q(atof(argv[i+1]));
        options["Q"] = true;
      }
    }
    if (strcmp(argv[i], "-PC") == 0 || strcmp(argv[i], "--PC") == 0)
    {
      parameters->set_parallel_computing(true);
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
  std::cout << "*************** Holzhutter2004 ***************\n";
  std::cout << "Usage: run -h or --help\n";
  std::cout << "   or: run [options]\n";
  std::cout << "Options are:\n";
  std::cout << "  -h, --help\n";
  std::cout << "        print this help, then exit (optional)\n";
  std::cout << "  -v, --version\n";
  std::cout << "        print the current version, then exit (optional)\n";
  std::cout << "  -seed, --seed\n";
  std::cout << "        specify the seed of the pseudorandom numbers generator (mandatory)\n";
  std::cout << "  -generations, --generations\n";
  std::cout << "        specify the number of generations (mandatory)\n";
  std::cout << "  -n, --n\n";
  std::cout << "        specify the population size (mandatory)\n";
  std::cout << "  -w, --w\n";
  std::cout << "        specify the standard deviation of the fitness function (mandatory)\n";
  std::cout << "  -sigma, --sigma\n";
  std::cout << "        specify the mutation size standard deviation (mandatory)\n";
  std::cout << "  -mu, --mu\n";
  std::cout << "        specify the mutation rate (per metabolite per generation) (mandatory)\n";
  std::cout << "  -alpha, --alpha\n";
  std::cout << "        specify the alpha parameter of the fitness function (mandatory)\n";
  std::cout << "  -beta, --beta\n";
  std::cout << "        specify the beta parameter of the fitness function (mandatory)\n";
  std::cout << "  -Q, --Q\n";
  std::cout << "        specify the Q parameter of the fitness function (mandatory)\n";
  std::cout << "  -PC, --PC\n";
  std::cout << "        activate parallel computing (optional)\n";
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
  std::cout << "*************** Holzhutter2004 ***************\n";
}

/**
 * \brief    Create simulation folders
 * \details  --
 * \param    void
 * \return   \e void
 */
void createFolders( void )
{
  system("rm -rf ancestor");
  system("rm -rf best");
  system("rm -rf population");
  system("rm -rf parameters");
  system("rm -rf figures");
  system("mkdir ancestor");
  system("mkdir best");
  system("mkdir population");
  system("mkdir parameters");
  system("mkdir figures");
}
