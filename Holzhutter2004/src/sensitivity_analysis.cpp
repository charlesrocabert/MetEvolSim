
#include "../cmake/Config.h"

#include <iostream>
#include <fstream>
#include <unordered_map>
#include <cstring>
#include <stdlib.h>
#include <assert.h>

#include "./lib/Macros.h"
#include "./lib/Enums.h"
#include "./lib/Structs.h"
#include "./lib/Parameters.h"
#include "./lib/SensitivityAnalysis.h"

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
  std::cout << "1) Load parameters ...\n";
  Parameters* parameters = new Parameters();
  readArgs(argc, argv, parameters);
  parameters->print_parameters();
  parameters->save_parameters();
  
  std::cout << "2) Create sensitivity analysis framework ...\n";
  SensitivityAnalysis* analysis = new SensitivityAnalysis(parameters);
  analysis->initialize();
  
  std::cout << "3) Run sensitivity analysis ...\n";
  analysis->run_analysis();
  
  std::cout << "4) Free the memory  ...\n";
  delete analysis;
  analysis = NULL;
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
  options["seed"]  = false;
  options["N"]     = false;
  options["sigma"] = false;
  options["w"]     = false;
  options["alpha"] = false;
  options["beta"]  = false;
  options["Q"]     = false;
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
    if (strcmp(argv[i], "-N") == 0 || strcmp(argv[i], "--N") == 0)
    {
      if (i+1 == argc)
      {
        std::cout << "Error: --N parameter value is missing.\n";
        exit(EXIT_FAILURE);
      }
      else
      {
        parameters->set_n(atof(argv[i+1]));
        options["N"] = true;
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
  std::cout << "Usage: sensitivity_analysis -h or --help\n";
  std::cout << "   or: sensitivity_analysis [options]\n";
  std::cout << "Options are:\n";
  std::cout << "  -h, --help\n";
  std::cout << "        print this help, then exit (optional)\n";
  std::cout << "  -v, --version\n";
  std::cout << "        print the current version, then exit (optional)\n";
  std::cout << "  -seed, --seed\n";
  std::cout << "        specify the standard deviation of the fitness function (mandatory)\n";
  std::cout << "  -N, --N\n";
  std::cout << "        specify the number of iterations for sensitivity analysis (mandatory)\n";
  std::cout << "  -sigma, --sigma\n";
  std::cout << "        specify the seed of the pseudorandom numbers generator (mandatory)\n";
  std::cout << "  -w, --w\n";
  std::cout << "        specify the mutation size standard deviation (mandatory)\n";
  std::cout << "  -alpha, --alpha\n";
  std::cout << "        specify the alpha parameter of the fitness function (mandatory)\n";
  std::cout << "  -beta, --beta\n";
  std::cout << "        specify the beta parameter of the fitness function (mandatory)\n";
  std::cout << "  -Q, --Q\n";
  std::cout << "        specify the Q parameter of the fitness function (mandatory)\n";
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

