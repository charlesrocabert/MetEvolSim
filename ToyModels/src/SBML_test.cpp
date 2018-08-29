
#include "../cmake/Config.h"

#include <iostream>
#include <fstream>
#include <assert.h>
#include <sbml/SBMLTypes.h>
#include <sbml/common/extern.h>

/**
 * \brief    Main function
 * \details  --
 * \param    int argc
 * \param    char const** argv
 * \return   \e int
 */
int main( int argc, char const** argv )
{
  SBMLDocument* document;
  SBMLReader reader;
  
  document = reader.readSBML("holzhutter.xml");
  if (document->getNumErrors() > 0)
  {
    std::cerr << "Encountered the following SBML errors:" << std::endl;
    document->printErrors(std::cerr);
    return 1;
  }
  Model* model = document->getModel();
  if (model == 0)
  {
    std::cout << "No model present." << std::endl;
    return 1;
  }
  std::cout << "-------------------" << std::endl;
  int N = model->getNumSpecies();
  for (int i = 0; i < N; i++)
  {
    std::cout << model->getSpecies(i)->getId() << " " << model->getSpecies(i)->getInitialConcentration() << "\n";
  }
  std::cout << "-------------------" << std::endl;
  int P = model->getNumParameters();
  for (int i = 0; i < P; i++)
  {
    std::cout << model->getParameter(i)->getId() << " " << model->getParameter(i)->getValue() << "\n";
  }
  std::cout << "-------------------" << std::endl;
  int R = model->getNumReactions();
  for (int i = 0; i < R; i++)
  {
    std::cout << model->getReaction(i)->getId() << " " << model->getReaction(i)->getListOfReactants()->get << "\n";
  }
  
  return EXIT_SUCCESS;
}



