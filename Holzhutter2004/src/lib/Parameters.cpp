
#include "Parameters.h"


/*----------------------------
 * CONSTRUCTORS
 *----------------------------*/

/**
 * \brief    Default constructor
 * \details  --
 * \param    void
 * \return   \e void
 */
Parameters::Parameters( void )
{
  /*----------------------------------------------------- PRNG */
  
  _prng = new Prng();
  _seed = 1;
  
  /*----------------------------------------------------- POPULATION */
  
  _generations = 10000;
  _n           = 1000;
  
  /*----------------------------------------------------- MUTATIONS */
  
  _sigma = 0.1;
  _mu    = 1e-2;
  
  /*----------------------------------------------------- FITNESS FUNCTION */
  
  _w     = 1e-5;
  _alpha = 0.5;
  _beta  = 0.0;
  _Q     = 2.0;
  
  /*----------------------------------------------------- PARALLEL COMPUTING */
  
  _parallel_computing = false;
}

/**
 * \brief    Copy constructor
 * \details  --
 * \param    const Parameters& parameters
 * \return   \e void
 */
Parameters::Parameters( Parameters const& parameters )
{
  /*----------------------------------------------------- PRNG */
  
  _prng = new Prng(*parameters._prng);
  _seed = parameters._seed;
  
  /*----------------------------------------------------- POPULATION */
  
  _generations = parameters._generations;
  _n           = parameters._n;
  
  /*----------------------------------------------------- MUTATIONS */
  
  _sigma = parameters._sigma;
  _mu    = parameters._mu;
  
  /*----------------------------------------------------- FITNESS FUNCTION */
  
  _w     = parameters._w;
  _alpha = parameters._alpha;
  _beta  = parameters._beta;
  _Q     = parameters._Q;
  
  /*----------------------------------------------------- PARALLEL COMPUTING */
  
  _parallel_computing = parameters._parallel_computing;
}

/*----------------------------
 * DESTRUCTORS
 *----------------------------*/

/**
 * \brief    Destructor
 * \details  --
 * \param    void
 * \return   \e void
 */
Parameters::~Parameters( void )
{
  delete _prng;
  _prng = NULL;
}

/*----------------------------
 * PUBLIC METHODS
 *----------------------------*/

/**
 * \brief    Print parameters values
 * \details  --
 * \param    void
 * \return   \e void
 */
void Parameters::print_parameters( void )
{
  std::cout << "====== PARAMETERS ======\n";
  
  /*----------------------------------------------------- PRNG */
  
  std::cout << "> seed = " << _seed << "\n";
  
  /*----------------------------------------------------- POPULATION */
  
  std::cout << "> generations = " << _generations << "\n";
  std::cout << "> n = " << _n << "\n";
  
  /*----------------------------------------------------- MUTATIONS */
  
  std::cout << "> sigma = " << _sigma << "\n";
  std::cout << "> mu = " << _mu << "\n";
  
  /*----------------------------------------------------- FITNESS FUNCTION */
  
  std::cout << "> w = " << _w << "\n";
  std::cout << "> alpha = " << _alpha << "\n";
  std::cout << "> beta = " << _beta << "\n";
  std::cout << "> Q = " << _Q << "\n";
  
  /*----------------------------------------------------- PARALLEL COMPUTING */
  
  std::cout << "> PC = " << _parallel_computing << "\n";
  
  /*----------------------------------------------------- */
  
  std::cout << "========================\n\n";
}

/**
 * \brief    Save parameters values
 * \details  --
 * \param    void
 * \return   \e void
 */
void Parameters::save_parameters( void )
{
  std::ofstream file("parameters/parameters.txt", std::ios::out | std::ios::trunc);
  file << "seed nb_g n m struct nbrandomit prev sigma mu w alpha beta Q PC\n";
  file << _seed << " ";
  file << _generations << " ";
  file << _n << " ";
  file << _sigma << " ";
  file << _mu << " ";
  file << _w << " ";
  file << _alpha << " ";
  file << _beta << " ";
  file << _Q << " ";
  file << _parallel_computing << "\n";
}

/*----------------------------
 * PROTECTED METHODS
 *----------------------------*/

