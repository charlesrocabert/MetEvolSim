
#include "SensitivityAnalysis.h"


/*----------------------------
 * CONSTRUCTORS
 *----------------------------*/

/**
 * \brief    Constructor
 * \details  --
 * \param    Parameters* parameters
 * \return   \e void
 */
SensitivityAnalysis::SensitivityAnalysis( Parameters* parameters )
{
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  assert(parameters != NULL);
  _parameters = parameters;
  _prng       = _parameters->get_prng();
  
  /*----------------------------------------------------- NETWORK STRUCTURE */
  
  _p_fixed   = 17;
  _p_mutable = 154;
  _m         = 40;
  
  _fixed_param_to_index.clear();
  _mutable_param_to_index.clear();
  _met_to_index.clear();
  
  _initial_fixed_params = new double[_p_fixed];
  _fixed_params         = new double[_p_fixed];
  for (int i = 0; i < _p_fixed; i++)
  {
    _initial_fixed_params[i] = 0.0;
    _fixed_params[i]         = 0.0;
  }
  
  _initial_mutable_params = new double[_p_mutable];
  _mutable_params         = new double[_p_mutable];
  for (int i = 0; i < _p_mutable; i++)
  {
    _initial_mutable_params[i] = 0.0;
    _mutable_params[i]         = 0.0;
  }
  
  _initial_s = new double[_m];
  _s         = new double[_m];
  for (int i = 0; i < _m; i++)
  {
    _initial_s[i] = 0.0;
    _s[i]         = 0.0;
  }
  
  /*----------------------------------------------------- PHENOTYPE */
  
  _c     = 0.0;
  _c_opt = 0.0;
  _w     = 0.0;
  
  /*----------------------------------------------------- ODE SOLVER */
  
  _dt       = DT_INIT;
  _t        = 0.0;
  _timestep = _dt;
  _isStable = false;
  
  /*----------------------------------------------------- SENSITIVITY_ANALYSIS */
  
  _param_mean = new double[_p_mutable];
  _param_var  = new double[_p_mutable];
  _conc_mean  = new double*[_p_mutable];
  _conc_var   = new double*[_p_mutable];
  _c_mean     = new double[_p_mutable];
  _c_var      = new double[_p_mutable];
  _w_mean     = new double[_p_mutable];
  _w_var      = new double[_p_mutable];
  for (int i = 0; i < _p_mutable; i++)
  {
    _param_mean[i] = 0.0;
    _param_var[i]  = 0.0;
    _conc_mean[i]  = new double[_m];
    _conc_var[i]   = new double[_m];
    _c_mean[i]     = 0.0;
    _c_var[i]      = 0.0;
    _w_mean[i]     = 0.0;
    _w_var[i]      = 0.0;
    for (int j = 0; j < _m; j++)
    {
      _conc_mean[i][j] = 0.0;
      _conc_var[i][j]  = 0.0;
    }
  }
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
SensitivityAnalysis::~SensitivityAnalysis( void )
{
  /*----------------------------------------------------- NETWORK STRUCTURE */
  
  _fixed_param_to_index.clear();
  _mutable_param_to_index.clear();
  _met_to_index.clear();
  
  delete[] _initial_fixed_params;
  _initial_fixed_params = NULL;
  delete[] _initial_mutable_params;
  _initial_mutable_params = NULL;
  delete[] _initial_s;
  _initial_s = NULL;
  delete[] _fixed_params;
  _fixed_params = NULL;
  delete[] _mutable_params;
  _mutable_params = NULL;
  delete[] _s;
  _s = NULL;
  
  /*----------------------------------------------------- SENSITIVITY_ANALYSIS */
  
  for (int i = 0; i < _p_mutable; i++)
  {
    delete[] _conc_mean[i];
    _conc_mean[i] = NULL;
    delete[] _conc_var[i];
    _conc_var[i] = NULL;
  }
  delete[] _param_mean;
  _param_mean = NULL;
  delete[] _param_var;
  _param_var = NULL;
  delete[] _conc_mean;
  _conc_mean = NULL;
  delete[] _conc_var;
  _conc_var = NULL;
  delete[] _c_mean;
  _c_mean = NULL;
  delete[] _c_var;
  _c_var = NULL;
  delete[] _w_mean;
  _w_mean = NULL;
  delete[] _w_var;
  _w_var = NULL;
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
void SensitivityAnalysis::initialize( void )
{
  /*----------------------------------------------------- NETWORK STRUCTURE */
  
  /*** Set the number of variables ***/
  _p_fixed   = 17;
  _p_mutable = 154;
  _m         = 40;
  
  /*** Create the indexes ***/
  create_fixed_param_to_index_map();
  create_mutable_param_to_index_map();
  create_met_to_index_map();
  
  /*** Initialize parameter values ***/
  initialize_fixed_parameters();
  initialize_mutable_parameters();
  initialize_concentrations();
  
  /*** Set parameter vectors ***/
  initialize_fixed_parameters_vector();
  initialize_mutable_parameters_vector();
  initialize_concentration_vector();
  
  /*----------------------------------------------------- PHENOTYPE */
  
  /*** Compute steady-state and fitness ***/
  compute_steady_state();
  compute_c();
  _c_opt = _c;
  compute_fitness();
}

/**
 * \brief    Run the sensitivity analysis
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::run_analysis( void )
{
  open_files();
  write_initial_concentrations();
  int counter = 1;
  for (std::unordered_map<std::string, int>::iterator it = _mutable_param_to_index.begin(); it != _mutable_param_to_index.end(); ++it)
  {
    /*---------------------*/
    /* 1) Run analysis     */
    /*---------------------*/
    std::cout << "   > Analyzing parameter " << it->first << " (" << counter << "/" << _p_mutable << ")\n";
    analyze_parameter(it->second, _parameters->get_sigma(), _parameters->get_n());
    
    /*---------------------*/
    /* 2) Save data        */
    /*---------------------*/
    write_files(it->first);
    
    /*---------------------*/
    /* 3) Reset parameters */
    /*---------------------*/
    memcpy(_mutable_params, _initial_mutable_params, sizeof(double)*_p_mutable);
    memcpy(_s, _initial_s, sizeof(double)*_m);
    counter++;
  }
}

/**
 * \brief    Open saving files
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::open_files( void )
{
  /*** Parameters exploration file ***/
  _param_file.open("param.txt", std::ios::out | std::ios::trunc);
  _param_file << "name ancestor mean var\n";
  
  /*** Mean concentration vector file ***/
  _mean_conc_file.open("mean_conc.txt", std::ios::out | std::ios::trunc);
  _mean_conc_file << "name";
  for (std::unordered_map<std::string, int>::iterator it = _met_to_index.begin(); it != _met_to_index.end(); ++it)
  {
    _mean_conc_file << " " << it->first;
  }
  _mean_conc_file << "\n";
  
  /*** Concentration vector variance file ***/
  _var_conc_file.open("var_conc.txt", std::ios::out | std::ios::trunc);
  _var_conc_file << "name";
  for (std::unordered_map<std::string, int>::iterator it = _met_to_index.begin(); it != _met_to_index.end(); ++it)
  {
    _var_conc_file << " " << it->first;
  }
  _var_conc_file << "\n";
  
  /*** Sum of concentrations exploration file ***/
  _sum_file.open("sum.txt", std::ios::out | std::ios::trunc);
  _sum_file << "name ancestor mean var\n";
  
  /*** Fitness exploration file ***/
  _fitness_file.open("fitness.txt", std::ios::out | std::ios::trunc);
  _fitness_file << "name ancestor mean var\n";
}

/**
 * \brief    Writing analysis for a given parameter
 * \details  --
 * \param    std::string parameter
 * \return   \e void
 */
void SensitivityAnalysis::write_files( std::string parameter )
{
  assert(_mutable_param_to_index.find(parameter) != _mutable_param_to_index.end());
  int i = _mutable_param_to_index[parameter];
  
  /*** Parameters exploration file ***/
  _param_file << parameter << " " << _initial_mutable_params[i] << " " << _param_mean[i] << " " << _param_var[i] << "\n";
  
  /*** Mean concentration vector file ***/
  _mean_conc_file << parameter;
  for (std::unordered_map<std::string, int>::iterator it = _met_to_index.begin(); it != _met_to_index.end(); ++it)
  {
    _mean_conc_file << " " << _conc_mean[i][it->second];
  }
  _mean_conc_file << "\n";
  
  /*** Concentration vector variance file ***/
  _var_conc_file << parameter;
  for (std::unordered_map<std::string, int>::iterator it = _met_to_index.begin(); it != _met_to_index.end(); ++it)
  {
    _var_conc_file << " " << _conc_var[i][it->second];
  }
  _var_conc_file << "\n";
  
  /*** Sum of concentrations exploration file ***/
  _sum_file << parameter << " " << _c_opt << " " << _c_mean[i] << " " << _c_var[i] << "\n";
  
  /*** Fitness exploration file ***/
  _sum_file << parameter << " " << 1.0 << " " << _w_mean[i] << " " << _w_var[i] << "\n";
}

/**
 * \brief    Close saving files
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::close_files( void )
{
  _param_file.close();
  _mean_conc_file.close();
  _var_conc_file.close();
  _sum_file.close();
  _fitness_file.close();
}

/**
 * \brief    Write initial concentrations in a file
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::write_initial_concentrations( void )
{
  std::ofstream file("init_conc.txt", std::ios::out | std::ios::trunc);
  file << "met conc\n";
  for (std::unordered_map<std::string, int>::iterator it = _met_to_index.begin(); it != _met_to_index.end(); ++it)
  {
    file << it->first << " " << _initial_s[it->second] << "\n";
  }
  file.close();
}

/**
 * \brief    Analyze the parameter at position i
 * \details  --
 * \param    int i
 * \param    double sigma
 * \param    int N
 * \return   \e void
 */
void SensitivityAnalysis::analyze_parameter( int i, double sigma, int N )
{
  assert(i >= 0);
  assert(i < _p_mutable);
  assert(sigma > 0.0);
  assert(N > 0);
  
  /*-----------------------*/
  /* 1) Run the analysis   */
  /*-----------------------*/
  double counter = 0.0;
  for (int rep = 0; rep < N; rep++)
  {
    //std::cout << rep << "\n";
    mutate(i, sigma);
    compute_steady_state();
    compute_c();
    compute_fitness();
    if (_isStable)
    {
      _param_mean[i] += _mutable_params[i];
      _param_var[i]  += _mutable_params[i]*_mutable_params[i];
      _c_mean[i]     += _c;
      _c_var[i]      += _c*_c;
      _w_mean[i]     += _w;
      _w_var[i]      += _w*_w;
      for (int j = 0; j < _m; j++)
      {
        _conc_mean[i][j] += _s[j];
        _conc_var[i][j]  += _s[j];
      }
      counter += 1.0;
    }
  }
  
  /*-----------------------*/
  /* 2) Compute statistics */
  /*-----------------------*/
  if (counter > 0.0)
  {
    _param_mean[i] /= counter;
    _param_var[i]  /= counter;
    _param_var[i]  -= _param_mean[i]*_param_mean[i];
    _c_mean[i]     /= counter;
    _c_var[i]      /= counter;
    _c_var[i]      -= _c_mean[i]*_c_mean[i];
    _w_mean[i]     /= counter;
    _w_var[i]      /= counter;
    _w_var[i]      -= _w_mean[i]*_w_mean[i];
    for (int j = 0; j < _m; j++)
    {
      _conc_mean[i][j] /= counter;
      _conc_var[i][j]  /= counter;
      _conc_var[i][j]  -= _conc_mean[i][j]*_conc_mean[i][j];
    }
  }
}

/**
 * \brief    Mutate the parameter i
 * \details  --
 * \param    int i
 * \param    double sigma
 * \return   \e void
 */
void SensitivityAnalysis::mutate( int i, double sigma )
{
  double log_param = log10(_mutable_params[i]);
  double new_param = pow(10.0, _prng->gaussian(log_param, sigma));
  _mutable_params[i] = new_param;
}

/**
 * \brief    Compute the new steady-state
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::compute_steady_state( void )
{
  double max_time        = IND_STEADY_STATE_MAX_T;
  _t                     = 0.0;
  _isStable              = false;
  int     counter        = 0;
  int     stable_counter = 0;
  bool    endOfSolving   = false;
  double* previous_s     = new double[_m];
  while (!endOfSolving)
  {
    bool stable   = false;
    bool too_low  = false;
    bool too_high = false;
    bool too_long = false;
    memcpy(previous_s, _s, sizeof(double)*_m);
    double old_dt = _dt;
    
    _timestep = _dt;
    solve();
    
    if (old_dt == _dt && counter%10 == 0)
    {
      _dt *= 2.0;
    }
    
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
    if (_t > max_time)
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

/**
 * \brief    Compute the sum of metabolites c
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::compute_c( void )
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
void SensitivityAnalysis::compute_fitness( void )
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

/*----------------------------
 * PROTECTED METHODS
 *----------------------------*/

/**
 * \brief    Create the fixed parameter to index map
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::create_fixed_param_to_index_map( void )
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
void SensitivityAnalysis::create_mutable_param_to_index_map( void )
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
void SensitivityAnalysis::create_met_to_index_map( void )
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

/**
 * \brief    Initialize fixed parameter values
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::initialize_fixed_parameters( void )
{
  assert(_initial_fixed_params != NULL);
  _initial_fixed_params[_fixed_param_to_index["Atot"]]     = 2.0;
  _initial_fixed_params[_fixed_param_to_index["EqMult"]]   = 1000.0;
  _initial_fixed_params[_fixed_param_to_index["GStotal"]]  = 3.114;
  _initial_fixed_params[_fixed_param_to_index["Inhibv1"]]  = 1.0;
  _initial_fixed_params[_fixed_param_to_index["L0v12"]]    = 19.0;
  _initial_fixed_params[_fixed_param_to_index["L0v3"]]     = 0.001072;
  _initial_fixed_params[_fixed_param_to_index["Mgtot"]]    = 2.8;
  _initial_fixed_params[_fixed_param_to_index["NADPtot"]]  = 0.052;
  _initial_fixed_params[_fixed_param_to_index["NADtot"]]   = 0.0655;
  _initial_fixed_params[_fixed_param_to_index["alfav0"]]   = 0.54;
  _initial_fixed_params[_fixed_param_to_index["protein1"]] = 0.024;
  _initial_fixed_params[_fixed_param_to_index["protein2"]] = 0.024;
  _initial_fixed_params[_fixed_param_to_index["Glcout"]]   = 5.0;
  _initial_fixed_params[_fixed_param_to_index["Lacex"]]    = 1.68;
  _initial_fixed_params[_fixed_param_to_index["PRPP"]]     = 1.0;
  _initial_fixed_params[_fixed_param_to_index["Phiex"]]    = 1.0;
  _initial_fixed_params[_fixed_param_to_index["Pyrex"]]    = 0.084;
}

/**
 * \brief    Initialize mutable parameter values
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::initialize_mutable_parameters( void )
{
  assert(_initial_mutable_params != NULL);
  _initial_mutable_params[_mutable_param_to_index["K13P2Gv6"]]    = 0.0035;
  _initial_mutable_params[_mutable_param_to_index["K13P2Gv7"]]    = 0.002;
  _initial_mutable_params[_mutable_param_to_index["K1v23"]]       = 0.4177;
  _initial_mutable_params[_mutable_param_to_index["K1v24"]]       = 0.00823;
  _initial_mutable_params[_mutable_param_to_index["K1v26"]]       = 0.00184;
  _initial_mutable_params[_mutable_param_to_index["K23P2Gv1"]]    = 2.7;
  _initial_mutable_params[_mutable_param_to_index["K23P2Gv8"]]    = 0.04;
  _initial_mutable_params[_mutable_param_to_index["K23P2Gv9"]]    = 0.2;
  _initial_mutable_params[_mutable_param_to_index["K2PGv10"]]     = 1.0;
  _initial_mutable_params[_mutable_param_to_index["K2PGv11"]]     = 1.0;
  _initial_mutable_params[_mutable_param_to_index["K2v23"]]       = 0.3055;
  _initial_mutable_params[_mutable_param_to_index["K2v24"]]       = 0.04765;
  _initial_mutable_params[_mutable_param_to_index["K2v26"]]       = 0.3055;
  _initial_mutable_params[_mutable_param_to_index["K3PGv10"]]     = 5.0;
  _initial_mutable_params[_mutable_param_to_index["K3PGv7"]]      = 1.2;
  _initial_mutable_params[_mutable_param_to_index["K3v23"]]       = 12.432;
  _initial_mutable_params[_mutable_param_to_index["K3v24"]]       = 0.1733;
  _initial_mutable_params[_mutable_param_to_index["K3v26"]]       = 0.0548;
  _initial_mutable_params[_mutable_param_to_index["K4v23"]]       = 0.00496;
  _initial_mutable_params[_mutable_param_to_index["K4v24"]]       = 0.006095;
  _initial_mutable_params[_mutable_param_to_index["K4v26"]]       = 0.0003;
  _initial_mutable_params[_mutable_param_to_index["K5v23"]]       = 0.41139;
  _initial_mutable_params[_mutable_param_to_index["K5v24"]]       = 0.8683;
  _initial_mutable_params[_mutable_param_to_index["K5v26"]]       = 0.0287;
  _initial_mutable_params[_mutable_param_to_index["K6PG1v18"]]    = 0.01;
  _initial_mutable_params[_mutable_param_to_index["K6PG2v18"]]    = 0.058;
  _initial_mutable_params[_mutable_param_to_index["K6v23"]]       = 0.00774;
  _initial_mutable_params[_mutable_param_to_index["K6v24"]]       = 0.4653;
  _initial_mutable_params[_mutable_param_to_index["K6v26"]]       = 0.122;
  _initial_mutable_params[_mutable_param_to_index["K7v23"]]       = 48.8;
  _initial_mutable_params[_mutable_param_to_index["K7v24"]]       = 2.524;
  _initial_mutable_params[_mutable_param_to_index["K7v26"]]       = 0.215;
  _initial_mutable_params[_mutable_param_to_index["KADPv16"]]     = 0.11;
  _initial_mutable_params[_mutable_param_to_index["KAMPv16"]]     = 0.08;
  _initial_mutable_params[_mutable_param_to_index["KAMPv3"]]      = 0.033;
  _initial_mutable_params[_mutable_param_to_index["KATPv12"]]     = 3.39;
  _initial_mutable_params[_mutable_param_to_index["KATPv16"]]     = 0.09;
  _initial_mutable_params[_mutable_param_to_index["KATPv17"]]     = 0.749;
  _initial_mutable_params[_mutable_param_to_index["KATPv18"]]     = 0.154;
  _initial_mutable_params[_mutable_param_to_index["KATPv25"]]     = 0.03;
  _initial_mutable_params[_mutable_param_to_index["KATPv3"]]      = 0.01;
  _initial_mutable_params[_mutable_param_to_index["KDHAPv4"]]     = 0.0364;
  _initial_mutable_params[_mutable_param_to_index["KDHAPv5"]]     = 0.838;
  _initial_mutable_params[_mutable_param_to_index["KFru16P2v12"]] = 0.005;
  _initial_mutable_params[_mutable_param_to_index["KFru16P2v4"]]  = 0.0071;
  _initial_mutable_params[_mutable_param_to_index["KFru6Pv2"]]    = 0.071;
  _initial_mutable_params[_mutable_param_to_index["KFru6Pv3"]]    = 0.1;
  _initial_mutable_params[_mutable_param_to_index["KG6Pv17"]]     = 0.0667;
  _initial_mutable_params[_mutable_param_to_index["KGSHv19"]]     = 20.0;
  _initial_mutable_params[_mutable_param_to_index["KGSSGv19"]]    = 0.0652;
  _initial_mutable_params[_mutable_param_to_index["KGlc6Pv1"]]    = 0.0045;
  _initial_mutable_params[_mutable_param_to_index["KGlc6Pv2"]]    = 0.182;
  _initial_mutable_params[_mutable_param_to_index["KGraPv4"]]     = 0.1906;
  _initial_mutable_params[_mutable_param_to_index["KGraPv5"]]     = 0.428;
  _initial_mutable_params[_mutable_param_to_index["KGraPv6"]]     = 0.005;
  _initial_mutable_params[_mutable_param_to_index["KMGlcv1"]]     = 0.1;
  _initial_mutable_params[_mutable_param_to_index["KMg23P2Gv1"]]  = 3.44;
  _initial_mutable_params[_mutable_param_to_index["KMgADPv12"]]   = 0.474;
  _initial_mutable_params[_mutable_param_to_index["KMgADPv7"]]    = 0.35;
  _initial_mutable_params[_mutable_param_to_index["KMgATPMgv1"]]  = 1.14;
  _initial_mutable_params[_mutable_param_to_index["KMgATPv1"]]    = 1.44;
  _initial_mutable_params[_mutable_param_to_index["KMgATPv3"]]    = 0.068;
  _initial_mutable_params[_mutable_param_to_index["KMgATPv7"]]    = 0.48;
  _initial_mutable_params[_mutable_param_to_index["KMgv1"]]       = 1.03;
  _initial_mutable_params[_mutable_param_to_index["KMgv3"]]       = 0.44;
  _initial_mutable_params[_mutable_param_to_index["KMinv0"]]      = 6.9;
  _initial_mutable_params[_mutable_param_to_index["KMoutv0"]]     = 1.7;
  _initial_mutable_params[_mutable_param_to_index["KNADHv6"]]     = 0.0083;
  _initial_mutable_params[_mutable_param_to_index["KNADPHv17"]]   = 0.00312;
  _initial_mutable_params[_mutable_param_to_index["KNADPHv18"]]   = 0.0045;
  _initial_mutable_params[_mutable_param_to_index["KNADPHv19"]]   = 0.00852;
  _initial_mutable_params[_mutable_param_to_index["KNADPv17"]]    = 0.00367;
  _initial_mutable_params[_mutable_param_to_index["KNADPv18"]]    = 0.018;
  _initial_mutable_params[_mutable_param_to_index["KNADPv19"]]    = 0.07;
  _initial_mutable_params[_mutable_param_to_index["KNADv6"]]      = 0.05;
  _initial_mutable_params[_mutable_param_to_index["KPEPv11"]]     = 1.0;
  _initial_mutable_params[_mutable_param_to_index["KPEPv12"]]     = 0.225;
  _initial_mutable_params[_mutable_param_to_index["KPGA23v17"]]   = 2.289;
  _initial_mutable_params[_mutable_param_to_index["KPGA23v18"]]   = 0.12;
  _initial_mutable_params[_mutable_param_to_index["KPv6"]]        = 3.9;
  _initial_mutable_params[_mutable_param_to_index["KR5Pv22"]]     = 2.2;
  _initial_mutable_params[_mutable_param_to_index["KR5Pv25"]]     = 0.57;
  _initial_mutable_params[_mutable_param_to_index["KRu5Pv21"]]    = 0.19;
  _initial_mutable_params[_mutable_param_to_index["KRu5Pv22"]]    = 0.78;
  _initial_mutable_params[_mutable_param_to_index["KX5Pv21"]]     = 0.5;
  _initial_mutable_params[_mutable_param_to_index["Kd1"]]         = 0.0002;
  _initial_mutable_params[_mutable_param_to_index["Kd2"]]         = 1e-05;
  _initial_mutable_params[_mutable_param_to_index["Kd23P2G"]]     = 1.667;
  _initial_mutable_params[_mutable_param_to_index["Kd3"]]         = 1e-05;
  _initial_mutable_params[_mutable_param_to_index["Kd4"]]         = 0.0002;
  _initial_mutable_params[_mutable_param_to_index["KdADP"]]       = 0.76;
  _initial_mutable_params[_mutable_param_to_index["KdAMP"]]       = 16.64;
  _initial_mutable_params[_mutable_param_to_index["KdATP"]]       = 0.072;
  _initial_mutable_params[_mutable_param_to_index["Keqv0"]]       = 1.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv1"]]       = 3900.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv10"]]      = 0.145;
  _initial_mutable_params[_mutable_param_to_index["Keqv11"]]      = 1.7;
  _initial_mutable_params[_mutable_param_to_index["Keqv12"]]      = 13790.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv13"]]      = 9090.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv14"]]      = 14181.8;
  _initial_mutable_params[_mutable_param_to_index["Keqv16"]]      = 0.25;
  _initial_mutable_params[_mutable_param_to_index["Keqv17"]]      = 2000.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv18"]]      = 141.7;
  _initial_mutable_params[_mutable_param_to_index["Keqv19"]]      = 1.04;
  _initial_mutable_params[_mutable_param_to_index["Keqv2"]]       = 0.3925;
  _initial_mutable_params[_mutable_param_to_index["Keqv21"]]      = 2.7;
  _initial_mutable_params[_mutable_param_to_index["Keqv22"]]      = 3.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv23"]]      = 1.05;
  _initial_mutable_params[_mutable_param_to_index["Keqv24"]]      = 1.05;
  _initial_mutable_params[_mutable_param_to_index["Keqv25"]]      = 100000.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv26"]]      = 1.2;
  _initial_mutable_params[_mutable_param_to_index["Keqv27"]]      = 1.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv28"]]      = 1.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv29"]]      = 1.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv3"]]       = 100000.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv4"]]       = 0.114;
  _initial_mutable_params[_mutable_param_to_index["Keqv5"]]       = 0.0407;
  _initial_mutable_params[_mutable_param_to_index["Keqv6"]]       = 0.000192;
  _initial_mutable_params[_mutable_param_to_index["Keqv7"]]       = 1455.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv8"]]       = 100000.0;
  _initial_mutable_params[_mutable_param_to_index["Keqv9"]]       = 100000.0;
  _initial_mutable_params[_mutable_param_to_index["KiGraPv4"]]    = 0.0572;
  _initial_mutable_params[_mutable_param_to_index["KiiGraPv4"]]   = 0.176;
  _initial_mutable_params[_mutable_param_to_index["Kv20"]]        = 0.03;
  _initial_mutable_params[_mutable_param_to_index["Vmax1v1"]]     = 15.8;
  _initial_mutable_params[_mutable_param_to_index["Vmax2v1"]]     = 33.2;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv0"]]      = 33.6;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv10"]]     = 2000.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv11"]]     = 1500.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv12"]]     = 570.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv13"]]     = 2800000.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv16"]]     = 1380.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv17"]]     = 162.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv18"]]     = 1575.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv19"]]     = 90.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv2"]]      = 935.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv21"]]     = 4634.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv22"]]     = 730.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv23"]]     = 23.5;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv24"]]     = 27.2;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv25"]]     = 1.1;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv26"]]     = 23.5;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv27"]]     = 100.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv28"]]     = 10000.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv29"]]     = 10000.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv3"]]      = 239.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv4"]]      = 98.91000366;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv5"]]      = 5456.600098;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv6"]]      = 4300.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv7"]]      = 5000.0;
  _initial_mutable_params[_mutable_param_to_index["Vmaxv9"]]      = 0.53;
  _initial_mutable_params[_mutable_param_to_index["kATPasev15"]]  = 1.68;
  _initial_mutable_params[_mutable_param_to_index["kDPGMv8"]]     = 76000.0;
  _initial_mutable_params[_mutable_param_to_index["kLDHv14"]]     = 243.4;
  
}

/**
 * \brief    Initialize concentration values
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::initialize_concentrations( void )
{
  assert(_initial_s != NULL);
  _initial_s[_met_to_index["ADPf"]]      = 0.18712760717235977;
  _initial_s[_met_to_index["AMPf"]]      = 0.0722413215141835;
  _initial_s[_met_to_index["ATPf"]]      = 0.1836572449838888;
  _initial_s[_met_to_index["DHAP"]]      = 0.149233080901138;
  _initial_s[_met_to_index["E4P"]]       = 0.006271757568490649;
  _initial_s[_met_to_index["Fru16P2"]]   = 0.009683496132313353;
  _initial_s[_met_to_index["Fru6P"]]     = 0.015344444071514918;
  _initial_s[_met_to_index["GSH"]]       = 3.1140265135966514;
  _initial_s[_met_to_index["GSSG"]]      = 0.00018674320167429774;
  _initial_s[_met_to_index["Glc6P"]]     = 0.039489574722161525;
  _initial_s[_met_to_index["GlcA6P"]]    = 0.025054259471968068;
  _initial_s[_met_to_index["Glcin"]]     = 4.566796368297684;
  _initial_s[_met_to_index["GraP"]]      = 0.006062870119943679;
  _initial_s[_met_to_index["Gri13P2"]]   = 0.0004806553656229012;
  _initial_s[_met_to_index["Gri23P2f"]]  = 2.0612328106487694;
  _initial_s[_met_to_index["Gri2P"]]     = 0.008442078092860253;
  _initial_s[_met_to_index["Gri3P"]]     = 0.06576393388493314;
  _initial_s[_met_to_index["Lac"]]       = 1.6803053255476528;
  _initial_s[_met_to_index["MgADP"]]     = 0.13682174687137127;
  _initial_s[_met_to_index["MgAMP"]]     = 0.0024387655884246713;
  _initial_s[_met_to_index["MgATP"]]     = 1.4177133138697715;
  _initial_s[_met_to_index["MgGri23P2"]] = 0.6872334598704511;
  _initial_s[_met_to_index["Mgf"]]       = 0.5557927137999811;
  _initial_s[_met_to_index["NAD"]]       = 0.0653436283321317;
  _initial_s[_met_to_index["NADH"]]      = 0.00015637166786830237;
  _initial_s[_met_to_index["NADPHf"]]    = 0.0048891706646177965;
  _initial_s[_met_to_index["NADPf"]]     = 0.000023437582334213253;
  _initial_s[_met_to_index["P1NADP"]]    = 5.7394148572358195e-6;
  _initial_s[_met_to_index["P1NADPH"]]   = 0.023945284417077356;
  _initial_s[_met_to_index["P1f"]]       = 0.000048976168065408;
  _initial_s[_met_to_index["P2NADP"]]    = 0.0020241447955371516;
  _initial_s[_met_to_index["P2NADPH"]]   = 0.021112223125576247;
  _initial_s[_met_to_index["P2f"]]       = 0.0008636320788866017;
  _initial_s[_met_to_index["PEP"]]       = 0.010939580637775247;
  _initial_s[_met_to_index["Phi"]]       = 0.999225013356031;
  _initial_s[_met_to_index["Pyr"]]       = 0.08399000505423984;
  _initial_s[_met_to_index["Rib5P"]]     = 0.014005278010718067;
  _initial_s[_met_to_index["Rul5P"]]     = 0.004721919539066009;
  _initial_s[_met_to_index["Sed7P"]]     = 0.015412334068365481;
  _initial_s[_met_to_index["Xul5P"]]     = 0.012743690466410572;
}

/**
 * \brief    Initialize the fixed parameters vector
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::initialize_fixed_parameters_vector( void )
{
  assert(_initial_fixed_params != NULL);
  assert(_fixed_params != NULL);
  memcpy(_fixed_params, _initial_fixed_params, sizeof(double)*_p_fixed);
}

/**
 * \brief    Initialize the mutable parameters vector
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::initialize_mutable_parameters_vector( void )
{
  assert(_initial_mutable_params != NULL);
  assert(_mutable_params != NULL);
  memcpy(_mutable_params, _initial_mutable_params, sizeof(double)*_p_mutable);
}

/**
 * \brief    Initialize the concentration vector
 * \details  --
 * \param    void
 * \return   \e void
 */
void SensitivityAnalysis::initialize_concentration_vector( void )
{
  assert(_initial_s != NULL);
  assert(_s != NULL);
  memcpy(_s, _initial_s, sizeof(double)*_m);
}

/**
 * \brief    Solve the ODE system for one timestep
 * \details  --
 * \param    void
 * \return   \e double
 */
void SensitivityAnalysis::solve( void )
{
  double* DSDT = new double[_m];
  double* OLDS = new double[_m];
  double  Tend = _t+_timestep;
  while (_t < Tend)
  {
    /*---------------------------------------*/
    /* 1) Save previous state                */
    /*---------------------------------------*/
    memcpy(OLDS, _s, sizeof(double)*_m);
    
    /*---------------------------------------*/
    /* 2) Compute next state with current dt */
    /*---------------------------------------*/
    ODE_system(DSDT);
    
    for (int i = 0; i < _m; i++)
    {
      _s[i] += DSDT[i]*_dt;
    }
    
    /*---------------------------------------*/
    /* 3) Check solving consistency          */
    /*---------------------------------------*/
    /*** Evaluate the concentration vector ***/
    bool decrease_h = false;
    for (int i = 0; i < _m; i++)
    {
      if (_s[i] <= 0.0 || fabs(_s[i]-OLDS[i])/OLDS[i] > ERR_REL)// || fabs(_s[i]-OLDS[i]) > ERR_ABS)
      {
        decrease_h = true;
        break;
      }
    }
    
    /*** Reduce DT if necessary ***/
    if (decrease_h)
    {
      memcpy(_s, OLDS, sizeof(double)*_m);
      _dt /= 2.0;
    }
    else
    {
      _t += _dt;
    }
  }
  delete[] OLDS;
  OLDS = NULL;
  delete[] DSDT;
  DSDT = NULL;
}

/**
 * \brief    Compute the ODE system
 * \details  --
 * \param    double* dsdt
 * \return   \e void
 */
void SensitivityAnalysis::ODE_system( double* dsdt )
{
  /*----------------------------------*/
  /* 1) Initialize fixed parameters   */
  /*----------------------------------*/
  //double Atot     = _fixed_params[_fixed_param_to_index["Atot"]];
  //double GStotal  = _fixed_params[_fixed_param_to_index["GStotal"]];
  //double Mgtot    = _fixed_params[_fixed_param_to_index["Mgtot"]];
  //double NADPtot  = _fixed_params[_fixed_param_to_index["NADPtot"]];
  //double NADtot   = _fixed_params[_fixed_param_to_index["NADtot"]];
  //double protein1 = _fixed_params[_fixed_param_to_index["protein1"]];
  //double protein2 = _fixed_params[_fixed_param_to_index["protein2"]];
  double EqMult  = _fixed_params[_fixed_param_to_index["EqMult"]];
  double Inhibv1 = _fixed_params[_fixed_param_to_index["Inhibv1"]];
  double L0v12   = _fixed_params[_fixed_param_to_index["L0v12"]];
  double L0v3    = _fixed_params[_fixed_param_to_index["L0v3"]];
  double alfav0  = _fixed_params[_fixed_param_to_index["alfav0"]];
  double Glcout  = _fixed_params[_fixed_param_to_index["Glcout"]];
  double Lacex   = _fixed_params[_fixed_param_to_index["Lacex"]];
  double PRPP    = _fixed_params[_fixed_param_to_index["PRPP"]];
  double Phiex   = _fixed_params[_fixed_param_to_index["Phiex"]];
  double Pyrex   = _fixed_params[_fixed_param_to_index["Pyrex"]];
  
  /*----------------------------------*/
  /* 2) Initialize mutable parameters */
  /*----------------------------------*/
  double K13P2Gv6    = _mutable_params[_mutable_param_to_index["K13P2Gv6"]];
  double K13P2Gv7    = _mutable_params[_mutable_param_to_index["K13P2Gv7"]];
  double K1v23       = _mutable_params[_mutable_param_to_index["K1v23"]];
  double K1v24       = _mutable_params[_mutable_param_to_index["K1v24"]];
  double K1v26       = _mutable_params[_mutable_param_to_index["K1v26"]];
  double K23P2Gv1    = _mutable_params[_mutable_param_to_index["K23P2Gv1"]];
  double K23P2Gv8    = _mutable_params[_mutable_param_to_index["K23P2Gv8"]];
  double K23P2Gv9    = _mutable_params[_mutable_param_to_index["K23P2Gv9"]];
  double K2PGv10     = _mutable_params[_mutable_param_to_index["K2PGv10"]];
  double K2PGv11     = _mutable_params[_mutable_param_to_index["K2PGv11"]];
  double K2v23       = _mutable_params[_mutable_param_to_index["K2v23"]];
  double K2v24       = _mutable_params[_mutable_param_to_index["K2v24"]];
  double K2v26       = _mutable_params[_mutable_param_to_index["K2v26"]];
  double K3PGv10     = _mutable_params[_mutable_param_to_index["K3PGv10"]];
  double K3PGv7      = _mutable_params[_mutable_param_to_index["K3PGv7"]];
  double K3v23       = _mutable_params[_mutable_param_to_index["K3v23"]];
  double K3v24       = _mutable_params[_mutable_param_to_index["K3v24"]];
  double K3v26       = _mutable_params[_mutable_param_to_index["K3v26"]];
  double K4v23       = _mutable_params[_mutable_param_to_index["K4v23"]];
  double K4v24       = _mutable_params[_mutable_param_to_index["K4v24"]];
  double K4v26       = _mutable_params[_mutable_param_to_index["K4v26"]];
  double K5v23       = _mutable_params[_mutable_param_to_index["K5v23"]];
  double K5v24       = _mutable_params[_mutable_param_to_index["K5v24"]];
  double K5v26       = _mutable_params[_mutable_param_to_index["K5v26"]];
  double K6PG1v18    = _mutable_params[_mutable_param_to_index["K6PG1v18"]];
  double K6PG2v18    = _mutable_params[_mutable_param_to_index["K6PG2v18"]];
  double K6v23       = _mutable_params[_mutable_param_to_index["K6v23"]];
  double K6v24       = _mutable_params[_mutable_param_to_index["K6v24"]];
  double K6v26       = _mutable_params[_mutable_param_to_index["K6v26"]];
  double K7v23       = _mutable_params[_mutable_param_to_index["K7v23"]];
  double K7v24       = _mutable_params[_mutable_param_to_index["K7v24"]];
  double K7v26       = _mutable_params[_mutable_param_to_index["K7v26"]];
  double KADPv16     = _mutable_params[_mutable_param_to_index["KADPv16"]];
  double KAMPv16     = _mutable_params[_mutable_param_to_index["KAMPv16"]];
  double KAMPv3      = _mutable_params[_mutable_param_to_index["KAMPv3"]];
  double KATPv12     = _mutable_params[_mutable_param_to_index["KATPv12"]];
  double KATPv16     = _mutable_params[_mutable_param_to_index["KATPv16"]];
  double KATPv17     = _mutable_params[_mutable_param_to_index["KATPv17"]];
  double KATPv18     = _mutable_params[_mutable_param_to_index["KATPv18"]];
  double KATPv25     = _mutable_params[_mutable_param_to_index["KATPv25"]];
  double KATPv3      = _mutable_params[_mutable_param_to_index["KATPv3"]];
  double KDHAPv4     = _mutable_params[_mutable_param_to_index["KDHAPv4"]];
  double KDHAPv5     = _mutable_params[_mutable_param_to_index["KDHAPv5"]];
  double KFru16P2v12 = _mutable_params[_mutable_param_to_index["KFru16P2v12"]];
  double KFru16P2v4  = _mutable_params[_mutable_param_to_index["KFru16P2v4"]];
  double KFru6Pv2    = _mutable_params[_mutable_param_to_index["KFru6Pv2"]];
  double KFru6Pv3    = _mutable_params[_mutable_param_to_index["KFru6Pv3"]];
  double KG6Pv17     = _mutable_params[_mutable_param_to_index["KG6Pv17"]];
  double KGSHv19     = _mutable_params[_mutable_param_to_index["KGSHv19"]];
  double KGSSGv19    = _mutable_params[_mutable_param_to_index["KGSSGv19"]];
  double KGlc6Pv1    = _mutable_params[_mutable_param_to_index["KGlc6Pv1"]];
  double KGlc6Pv2    = _mutable_params[_mutable_param_to_index["KGlc6Pv2"]];
  double KGraPv4     = _mutable_params[_mutable_param_to_index["KGraPv4"]];
  double KGraPv5     = _mutable_params[_mutable_param_to_index["KGraPv5"]];
  double KGraPv6     = _mutable_params[_mutable_param_to_index["KGraPv6"]];
  double KMGlcv1     = _mutable_params[_mutable_param_to_index["KMGlcv1"]];
  double KMg23P2Gv1  = _mutable_params[_mutable_param_to_index["KMg23P2Gv1"]];
  double KMgADPv12   = _mutable_params[_mutable_param_to_index["KMgADPv12"]];
  double KMgADPv7    = _mutable_params[_mutable_param_to_index["KMgADPv7"]];
  double KMgATPMgv1  = _mutable_params[_mutable_param_to_index["KMgATPMgv1"]];
  double KMgATPv1    = _mutable_params[_mutable_param_to_index["KMgATPv1"]];
  double KMgATPv3    = _mutable_params[_mutable_param_to_index["KMgATPv3"]];
  double KMgATPv7    = _mutable_params[_mutable_param_to_index["KMgATPv7"]];
  double KMgv1       = _mutable_params[_mutable_param_to_index["KMgv1"]];
  double KMgv3       = _mutable_params[_mutable_param_to_index["KMgv3"]];
  double KMinv0      = _mutable_params[_mutable_param_to_index["KMinv0"]];
  double KMoutv0     = _mutable_params[_mutable_param_to_index["KMoutv0"]];
  double KNADHv6     = _mutable_params[_mutable_param_to_index["KNADHv6"]];
  double KNADPHv17   = _mutable_params[_mutable_param_to_index["KNADPHv17"]];
  double KNADPHv18   = _mutable_params[_mutable_param_to_index["KNADPHv18"]];
  double KNADPHv19   = _mutable_params[_mutable_param_to_index["KNADPHv19"]];
  double KNADPv17    = _mutable_params[_mutable_param_to_index["KNADPv17"]];
  double KNADPv18    = _mutable_params[_mutable_param_to_index["KNADPv18"]];
  double KNADPv19    = _mutable_params[_mutable_param_to_index["KNADPv19"]];
  double KNADv6      = _mutable_params[_mutable_param_to_index["KNADv6"]];
  double KPEPv11     = _mutable_params[_mutable_param_to_index["KPEPv11"]];
  double KPEPv12     = _mutable_params[_mutable_param_to_index["KPEPv12"]];
  double KPGA23v17   = _mutable_params[_mutable_param_to_index["KPGA23v17"]];
  double KPGA23v18   = _mutable_params[_mutable_param_to_index["KPGA23v18"]];
  double KPv6        = _mutable_params[_mutable_param_to_index["KPv6"]];
  double KR5Pv22     = _mutable_params[_mutable_param_to_index["KR5Pv22"]];
  double KR5Pv25     = _mutable_params[_mutable_param_to_index["KR5Pv25"]];
  double KRu5Pv21    = _mutable_params[_mutable_param_to_index["KRu5Pv21"]];
  double KRu5Pv22    = _mutable_params[_mutable_param_to_index["KRu5Pv22"]];
  double KX5Pv21     = _mutable_params[_mutable_param_to_index["KX5Pv21"]];
  double Kd1         = _mutable_params[_mutable_param_to_index["Kd1"]];
  double Kd2         = _mutable_params[_mutable_param_to_index["Kd2"]];
  double Kd23P2G     = _mutable_params[_mutable_param_to_index["Kd23P2G"]];
  double Kd3         = _mutable_params[_mutable_param_to_index["Kd3"]];
  double Kd4         = _mutable_params[_mutable_param_to_index["Kd4"]];
  double KdADP       = _mutable_params[_mutable_param_to_index["KdADP"]];
  double KdAMP       = _mutable_params[_mutable_param_to_index["KdAMP"]];
  double KdATP       = _mutable_params[_mutable_param_to_index["KdATP"]];
  double Keqv0       = _mutable_params[_mutable_param_to_index["Keqv0"]];
  double Keqv1       = _mutable_params[_mutable_param_to_index["Keqv1"]];
  double Keqv10      = _mutable_params[_mutable_param_to_index["Keqv10"]];
  double Keqv11      = _mutable_params[_mutable_param_to_index["Keqv11"]];
  double Keqv12      = _mutable_params[_mutable_param_to_index["Keqv12"]];
  double Keqv13      = _mutable_params[_mutable_param_to_index["Keqv13"]];
  double Keqv14      = _mutable_params[_mutable_param_to_index["Keqv14"]];
  double Keqv16      = _mutable_params[_mutable_param_to_index["Keqv16"]];
  double Keqv17      = _mutable_params[_mutable_param_to_index["Keqv17"]];
  double Keqv18      = _mutable_params[_mutable_param_to_index["Keqv18"]];
  double Keqv19      = _mutable_params[_mutable_param_to_index["Keqv19"]];
  double Keqv2       = _mutable_params[_mutable_param_to_index["Keqv2"]];
  double Keqv21      = _mutable_params[_mutable_param_to_index["Keqv21"]];
  double Keqv22      = _mutable_params[_mutable_param_to_index["Keqv22"]];
  double Keqv23      = _mutable_params[_mutable_param_to_index["Keqv23"]];
  double Keqv24      = _mutable_params[_mutable_param_to_index["Keqv24"]];
  double Keqv25      = _mutable_params[_mutable_param_to_index["Keqv25"]];
  double Keqv26      = _mutable_params[_mutable_param_to_index["Keqv26"]];
  double Keqv27      = _mutable_params[_mutable_param_to_index["Keqv27"]];
  double Keqv28      = _mutable_params[_mutable_param_to_index["Keqv28"]];
  double Keqv29      = _mutable_params[_mutable_param_to_index["Keqv29"]];
  double Keqv3       = _mutable_params[_mutable_param_to_index["Keqv3"]];
  double Keqv4       = _mutable_params[_mutable_param_to_index["Keqv4"]];
  double Keqv5       = _mutable_params[_mutable_param_to_index["Keqv5"]];
  double Keqv6       = _mutable_params[_mutable_param_to_index["Keqv6"]];
  double Keqv7       = _mutable_params[_mutable_param_to_index["Keqv7"]];
  double Keqv8       = _mutable_params[_mutable_param_to_index["Keqv8"]];
  double Keqv9       = _mutable_params[_mutable_param_to_index["Keqv9"]];
  double KiGraPv4    = _mutable_params[_mutable_param_to_index["KiGraPv4"]];
  double KiiGraPv4   = _mutable_params[_mutable_param_to_index["KiiGraPv4"]];
  double Kv20        = _mutable_params[_mutable_param_to_index["Kv20"]];
  double Vmax1v1     = _mutable_params[_mutable_param_to_index["Vmax1v1"]];
  double Vmax2v1     = _mutable_params[_mutable_param_to_index["Vmax2v1"]];
  double Vmaxv0      = _mutable_params[_mutable_param_to_index["Vmaxv0"]];
  double Vmaxv10     = _mutable_params[_mutable_param_to_index["Vmaxv10"]];
  double Vmaxv11     = _mutable_params[_mutable_param_to_index["Vmaxv11"]];
  double Vmaxv12     = _mutable_params[_mutable_param_to_index["Vmaxv12"]];
  double Vmaxv13     = _mutable_params[_mutable_param_to_index["Vmaxv13"]];
  double Vmaxv16     = _mutable_params[_mutable_param_to_index["Vmaxv16"]];
  double Vmaxv17     = _mutable_params[_mutable_param_to_index["Vmaxv17"]];
  double Vmaxv18     = _mutable_params[_mutable_param_to_index["Vmaxv18"]];
  double Vmaxv19     = _mutable_params[_mutable_param_to_index["Vmaxv19"]];
  double Vmaxv2      = _mutable_params[_mutable_param_to_index["Vmaxv2"]];
  double Vmaxv21     = _mutable_params[_mutable_param_to_index["Vmaxv21"]];
  double Vmaxv22     = _mutable_params[_mutable_param_to_index["Vmaxv22"]];
  double Vmaxv23     = _mutable_params[_mutable_param_to_index["Vmaxv23"]];
  double Vmaxv24     = _mutable_params[_mutable_param_to_index["Vmaxv24"]];
  double Vmaxv25     = _mutable_params[_mutable_param_to_index["Vmaxv25"]];
  double Vmaxv26     = _mutable_params[_mutable_param_to_index["Vmaxv26"]];
  double Vmaxv27     = _mutable_params[_mutable_param_to_index["Vmaxv27"]];
  double Vmaxv28     = _mutable_params[_mutable_param_to_index["Vmaxv28"]];
  double Vmaxv29     = _mutable_params[_mutable_param_to_index["Vmaxv29"]];
  double Vmaxv3      = _mutable_params[_mutable_param_to_index["Vmaxv3"]];
  double Vmaxv4      = _mutable_params[_mutable_param_to_index["Vmaxv4"]];
  double Vmaxv5      = _mutable_params[_mutable_param_to_index["Vmaxv5"]];
  double Vmaxv6      = _mutable_params[_mutable_param_to_index["Vmaxv6"]];
  double Vmaxv7      = _mutable_params[_mutable_param_to_index["Vmaxv7"]];
  double Vmaxv9      = _mutable_params[_mutable_param_to_index["Vmaxv9"]];
  double kATPasev15  = _mutable_params[_mutable_param_to_index["kATPasev15"]];
  double kDPGMv8     = _mutable_params[_mutable_param_to_index["kDPGMv8"]];
  double kLDHv14     = _mutable_params[_mutable_param_to_index["kLDHv14"]];
  
  
  /*----------------------------------*/
  /* 3) Initialize metabolites        */
  /*----------------------------------*/
  double ADPf      = _s[_met_to_index["ADPf"]];
  double AMPf      = _s[_met_to_index["AMPf"]];
  double ATPf      = _s[_met_to_index["ATPf"]];
  double DHAP      = _s[_met_to_index["DHAP"]];
  double E4P       = _s[_met_to_index["E4P"]];
  double Fru16P2   = _s[_met_to_index["Fru16P2"]];
  double Fru6P     = _s[_met_to_index["Fru6P"]];
  double GSH       = _s[_met_to_index["GSH"]];
  double GSSG      = _s[_met_to_index["GSSG"]];
  double Glc6P     = _s[_met_to_index["Glc6P"]];
  double GlcA6P    = _s[_met_to_index["GlcA6P"]];
  double Glcin     = _s[_met_to_index["Glcin"]];
  double GraP      = _s[_met_to_index["GraP"]];
  double Gri13P2   = _s[_met_to_index["Gri13P2"]];
  double Gri23P2f  = _s[_met_to_index["Gri23P2f"]];
  double Gri2P     = _s[_met_to_index["Gri2P"]];
  double Gri3P     = _s[_met_to_index["Gri3P"]];
  double Lac       = _s[_met_to_index["Lac"]];
  double MgADP     = _s[_met_to_index["MgADP"]];
  double MgAMP     = _s[_met_to_index["MgAMP"]];
  double MgATP     = _s[_met_to_index["MgATP"]];
  double MgGri23P2 = _s[_met_to_index["MgGri23P2"]];
  double Mgf       = _s[_met_to_index["Mgf"]];
  double NAD       = _s[_met_to_index["NAD"]];
  double NADH      = _s[_met_to_index["NADH"]];
  double NADPHf    = _s[_met_to_index["NADPHf"]];
  double NADPf     = _s[_met_to_index["NADPf"]];
  double P1NADP    = _s[_met_to_index["P1NADP"]];
  double P1NADPH   = _s[_met_to_index["P1NADPH"]];
  double P1f       = _s[_met_to_index["P1f"]];
  double P2NADP    = _s[_met_to_index["P2NADP"]];
  double P2NADPH   = _s[_met_to_index["P2NADPH"]];
  double P2f       = _s[_met_to_index["P2f"]];
  double PEP       = _s[_met_to_index["PEP"]];
  double Phi       = _s[_met_to_index["Phi"]];
  double Pyr       = _s[_met_to_index["Pyr"]];
  double Rib5P     = _s[_met_to_index["Rib5P"]];
  double Rul5P     = _s[_met_to_index["Rul5P"]];
  double Sed7P     = _s[_met_to_index["Sed7P"]];
  double Xul5P     = _s[_met_to_index["Xul5P"]];
  
  /*----------------------------------*/
  /* 4) Initialize dy/dt vector       */
  /*----------------------------------*/
  for (int i = 0; i < _m; i++)
  {
    dsdt[i]    = 0.0;
  }
  
  /*----------------------------------*/
  /* 5) Compute reaction rates        */
  /*----------------------------------*/
  double v1 = (Vmaxv0*(Glcout - Glcin/Keqv0))/(KMoutv0*(1 + Glcout/KMoutv0 + Glcin/KMinv0 + (alfav0*Glcout*Glcin)/(KMinv0*KMoutv0)));
  double v2 = (Inhibv1*Vmax1v1*Glcin*(-((Glc6P*MgADP)/Keqv1) + MgATP + (Vmax2v1*MgATP*Mgf)/(KMgATPMgv1*Vmax1v1)))/(KMgATPv1*(KMGlcv1 + Glcin)*(1 + Mgf/KMgv1 + (MgATP*(1 + Mgf/KMgATPMgv1))/KMgATPv1 + (1.55 + Glc6P/KGlc6Pv1)*(1 + Mgf/KMgv1) + (Gri23P2f + MgGri23P2)/K23P2Gv1 + (Mgf*(Gri23P2f + MgGri23P2))/(KMg23P2Gv1*KMgv1)));
  double v3 = (Vmaxv2*(-(Fru6P/Keqv2) + Glc6P))/(KGlc6Pv2*(1 + Fru6P/KFru6Pv2) + Glc6P);
  double v4 = (Vmaxv3*(-((Fru16P2*MgADP)/Keqv3) + Fru6P*MgATP))/((KFru6Pv3 + Fru6P)*(KMgATPv3 + MgATP)*(1 + (L0v3*pow((1 + ATPf/KATPv3), 4.0)*pow((1 + Mgf/KMgv3), 4.0))/(pow((1 + Fru6P/KFru6Pv3), 4.0)*pow((1 + (AMPf + MgAMP)/KAMPv3), 4.0))));
  double v5 = (Vmaxv4*(Fru16P2 - (DHAP*GraP)/Keqv4))/(KFru16P2v4*(1 + Fru16P2/KFru16P2v4 + GraP/KiGraPv4 + (Fru16P2*GraP)/(KFru16P2v4*KiiGraPv4) + (DHAP*(KGraPv4 + GraP))/(KDHAPv4*KiGraPv4)));
  double v6 = (Vmaxv5*(DHAP - GraP/Keqv5))/(DHAP + KDHAPv5*(1 + GraP/KGraPv5));
  double v7 = (Vmaxv6*(-((Gri13P2*NADH)/Keqv6) + GraP*NAD*Phi))/(KGraPv6*KNADv6*KPv6*(-1 + (1 + Gri13P2/K13P2Gv6)*(1 + NADH/KNADHv6) + (1 + GraP/KGraPv6)*(1 + NAD/KNADv6)*(1 + Phi/KPv6)));
  double v8 = (Vmaxv7*(Gri13P2*MgADP - (Gri3P*MgATP)/Keqv7))/(K13P2Gv7*KMgADPv7*(-1 + (1 + Gri13P2/K13P2Gv7)*(1 + MgADP/KMgADPv7) + (1 + Gri3P/K3PGv7)*(1 + MgATP/KMgATPv7)));
  double v9 = (kDPGMv8*(Gri13P2 - (Gri23P2f + MgGri23P2)/Keqv8))/(1 + (Gri23P2f + MgGri23P2)/K23P2Gv8);
  double v10 = (Vmaxv9*(Gri23P2f - Gri3P/Keqv9 + MgGri23P2))/(K23P2Gv9 + Gri23P2f + MgGri23P2);
  double v11 = (Vmaxv10*(-(Gri2P/Keqv10) + Gri3P))/(K3PGv10*(1 + Gri2P/K2PGv10) + Gri3P);
  double v12 = (Vmaxv11*(Gri2P - PEP/Keqv11))/(Gri2P + K2PGv11*(1 + PEP/KPEPv11));
  double v13 = (Vmaxv12*(MgADP*PEP - (MgATP*Pyr)/Keqv12))/((KMgADPv12 + MgADP)*(KPEPv12 + PEP)*(1 + (L0v12*pow((1 + (ATPf + MgATP)/KATPv12), 4.0))/(pow((1 + Fru16P2/KFru16P2v12), 4.0)*pow((1 + PEP/KPEPv12), 4.0))));
  double v14 = Vmaxv13*(-((Lac*NAD)/Keqv13) + NADH*Pyr);
  double v15 = kLDHv14*(-((Lac*NADPf)/Keqv14) + NADPHf*Pyr);
  double v16 = kATPasev15*MgATP;
  double v17 = (Vmaxv16*(-((ADPf*MgADP)/Keqv16) + AMPf*MgATP))/(KAMPv16*KATPv16*((ADPf*MgADP)/pow(KADPv16, 2.0) + (ADPf + MgADP)/KADPv16 + (1 + AMPf/KAMPv16)*(1 + MgATP/KATPv16)));
  double v18 = (Vmaxv17*(Glc6P*NADPf - (GlcA6P*NADPHf)/Keqv17))/(KG6Pv17*KNADPv17*(1 + (ATPf + MgATP)/KATPv17 + (Gri23P2f + MgGri23P2)/KPGA23v17 + ((1 + Glc6P/KG6Pv17)*NADPf)/KNADPv17 + NADPHf/KNADPHv17));
  double v19 = (Vmaxv18*(GlcA6P*NADPf - (NADPHf*Rul5P)/Keqv18))/(K6PG1v18*KNADPv18*((ATPf + MgATP)/KATPv18 + (1 + GlcA6P/K6PG1v18 + (Gri23P2f + MgGri23P2)/KPGA23v18)*(1 + NADPf/KNADPv18) + ((1 + GlcA6P/K6PG2v18)*NADPHf)/KNADPHv18));
  double v20 = (Vmaxv19*(-((pow(GSH, 2.0)*NADPf)/(Keqv19*pow(KGSHv19, 2.0)*KNADPv19)) + (GSSG*NADPHf)/(KGSSGv19*KNADPHv19)))/(1 + ((1 + (GSH*(1 + GSH/KGSHv19))/KGSHv19)*NADPf)/KNADPv19 + ((1 + GSSG/KGSSGv19)*NADPHf)/KNADPHv19);
  double v21 = Kv20*GSH;
  double v22 = (Vmaxv21*(Rul5P - Xul5P/Keqv21))/(Rul5P + KRu5Pv21*(1 + Xul5P/KX5Pv21));
  double v23 = (Vmaxv22*(-(Rib5P/Keqv22) + Rul5P))/(KRu5Pv22*(1 + Rib5P/KR5Pv22) + Rul5P);
  double v24 = (Vmaxv23*(-((GraP*Sed7P)/Keqv23) + Rib5P*Xul5P))/(K4v23*Sed7P + GraP*(K3v23 + K5v23*Sed7P) + Rib5P*(K2v23 + K6v23*Sed7P) + K7v23*GraP*Xul5P + (K1v23 + Rib5P)*Xul5P);
  double v25 = (Vmaxv24*(-((E4P*Fru6P)/Keqv24) + GraP*Sed7P))/(K4v24*Fru6P + E4P*(K3v24 + K5v24*Fru6P) + (K2v24 + K6v24*Fru6P)*GraP + K7v24*E4P*Sed7P + (K1v24 + GraP)*Sed7P);
  double v26 = (Vmaxv25*(-((PRPP*MgAMP)/Keqv25) + MgATP*Rib5P))/((KATPv25 + MgATP)*(KR5Pv25 + Rib5P));
  double v27 = (Vmaxv26*(-((Fru6P*GraP)/Keqv26) + E4P*Xul5P))/(K4v26*Fru6P + E4P*(K2v26 + K6v26*Fru6P) + (K3v26 + K5v26*Fru6P)*GraP + (K1v26 + E4P)*Xul5P + K7v26*GraP*Xul5P);
  double v28 = Vmaxv27*(Phiex - Phi/Keqv27);
  double v29 = Vmaxv28*(Lacex - Lac/Keqv28);
  double v30 = Vmaxv29*(Pyrex - Pyr/Keqv29);
  double v31 = EqMult*(MgATP - (ATPf*Mgf)/KdATP);
  double v32 = EqMult*(MgADP - (ADPf*Mgf)/KdADP);
  double v33 = EqMult*(MgAMP - (AMPf*Mgf)/KdAMP);
  double v34 = EqMult*(-((Gri23P2f*Mgf)/Kd23P2G) + MgGri23P2);
  double v35 = EqMult*(-((NADPf*P1f)/Kd1) + P1NADP);
  double v36 = EqMult*(-((NADPHf*P1f)/Kd3) + P1NADPH);
  double v37 = EqMult*(-((NADPf*P2f)/Kd2) + P2NADP);
  double v38 = EqMult*(-((NADPHf*P2f)/Kd4) + P2NADPH);
  
  /*----------------------------------*/
  /* 6) Compute ds/dt                 */
  /*----------------------------------*/
  
  /* Constants: Glcout Lacex PRPP Phiex Pyrex */
  
  /* v1 {1.0}$Glcout = {1.0}Glcin */
  dsdt[_met_to_index["Glcin"]]   += v1;
  
  /* v2 {1.0}Glcin + {1.0}MgATP = {1.0}Glc6P + {1.0}MgADP */
  dsdt[_met_to_index["Glcin"]] -= v2;
  dsdt[_met_to_index["MgATP"]] -= v2;
  dsdt[_met_to_index["Glc6P"]] += v2;
  dsdt[_met_to_index["MgADP"]] += v2;
  
  /* v3 {1.0}Glc6P = {1.0}Fru6P */
  dsdt[_met_to_index["Glc6P"]] -= v3;
  dsdt[_met_to_index["Fru6P"]] += v3;
  
  /* v4 {1.0}Fru6P + {1.0}MgATP = {1.0}Fru16P2 + {1.0}MgADP */
  dsdt[_met_to_index["Fru6P"]]   -= v4;
  dsdt[_met_to_index["MgATP"]]   -= v4;
  dsdt[_met_to_index["Fru16P2"]] += v4;
  dsdt[_met_to_index["MgADP"]]   += v4;
  
  /* v5 {1.0}Fru16P2 = {1.0}GraP + {1.0}DHAP */
  dsdt[_met_to_index["Fru16P2"]] -= v5;
  dsdt[_met_to_index["GraP"]]    += v5;
  dsdt[_met_to_index["DHAP"]]    += v5;
  
  /* v6 {1.0}DHAP = {1.0}GraP */
  dsdt[_met_to_index["DHAP"]] -= v6;
  dsdt[_met_to_index["GraP"]] += v6;
  
  /* v7 {1.0}GraP + {1.0}Phi + {1.0}NAD = {1.0}Gri13P2 + {1.0}NADH */
  dsdt[_met_to_index["GraP"]]    -= v7;
  dsdt[_met_to_index["Phi"]]     -= v7;
  dsdt[_met_to_index["NAD"]]     -= v7;
  dsdt[_met_to_index["Gri13P2"]] += v7;
  dsdt[_met_to_index["NADH"]]    += v7;
  
  /* v8 {1.0}Gri13P2 + {1.0}MgADP = {1.0}Gri3P + {1.0}MgATP */
  dsdt[_met_to_index["Gri13P2"]] -= v8;
  dsdt[_met_to_index["MgADP"]]   -= v8;
  dsdt[_met_to_index["Gri3P"]]   += v8;
  dsdt[_met_to_index["MgATP"]]   += v8;
  
  /* v9 {1.0}Gri13P2 = {1.0}Gri23P2f */
  dsdt[_met_to_index["Gri13P2"]]  -= v9;
  dsdt[_met_to_index["Gri23P2f"]] += v9;
  
  /* v10 {1.0}Gri23P2f = {1.0}Gri3P + {1.0}Phi */
  dsdt[_met_to_index["Gri23P2f"]] -= v10;
  dsdt[_met_to_index["Gri3P"]]    += v10;
  dsdt[_met_to_index["Phi"]]      += v10;
  
  /* v11 {1.0}Gri3P = {1.0}Gri2P */
  dsdt[_met_to_index["Gri3P"]] -= v11;
  dsdt[_met_to_index["Gri2P"]] += v11;
  
  /* v12 {1.0}Gri2P = {1.0}PEP */
  dsdt[_met_to_index["Gri2P"]] -= v12;
  dsdt[_met_to_index["PEP"]]   += v12;
  
  /* v13 {1.0}PEP + {1.0}MgADP = {1.0}Pyr + {1.0}MgATP */
  dsdt[_met_to_index["PEP"]]   -= v13;
  dsdt[_met_to_index["MgADP"]] -= v13;
  dsdt[_met_to_index["Pyr"]]   += v13;
  dsdt[_met_to_index["MgATP"]] += v13;
  
  /* v14 {1.0}Pyr + {1.0}NADH = {1.0}Lac + {1.0}NAD */
  dsdt[_met_to_index["Pyr"]]  -= v14;
  dsdt[_met_to_index["NADH"]] -= v14;
  dsdt[_met_to_index["Lac"]]  += v14;
  dsdt[_met_to_index["NAD"]]  += v14;
  
  /* v15 {1.0}Pyr + {1.0}NADPHf = {1.0}Lac + {1.0}NADPf */
  dsdt[_met_to_index["Pyr"]]    -= v15;
  dsdt[_met_to_index["NADPHf"]] -= v15;
  dsdt[_met_to_index["Lac"]]    += v15;
  dsdt[_met_to_index["NADPf"]]  += v15;
  
  /* v16 {1.0}MgATP = {1.0}MgADP + {1.0}Phi */
  dsdt[_met_to_index["MgATP"]] -= v16;
  dsdt[_met_to_index["MgADP"]] += v16;
  dsdt[_met_to_index["Phi"]]   += v16;
  
  /* v17 {1.0}MgATP + {1.0}AMPf = {1.0}MgADP + {1.0}ADPf */
  dsdt[_met_to_index["MgATP"]] -= v17;
  dsdt[_met_to_index["AMPf"]]  -= v17;
  dsdt[_met_to_index["MgADP"]] += v17;
  dsdt[_met_to_index["ADPf"]]  += v17;
  
  /* v18 {1.0}Glc6P + {1.0}NADPf = {1.0}GlcA6P + {1.0}NADPHf */
  dsdt[_met_to_index["Glc6P"]]  -= v18;
  dsdt[_met_to_index["NADPf"]]  -= v18;
  dsdt[_met_to_index["GlcA6P"]] += v18;
  dsdt[_met_to_index["NADPHf"]] += v18;
  
  /* v19 {1.0}GlcA6P + {1.0}NADPf = {1.0}Rul5P + {1.0}NADPHf */
  dsdt[_met_to_index["GlcA6P"]] -= v19;
  dsdt[_met_to_index["NADPf"]]  -= v19;
  dsdt[_met_to_index["Rul5P"]]  += v19;
  dsdt[_met_to_index["NADPHf"]] += v19;
  
  /* v20 {1.0}GSSG + {1.0}NADPHf = {2.0}GSH + {1.0}NADPf */
  dsdt[_met_to_index["GSSG"]]   -= v20;
  dsdt[_met_to_index["NADPHf"]] -= v20;
  dsdt[_met_to_index["GSH"]]    += 2.0*v20;
  dsdt[_met_to_index["NADPf"]]  += v20;
  
  /* v21 {2.0}GSH = {1.0}GSSG */
  dsdt[_met_to_index["GSH"]]  -= 2.0*v21;
  dsdt[_met_to_index["GSSG"]] += v21;
  
  /* v22 {1.0}Rul5P = {1.0}Xul5P */
  dsdt[_met_to_index["Rul5P"]] -= v22;
  dsdt[_met_to_index["Xul5P"]] += v22;
  
  /* v23 {1.0}Rul5P = {1.0}Rib5P */
  dsdt[_met_to_index["Rul5P"]] -= v23;
  dsdt[_met_to_index["Rib5P"]] += v23;
  
  /* v24 {1.0}Rib5P + {1.0}Xul5P = {1.0}GraP + {1.0}Sed7P */
  dsdt[_met_to_index["Rib5P"]] -= v24;
  dsdt[_met_to_index["Xul5P"]] -= v24;
  dsdt[_met_to_index["GraP"]]  += v24;
  dsdt[_met_to_index["Sed7P"]] += v24;
  
  /* v25 {1.0}Sed7P + {1.0}GraP = {1.0}E4P + {1.0}Fru6P */
  dsdt[_met_to_index["Sed7P"]] -= v25;
  dsdt[_met_to_index["GraP"]]  -= v25;
  dsdt[_met_to_index["E4P"]]   += v25;
  dsdt[_met_to_index["Fru6P"]] += v25;
  
  /* v26 {1.0}Rib5P + {1.0}MgATP = {1.0}$PRPP + {1.0}MgAMP */
  dsdt[_met_to_index["Rib5P"]] -= v26;
  dsdt[_met_to_index["MgATP"]] -= v26;
  dsdt[_met_to_index["MgAMP"]] += v26;
  
  /* v27 {1.0}E4P + {1.0}Xul5P = {1.0}GraP + {1.0}Fru6P */
  dsdt[_met_to_index["E4P"]]   -= v27;
  dsdt[_met_to_index["Xul5P"]] -= v27;
  dsdt[_met_to_index["GraP"]]  += v27;
  dsdt[_met_to_index["Fru6P"]] += v27;
  
  /* v28 {1.0}$Phiex = {1.0}Phi */
  dsdt[_met_to_index["Phi"]] += v28;
  
  /* v29 {1.0}$Lacex = {1.0}Lac */
  dsdt[_met_to_index["Lac"]] += v29;
  
  /* v30 {1.0}$Pyrex = {1.0}Pyr */
  dsdt[_met_to_index["Pyr"]] += v30;
  
  /* v31 {1.0}MgATP = {1.0}ATPf + {1.0}Mgf */
  dsdt[_met_to_index["MgATP"]] -= v31;
  dsdt[_met_to_index["ATPf"]]  += v31;
  dsdt[_met_to_index["Mgf"]]   += v31;
  
  /* v32 {1.0}MgADP = {1.0}ADPf + {1.0}Mgf */
  dsdt[_met_to_index["MgADP"]] -= v32;
  dsdt[_met_to_index["ADPf"]]  += v32;
  dsdt[_met_to_index["Mgf"]]   += v32;
  
  /* v33 {1.0}MgAMP = {1.0}AMPf + {1.0}Mgf */
  dsdt[_met_to_index["MgAMP"]] -= v33;
  dsdt[_met_to_index["AMPf"]]  += v33;
  dsdt[_met_to_index["Mgf"]]   += v33;
  
  /* v34 {1.0}MgGri23P2 = {1.0}Gri23P2f + {1.0}Mgf */
  dsdt[_met_to_index["MgGri23P2"]] -= v34;
  dsdt[_met_to_index["Gri23P2f"]]  += v34;
  dsdt[_met_to_index["Mgf"]]       += v34;
  
  /* v35 {1.0}P1NADP = {1.0}P1f + {1.0}NADPf */
  dsdt[_met_to_index["P1NADP"]] -= v35;
  dsdt[_met_to_index["P1f"]]    += v35;
  dsdt[_met_to_index["NADPf"]]  += v35;
  
  /* v36 {1.0}P1NADPH = {1.0}P1f + {1.0}NADPHf */
  dsdt[_met_to_index["P1NADPH"]] -= v36;
  dsdt[_met_to_index["P1f"]]     += v36;
  dsdt[_met_to_index["NADPHf"]]  += v36;
  
  /* v37 {1.0}P2NADP = {1.0}P2f + {1.0}NADPf */
  dsdt[_met_to_index["P2NADP"]] -= v37;
  dsdt[_met_to_index["P2f"]]    += v37;
  dsdt[_met_to_index["NADPf"]]  += v37;
  
  /* v38 {1.0}P2NADPH = {1.0}P2f + {1.0}NADPHf */
  dsdt[_met_to_index["P2NADPH"]] -= v38;
  dsdt[_met_to_index["P2f"]]     += v38;
  dsdt[_met_to_index["NADPHf"]]  += v38;
}

