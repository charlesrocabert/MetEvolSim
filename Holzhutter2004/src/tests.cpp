
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

/**
 * \brief    Main function
 * \details  --
 * \param    void
 * \return   \e int
 */
int main( void )
{
  std::cout << "1) Load parameters ...\n";
  Parameters* params = new Parameters();
  params->set_seed(1234);
  params->set_generations(10000);
  params->set_n(1000);
  params->set_m(40);
  params->set_sigma(0.01);
  params->set_mu(1e-3);
  params->set_w(1e-05);
  params->set_alpha(0.5);
  params->set_beta(0.0);
  params->set_Q(2.0);
  params->set_parallel_computing(false);
  
  std::cout << "2) Create an individual ...\n";
  Individual* ind = new Individual(params);
  
  std::cout << "3) Initialize individual ...\n";
  ind->initialize();
  
  std::cout << "4) Free the memory  ...\n";
  delete ind;
  ind = NULL;
  delete params;
  params = NULL;
  return EXIT_SUCCESS;
}

