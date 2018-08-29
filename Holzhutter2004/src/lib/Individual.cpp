
#include "Individual.h"


/*----------------------------
 * CONSTRUCTORS
 *----------------------------*/

/**
 * \brief    Constructor
 * \details  --
 * \param    Parameters* parameters
 * \return   \e void
 */
Individual::Individual( Parameters* parameters )
{
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  assert(parameters != NULL);
  _parameters = parameters;
  _prng       = _parameters->get_prng();
  _identifier = 0;
  _parent     = 0;
  _g          = 0;
  
  /*----------------------------------------------------- NETWORK STRUCTURE */
  
  /*** Set m and Sdim ***/
  _m    = _parameters->get_m();
  _Sdim = _m+2;
  
  /*** Allocate S memory ***/
  _S             = NULL;
  _influx_index  = _m;
  _outflux_index = _m+1;
  create_stoichiometric_matrix();
  
  /*** Allocate degree memory ***/
  _degree           = NULL;
  _in_degree        = NULL;
  _out_degree       = NULL;
  _mean_km_f        = NULL;
  _mean_vmax_f      = NULL;
  _mean_km_b        = NULL;
  _mean_vmax_b      = NULL;
  _in_mean_km_f     = NULL;
  _in_mean_vmax_f   = NULL;
  _in_mean_km_b     = NULL;
  _in_mean_vmax_b   = NULL;
  _out_mean_km_f    = NULL;
  _out_mean_vmax_f  = NULL;
  _out_mean_km_b    = NULL;
  _out_mean_vmax_b  = NULL;
  _degree           = new int[_m];
  _in_degree        = new int[_m];
  _out_degree       = new int[_m];
  _mean_km_f        = new double[_m];
  _mean_vmax_f      = new double[_m];
  _mean_km_b        = new double[_m];
  _mean_vmax_b      = new double[_m];
  _mean_counter     = new int[_m];
  _in_mean_km_f     = new double[_m];
  _in_mean_vmax_f   = new double[_m];
  _in_mean_km_b     = new double[_m];
  _in_mean_vmax_b   = new double[_m];
  _in_mean_counter  = new int[_m];
  _out_mean_km_f    = new double[_m];
  _out_mean_vmax_f  = new double[_m];
  _out_mean_km_b    = new double[_m];
  _out_mean_vmax_b  = new double[_m];
  _out_mean_counter = new int[_m];
  for (int i = 0; i < _m; i++)
  {
    _degree[i]           = 0;
    _in_degree[i]        = 0;
    _out_degree[i]       = 0;
    _mean_km_f[i]        = 0.0;
    _mean_vmax_f[i]      = 0.0;
    _mean_km_b[i]        = 0.0;
    _mean_vmax_b[i]      = 0.0;
    _mean_counter[i]     = 0;
    _in_mean_km_f[i]     = 0.0;
    _in_mean_vmax_f[i]   = 0.0;
    _in_mean_km_b[i]     = 0.0;
    _in_mean_vmax_b[i]   = 0.0;
    _in_mean_counter[i]  = 0;
    _out_mean_km_f[i]    = 0.0;
    _out_mean_vmax_f[i]  = 0.0;
    _out_mean_km_b[i]    = 0.0;
    _out_mean_vmax_b[i]  = 0.0;
    _out_mean_counter[i] = 0;
  }
  
  /*----------------------------------------------------- PHENOTYPE */
  
  _mutated = false;
  /*** Allocate concentration memory ***/
  _s     = NULL;
  _old_s = NULL;
  _s     = new double[_m];
  _old_s = new double[_m];
  for (int i = 0; i < _m; i++)
  {
    _s[i]     = 0.0;
    _old_s[i] = 0.0;
  }
  _c     = 0.0;
  _old_c = 0.0;
  _c_opt = 0.0;
  _w     = 0.0;
  
  /*----------------------------------------------------- REACTION LIST */
  
  /*** Allocate reaction list and ODE solver memory ***/
  _reaction_list = NULL;
  create_reaction_list();
  _ode_solver    = NULL;
  _dt            = DT_INIT;
  _isStable      = false;
  
  /*----------------------------------------------------- TREE MANAGEMENT */
  
  _prepared_for_tree = false;
}

/**
 * \brief    Copy constructor
 * \details  --
 * \param    const Individual& individual
 * \return   \e void
 */
Individual::Individual( const Individual& individual )
{
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  _parameters = individual._parameters;
  _prng       = individual._prng;
  _identifier = individual._identifier;
  _parent     = individual._parent;
  _g          = individual._g;
  
  /*----------------------------------------------------- NETWORK STRUCTURE */

  /*** Set m and Sdim ***/
  _m    = individual._m;
  _Sdim = individual._Sdim;
  
  /*** Allocate S memory ***/
  _S             = NULL;
  _influx_index  = individual._influx_index;
  _outflux_index = individual._outflux_index;
  copy_stoichiometric_matrix(individual._S);
  
  /*** Allocate degree memory ***/
  _degree           = NULL;
  _in_degree        = NULL;
  _out_degree       = NULL;
  _mean_km_f        = NULL;
  _mean_vmax_f      = NULL;
  _mean_km_b        = NULL;
  _mean_vmax_b      = NULL;
  _in_mean_km_f     = NULL;
  _in_mean_vmax_f   = NULL;
  _in_mean_km_b     = NULL;
  _in_mean_vmax_b   = NULL;
  _out_mean_km_f    = NULL;
  _out_mean_vmax_f  = NULL;
  _out_mean_km_b    = NULL;
  _out_mean_vmax_b  = NULL;
  _degree           = new int[_m];
  _in_degree        = new int[_m];
  _out_degree       = new int[_m];
  _mean_km_f        = new double[_m];
  _mean_vmax_f      = new double[_m];
  _mean_km_b        = new double[_m];
  _mean_vmax_b      = new double[_m];
  _mean_counter     = new int[_m];
  _in_mean_km_f     = new double[_m];
  _in_mean_vmax_f   = new double[_m];
  _in_mean_km_b     = new double[_m];
  _in_mean_vmax_b   = new double[_m];
  _in_mean_counter  = new int[_m];
  _out_mean_km_f    = new double[_m];
  _out_mean_vmax_f  = new double[_m];
  _out_mean_km_b    = new double[_m];
  _out_mean_vmax_b  = new double[_m];
  _out_mean_counter = new int[_m];
  memcpy(_degree, individual._degree, sizeof(int)*_m);
  memcpy(_in_degree, individual._in_degree, sizeof(int)*_m);
  memcpy(_out_degree, individual._out_degree, sizeof(int)*_m);
  memcpy(_mean_km_f, individual._mean_km_f, sizeof(int)*_m);
  memcpy(_mean_vmax_f, individual._mean_vmax_f, sizeof(int)*_m);
  memcpy(_mean_km_b, individual._mean_km_b, sizeof(double)*_m);
  memcpy(_mean_vmax_b, individual._mean_vmax_b, sizeof(double)*_m);
  memcpy(_mean_counter, individual._mean_counter, sizeof(int)*_m);
  memcpy(_in_mean_km_f, individual._in_mean_km_f, sizeof(double)*_m);
  memcpy(_in_mean_vmax_f, individual._in_mean_vmax_f, sizeof(double)*_m);
  memcpy(_in_mean_km_b, individual._in_mean_km_b, sizeof(double)*_m);
  memcpy(_in_mean_vmax_b, individual._in_mean_vmax_b, sizeof(double)*_m);
  memcpy(_in_mean_counter, individual._in_mean_counter, sizeof(int)*_m);
  memcpy(_out_mean_km_f, individual._out_mean_km_f, sizeof(double)*_m);
  memcpy(_out_mean_vmax_f, individual._out_mean_vmax_f, sizeof(double)*_m);
  memcpy(_out_mean_km_b, individual._out_mean_km_b, sizeof(double)*_m);
  memcpy(_out_mean_vmax_b, individual._out_mean_vmax_b, sizeof(double)*_m);
  memcpy(_out_mean_counter, individual._out_mean_counter, sizeof(int)*_m);
  
  /*----------------------------------------------------- PHENOTYPE */
  
  _mutated = individual._mutated;
  /*** Allocate concentration memory ***/
  _s     = NULL;
  _old_s = NULL;
  _s     = new double[_m];
  _old_s = new double[_m];
  memcpy(_s, individual._s, sizeof(double)*_m);
  memcpy(_old_s, individual._old_s, sizeof(double)*_m);
  _c     = individual._c;
  _old_c = individual._old_c;
  _c_opt = individual._c_opt;
  _w     = individual._w;
  
  /*----------------------------------------------------- REACTION LIST */
  
  /*** Allocate reaction list and ODE solver memory ***/
  _reaction_list = NULL;
  _ode_solver    = NULL;
  copy_reaction_list(individual._reaction_list);
  create_ode_solver();
  _dt       = individual._dt;
  _isStable = individual._isStable;
  
  /*----------------------------------------------------- TREE MANAGEMENT */
  
  _prepared_for_tree = individual._prepared_for_tree;
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
Individual::~Individual( void )
{
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  _parameters = NULL;
  _prng       = NULL;
  
  /*----------------------------------------------------- NETWORK STRUCTURE */
  
  if (!_prepared_for_tree)
  {
    delete_stoichiometric_matrix();
    delete[] _degree;
    _degree = NULL;
    delete[] _in_degree;
    _in_degree = NULL;
    delete[] _out_degree;
    _out_degree = NULL;
    delete[] _mean_km_f;
    _mean_km_f = NULL;
    delete[] _mean_vmax_f;
    _mean_vmax_f = NULL;
    delete[] _mean_km_b;
    _mean_km_b = NULL;
    delete[] _mean_vmax_b;
    _mean_vmax_b = NULL;
    delete[] _mean_counter;
    _mean_counter = NULL;
    delete[] _in_mean_km_f;
    _in_mean_km_f = NULL;
    delete[] _in_mean_vmax_f;
    _in_mean_vmax_f = NULL;
    delete[] _in_mean_km_b;
    _in_mean_km_b = NULL;
    delete[] _in_mean_vmax_b;
    _in_mean_vmax_b = NULL;
    delete[] _in_mean_counter;
    _in_mean_counter = NULL;
    delete[] _out_mean_km_f;
    _out_mean_km_f = NULL;
    delete[] _out_mean_vmax_f;
    _out_mean_vmax_f = NULL;
    delete[] _out_mean_km_b;
    _out_mean_km_b = NULL;
    delete[] _out_mean_vmax_b;
    _out_mean_vmax_b = NULL;
    delete[] _out_mean_counter;
    _out_mean_counter = NULL;
  }
  
  /*----------------------------------------------------- PHENOTYPE */
  
  delete[] _s;
  _s = NULL;
  if (!_prepared_for_tree)
  {
    delete[] _old_s;
    _old_s = NULL;
  }
  
  /*----------------------------------------------------- REACTION LIST */
  
  delete_reaction_list();
  if (!_prepared_for_tree)
  {
    delete_ode_solver();
  }
}

/*----------------------------
 * PUBLIC METHODS
 *----------------------------*/

/**
 * \brief    Initialize the metabolic vector
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::initialize( void )
{
  /*----------------------------------------------------- NETWORK STRUCTURE */
  
  /*** Generate linear pathway ***/
  if (_parameters->get_structure() == LINEAR_PATHWAY)
  {
    generate_linear_pathway_matrix();
  }
  /*** Or generate basic random network ***/
  else if (_parameters->get_structure() == RANDOM_NETWORK)
  {
    generate_random_network_matrix();
  }
  /*** Or generate scale-free network ***/
  else if (_parameters->get_structure() == SCALE_FREE_NETWORK)
  {
    generate_scale_free_network_matrix();
  }
  save_stoichiometric_matrix("ancestor/ancestor_stoichiometric_matrix.txt");
  
  /*----------------------------------------------------- REACTION LIST */
  
  /*** Generate reaction list (no allocation) ***/
  generate_random_reaction_list();
  save_reaction_list("ancestor/ancestor_reaction_list.txt", "ancestor/ancestor_adjacency_list.txt");
  
  /*** Initialize the ODE solver ***/
  create_ode_solver();
  initialize_concentration_vector();
  
  /*----------------------------------------------------- PHENOTYPE */
  
  /*** Compute steady-state and fitness ***/
  compute_steady_state(true);
  save_indidivual_state("ancestor/ancestor_individual.txt");
  compute_c();
  _c_opt = _c;
  compute_fitness();
}

/**
 * \brief    Mutate the metabolic vector
 * \details  --
 * \param    double sigma
 * \param    double mu
 * \return   \e void
 */
void Individual::mutate( double sigma, double mu )
{
  _mutated = false;
  for (int i = 0; i < _reaction_list->r; i++)
  {
    /*------------------------------*/
    /* 1) Mutate forward parameters */
    /*------------------------------*/
    if (_reaction_list->type[i] == OUTFLOWING_REACTION || _reaction_list->type[i] == IRREVERSIBLE_REACTION || _reaction_list->type[i] == REVERSIBLE_REACTION)
    {
      /*** Mutate KM_F ***/
      if (_prng->uniform() < mu)
      {
        double log_km  = log10(_reaction_list->km_f[i]);
        double new_val = pow(10.0, _prng->gaussian(log_km, sigma));
        if (new_val < KM_F_MIN)
        {
          new_val = KM_F_MIN;
        }
        else if (new_val > KM_F_MAX)
        {
          new_val = KM_F_MAX;
        }
        _reaction_list->km_f[i] = new_val;
        _mutated                = true;
      }
      /*** Mutate Vmax_F ***/
      if (_prng->uniform() < mu)
      {
        double log_vmax = log10(_reaction_list->vmax_f[i]);
        double new_val  = pow(10.0, _prng->gaussian(log_vmax, sigma));
        if (new_val < VMAX_F_MIN)
        {
          new_val = VMAX_F_MIN;
        }
        else if (new_val > VMAX_F_MAX)
        {
          new_val = VMAX_F_MAX;
        }
        _reaction_list->vmax_f[i] = new_val;
        _mutated                  = true;
      }
    }
    
    /*-------------------------------*/
    /* 2) Mutate backward parameters */
    /*-------------------------------*/
    if (_reaction_list->type[i] == REVERSIBLE_REACTION)
    {
      /*** Mutate KM_B ***/
      if (_prng->uniform() < mu)
      {
        double log_km  = log10(_reaction_list->km_b[i]);
        double new_val = pow(10.0, _prng->gaussian(log_km, sigma));
        if (new_val < KM_B_MIN)
        {
          new_val = KM_B_MIN;
        }
        else if (new_val > KM_B_MAX)
        {
          new_val = KM_B_MAX;
        }
        _reaction_list->km_b[i] = new_val;
        _mutated                = true;
      }
      /*** Mutate Vmax_B ***/
      if (_prng->uniform() < mu)
      {
        double log_vmax = log10(_reaction_list->vmax_b[i]);
        double new_val  = pow(10.0, _prng->gaussian(log_vmax, sigma));
        if (new_val < _reaction_list->vmax_f[i])
        {
          new_val = _reaction_list->vmax_f[i];
        }
        else if (new_val > VMAX_B_MAX)
        {
          new_val = VMAX_B_MAX;
        }
        _reaction_list->vmax_b[i] = new_val;
        _mutated                  = true;
      }
    }
  }
}

/**
 * \brief    Compute the new steady-state
 * \details  --
 * \param    bool ancestor
 * \return   \e void
 */
void Individual::compute_steady_state( bool ancestor )
{
  double max_time = IND_STEADY_STATE_MAX_T;
  if (ancestor)
  {
    max_time = ANC_STEADY_STATE_MAX_T;
  }
  /*-------------------------------*/
  /* 1) Save previous steady-state */
  /*-------------------------------*/
  memcpy(_old_s, _s, sizeof(double)*_m);
  
  /*-------------------------------*/
  /* 2) If mutated, compute the    */
  /*    new steady-state           */
  /*-------------------------------*/
  if (_mutated || ancestor)
  {
    _isStable              = false;
    double  t              = 0.0;
    int     counter        = 0;
    int     stable_counter = 0;
    bool    endOfSolving   = false;
    double* previous_s     = new double[_m];
    
    /* save */
    std::ofstream file;
    if (ancestor)
    {
      file.open("ancestor/ancestor_ode_trajectories.txt", std::ios::out | std::ios::trunc);
      file << "t dt";
      for (int i = 0; i < _m; i++)
      {
        file << " " << i+1;
      }
      file << "\n";
      file << t << " " << _dt;
      for (int i = 0; i < _m; i++)
      {
        file << " " << _s[i];
      }
      file << "\n";
    }
    /********/
    
    while (!endOfSolving)
    {
      bool stable   = false;
      bool too_low  = false;
      bool too_high = false;
      bool too_long = false;
      memcpy(previous_s, _s, sizeof(double)*_m);
      double old_dt = _dt;
      
      _ode_solver->solve(_dt, t, _dt);
      
      if (old_dt == _dt && counter%10 == 0)
      {
        _dt *= 2.0;
      }
      
      /* save */
      if (ancestor && counter%10000 == 0)
      {
        file << t << " " << _dt;
        for (int i = 0; i < _m; i++)
        {
          file << " " << _s[i];
        }
        file << "\n";
        file.flush();
      }
      /*******/
      
      stable = true;
      for (int i = 0; i < _m; i++)
      {
        if (fabs(_s[i]-previous_s[i])/previous_s[i] > STEADY_STATE_DIFF_TH)
        {
          stable = false;
        }
        if (_s[i] < MINIMUM_CONCENTRATION)
        {
          too_low = true;
        }
        else if (_s[i] > MAXIMUM_CONCENTRATION)
        {
          too_high = true;
        }
      }
      if (stable)
      {
        stable_counter++;
      }
      if (stable_counter > 10)
      {
        _isStable = true;
      }
      if (t > max_time)
      {
        too_long = true;
      }
      if (_isStable || too_low || too_high || too_long)
      {
        endOfSolving = true;
      }
      counter++;
    }
  }
}

/**
 * \brief    Compute the sum of metabolites c
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::compute_c( void )
{
  _c = 0.0;
  for (int i = 0; i < _m; i++)
  {
    _c += _s[i];
  }
}

/**
 * \brief    Compute the fitness
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::compute_fitness( void )
{
  double xopt = log10(_c_opt);
  double x    = log10(_c);
  if (_isStable)
  {
    _w = _parameters->get_beta()+(1.0-_parameters->get_beta())*exp(-_parameters->get_alpha()*pow(x-xopt, _parameters->get_Q())/(_parameters->get_w()*_parameters->get_w()));
  }
  else
  {
    _w = 0.0;
  }
}

/**
 * \brief    Create the stoichiometric matrix
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::create_stoichiometric_matrix( void )
{
  assert(_S == NULL);
  _S = new reaction_type*[_Sdim];
  for (int i = 0; i < _Sdim; i++)
  {
    _S[i] = new reaction_type[_Sdim];
    for (int j = 0; j < _Sdim; j++)
    {
      _S[i][j] = NO_REACTION;
    }
  }
}

/**
 * \brief    Create and copy the stoichiometric matrix
 * \details  --
 * \param    reaction_type** S
 * \return   \e void
 */
void Individual::copy_stoichiometric_matrix( reaction_type** S )
{
  assert(_S == NULL);
  _S = new reaction_type*[_Sdim];
  for (int i = 0; i < _Sdim; i++)
  {
    _S[i] = new reaction_type[_Sdim];
    for (int j = 0; j < _Sdim; j++)
    {
      _S[i][j] = S[i][j];
    }
  }
}

/**
 * \brief    Print the stoichiometric matrix
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::print_stoichiometric_matrix( void )
{
  std::cout << "====== STOICHIOMETRIC MATRIX ======\n";
  
  for (int i = 0; i < _Sdim; i++)
  {
    if (i < _m)
    {
      std::cout << i+1 << "\t";
    }
    else if (i == _m)
    {
      std::cout << "in\t";
    }
    else if (i == _m+1)
    {
      std::cout << "out\t";
    }
    for (int j = 0; j < _Sdim; j++)
    {
      std::cout << _S[i][j] << " ";
    }
    std::cout << "\n";
  }
  std::cout << "- - - - - - - - - - - - - - - - - -\n";
  std::cout << "m  Degree In-degree Out-degree\n";
  for (int i = 0; i < _m; i++)
  {
    std::cout << i+1 << "\t" << _degree[i] << "\t" << _in_degree[i] << "\t" << _out_degree[i] << "\n";
  }
  std::cout << "===================================\n\n";
}

/**
 * \brief    Save the stoichiometric matrix in a file
 * \details  --
 * \param    std::string filename
 * \return   \e void
 */
void Individual::save_stoichiometric_matrix( std::string filename )
{
  /*-------------------------------*/
  /* 1) Save stoichiometric matrix */
  /*-------------------------------*/
  std::ofstream file(filename, std::ios::out | std::ios::trunc);
  for (int i = 0; i < _Sdim; i++)
  {
    for (int j = 0; j < _Sdim; j++)
    {
      if (j < _Sdim-1)
      {
        if (_S[i][j] != NO_REACTION)
        {
          file << "1 ";
        }
        else
        {
          file << "0 ";
        }
      }
      else
      {
        if (_S[i][j] != NO_REACTION)
        {
          file << "1\n";
        }
        else
        {
          file << "0\n";
        }
      }
    }
  }
  file.close();
}

/**
 * \brief    Delete the stoichiometric matrix
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::delete_stoichiometric_matrix( void )
{
  for (int i = 0; i < _Sdim; i++)
  {
    delete[] _S[i];
    _S[i] = NULL;
  }
  delete[] _S;
  _S = NULL;
}

/**
 * \brief    Generate a linear pathway stoichiometric matrix
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::generate_linear_pathway_matrix( void )
{
  /*----------------------------------------*/
  /* 1) Influx and outflux are irreversible */
  /*----------------------------------------*/
  _S[_influx_index][0] = INFLOWING_REACTION;
  _in_degree[0]++;
  _degree[0]++;
  
  _S[_m-1][_outflux_index] = OUTFLOWING_REACTION;
  _out_degree[_m-1]++;
  _degree[_m-1]++;
  
  /*----------------------------------------*/
  /* 2) Create links, reversible or not     */
  /*----------------------------------------*/
  for (int i = 0; i < _m-1; i++)
  {
    if (_prng->uniform() < _parameters->get_p_reversible())
    {
      _S[i][i+1] = REVERSIBLE_REACTION;
      _out_degree[i]++;
      _degree[i]++;
      _in_degree[i+1]++;
      _degree[i+1]++;
    }
    else
    {
      _S[i][i+1] = IRREVERSIBLE_REACTION;
      _out_degree[i]++;
      _degree[i]++;
      _in_degree[i+1]++;
      _degree[i+1]++;
    }
  }
}

/**
 * \brief    Generate a random stoichiometric matrix
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::generate_random_network_matrix( void )
{
  bool connected = false;
  while (!connected)
  {
    /*----------------------------------------*/
    /* 1) Initialize the network              */
    /*----------------------------------------*/
    for (int i = 0; i < _Sdim; i++)
    {
      for (int j = 0; j < _Sdim; j++)
      {
        _S[i][j] = NO_REACTION;
      }
    }
    for (int i = 0; i < _m; i++)
    {
      _degree[i]     = 0;
      _in_degree[i]  = 0;
      _out_degree[i] = 0;
    }
    
    /*----------------------------------------*/
    /* 2) Influx and outflux are irreversible */
    /*----------------------------------------*/
    _S[_influx_index][0] = INFLOWING_REACTION;
    _in_degree[0]++;
    _degree[0]++;
    
    _S[_m-1][_outflux_index] = OUTFLOWING_REACTION;
    _out_degree[_m-1]++;
    _degree[_m-1]++;
    
    /*----------------------------------------*/
    /* 3) Create links, reversible or not     */
    /*----------------------------------------*/
    for (int iter = 0; iter < _parameters->get_nb_random_iterations(); iter++)
    {
      int s = _prng->uniform(0, _m-1);
      int p = _prng->uniform(0, _m-1);
      while (s == p)
      {
        p = _prng->uniform(0, _m-1);
      }
      if (_S[s][p] == NO_REACTION)
      {
        if (_prng->uniform() < _parameters->get_p_reversible())
        {
          _S[s][p] = REVERSIBLE_REACTION;
          _out_degree[s]++;
          _degree[s]++;
          _in_degree[p]++;
          _degree[p]++;
        }
        else
        {
          _S[s][p] = IRREVERSIBLE_REACTION;
          _out_degree[s]++;
          _degree[s]++;
          _in_degree[p]++;
          _degree[p]++;
        }
      }
    }
    
    /*----------------------------------------*/
    /* 4) Test the network's connectivity     */
    /*----------------------------------------*/
    connected    = true;
    int* reached = new int[_m];
    for (int i = 0; i < _m; i++)
    {
      for (int j = 0; j < _m; j++)
      {
        reached[j] = 0;
      }
      reached[i] = 1;
      DFS(i, reached);
      if (reached[_m-1] == 0)
      {
        connected = false;
      }
      if (i == 0)
      {
        for (int j = 0; j < _m; j++)
        {
          if (reached[j] == 0)
          {
            connected = false;
          }
        }
      }
    }
    delete[] reached;
    reached = NULL;
  }
}

void Individual::generate_scale_free_network_matrix( void )
{
  /* TODO */
}

/**
 * \brief    Run a depth first search algorithm
 * \details  --
 * \param    int i
 * \return   \e void
 */
void Individual::DFS( int i, int* reached )
{
  for (int j = 0; j < _m; j++)
  {
    if (reached[j] == 0 && (_S[i][j] == IRREVERSIBLE_REACTION || _S[i][j] == REVERSIBLE_REACTION))
    {
      reached[j] = 1;
      DFS(j, reached);
    }
  }
}

/**
 * \brief    Create the reaction list
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::create_reaction_list( void )
{
  assert(_reaction_list == NULL);
  _reaction_list = new reaction_list;
}

/**
 * \brief    Create and copy the reaction list
 * \details  --
 * \param    reaction_list* list
 * \return   \e void
 */
void Individual::copy_reaction_list( reaction_list* list )
{
  assert(_reaction_list == NULL);
  _reaction_list         = new reaction_list;
  _reaction_list->s      = list->s;
  _reaction_list->p      = list->p;
  _reaction_list->type   = list->type;
  _reaction_list->km_f   = list->km_f;
  _reaction_list->vmax_f = list->vmax_f;
  _reaction_list->km_b   = list->km_b;
  _reaction_list->vmax_b = list->vmax_b;
  _reaction_list->m      = list->m;
  _reaction_list->r      = list->r;
}

/**
 * \brief    Print the reaction list
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::print_reaction_list( void )
{
  std::cout << "====== REACTION LIST ======\n";
  std::cout << "Nb metabolites = " << _reaction_list->m << "\n";
  std::cout << "Nb reactions = " << _reaction_list->r << "\n";
  std::cout << "- - - - - - - - - - - - - -\n";
  for (int i = 0; i < _reaction_list->r; i++)
  {
    std::cout << "s=" << _reaction_list->s[i];
    std::cout << ", p=" << _reaction_list->p[i];
    std::cout << ", type=" << _reaction_list->type[i];
    std::cout << ", kmF=" << _reaction_list->km_f[i];
    std::cout << ", vmaxF=" << _reaction_list->vmax_f[i];
    std::cout << ", kmB=" << _reaction_list->km_b[i];
    std::cout << ", vmaxB=" << _reaction_list->vmax_b[i] << "\n";
  }
  std::cout << "===========================\n\n";
}

/**
 * \brief    Save the reaction list in a file
 * \details  --
 * \param    std::string reaction_list_filename
 * \param    std::string adjacency_list_filename
 * \return   \e void
 */
void Individual::save_reaction_list( std::string reaction_list_filename, std::string adjacency_list_filename )
{
  /*----------------------------*/
  /* 1) Save full reaction list */
  /*----------------------------*/
  std::ofstream file(reaction_list_filename, std::ios::out | std::ios::trunc);
  file << "substrate product reaction_type km_f vmax_f km_b vmax_b\n";
  for (int i = 0; i < _reaction_list->r; i++)
  {
    file << _reaction_list->s[i] << " ";
    file << _reaction_list->p[i] << " ";
    file << _reaction_list->type[i] << " ";
    file << _reaction_list->km_f[i] << " ";
    file << _reaction_list->vmax_f[i] << " ";
    file << _reaction_list->km_b[i] << " ";
    file << _reaction_list->vmax_b[i] << "\n";
  }
  file.close();
  
  /*----------------------------*/
  /* 2) Save adjacency list     */
  /*----------------------------*/
  file.open(adjacency_list_filename, std::ios::out | std::ios::trunc);
  for (int i = 0; i < _reaction_list->r; i++)
  {
    if (_reaction_list->type[i] == INFLOWING_REACTION)
    {
      file << "IN" << " " << _reaction_list->p[i] << "\n";
    }
    else if (_reaction_list->type[i] == OUTFLOWING_REACTION)
    {
      file << _reaction_list->s[i] << " " << "OUT" << "\n";
    }
    else if (_reaction_list->type[i] == IRREVERSIBLE_REACTION)
    {
      file << _reaction_list->s[i] << " " << _reaction_list->p[i] << "\n";
    }
    else if (_reaction_list->type[i] == REVERSIBLE_REACTION)
    {
      file << _reaction_list->s[i] << " " << _reaction_list->p[i] << "\n";
      file << _reaction_list->p[i] << " " << _reaction_list->s[i] << "\n";
    }
  }
  file.close();
}

/**
 * \brief    Delete the reaction list
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::delete_reaction_list( void )
{
  delete _reaction_list;
  _reaction_list = NULL;
}

/**
 * \brief    Create the ODE solver
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::create_ode_solver( void )
{
  assert(_ode_solver == NULL);
  _ode_solver = new ODESolver(_reaction_list, _s);
}

/**
 * \brief    Delete the ODE solver
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::delete_ode_solver( void )
{
  delete _ode_solver;
  _ode_solver = NULL;
}

/**
 * \brief    Add a reaction to the reaction list
 * \details  --
 * \param    int s
 * \param    int p
 * \param    reaction_type rtype
 * \param    double km_f
 * \param    double vmax_f
 * \param    double km_b
 * \param    double vmax_b
 * \return   \e void
 */
void Individual::add_reaction( int s, int p, reaction_type rtype, double km_f, double vmax_f, double km_b, double vmax_b )
{
  /*------------------------------------------*/
  /* 1) Check consistency                     */
  /*------------------------------------------*/
  assert(s >= 0);
  assert(s < _Sdim);
  assert(p >= 0);
  assert(p < _Sdim);
  assert(rtype == NO_REACTION || rtype == INFLOWING_REACTION || rtype == OUTFLOWING_REACTION || rtype == IRREVERSIBLE_REACTION || rtype == REVERSIBLE_REACTION);
  if (rtype == OUTFLOWING_REACTION || rtype == IRREVERSIBLE_REACTION || rtype == REVERSIBLE_REACTION)
  {
    assert(km_f >= KM_F_MIN);
    assert(km_f <= KM_F_MAX);
    assert(vmax_f >= VMAX_F_MIN);
    assert(vmax_f <= VMAX_F_MAX);
    if (rtype == REVERSIBLE_REACTION)
    {
      assert(km_b >= KM_B_MIN);
      assert(km_b <= KM_B_MAX);
      assert(vmax_b >= VMAX_B_MIN);
      assert(vmax_b <= VMAX_B_MAX);
    }
    else
    {
      assert(km_b == 0.0);
      assert(vmax_b == 0.0);
    }
  }
  else
  {
    assert(km_f == 0.0);
    assert(vmax_f == 0.0);
    assert(km_b == 0.0);
    assert(vmax_b == 0.0);
  }
  
  /*------------------------------------------*/
  /* 2) Add the reaction to the reaction list */
  /*------------------------------------------*/
  _reaction_list->s.push_back(s);
  _reaction_list->p.push_back(p);
  _reaction_list->type.push_back(rtype);
  _reaction_list->km_f.push_back(km_f);
  _reaction_list->vmax_f.push_back(vmax_f);
  _reaction_list->km_b.push_back(km_b);
  _reaction_list->vmax_b.push_back(vmax_b);
  
  /*------------------------------------------*/
  /* 3) Save kinetic parameter values         */
  /*------------------------------------------*/
  if (rtype == OUTFLOWING_REACTION || rtype == IRREVERSIBLE_REACTION || rtype == REVERSIBLE_REACTION)
  {
    _mean_km_f[s]       += km_f;
    _mean_vmax_f[s]     += vmax_f;
    _mean_km_b[s]       += km_b;
    _mean_vmax_b[s]     += vmax_b;
    _mean_counter[s]++;
    _out_mean_km_f[s]   += km_f;
    _out_mean_vmax_f[s] += vmax_f;
    _out_mean_km_b[s]   += km_b;
    _out_mean_vmax_b[s] += vmax_b;
    _out_mean_counter[s]++;
    if (rtype != OUTFLOWING_REACTION)
    {
      _mean_km_f[p]   += km_f;
      _mean_vmax_f[p] += vmax_f;
      _mean_km_b[p]   += km_b;
      _mean_vmax_b[p] += vmax_b;
      _mean_counter[p]++;
      _in_mean_km_f[p]   += km_f;
      _in_mean_vmax_f[p] += vmax_f;
      _in_mean_km_b[p]   += km_b;
      _in_mean_vmax_b[p] += vmax_b;
      _in_mean_counter[p]++;
    }
  }
}

/**
 * \brief    Generate a random reaction list
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::generate_random_reaction_list( void )
{
  /*-----------------------------------------------*/
  /* 1) Generate the reaction list                 */
  /*-----------------------------------------------*/
  double log_km_f_min   = log10(KM_F_MIN);
  double log_km_f_max   = log10(KM_F_MAX);
  double log_vmax_f_min = log10(VMAX_F_MIN);
  double log_vmax_f_max = log10(VMAX_F_MAX);
  //double log_km_b_min   = log10(KM_B_MIN);
  double log_km_b_max   = log10(KM_B_MAX);
  double log_vmax_b_min = log10(VMAX_B_MIN);
  //double log_vmax_b_max = log10(VMAX_B_MAX);
  int    nb_reactions   = 0;
  for (int i = 0; i < _Sdim; i++)
  {
    for (int j = 0; j < _Sdim; j++)
    {
      /*-----------------------------------------------------*/
      /* 1.1) If the reaction is an inflowing reaction       */
      /*-----------------------------------------------------*/
      if (_S[i][j] == INFLOWING_REACTION && i == _influx_index && j < _influx_index)
      {
        add_reaction(i, j, INFLOWING_REACTION, 0.0, 0.0, 0.0, 0.0);
        nb_reactions++;
      }
      /*-----------------------------------------------------*/
      /* 1.2) Else if the reaction is an outflowing reaction */
      /*-----------------------------------------------------*/
      else if (_S[i][j] == OUTFLOWING_REACTION && i < _influx_index && j == _outflux_index)
      {
        double log_km_f   = _prng->uniform()*(log_km_f_max-log_km_f_min)+log_km_f_min;
        double log_vmax_f = _prng->uniform()*(log_vmax_f_max-log_vmax_f_min)+log_vmax_f_min;
        double km_f       = pow(10.0, log_km_f);
        double vmax_f     = pow(10.0, log_vmax_f);
        add_reaction(i, j, OUTFLOWING_REACTION, km_f, vmax_f, 0.0, 0.0);
        nb_reactions++;
      }
      /*-----------------------------------------------------*/
      /* 1.3) Else if the reaction is irreversible           */
      /*-----------------------------------------------------*/
      else if (_S[i][j] == IRREVERSIBLE_REACTION && i < _influx_index && j < _influx_index)
      {
        double log_km_f   = _prng->uniform()*(log_km_f_max-log_km_f_min)+log_km_f_min;
        double log_vmax_f = _prng->uniform()*(log_vmax_f_max-log_vmax_f_min)+log_vmax_f_min;
        double km_f       = pow(10.0, log_km_f);
        double vmax_f     = pow(10.0, log_vmax_f);
        add_reaction(i, j, IRREVERSIBLE_REACTION, km_f, vmax_f, 0.0, 0.0);
        nb_reactions++;
      }
      /*-----------------------------------------------------*/
      /* 1.4) Else if the reaction is reversible             */
      /*-----------------------------------------------------*/
      else if (_S[i][j] == REVERSIBLE_REACTION && i < _influx_index && j < _influx_index)
      {
        double log_km_f   = _prng->uniform()*(log_km_f_max-log_km_f_min)+log_km_f_min;
        double log_vmax_f = _prng->uniform()*(log_vmax_f_max-log_vmax_f_min)+log_vmax_f_min;
        double log_km_b   = _prng->uniform()*(log_km_b_max-log_km_f)+log_km_f;
        double log_vmax_b = _prng->uniform()*(log_vmax_f-log_vmax_b_min)+log_vmax_b_min;
        double km_f       = pow(10.0, log_km_f);
        double vmax_f     = pow(10.0, log_vmax_f);
        double km_b       = pow(10.0, log_km_b);
        double vmax_b     = pow(10.0, log_vmax_b);
        add_reaction(i, j, REVERSIBLE_REACTION, km_f, vmax_f, km_b, vmax_b);
        nb_reactions++;
      }
      else
      {
        if (_S[i][j] != NO_REACTION)
        {
          std::cout << "Incorrect reaction scheme in Individual::generate_reaction_list(). Exit.\n";
          exit(EXIT_FAILURE);
        }
        
      }
    }
  }
  _reaction_list->m = _m;
  _reaction_list->r = nb_reactions;
  
  /*-----------------------------------------------*/
  /* 2) Compute mean kinetic values per metabolite */
  /*-----------------------------------------------*/
  for (int i = 0; i < _m; i++)
  {
    if (_mean_counter[i] > 0)
    {
      _mean_km_f[i]       /= (double)_mean_counter[i];
      _mean_vmax_f[i]     /= (double)_mean_counter[i];
      _mean_km_b[i]       /= (double)_mean_counter[i];
      _mean_vmax_b[i]     /= (double)_mean_counter[i];
    }
    if (_in_mean_counter[i] > 0)
    {
      _in_mean_km_f[i]    /= (double)_in_mean_counter[i];
      _in_mean_vmax_f[i]  /= (double)_in_mean_counter[i];
      _in_mean_km_b[i]    /= (double)_in_mean_counter[i];
      _in_mean_vmax_b[i]  /= (double)_in_mean_counter[i];
    }
    if (_out_mean_counter[i] > 0)
    {
      _out_mean_km_f[i]   /= (double)_out_mean_counter[i];
      _out_mean_vmax_f[i] /= (double)_out_mean_counter[i];
      _out_mean_km_b[i]   /= (double)_out_mean_counter[i];
      _out_mean_vmax_b[i] /= (double)_out_mean_counter[i];
    }
  }
}

/**
 * \brief    Initialize the concentration vector
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::initialize_concentration_vector( void )
{
  if (_parameters->get_structure() == LINEAR_PATHWAY)
  {
    for (int i = 0; i < _m; i++)
    {
      _s[i] = (_reaction_list->km_f[i]*INFLUX)/(_reaction_list->vmax_f[i]-INFLUX);
    }
  }
  else
  {
    for (int i = 0; i < _m; i++)
    {
      _s[i] = 100.0;
    }
  }
  
}

/**
 * \brief    Save the current individual state
 * \details  --
 * \param    std::string filename
 * \return   \e void
 */
void Individual::save_indidivual_state( std::string filename )
{
  std::ofstream file(filename, std::ios::out | std::ios::trunc);
  file << "met s copt mean_km_f mean_vmax_f mean_km_b mean_vmax_b in_mean_km_f in_mean_vmax_f in_mean_km_b in_mean_vmax_b out_mean_km_f out_mean_vmax_f out_mean_km_b out_mean_vmax_b degree in_degree out_degree\n";
  for (int i = 0; i < _m; i++)
  {
    file << i+1 << " ";
    file << _s[i] << " ";
    file << _c_opt << " ";
    file << _mean_km_f[i] << " ";
    file << _mean_vmax_f[i] << " ";
    file << _mean_km_b[i] << " ";
    file << _mean_vmax_b[i] << " ";
    file << _in_mean_km_f[i] << " ";
    file << _in_mean_vmax_f[i] << " ";
    file << _in_mean_km_b[i] << " ";
    file << _in_mean_vmax_b[i] << " ";
    file << _out_mean_km_f[i] << " ";
    file << _out_mean_vmax_f[i] << " ";
    file << _out_mean_km_b[i] << " ";
    file << _out_mean_vmax_b[i] << " ";
    file << _degree[i] << " ";
    file << _in_degree[i] << " ";
    file << _out_degree[i] << "\n";
  }
  file.close();
}

/**
 * \brief    Prepare the individual saved in the tree
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::prepare_for_tree( void )
{
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  _parameters = NULL;
  _prng       = NULL;
  
  /*----------------------------------------------------- NETWORK STRUCTURE */
  
  delete_stoichiometric_matrix();
  delete[] _degree;
  _degree = NULL;
  delete[] _in_degree;
  _in_degree = NULL;
  delete[] _out_degree;
  _out_degree = NULL;
  delete[] _mean_km_f;
  _mean_km_f = NULL;
  delete[] _mean_vmax_f;
  _mean_vmax_f = NULL;
  delete[] _mean_km_b;
  _mean_km_b = NULL;
  delete[] _mean_vmax_b;
  _mean_vmax_b = NULL;
  delete[] _mean_counter;
  _mean_counter = NULL;
  delete[] _in_mean_km_f;
  _in_mean_km_f = NULL;
  delete[] _in_mean_vmax_f;
  _in_mean_vmax_f = NULL;
  delete[] _in_mean_km_b;
  _in_mean_km_b = NULL;
  delete[] _in_mean_vmax_b;
  _in_mean_vmax_b = NULL;
  delete[] _in_mean_counter;
  _in_mean_counter = NULL;
  delete[] _out_mean_km_f;
  _out_mean_km_f = NULL;
  delete[] _out_mean_vmax_f;
  _out_mean_vmax_f = NULL;
  delete[] _out_mean_km_b;
  _out_mean_km_b = NULL;
  delete[] _out_mean_vmax_b;
  _out_mean_vmax_b = NULL;
  delete[] _out_mean_counter;
  _out_mean_counter = NULL;
  
  /*----------------------------------------------------- PHENOTYPE */
  
  delete[] _old_s;
  _old_s = NULL;
  
  /*----------------------------------------------------- REACTION LIST */
  
  delete_ode_solver();
  
  /*----------------------------------------------------- TREE MANAGEMENT */
  
  _prepared_for_tree = true;
}

/*----------------------------
 * PROTECTED METHODS
 *----------------------------*/

