
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
  create_fixed_param_to_index_map();
  create_mutable_param_to_index_map();
  create_met_to_index_map();
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
  _fixed_param_to_index.clear();
  _mutable_param_to_index.clear();
  _met_to_index.clear();
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
  
  Individual* ancestor = new Individual(_parameters);
  ancestor->initialize();
  
  /*** Generate the initial population ***/
  for (int i = 0; i < _n; i++)
  {
    /*** Create new individual ***/
    _pop[i] = new Individual(*ancestor);
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
  for (std::unordered_map<std::string, int>::iterator it = _met_to_index.begin(); it != _met_to_index.end(); ++it)
  {
    _mean_s_file << " " << it->first;
    _var_s_file << " " << it->first;
    _cv_s_file << " " << it->first;
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
  for (std::unordered_map<std::string, int>::iterator it = _met_to_index.begin(); it != _met_to_index.end(); ++it)
  {
    _mean_s_file << " " << _mean_s[it->second];
    _var_s_file << " " << _var_s[it->second];
    _cv_s_file << " " << _cv_s[it->second];
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
  _pop[_best_pos]->save_indidivual_state("best/best_params.txt", "best/best_conc.txt");
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

/**
 * \brief    Create the fixed parameter to index map
 * \details  --
 * \param    void
 * \return   \e void
 */
void Population::create_fixed_param_to_index_map( void )
{
  _fixed_param_to_index.clear();
  _fixed_param_to_index["Atot"]     = 0;
  _fixed_param_to_index["EqMult"]   = 1;
  _fixed_param_to_index["GStotal"]  = 2;
  _fixed_param_to_index["Inhibv1"]  = 3;
  _fixed_param_to_index["L0v12"]    = 4;
  _fixed_param_to_index["L0v3"]     = 5;
  _fixed_param_to_index["Mgtot"]    = 6;
  _fixed_param_to_index["NADPtot"]  = 7;
  _fixed_param_to_index["NADtot"]   = 8;
  _fixed_param_to_index["alfav0"]   = 9;
  _fixed_param_to_index["protein1"] = 10;
  _fixed_param_to_index["protein2"] = 11;
  _fixed_param_to_index["Glcout"]   = 12;
  _fixed_param_to_index["Lacex"]    = 13;
  _fixed_param_to_index["PRPP"]     = 14;
  _fixed_param_to_index["Phiex"]    = 15;
  _fixed_param_to_index["Pyrex"]    = 16;
}

/**
 * \brief    Create the mutable parameter to index map
 * \details  --
 * \param    void
 * \return   \e void
 */
void Population::create_mutable_param_to_index_map( void )
{
  _mutable_param_to_index.clear();
  _mutable_param_to_index["K13P2Gv6"]    = 0;
  _mutable_param_to_index["K13P2Gv7"]    = 1;
  _mutable_param_to_index["K1v23"]       = 2;
  _mutable_param_to_index["K1v24"]       = 3;
  _mutable_param_to_index["K1v26"]       = 4;
  _mutable_param_to_index["K23P2Gv1"]    = 5;
  _mutable_param_to_index["K23P2Gv8"]    = 6;
  _mutable_param_to_index["K23P2Gv9"]    = 7;
  _mutable_param_to_index["K2PGv10"]     = 8;
  _mutable_param_to_index["K2PGv11"]     = 9;
  _mutable_param_to_index["K2v23"]       = 10;
  _mutable_param_to_index["K2v24"]       = 11;
  _mutable_param_to_index["K2v26"]       = 12;
  _mutable_param_to_index["K3PGv10"]     = 13;
  _mutable_param_to_index["K3PGv7"]      = 14;
  _mutable_param_to_index["K3v23"]       = 15;
  _mutable_param_to_index["K3v24"]       = 16;
  _mutable_param_to_index["K3v26"]       = 17;
  _mutable_param_to_index["K4v23"]       = 18;
  _mutable_param_to_index["K4v24"]       = 19;
  _mutable_param_to_index["K4v26"]       = 20;
  _mutable_param_to_index["K5v23"]       = 21;
  _mutable_param_to_index["K5v24"]       = 22;
  _mutable_param_to_index["K5v26"]       = 23;
  _mutable_param_to_index["K6PG1v18"]    = 24;
  _mutable_param_to_index["K6PG2v18"]    = 25;
  _mutable_param_to_index["K6v23"]       = 26;
  _mutable_param_to_index["K6v24"]       = 27;
  _mutable_param_to_index["K6v26"]       = 28;
  _mutable_param_to_index["K7v23"]       = 29;
  _mutable_param_to_index["K7v24"]       = 30;
  _mutable_param_to_index["K7v26"]       = 31;
  _mutable_param_to_index["KADPv16"]     = 32;
  _mutable_param_to_index["KAMPv16"]     = 33;
  _mutable_param_to_index["KAMPv3"]      = 34;
  _mutable_param_to_index["KATPv12"]     = 35;
  _mutable_param_to_index["KATPv16"]     = 36;
  _mutable_param_to_index["KATPv17"]     = 37;
  _mutable_param_to_index["KATPv18"]     = 38;
  _mutable_param_to_index["KATPv25"]     = 39;
  _mutable_param_to_index["KATPv3"]      = 40;
  _mutable_param_to_index["KDHAPv4"]     = 41;
  _mutable_param_to_index["KDHAPv5"]     = 42;
  _mutable_param_to_index["KFru16P2v12"] = 43;
  _mutable_param_to_index["KFru16P2v4"]  = 44;
  _mutable_param_to_index["KFru6Pv2"]    = 45;
  _mutable_param_to_index["KFru6Pv3"]    = 46;
  _mutable_param_to_index["KG6Pv17"]     = 47;
  _mutable_param_to_index["KGSHv19"]     = 48;
  _mutable_param_to_index["KGSSGv19"]    = 49;
  _mutable_param_to_index["KGlc6Pv1"]    = 50;
  _mutable_param_to_index["KGlc6Pv2"]    = 51;
  _mutable_param_to_index["KGraPv4"]     = 52;
  _mutable_param_to_index["KGraPv5"]     = 53;
  _mutable_param_to_index["KGraPv6"]     = 54;
  _mutable_param_to_index["KMGlcv1"]     = 55;
  _mutable_param_to_index["KMg23P2Gv1"]  = 56;
  _mutable_param_to_index["KMgADPv12"]   = 57;
  _mutable_param_to_index["KMgADPv7"]    = 58;
  _mutable_param_to_index["KMgATPMgv1"]  = 59;
  _mutable_param_to_index["KMgATPv1"]    = 60;
  _mutable_param_to_index["KMgATPv3"]    = 61;
  _mutable_param_to_index["KMgATPv7"]    = 62;
  _mutable_param_to_index["KMgv1"]       = 63;
  _mutable_param_to_index["KMgv3"]       = 64;
  _mutable_param_to_index["KMinv0"]      = 65;
  _mutable_param_to_index["KMoutv0"]     = 66;
  _mutable_param_to_index["KNADHv6"]     = 67;
  _mutable_param_to_index["KNADPHv17"]   = 68;
  _mutable_param_to_index["KNADPHv18"]   = 69;
  _mutable_param_to_index["KNADPHv19"]   = 70;
  _mutable_param_to_index["KNADPv17"]    = 71;
  _mutable_param_to_index["KNADPv18"]    = 72;
  _mutable_param_to_index["KNADPv19"]    = 73;
  _mutable_param_to_index["KNADv6"]      = 74;
  _mutable_param_to_index["KPEPv11"]     = 75;
  _mutable_param_to_index["KPEPv12"]     = 76;
  _mutable_param_to_index["KPGA23v17"]   = 77;
  _mutable_param_to_index["KPGA23v18"]   = 78;
  _mutable_param_to_index["KPv6"]        = 79;
  _mutable_param_to_index["KR5Pv22"]     = 80;
  _mutable_param_to_index["KR5Pv25"]     = 81;
  _mutable_param_to_index["KRu5Pv21"]    = 82;
  _mutable_param_to_index["KRu5Pv22"]    = 83;
  _mutable_param_to_index["KX5Pv21"]     = 84;
  _mutable_param_to_index["Kd1"]         = 85;
  _mutable_param_to_index["Kd2"]         = 86;
  _mutable_param_to_index["Kd23P2G"]     = 87;
  _mutable_param_to_index["Kd3"]         = 88;
  _mutable_param_to_index["Kd4"]         = 89;
  _mutable_param_to_index["KdADP"]       = 90;
  _mutable_param_to_index["KdAMP"]       = 91;
  _mutable_param_to_index["KdATP"]       = 92;
  _mutable_param_to_index["Keqv0"]       = 93;
  _mutable_param_to_index["Keqv1"]       = 94;
  _mutable_param_to_index["Keqv10"]      = 95;
  _mutable_param_to_index["Keqv11"]      = 96;
  _mutable_param_to_index["Keqv12"]      = 97;
  _mutable_param_to_index["Keqv13"]      = 98;
  _mutable_param_to_index["Keqv14"]      = 99;
  _mutable_param_to_index["Keqv16"]      = 100;
  _mutable_param_to_index["Keqv17"]      = 101;
  _mutable_param_to_index["Keqv18"]      = 102;
  _mutable_param_to_index["Keqv19"]      = 103;
  _mutable_param_to_index["Keqv2"]       = 104;
  _mutable_param_to_index["Keqv21"]      = 105;
  _mutable_param_to_index["Keqv22"]      = 106;
  _mutable_param_to_index["Keqv23"]      = 107;
  _mutable_param_to_index["Keqv24"]      = 108;
  _mutable_param_to_index["Keqv25"]      = 109;
  _mutable_param_to_index["Keqv26"]      = 110;
  _mutable_param_to_index["Keqv27"]      = 111;
  _mutable_param_to_index["Keqv28"]      = 112;
  _mutable_param_to_index["Keqv29"]      = 113;
  _mutable_param_to_index["Keqv3"]       = 114;
  _mutable_param_to_index["Keqv4"]       = 115;
  _mutable_param_to_index["Keqv5"]       = 116;
  _mutable_param_to_index["Keqv6"]       = 117;
  _mutable_param_to_index["Keqv7"]       = 118;
  _mutable_param_to_index["Keqv8"]       = 119;
  _mutable_param_to_index["Keqv9"]       = 120;
  _mutable_param_to_index["KiGraPv4"]    = 121;
  _mutable_param_to_index["KiiGraPv4"]   = 122;
  _mutable_param_to_index["Kv20"]        = 123;
  _mutable_param_to_index["Vmax1v1"]     = 124;
  _mutable_param_to_index["Vmax2v1"]     = 125;
  _mutable_param_to_index["Vmaxv0"]      = 126;
  _mutable_param_to_index["Vmaxv10"]     = 127;
  _mutable_param_to_index["Vmaxv11"]     = 128;
  _mutable_param_to_index["Vmaxv12"]     = 129;
  _mutable_param_to_index["Vmaxv13"]     = 130;
  _mutable_param_to_index["Vmaxv16"]     = 131;
  _mutable_param_to_index["Vmaxv17"]     = 132;
  _mutable_param_to_index["Vmaxv18"]     = 133;
  _mutable_param_to_index["Vmaxv19"]     = 134;
  _mutable_param_to_index["Vmaxv2"]      = 135;
  _mutable_param_to_index["Vmaxv21"]     = 136;
  _mutable_param_to_index["Vmaxv22"]     = 137;
  _mutable_param_to_index["Vmaxv23"]     = 138;
  _mutable_param_to_index["Vmaxv24"]     = 139;
  _mutable_param_to_index["Vmaxv25"]     = 140;
  _mutable_param_to_index["Vmaxv26"]     = 141;
  _mutable_param_to_index["Vmaxv27"]     = 142;
  _mutable_param_to_index["Vmaxv28"]     = 143;
  _mutable_param_to_index["Vmaxv29"]     = 144;
  _mutable_param_to_index["Vmaxv3"]      = 145;
  _mutable_param_to_index["Vmaxv4"]      = 146;
  _mutable_param_to_index["Vmaxv5"]      = 147;
  _mutable_param_to_index["Vmaxv6"]      = 148;
  _mutable_param_to_index["Vmaxv7"]      = 149;
  _mutable_param_to_index["Vmaxv9"]      = 150;
  _mutable_param_to_index["kATPasev15"]  = 151;
  _mutable_param_to_index["kDPGMv8"]     = 152;
  _mutable_param_to_index["kLDHv14"]     = 153;
}

/**
 * \brief    Create the metabolite to index map
 * \details  --
 * \param    void
 * \return   \e void
 */
void Population::create_met_to_index_map( void )
{
  _met_to_index.clear();
  _met_to_index["ADPf"]      = 0;
  _met_to_index["AMPf"]      = 1;
  _met_to_index["ATPf"]      = 2;
  _met_to_index["DHAP"]      = 3;
  _met_to_index["E4P"]       = 4;
  _met_to_index["Fru16P2"]   = 5;
  _met_to_index["Fru6P"]     = 6;
  _met_to_index["GSH"]       = 7;
  _met_to_index["GSSG"]      = 8;
  _met_to_index["Glc6P"]     = 9;
  _met_to_index["GlcA6P"]    = 10;
  _met_to_index["Glcin"]     = 11;
  _met_to_index["GraP"]      = 12;
  _met_to_index["Gri13P2"]   = 13;
  _met_to_index["Gri23P2f"]  = 14;
  _met_to_index["Gri2P"]     = 15;
  _met_to_index["Gri3P"]     = 16;
  _met_to_index["Lac"]       = 17;
  _met_to_index["MgADP"]     = 18;
  _met_to_index["MgAMP"]     = 19;
  _met_to_index["MgATP"]     = 20;
  _met_to_index["MgGri23P2"] = 21;
  _met_to_index["Mgf"]       = 22;
  _met_to_index["NAD"]       = 23;
  _met_to_index["NADH"]      = 24;
  _met_to_index["NADPHf"]    = 25;
  _met_to_index["NADPf"]     = 26;
  _met_to_index["P1NADP"]    = 27;
  _met_to_index["P1NADPH"]   = 28;
  _met_to_index["P1f"]       = 29;
  _met_to_index["P2NADP"]    = 30;
  _met_to_index["P2NADPH"]   = 31;
  _met_to_index["P2f"]       = 32;
  _met_to_index["PEP"]       = 33;
  _met_to_index["Phi"]       = 34;
  _met_to_index["Pyr"]       = 35;
  _met_to_index["Rib5P"]     = 36;
  _met_to_index["Rul5P"]     = 37;
  _met_to_index["Sed7P"]     = 38;
  _met_to_index["Xul5P"]     = 39;
}

