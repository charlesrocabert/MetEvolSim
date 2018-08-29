
#include "Population.h"


/*----------------------------
 * CONSTRUCTORS
 *----------------------------*/

/**
 * \brief    Constructor
 * \details  --
 * \param    Parameters* parameters
 * \return   \e void
 */
Population::Population( Parameters* parameters )
{
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  assert(parameters != NULL);
  _parameters = parameters;
  _prng       = _parameters->get_prng();
  _tree       = NULL;
  
  /*----------------------------------------------------- VARIABLES */
  
  _id    = 1;
  _n     = 0;
  _m     = 0;
  _g     = 0;
  _pop   = NULL;
  _w_vec = NULL;
  _w_sum = 0.0;
  
  /*----------------------------------------------------- STATISTICS */
  
  _best_pos = 0;
  _best_w   = 0.0;
  _c_opt    = 0.0;
  _mean_c   = 0.0;
  _var_c    = 0.0;
  _mean_w   = 0.0;
  _var_w    = 0.0;
  _mean_s   = NULL;
  _var_s    = NULL;
  _cv_s     = NULL;
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
Population::~Population( void )
{
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  delete _tree;
  _tree = NULL;
  
  /*----------------------------------------------------- VARIABLES */
  
  for (int i = 0; i < _n; i++)
  {
    delete _pop[i];
    _pop[i] = NULL;
  }
  delete[] _pop;
  _pop = NULL;
  delete[] _w_vec;
  _w_vec = NULL;
  
  /*----------------------------------------------------- STATISTICS */
  
  delete[] _mean_s;
  _mean_s = NULL;
  delete[] _var_s;
  _var_s = NULL;
  delete[] _cv_s;
  _cv_s = NULL;
}

/*----------------------------
 * PUBLIC METHODS
 *----------------------------*/

/**
 * \brief    Initialize the population
 * \details  --
 * \param    void
 * \return   \e void
 */
void Population::initialize( void )
{
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  _tree = new Tree(_parameters);
  
  /*----------------------------------------------------- POPULATION */
  
  /*** Initialize main variables ***/
  _id       = 1;
  _n        = _parameters->get_n();
  _m        = _parameters->get_m();
  _g        = 0;
  _pop      = new Individual*[_n];
  _w_vec    = new double[_n];
  _w_sum    = 0.0;
  _best_pos = 0;
  _best_w   = 0.0;
  _mean_c   = 0.0;
  _var_c    = 0.0;
  _mean_w   = 0.0;
  _var_w    = 0.0;
  
  /*** Create initial individual ***/
  std::cout << "> Looking for a stable ancestor\n";
  Individual* ancestor = NULL;
  bool stable_network  = false;
  int  counter         = 1;
  while (!stable_network)
  {
    std::cout << "    • test new ancestor (iteration " << counter << ")...\n";
    delete ancestor;
    ancestor = NULL;
    ancestor = new Individual(_parameters);
    ancestor->initialize();
    stable_network = ancestor->isStable();
    counter++;
  }
  std::cout << "    • found an ancestor at iteration " << counter << ".\n";
  
  /*** Generate the initial population ***/
  std::cout << "> Generate the initial population\n";
  for (int i = 0; i < _n; i++)
  {
    /*** Copy the ancestor ***/
    _pop[i]   = new Individual(*ancestor);
    _pop[i]->set_identifier(_id);
    _id++;
    _pop[i]->set_parent(0);
    _pop[i]->set_generation(_g);
    
    /*** Set the new individual as a root of the tree ***/
    _tree->add_root(_pop[i]);
    
    /*** Compute statistics ***/
    _w_vec[i] = _pop[i]->get_w();
    _w_sum   += _w_vec[i];
    _mean_c  += _pop[i]->get_c();
    _var_c   += _pop[i]->get_c()*_pop[i]->get_c();
    _mean_w  += _w_vec[i];
    _var_w   += _w_vec[i]*_w_vec[i];
    if (_best_w < _w_vec[i])
    {
      _best_pos = i;
      _best_w   = _w_vec[i];
    }
  }
  for (int i = 0; i < _n; i++)
  {
    _w_vec[i] /= _w_sum;
  }
  _mean_c /= (double)_n;
  _var_c  /= (double)_n;
  _var_c  -= _mean_c*_mean_c;
  _mean_w /= (double)_n;
  _var_w  /= (double)_n;
  _var_w  -= _mean_w*_mean_w;
  _c_opt   = _pop[0]->get_c_opt();
  
  delete ancestor;
  ancestor = NULL;
  
  /*----------------------------------------------------- STATISTICS */
  
  _mean_s = new double[_m];
  _var_s  = new double[_m];
  _cv_s   = new double[_m];
  for (int i = 0; i < _m; i++)
  {
    _mean_s[i] = 0.0;
    _var_s[i]  = 0.0;
    _cv_s[i]   = 0.0;
  }
}

/**
 * \brief    Compute the next generation
 * \details  --
 * \param    void
 * \return   \e void
 */
void Population::next_generation( void )
{
  /*------------------------------------*/
  /* 1) Draw the new population         */
  /*------------------------------------*/
  Individual** new_pop = new Individual*[_n];
  unsigned int* draws = new unsigned int[_n];
  for (int i = 0; i < _n; i++)
  {
    draws[i] = 0;
  }
  _prng->multinomial(draws, _w_vec, _n, _n);
  int index = 0;
  for (int i = 0; i < _n; i++)
  {
    _tree->set_dead(_pop[i]->get_identifier());
    for (unsigned int j = 0; j < draws[i]; j++)
    {
      /*** Create the new individual ***/
      new_pop[index] = new Individual(*_pop[i]);
      new_pop[index]->set_identifier(_id);
      _id++;
      new_pop[index]->set_parent(_pop[i]->get_identifier());
      new_pop[index]->set_generation(_g);
      index++;
    }
    delete _pop[i];
    _pop[i] = NULL;
  }
  delete[] _pop;
  _pop = NULL;
  _pop = new_pop;
  
  /*------------------------------------*/
  /* 2) Solve ODEs                      */
  /*------------------------------------*/
  if (_parameters->get_parallel_computing())
  {
    tbb::task_group tasks;
    for (int i = 0; i < _n; i++)
    {
      tasks.run([=]{evaluate_individual(i);});
    }
    tasks.wait();
  }
  else
  {
    for (int i = 0; i < _n; i++)
    {
      evaluate_individual(i);
    }
  }
  
  /*------------------------------------*/
  /* 3) Add new individuals to the tree */
  /*------------------------------------*/
  for (int i = 0; i < _n; i++)
  {
    _tree->add_reproduction_event(_pop[i]);
  }
  //_tree->prune();
  
  /*------------------------------------*/
  /* 4) Compute new fitnesses           */
  /*------------------------------------*/
  _w_sum    = 0.0;
  _best_pos = 0;
  _best_w   = 0.0;
  _mean_c   = 0.0;
  _var_c    = 0.0;
  _mean_w   = 0.0;
  _var_w    = 0.0;
  for (int i = 0; i < _n; i++)
  {
    _w_vec[i] = _pop[i]->get_w();
    _w_sum   += _w_vec[i];
    _mean_c  += _pop[i]->get_c();
    _var_c   += _pop[i]->get_c()*_pop[i]->get_c();
    _mean_w  += _w_vec[i];
    _var_w   += _w_vec[i]*_w_vec[i];
    if (_best_w < _w_vec[i])
    {
      _best_pos = i;
      _best_w   = _w_vec[i];
    }
  }
  _mean_c /= (double)_n;
  _var_c  /= (double)_n;
  _var_c  -= _mean_c*_mean_c;
  _mean_w /= (double)_n;
  _var_w  /= (double)_n;
  _var_w  -= _mean_w*_mean_w;
  _g++;
}

/**
 * \brief    Compute statistics
 * \details  --
 * \param    void
 * \return   \e void
 */
void Population::compute_statistics( void )
{
  for (int i = 0; i < _m; i++)
  {
    _mean_s[i] = 0.0;
    _var_s[i]  = 0.0;
    _cv_s[i]   = 0.0;
    for (int j = 0; j < _n; j++)
    {
      _mean_s[i] += _pop[j]->get_s(i);
      _var_s[i]  += _pop[j]->get_s(i)*_pop[j]->get_s(i);
    }
    _mean_s[i] /= (double)_n;
    _var_s[i]  /= (double)_n;
    _var_s[i]  -= _mean_s[i]*_mean_s[i];
    if (_var_s[i] < 0.0)
    {
      _var_s[i] = 0.0;
    }
    _cv_s[i] = sqrt(_var_s[i])/_mean_s[i];
  }
}

/**
 * \brief    Open statistics files
 * \details  --
 * \param    void
 * \return   \e void
 */
void Population::open_statistic_files( void )
{
  /*------------------*/
  /* 1) Open files    */
  /*------------------*/
  _fitness_file.open("population/fitness.txt", std::ios::out | std::ios::trunc);
  _mean_s_file.open("population/mean_s.txt", std::ios::out | std::ios::trunc);
  _var_s_file.open("population/var_s.txt", std::ios::out | std::ios::trunc);
  _cv_s_file.open("population/cv_s.txt", std::ios::out | std::ios::trunc);
  
  /*------------------*/
  /* 2) Write headers */
  /*------------------*/
  _fitness_file << "g c_opt mean_c var_c mean_w var_w best_w nb_nodes\n";
  _mean_s_file << "g";
  _var_s_file << "g";
  _cv_s_file << "g";
  for (int i = 1; i <= _m; i++)
  {
    _mean_s_file << " " << i;
    _var_s_file << " " << i;
    _cv_s_file << " " << i;
  }
  _mean_s_file << "\n";
  _var_s_file << "\n";
  _cv_s_file << "\n";
}

/**
 * \brief    Write statistics into files
 * \details  --
 * \param    void
 * \return   \e void
 */
void Population::write_statistic_files( void )
{
  /*------------------------------*/
  /* 1) Write fitness stats       */
  /*------------------------------*/
  _fitness_file << _g << " ";
  _fitness_file << _c_opt << " ";
  _fitness_file << _mean_c << " ";
  _fitness_file << _var_c << " ";
  _fitness_file << _mean_w << " ";
  _fitness_file << _var_w << " ";
  _fitness_file << _best_w << " ";
  _fitness_file << _tree->get_number_of_nodes() << "\n";
  
  /*------------------------------*/
  /* 2) Write concentration stats */
  /*------------------------------*/
  _mean_s_file << _g;
  _var_s_file << _g;
  _cv_s_file << _g;
  for (int i = 0; i < _m; i++)
  {
    _mean_s_file << " " << _mean_s[i];
    _var_s_file << " " << _var_s[i];
    _cv_s_file << " " << _cv_s[i];
  }
  _mean_s_file << "\n";
  _var_s_file << "\n";
  _cv_s_file << "\n";
  
  /*------------------------------*/
  /* 3) Flush files               */
  /*------------------------------*/
  _fitness_file.flush();
  _mean_s_file.flush();
  _var_s_file.flush();
  _cv_s_file.flush();
}

/**
 * \brief    Close statistics files
 * \details  --
 * \param    void
 * \return   \e void
 */
void Population::close_statistic_files( void )
{
  _fitness_file.close();
  _mean_s_file.close();
  _var_s_file.close();
  _cv_s_file.close();
}

/**
 * \brief    Write best individual statistics
 * \details  --
 * \param    void
 * \return   \e void
 */
void Population::write_best_individual( void )
{
  _pop[_best_pos]->save_indidivual_state("best/best_individual.txt");
}

/*----------------------------
 * PROTECTED METHODS
 *----------------------------*/

/**
 * \brief    Evaluate the individual at position i
 * \details  --
 * \param    int i
 * \return   \e void
 */
void Population::evaluate_individual( int i )
{
  _pop[i]->mutate(_parameters->get_sigma(), _parameters->get_mu());
  _pop[i]->compute_steady_state(false);
  _pop[i]->compute_c();
  _pop[i]->compute_fitness();
}

