
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
  
  _p = 0;
  _m = 0;
  
  _params_id_to_index.clear();
  _met_id_to_index.clear();
  
  _initial_params = new double[_p];
  _params         = new double[_p];
  for (int i = 0; i < _p; i++)
  {
    _initial_params[i] = 0.0;
    _params[i] = 0.0;
  }
  
  _initial_s = new double[_m];
  _s         = new double[_m];
  for (int i = 0; i < _m; i++)
  {
    _initial_s[i] = 0.0;
    _s[i] = 0.0;
  }
  
  /*----------------------------------------------------- PHENOTYPE */
  
  _mutated = false;
  _old_s   = NULL;
  _old_s   = new double[_m];
  for (int i = 0; i < _m; i++)
  {
    _old_s[i] = 0.0;
  }
  _c     = 0.0;
  _old_c = 0.0;
  _c_opt = 0.0;
  _w     = 0.0;
  
  /*----------------------------------------------------- ODE SOLVER */
  
  _dt       = DT_INIT;
  _t        = 0.0;
  _timestep = _dt;
  _isStable = false;
  
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

  _p = 171;
  _m = 40;
  
  create_params_id_to_index_map();
  create_met_id_to_index_map();
  
  _initial_params = new double[_p];
  _initial_s      = new double[_m];
  _params         = new double[_p];
  _s              = new double[_m];
  memcpy(_initial_params, individual._initial_params, sizeof(double)*_p);
  memcpy(_initial_s, individual._initial_s, sizeof(double)*_m);
  memcpy(_params, individual._params, sizeof(double)*_p);
  memcpy(_s, individual._s, sizeof(double)*_m);
  
  /*----------------------------------------------------- PHENOTYPE */
  
  _mutated = individual._mutated;
  _old_s   = NULL;
  _old_s   = new double[_m];
  memcpy(_old_s, individual._old_s, sizeof(double)*_m);
  _c     = individual._c;
  _old_c = individual._old_c;
  _c_opt = individual._c_opt;
  _w     = individual._w;
  
  /*----------------------------------------------------- ODE SOLVER */
  
  _dt       = individual._dt;
  _t        = 0.0;
  _timestep = _dt;
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
    /* TODO */
  }
  _params_id_to_index.clear();
  _met_id_to_index.clear();
  delete[] _initial_params;
  _initial_params = NULL;
  delete[] _initial_s;
  _initial_s = NULL;
  delete[] _params;
  _params = NULL;
  delete[] _s;
  _s = NULL;
  
  /*----------------------------------------------------- PHENOTYPE */
  
  if (!_prepared_for_tree)
  {
    delete[] _old_s;
    _old_s = NULL;
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
  
  _p = 171;
  _m = 40;
  
  create_params_id_to_index_map();
  create_met_id_to_index_map();
  
  initialize_parameters();
  initialize_concentrations();
  
  initialize_parameters_vector();
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
 * \brief    Save the current individual state
 * \details  --
 * \param    std::string filename
 * \return   \e void
 */
void Individual::save_indidivual_state( std::string filename )
{
  std::ofstream file(filename, std::ios::out | std::ios::trunc);
  /* TODO */
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
  
  /* TODO */
  
  /*----------------------------------------------------- PHENOTYPE */
  
  delete[] _old_s;
  _old_s = NULL;
  
  /*----------------------------------------------------- TREE MANAGEMENT */
  
  _prepared_for_tree = true;
}

/*----------------------------
 * PROTECTED METHODS
 *----------------------------*/

/**
 * \brief    Create the parameter id to index map
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::create_params_id_to_index_map( void )
{
  _params_id_to_index.clear();
  _params_id_to_index["Atot"]        = 0;
  _params_id_to_index["EqMult"]      = 1;
  _params_id_to_index["GStotal"]     = 2;
  _params_id_to_index["Inhibv1"]     = 3;
  _params_id_to_index["K13P2Gv6"]    = 4;
  _params_id_to_index["K13P2Gv7"]    = 5;
  _params_id_to_index["K1v23"]       = 6;
  _params_id_to_index["K1v24"]       = 7;
  _params_id_to_index["K1v26"]       = 8;
  _params_id_to_index["K23P2Gv1"]    = 9;
  _params_id_to_index["K23P2Gv8"]    = 10;
  _params_id_to_index["K23P2Gv9"]    = 11;
  _params_id_to_index["K2PGv10"]     = 12;
  _params_id_to_index["K2PGv11"]     = 13;
  _params_id_to_index["K2v23"]       = 14;
  _params_id_to_index["K2v24"]       = 15;
  _params_id_to_index["K2v26"]       = 16;
  _params_id_to_index["K3PGv10"]     = 17;
  _params_id_to_index["K3PGv7"]      = 18;
  _params_id_to_index["K3v23"]       = 19;
  _params_id_to_index["K3v24"]       = 20;
  _params_id_to_index["K3v26"]       = 21;
  _params_id_to_index["K4v23"]       = 22;
  _params_id_to_index["K4v24"]       = 23;
  _params_id_to_index["K4v26"]       = 24;
  _params_id_to_index["K5v23"]       = 25;
  _params_id_to_index["K5v24"]       = 26;
  _params_id_to_index["K5v26"]       = 27;
  _params_id_to_index["K6PG1v18"]    = 28;
  _params_id_to_index["K6PG2v18"]    = 29;
  _params_id_to_index["K6v23"]       = 30;
  _params_id_to_index["K6v24"]       = 31;
  _params_id_to_index["K6v26"]       = 32;
  _params_id_to_index["K7v23"]       = 33;
  _params_id_to_index["K7v24"]       = 34;
  _params_id_to_index["K7v26"]       = 35;
  _params_id_to_index["KADPv16"]     = 36;
  _params_id_to_index["KAMPv16"]     = 37;
  _params_id_to_index["KAMPv3"]      = 38;
  _params_id_to_index["KATPv12"]     = 39;
  _params_id_to_index["KATPv16"]     = 40;
  _params_id_to_index["KATPv17"]     = 41;
  _params_id_to_index["KATPv18"]     = 42;
  _params_id_to_index["KATPv25"]     = 43;
  _params_id_to_index["KATPv3"]      = 44;
  _params_id_to_index["KDHAPv4"]     = 45;
  _params_id_to_index["KDHAPv5"]     = 46;
  _params_id_to_index["KFru16P2v12"] = 47;
  _params_id_to_index["KFru16P2v4"]  = 48;
  _params_id_to_index["KFru6Pv2"]    = 49;
  _params_id_to_index["KFru6Pv3"]    = 50;
  _params_id_to_index["KG6Pv17"]     = 51;
  _params_id_to_index["KGSHv19"]     = 52;
  _params_id_to_index["KGSSGv19"]    = 53;
  _params_id_to_index["KGlc6Pv1"]    = 54;
  _params_id_to_index["KGlc6Pv2"]    = 55;
  _params_id_to_index["KGraPv4"]     = 56;
  _params_id_to_index["KGraPv5"]     = 57;
  _params_id_to_index["KGraPv6"]     = 58;
  _params_id_to_index["KMGlcv1"]     = 59;
  _params_id_to_index["KMg23P2Gv1"]  = 60;
  _params_id_to_index["KMgADPv12"]   = 61;
  _params_id_to_index["KMgADPv7"]    = 62;
  _params_id_to_index["KMgATPMgv1"]  = 63;
  _params_id_to_index["KMgATPv1"]    = 64;
  _params_id_to_index["KMgATPv3"]    = 65;
  _params_id_to_index["KMgATPv7"]    = 66;
  _params_id_to_index["KMgv1"]       = 67;
  _params_id_to_index["KMgv3"]       = 68;
  _params_id_to_index["KMinv0"]      = 69;
  _params_id_to_index["KMoutv0"]     = 70;
  _params_id_to_index["KNADHv6"]     = 71;
  _params_id_to_index["KNADPHv17"]   = 72;
  _params_id_to_index["KNADPHv18"]   = 73;
  _params_id_to_index["KNADPHv19"]   = 74;
  _params_id_to_index["KNADPv17"]    = 75;
  _params_id_to_index["KNADPv18"]    = 76;
  _params_id_to_index["KNADPv19"]    = 77;
  _params_id_to_index["KNADv6"]      = 78;
  _params_id_to_index["KPEPv11"]     = 79;
  _params_id_to_index["KPEPv12"]     = 80;
  _params_id_to_index["KPGA23v17"]   = 81;
  _params_id_to_index["KPGA23v18"]   = 82;
  _params_id_to_index["KPv6"]        = 83;
  _params_id_to_index["KR5Pv22"]     = 84;
  _params_id_to_index["KR5Pv25"]     = 85;
  _params_id_to_index["KRu5Pv21"]    = 86;
  _params_id_to_index["KRu5Pv22"]    = 87;
  _params_id_to_index["KX5Pv21"]     = 88;
  _params_id_to_index["Kd1"]         = 89;
  _params_id_to_index["Kd2"]         = 90;
  _params_id_to_index["Kd23P2G"]     = 91;
  _params_id_to_index["Kd3"]         = 92;
  _params_id_to_index["Kd4"]         = 93;
  _params_id_to_index["KdADP"]       = 94;
  _params_id_to_index["KdAMP"]       = 95;
  _params_id_to_index["KdATP"]       = 96;
  _params_id_to_index["Keqv0"]       = 97;
  _params_id_to_index["Keqv1"]       = 98;
  _params_id_to_index["Keqv10"]      = 99;
  _params_id_to_index["Keqv11"]      = 100;
  _params_id_to_index["Keqv12"]      = 101;
  _params_id_to_index["Keqv13"]      = 102;
  _params_id_to_index["Keqv14"]      = 103;
  _params_id_to_index["Keqv16"]      = 104;
  _params_id_to_index["Keqv17"]      = 105;
  _params_id_to_index["Keqv18"]      = 106;
  _params_id_to_index["Keqv19"]      = 107;
  _params_id_to_index["Keqv2"]       = 108;
  _params_id_to_index["Keqv21"]      = 109;
  _params_id_to_index["Keqv22"]      = 110;
  _params_id_to_index["Keqv23"]      = 111;
  _params_id_to_index["Keqv24"]      = 112;
  _params_id_to_index["Keqv25"]      = 113;
  _params_id_to_index["Keqv26"]      = 114;
  _params_id_to_index["Keqv27"]      = 115;
  _params_id_to_index["Keqv28"]      = 116;
  _params_id_to_index["Keqv29"]      = 117;
  _params_id_to_index["Keqv3"]       = 118;
  _params_id_to_index["Keqv4"]       = 119;
  _params_id_to_index["Keqv5"]       = 120;
  _params_id_to_index["Keqv6"]       = 121;
  _params_id_to_index["Keqv7"]       = 122;
  _params_id_to_index["Keqv8"]       = 123;
  _params_id_to_index["Keqv9"]       = 124;
  _params_id_to_index["KiGraPv4"]    = 125;
  _params_id_to_index["KiiGraPv4"]   = 126;
  _params_id_to_index["Kv20"]        = 127;
  _params_id_to_index["L0v12"]       = 128;
  _params_id_to_index["L0v3"]        = 129;
  _params_id_to_index["Mgtot"]       = 130;
  _params_id_to_index["NADPtot"]     = 131;
  _params_id_to_index["NADtot"]      = 132;
  _params_id_to_index["Vmax1v1"]     = 133;
  _params_id_to_index["Vmax2v1"]     = 134;
  _params_id_to_index["Vmaxv0"]      = 135;
  _params_id_to_index["Vmaxv10"]     = 136;
  _params_id_to_index["Vmaxv11"]     = 137;
  _params_id_to_index["Vmaxv12"]     = 138;
  _params_id_to_index["Vmaxv13"]     = 139;
  _params_id_to_index["Vmaxv16"]     = 140;
  _params_id_to_index["Vmaxv17"]     = 141;
  _params_id_to_index["Vmaxv18"]     = 142;
  _params_id_to_index["Vmaxv19"]     = 143;
  _params_id_to_index["Vmaxv2"]      = 144;
  _params_id_to_index["Vmaxv21"]     = 145;
  _params_id_to_index["Vmaxv22"]     = 146;
  _params_id_to_index["Vmaxv23"]     = 147;
  _params_id_to_index["Vmaxv24"]     = 148;
  _params_id_to_index["Vmaxv25"]     = 149;
  _params_id_to_index["Vmaxv26"]     = 150;
  _params_id_to_index["Vmaxv27"]     = 151;
  _params_id_to_index["Vmaxv28"]     = 152;
  _params_id_to_index["Vmaxv29"]     = 153;
  _params_id_to_index["Vmaxv3"]      = 154;
  _params_id_to_index["Vmaxv4"]      = 155;
  _params_id_to_index["Vmaxv5"]      = 156;
  _params_id_to_index["Vmaxv6"]      = 157;
  _params_id_to_index["Vmaxv7"]      = 158;
  _params_id_to_index["Vmaxv9"]      = 159;
  _params_id_to_index["alfav0"]      = 160;
  _params_id_to_index["kATPasev15"]  = 161;
  _params_id_to_index["kDPGMv8"]     = 162;
  _params_id_to_index["kLDHv14"]     = 163;
  _params_id_to_index["protein1"]    = 164;
  _params_id_to_index["protein2"]    = 165;
  _params_id_to_index["Glcout"]      = 166;
  _params_id_to_index["Lacex"]       = 167;
  _params_id_to_index["PRPP"]        = 168;
  _params_id_to_index["Phiex"]       = 169;
  _params_id_to_index["Pyrex"]       = 170;
}

/**
 * \brief    Create the metabolite id to index map
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::create_met_id_to_index_map( void )
{
  _met_id_to_index.clear();
  _met_id_to_index["ADPf"]      = 0;
  _met_id_to_index["AMPf"]      = 1;
  _met_id_to_index["ATPf"]      = 2;
  _met_id_to_index["DHAP"]      = 3;
  _met_id_to_index["E4P"]       = 4;
  _met_id_to_index["Fru16P2"]   = 5;
  _met_id_to_index["Fru6P"]     = 6;
  _met_id_to_index["GSH"]       = 7;
  _met_id_to_index["GSSG"]      = 8;
  _met_id_to_index["Glc6P"]     = 9;
  _met_id_to_index["GlcA6P"]    = 10;
  _met_id_to_index["Glcin"]     = 11;
  _met_id_to_index["GraP"]      = 12;
  _met_id_to_index["Gri13P2"]   = 13;
  _met_id_to_index["Gri23P2f"]  = 14;
  _met_id_to_index["Gri2P"]     = 15;
  _met_id_to_index["Gri3P"]     = 16;
  _met_id_to_index["Lac"]       = 17;
  _met_id_to_index["MgADP"]     = 18;
  _met_id_to_index["MgAMP"]     = 19;
  _met_id_to_index["MgATP"]     = 20;
  _met_id_to_index["MgGri23P2"] = 21;
  _met_id_to_index["Mgf"]       = 22;
  _met_id_to_index["NAD"]       = 23;
  _met_id_to_index["NADH"]      = 24;
  _met_id_to_index["NADPHf"]    = 25;
  _met_id_to_index["NADPf"]     = 26;
  _met_id_to_index["P1NADP"]    = 27;
  _met_id_to_index["P1NADPH"]   = 28;
  _met_id_to_index["P1f"]       = 29;
  _met_id_to_index["P2NADP"]    = 30;
  _met_id_to_index["P2NADPH"]   = 31;
  _met_id_to_index["P2f"]       = 32;
  _met_id_to_index["PEP"]       = 33;
  _met_id_to_index["Phi"]       = 34;
  _met_id_to_index["Pyr"]       = 35;
  _met_id_to_index["Rib5P"]     = 36;
  _met_id_to_index["Rul5P"]     = 37;
  _met_id_to_index["Sed7P"]     = 38;
  _met_id_to_index["Xul5P"]     = 39;
}

/**
 * \brief    Initialize parameter values
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::initialize_parameters( void )
{
  assert(_initial_params != NULL);
  _initial_params[_params_id_to_index["Atot"]]        = 2.0;
  _initial_params[_params_id_to_index["EqMult"]]      = 1000.0;
  _initial_params[_params_id_to_index["GStotal"]]     = 3.114;
  _initial_params[_params_id_to_index["Inhibv1"]]     = 1.0;
  _initial_params[_params_id_to_index["K13P2Gv6"]]    = 0.0035;
  _initial_params[_params_id_to_index["K13P2Gv7"]]    = 0.002;
  _initial_params[_params_id_to_index["K1v23"]]       = 0.4177;
  _initial_params[_params_id_to_index["K1v24"]]       = 0.00823;
  _initial_params[_params_id_to_index["K1v26"]]       = 0.00184;
  _initial_params[_params_id_to_index["K23P2Gv1"]]    = 2.7;
  _initial_params[_params_id_to_index["K23P2Gv8"]]    = 0.04;
  _initial_params[_params_id_to_index["K23P2Gv9"]]    = 0.2;
  _initial_params[_params_id_to_index["K2PGv10"]]     = 1.0;
  _initial_params[_params_id_to_index["K2PGv11"]]     = 1.0;
  _initial_params[_params_id_to_index["K2v23"]]       = 0.3055;
  _initial_params[_params_id_to_index["K2v24"]]       = 0.04765;
  _initial_params[_params_id_to_index["K2v26"]]       = 0.3055;
  _initial_params[_params_id_to_index["K3PGv10"]]     = 5.0;
  _initial_params[_params_id_to_index["K3PGv7"]]      = 1.2;
  _initial_params[_params_id_to_index["K3v23"]]       = 12.432;
  _initial_params[_params_id_to_index["K3v24"]]       = 0.1733;
  _initial_params[_params_id_to_index["K3v26"]]       = 0.0548;
  _initial_params[_params_id_to_index["K4v23"]]       = 0.00496;
  _initial_params[_params_id_to_index["K4v24"]]       = 0.006095;
  _initial_params[_params_id_to_index["K4v26"]]       = 0.0003;
  _initial_params[_params_id_to_index["K5v23"]]       = 0.41139;
  _initial_params[_params_id_to_index["K5v24"]]       = 0.8683;
  _initial_params[_params_id_to_index["K5v26"]]       = 0.0287;
  _initial_params[_params_id_to_index["K6PG1v18"]]    = 0.01;
  _initial_params[_params_id_to_index["K6PG2v18"]]    = 0.058;
  _initial_params[_params_id_to_index["K6v23"]]       = 0.00774;
  _initial_params[_params_id_to_index["K6v24"]]       = 0.4653;
  _initial_params[_params_id_to_index["K6v26"]]       = 0.122;
  _initial_params[_params_id_to_index["K7v23"]]       = 48.8;
  _initial_params[_params_id_to_index["K7v24"]]       = 2.524;
  _initial_params[_params_id_to_index["K7v26"]]       = 0.215;
  _initial_params[_params_id_to_index["KADPv16"]]     = 0.11;
  _initial_params[_params_id_to_index["KAMPv16"]]     = 0.08;
  _initial_params[_params_id_to_index["KAMPv3"]]      = 0.033;
  _initial_params[_params_id_to_index["KATPv12"]]     = 3.39;
  _initial_params[_params_id_to_index["KATPv16"]]     = 0.09;
  _initial_params[_params_id_to_index["KATPv17"]]     = 0.749;
  _initial_params[_params_id_to_index["KATPv18"]]     = 0.154;
  _initial_params[_params_id_to_index["KATPv25"]]     = 0.03;
  _initial_params[_params_id_to_index["KATPv3"]]      = 0.01;
  _initial_params[_params_id_to_index["KDHAPv4"]]     = 0.0364;
  _initial_params[_params_id_to_index["KDHAPv5"]]     = 0.838;
  _initial_params[_params_id_to_index["KFru16P2v12"]] = 0.005;
  _initial_params[_params_id_to_index["KFru16P2v4"]]  = 0.0071;
  _initial_params[_params_id_to_index["KFru6Pv2"]]    = 0.071;
  _initial_params[_params_id_to_index["KFru6Pv3"]]    = 0.1;
  _initial_params[_params_id_to_index["KG6Pv17"]]     = 0.0667;
  _initial_params[_params_id_to_index["KGSHv19"]]     = 20.0;
  _initial_params[_params_id_to_index["KGSSGv19"]]    = 0.0652;
  _initial_params[_params_id_to_index["KGlc6Pv1"]]    = 0.0045;
  _initial_params[_params_id_to_index["KGlc6Pv2"]]    = 0.182;
  _initial_params[_params_id_to_index["KGraPv4"]]     = 0.1906;
  _initial_params[_params_id_to_index["KGraPv5"]]     = 0.428;
  _initial_params[_params_id_to_index["KGraPv6"]]     = 0.005;
  _initial_params[_params_id_to_index["KMGlcv1"]]     = 0.1;
  _initial_params[_params_id_to_index["KMg23P2Gv1"]]  = 3.44;
  _initial_params[_params_id_to_index["KMgADPv12"]]   = 0.474;
  _initial_params[_params_id_to_index["KMgADPv7"]]    = 0.35;
  _initial_params[_params_id_to_index["KMgATPMgv1"]]  = 1.14;
  _initial_params[_params_id_to_index["KMgATPv1"]]    = 1.44;
  _initial_params[_params_id_to_index["KMgATPv3"]]    = 0.068;
  _initial_params[_params_id_to_index["KMgATPv7"]]    = 0.48;
  _initial_params[_params_id_to_index["KMgv1"]]       = 1.03;
  _initial_params[_params_id_to_index["KMgv3"]]       = 0.44;
  _initial_params[_params_id_to_index["KMinv0"]]      = 6.9;
  _initial_params[_params_id_to_index["KMoutv0"]]     = 1.7;
  _initial_params[_params_id_to_index["KNADHv6"]]     = 0.0083;
  _initial_params[_params_id_to_index["KNADPHv17"]]   = 0.00312;
  _initial_params[_params_id_to_index["KNADPHv18"]]   = 0.0045;
  _initial_params[_params_id_to_index["KNADPHv19"]]   = 0.00852;
  _initial_params[_params_id_to_index["KNADPv17"]]    = 0.00367;
  _initial_params[_params_id_to_index["KNADPv18"]]    = 0.018;
  _initial_params[_params_id_to_index["KNADPv19"]]    = 0.07;
  _initial_params[_params_id_to_index["KNADv6"]]      = 0.05;
  _initial_params[_params_id_to_index["KPEPv11"]]     = 1.0;
  _initial_params[_params_id_to_index["KPEPv12"]]     = 0.225;
  _initial_params[_params_id_to_index["KPGA23v17"]]   = 2.289;
  _initial_params[_params_id_to_index["KPGA23v18"]]   = 0.12;
  _initial_params[_params_id_to_index["KPv6"]]        = 3.9;
  _initial_params[_params_id_to_index["KR5Pv22"]]     = 2.2;
  _initial_params[_params_id_to_index["KR5Pv25"]]     = 0.57;
  _initial_params[_params_id_to_index["KRu5Pv21"]]    = 0.19;
  _initial_params[_params_id_to_index["KRu5Pv22"]]    = 0.78;
  _initial_params[_params_id_to_index["KX5Pv21"]]     = 0.5;
  _initial_params[_params_id_to_index["Kd1"]]         = 0.0002;
  _initial_params[_params_id_to_index["Kd2"]]         = 1e-05;
  _initial_params[_params_id_to_index["Kd23P2G"]]     = 1.667;
  _initial_params[_params_id_to_index["Kd3"]]         = 1e-05;
  _initial_params[_params_id_to_index["Kd4"]]         = 0.0002;
  _initial_params[_params_id_to_index["KdADP"]]       = 0.76;
  _initial_params[_params_id_to_index["KdAMP"]]       = 16.64;
  _initial_params[_params_id_to_index["KdATP"]]       = 0.072;
  _initial_params[_params_id_to_index["Keqv0"]]       = 1.0;
  _initial_params[_params_id_to_index["Keqv1"]]       = 3900.0;
  _initial_params[_params_id_to_index["Keqv10"]]      = 0.145;
  _initial_params[_params_id_to_index["Keqv11"]]      = 1.7;
  _initial_params[_params_id_to_index["Keqv12"]]      = 13790.0;
  _initial_params[_params_id_to_index["Keqv13"]]      = 9090.0;
  _initial_params[_params_id_to_index["Keqv14"]]      = 14181.8;
  _initial_params[_params_id_to_index["Keqv16"]]      = 0.25;
  _initial_params[_params_id_to_index["Keqv17"]]      = 2000.0;
  _initial_params[_params_id_to_index["Keqv18"]]      = 141.7;
  _initial_params[_params_id_to_index["Keqv19"]]      = 1.04;
  _initial_params[_params_id_to_index["Keqv2"]]       = 0.3925;
  _initial_params[_params_id_to_index["Keqv21"]]      = 2.7;
  _initial_params[_params_id_to_index["Keqv22"]]      = 3.0;
  _initial_params[_params_id_to_index["Keqv23"]]      = 1.05;
  _initial_params[_params_id_to_index["Keqv24"]]      = 1.05;
  _initial_params[_params_id_to_index["Keqv25"]]      = 100000.0;
  _initial_params[_params_id_to_index["Keqv26"]]      = 1.2;
  _initial_params[_params_id_to_index["Keqv27"]]      = 1.0;
  _initial_params[_params_id_to_index["Keqv28"]]      = 1.0;
  _initial_params[_params_id_to_index["Keqv29"]]      = 1.0;
  _initial_params[_params_id_to_index["Keqv3"]]       = 100000.0;
  _initial_params[_params_id_to_index["Keqv4"]]       = 0.114;
  _initial_params[_params_id_to_index["Keqv5"]]       = 0.0407;
  _initial_params[_params_id_to_index["Keqv6"]]       = 0.000192;
  _initial_params[_params_id_to_index["Keqv7"]]       = 1455.0;
  _initial_params[_params_id_to_index["Keqv8"]]       = 100000.0;
  _initial_params[_params_id_to_index["Keqv9"]]       = 100000.0;
  _initial_params[_params_id_to_index["KiGraPv4"]]    = 0.0572;
  _initial_params[_params_id_to_index["KiiGraPv4"]]   = 0.176;
  _initial_params[_params_id_to_index["Kv20"]]        = 0.03;
  _initial_params[_params_id_to_index["L0v12"]]       = 19.0;
  _initial_params[_params_id_to_index["L0v3"]]        = 0.001072;
  _initial_params[_params_id_to_index["Mgtot"]]       = 2.8;
  _initial_params[_params_id_to_index["NADPtot"]]     = 0.052;
  _initial_params[_params_id_to_index["NADtot"]]      = 0.0655;
  _initial_params[_params_id_to_index["Vmax1v1"]]     = 15.8;
  _initial_params[_params_id_to_index["Vmax2v1"]]     = 33.2;
  _initial_params[_params_id_to_index["Vmaxv0"]]      = 33.6;
  _initial_params[_params_id_to_index["Vmaxv10"]]     = 2000.0;
  _initial_params[_params_id_to_index["Vmaxv11"]]     = 1500.0;
  _initial_params[_params_id_to_index["Vmaxv12"]]     = 570.0;
  _initial_params[_params_id_to_index["Vmaxv13"]]     = 2800000.0;
  _initial_params[_params_id_to_index["Vmaxv16"]]     = 1380.0;
  _initial_params[_params_id_to_index["Vmaxv17"]]     = 162.0;
  _initial_params[_params_id_to_index["Vmaxv18"]]     = 1575.0;
  _initial_params[_params_id_to_index["Vmaxv19"]]     = 90.0;
  _initial_params[_params_id_to_index["Vmaxv2"]]      = 935.0;
  _initial_params[_params_id_to_index["Vmaxv21"]]     = 4634.0;
  _initial_params[_params_id_to_index["Vmaxv22"]]     = 730.0;
  _initial_params[_params_id_to_index["Vmaxv23"]]     = 23.5;
  _initial_params[_params_id_to_index["Vmaxv24"]]     = 27.2;
  _initial_params[_params_id_to_index["Vmaxv25"]]     = 1.1;
  _initial_params[_params_id_to_index["Vmaxv26"]]     = 23.5;
  _initial_params[_params_id_to_index["Vmaxv27"]]     = 100.0;
  _initial_params[_params_id_to_index["Vmaxv28"]]     = 10000.0;
  _initial_params[_params_id_to_index["Vmaxv29"]]     = 10000.0;
  _initial_params[_params_id_to_index["Vmaxv3"]]      = 239.0;
  _initial_params[_params_id_to_index["Vmaxv4"]]      = 98.91000366;
  _initial_params[_params_id_to_index["Vmaxv5"]]      = 5456.600098;
  _initial_params[_params_id_to_index["Vmaxv6"]]      = 4300.0;
  _initial_params[_params_id_to_index["Vmaxv7"]]      = 5000.0;
  _initial_params[_params_id_to_index["Vmaxv9"]]      = 0.53;
  _initial_params[_params_id_to_index["alfav0"]]      = 0.54;
  _initial_params[_params_id_to_index["kATPasev15"]]  = 1.68;
  _initial_params[_params_id_to_index["kDPGMv8"]]     = 76000.0;
  _initial_params[_params_id_to_index["kLDHv14"]]     = 243.4;
  _initial_params[_params_id_to_index["protein1"]]    = 0.024;
  _initial_params[_params_id_to_index["protein2"]]    = 0.024;
  _initial_params[_params_id_to_index["Glcout"]]      = 5.0;
  _initial_params[_params_id_to_index["Lacex"]]       = 1.68;
  _initial_params[_params_id_to_index["PRPP"]]        = 1.0;
  _initial_params[_params_id_to_index["Phiex"]]       = 1.0;
  _initial_params[_params_id_to_index["Pyrex"]]       = 0.084;
}

/**
 * \brief    Initialize concentration values
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::initialize_concentrations( void )
{
  assert(_initial_s != NULL);
  _initial_s[_met_id_to_index["ADPf"]]      = 0.25;
  _initial_s[_met_id_to_index["AMPf"]]      = 0.0;
  _initial_s[_met_id_to_index["ATPf"]]      = 0.25;
  _initial_s[_met_id_to_index["DHAP"]]      = 0.1492;
  _initial_s[_met_id_to_index["E4P"]]       = 0.0063;
  _initial_s[_met_id_to_index["Fru16P2"]]   = 0.0097;
  _initial_s[_met_id_to_index["Fru6P"]]     = 0.0153;
  _initial_s[_met_id_to_index["GSH"]]       = 3.1136;
  _initial_s[_met_id_to_index["GSSG"]]      = 0.0004;
  _initial_s[_met_id_to_index["Glc6P"]]     = 0.0394;
  _initial_s[_met_id_to_index["GlcA6P"]]    = 0.025;
  _initial_s[_met_id_to_index["Glcin"]]     = 4.5663;
  _initial_s[_met_id_to_index["GraP"]]      = 0.0061;
  _initial_s[_met_id_to_index["Gri13P2"]]   = 0.0005;
  _initial_s[_met_id_to_index["Gri23P2f"]]  = 2.0601;
  _initial_s[_met_id_to_index["Gri2P"]]     = 0.0084;
  _initial_s[_met_id_to_index["Gri3P"]]     = 0.0658;
  _initial_s[_met_id_to_index["Lac"]]       = 1.6803;
  _initial_s[_met_id_to_index["MgADP"]]     = 0.1;
  _initial_s[_met_id_to_index["MgAMP"]]     = 0.0;
  _initial_s[_met_id_to_index["MgATP"]]     = 1.4;
  _initial_s[_met_id_to_index["MgGri23P2"]] = 0.5;
  _initial_s[_met_id_to_index["Mgf"]]       = 0.8;
  _initial_s[_met_id_to_index["NAD"]]       = 0.0653;
  _initial_s[_met_id_to_index["NADH"]]      = 0.0002;
  _initial_s[_met_id_to_index["NADPHf"]]    = 0.004;
  _initial_s[_met_id_to_index["NADPf"]]     = 0.0;
  _initial_s[_met_id_to_index["P1NADP"]]    = 0.0;
  _initial_s[_met_id_to_index["P1NADPH"]]   = 0.024;
  _initial_s[_met_id_to_index["P1f"]]       = 0.0;
  _initial_s[_met_id_to_index["P2NADP"]]    = 0.0;
  _initial_s[_met_id_to_index["P2NADPH"]]   = 0.024;
  _initial_s[_met_id_to_index["P2f"]]       = 0.0;
  _initial_s[_met_id_to_index["PEP"]]       = 0.0109;
  _initial_s[_met_id_to_index["Phi"]]       = 0.9992;
  _initial_s[_met_id_to_index["Pyr"]]       = 0.084;
  _initial_s[_met_id_to_index["Rib5P"]]     = 0.014;
  _initial_s[_met_id_to_index["Rul5P"]]     = 0.0047;
  _initial_s[_met_id_to_index["Sed7P"]]     = 0.0154;
  _initial_s[_met_id_to_index["Xul5P"]]     = 0.0127;
}

/**
 * \brief    Initialize the parameters vector
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::initialize_parameters_vector( void )
{
  assert(_initial_params != NULL);
  assert(_params != NULL);
  memcpy(_params, _initial_params, sizeof(double)*_p);
}

/**
 * \brief    Initialize the concentration vector
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::initialize_concentration_vector( void )
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
void Individual::solve( void )
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
    ODE_system(_s, DSDT);
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
 * \param    const double* s
 * \param    double* dsdt
 * \return   \e void
 */
void Individual::ODE_system( const double* s, double* dsdt )
{
  /*----------------------------*/
  /* 1) Initialize parameters   */
  /*----------------------------*/
  double Atot = _params[_params_id_to_index["Atot"]];
  double EqMult = _params[_params_id_to_index["EqMult"]];
  double GStotal = _params[_params_id_to_index["GStotal"]];
  double Inhibv1 = _params[_params_id_to_index["Inhibv1"]];
  double K13P2Gv6 = _params[_params_id_to_index["K13P2Gv6"]];
  double K13P2Gv7 = _params[_params_id_to_index["K13P2Gv7"]];
  double K1v23 = _params[_params_id_to_index["K1v23"]];
  double K1v24 = _params[_params_id_to_index["K1v24"]];
  double K1v26 = _params[_params_id_to_index["K1v26"]];
  double K23P2Gv1 = _params[_params_id_to_index["K23P2Gv1"]];
  double K23P2Gv8 = _params[_params_id_to_index["K23P2Gv8"]];
  double K23P2Gv9 = _params[_params_id_to_index["K23P2Gv9"]];
  double K2PGv10 = _params[_params_id_to_index["K2PGv10"]];
  double K2PGv11 = _params[_params_id_to_index["K2PGv11"]];
  double K2v23 = _params[_params_id_to_index["K2v23"]];
  double K2v24 = _params[_params_id_to_index["K2v24"]];
  double K2v26 = _params[_params_id_to_index["K2v26"]];
  double K3PGv10 = _params[_params_id_to_index["K3PGv10"]];
  double K3PGv7 = _params[_params_id_to_index["K3PGv7"]];
  double K3v23 = _params[_params_id_to_index["K3v23"]];
  double K3v24 = _params[_params_id_to_index["K3v24"]];
  double K3v26 = _params[_params_id_to_index["K3v26"]];
  double K4v23 = _params[_params_id_to_index["K4v23"]];
  double K4v24 = _params[_params_id_to_index["K4v24"]];
  double K4v26 = _params[_params_id_to_index["K4v26"]];
  double K5v23 = _params[_params_id_to_index["K5v23"]];
  double K5v24 = _params[_params_id_to_index["K5v24"]];
  double K5v26 = _params[_params_id_to_index["K5v26"]];
  double K6PG1v18 = _params[_params_id_to_index["K6PG1v18"]];
  double K6PG2v18 = _params[_params_id_to_index["K6PG2v18"]];
  double K6v23 = _params[_params_id_to_index["K6v23"]];
  double K6v24 = _params[_params_id_to_index["K6v24"]];
  double K6v26 = _params[_params_id_to_index["K6v26"]];
  double K7v23 = _params[_params_id_to_index["K7v23"]];
  double K7v24 = _params[_params_id_to_index["K7v24"]];
  double K7v26 = _params[_params_id_to_index["K7v26"]];
  double KADPv16 = _params[_params_id_to_index["KADPv16"]];
  double KAMPv16 = _params[_params_id_to_index["KAMPv16"]];
  double KAMPv3 = _params[_params_id_to_index["KAMPv3"]];
  double KATPv12 = _params[_params_id_to_index["KATPv12"]];
  double KATPv16 = _params[_params_id_to_index["KATPv16"]];
  double KATPv17 = _params[_params_id_to_index["KATPv17"]];
  double KATPv18 = _params[_params_id_to_index["KATPv18"]];
  double KATPv25 = _params[_params_id_to_index["KATPv25"]];
  double KATPv3 = _params[_params_id_to_index["KATPv3"]];
  double KDHAPv4 = _params[_params_id_to_index["KDHAPv4"]];
  double KDHAPv5 = _params[_params_id_to_index["KDHAPv5"]];
  double KFru16P2v12 = _params[_params_id_to_index["KFru16P2v12"]];
  double KFru16P2v4 = _params[_params_id_to_index["KFru16P2v4"]];
  double KFru6Pv2 = _params[_params_id_to_index["KFru6Pv2"]];
  double KFru6Pv3 = _params[_params_id_to_index["KFru6Pv3"]];
  double KG6Pv17 = _params[_params_id_to_index["KG6Pv17"]];
  double KGSHv19 = _params[_params_id_to_index["KGSHv19"]];
  double KGSSGv19 = _params[_params_id_to_index["KGSSGv19"]];
  double KGlc6Pv1 = _params[_params_id_to_index["KGlc6Pv1"]];
  double KGlc6Pv2 = _params[_params_id_to_index["KGlc6Pv2"]];
  double KGraPv4 = _params[_params_id_to_index["KGraPv4"]];
  double KGraPv5 = _params[_params_id_to_index["KGraPv5"]];
  double KGraPv6 = _params[_params_id_to_index["KGraPv6"]];
  double KMGlcv1 = _params[_params_id_to_index["KMGlcv1"]];
  double KMg23P2Gv1 = _params[_params_id_to_index["KMg23P2Gv1"]];
  double KMgADPv12 = _params[_params_id_to_index["KMgADPv12"]];
  double KMgADPv7 = _params[_params_id_to_index["KMgADPv7"]];
  double KMgATPMgv1 = _params[_params_id_to_index["KMgATPMgv1"]];
  double KMgATPv1 = _params[_params_id_to_index["KMgATPv1"]];
  double KMgATPv3 = _params[_params_id_to_index["KMgATPv3"]];
  double KMgATPv7 = _params[_params_id_to_index["KMgATPv7"]];
  double KMgv1 = _params[_params_id_to_index["KMgv1"]];
  double KMgv3 = _params[_params_id_to_index["KMgv3"]];
  double KMinv0 = _params[_params_id_to_index["KMinv0"]];
  double KMoutv0 = _params[_params_id_to_index["KMoutv0"]];
  double KNADHv6 = _params[_params_id_to_index["KNADHv6"]];
  double KNADPHv17 = _params[_params_id_to_index["KNADPHv17"]];
  double KNADPHv18 = _params[_params_id_to_index["KNADPHv18"]];
  double KNADPHv19 = _params[_params_id_to_index["KNADPHv19"]];
  double KNADPv17 = _params[_params_id_to_index["KNADPv17"]];
  double KNADPv18 = _params[_params_id_to_index["KNADPv18"]];
  double KNADPv19 = _params[_params_id_to_index["KNADPv19"]];
  double KNADv6 = _params[_params_id_to_index["KNADv6"]];
  double KPEPv11 = _params[_params_id_to_index["KPEPv11"]];
  double KPEPv12 = _params[_params_id_to_index["KPEPv12"]];
  double KPGA23v17 = _params[_params_id_to_index["KPGA23v17"]];
  double KPGA23v18 = _params[_params_id_to_index["KPGA23v18"]];
  double KPv6 = _params[_params_id_to_index["KPv6"]];
  double KR5Pv22 = _params[_params_id_to_index["KR5Pv22"]];
  double KR5Pv25 = _params[_params_id_to_index["KR5Pv25"]];
  double KRu5Pv21 = _params[_params_id_to_index["KRu5Pv21"]];
  double KRu5Pv22 = _params[_params_id_to_index["KRu5Pv22"]];
  double KX5Pv21 = _params[_params_id_to_index["KX5Pv21"]];
  double Kd1 = _params[_params_id_to_index["Kd1"]];
  double Kd2 = _params[_params_id_to_index["Kd2"]];
  double Kd23P2G = _params[_params_id_to_index["Kd23P2G"]];
  double Kd3 = _params[_params_id_to_index["Kd3"]];
  double Kd4 = _params[_params_id_to_index["Kd4"]];
  double KdADP = _params[_params_id_to_index["KdADP"]];
  double KdAMP = _params[_params_id_to_index["KdAMP"]];
  double KdATP = _params[_params_id_to_index["KdATP"]];
  double Keqv0 = _params[_params_id_to_index["Keqv0"]];
  double Keqv1 = _params[_params_id_to_index["Keqv1"]];
  double Keqv10 = _params[_params_id_to_index["Keqv10"]];
  double Keqv11 = _params[_params_id_to_index["Keqv11"]];
  double Keqv12 = _params[_params_id_to_index["Keqv12"]];
  double Keqv13 = _params[_params_id_to_index["Keqv13"]];
  double Keqv14 = _params[_params_id_to_index["Keqv14"]];
  double Keqv16 = _params[_params_id_to_index["Keqv16"]];
  double Keqv17 = _params[_params_id_to_index["Keqv17"]];
  double Keqv18 = _params[_params_id_to_index["Keqv18"]];
  double Keqv19 = _params[_params_id_to_index["Keqv19"]];
  double Keqv2 = _params[_params_id_to_index["Keqv2"]];
  double Keqv21 = _params[_params_id_to_index["Keqv21"]];
  double Keqv22 = _params[_params_id_to_index["Keqv22"]];
  double Keqv23 = _params[_params_id_to_index["Keqv23"]];
  double Keqv24 = _params[_params_id_to_index["Keqv24"]];
  double Keqv25 = _params[_params_id_to_index["Keqv25"]];
  double Keqv26 = _params[_params_id_to_index["Keqv26"]];
  double Keqv27 = _params[_params_id_to_index["Keqv27"]];
  double Keqv28 = _params[_params_id_to_index["Keqv28"]];
  double Keqv29 = _params[_params_id_to_index["Keqv29"]];
  double Keqv3 = _params[_params_id_to_index["Keqv3"]];
  double Keqv4 = _params[_params_id_to_index["Keqv4"]];
  double Keqv5 = _params[_params_id_to_index["Keqv5"]];
  double Keqv6 = _params[_params_id_to_index["Keqv6"]];
  double Keqv7 = _params[_params_id_to_index["Keqv7"]];
  double Keqv8 = _params[_params_id_to_index["Keqv8"]];
  double Keqv9 = _params[_params_id_to_index["Keqv9"]];
  double KiGraPv4 = _params[_params_id_to_index["KiGraPv4"]];
  double KiiGraPv4 = _params[_params_id_to_index["KiiGraPv4"]];
  double Kv20 = _params[_params_id_to_index["Kv20"]];
  double L0v12 = _params[_params_id_to_index["L0v12"]];
  double L0v3 = _params[_params_id_to_index["L0v3"]];
  double Mgtot = _params[_params_id_to_index["Mgtot"]];
  double NADPtot = _params[_params_id_to_index["NADPtot"]];
  double NADtot = _params[_params_id_to_index["NADtot"]];
  double Vmax1v1 = _params[_params_id_to_index["Vmax1v1"]];
  double Vmax2v1 = _params[_params_id_to_index["Vmax2v1"]];
  double Vmaxv0 = _params[_params_id_to_index["Vmaxv0"]];
  double Vmaxv10 = _params[_params_id_to_index["Vmaxv10"]];
  double Vmaxv11 = _params[_params_id_to_index["Vmaxv11"]];
  double Vmaxv12 = _params[_params_id_to_index["Vmaxv12"]];
  double Vmaxv13 = _params[_params_id_to_index["Vmaxv13"]];
  double Vmaxv16 = _params[_params_id_to_index["Vmaxv16"]];
  double Vmaxv17 = _params[_params_id_to_index["Vmaxv17"]];
  double Vmaxv18 = _params[_params_id_to_index["Vmaxv18"]];
  double Vmaxv19 = _params[_params_id_to_index["Vmaxv19"]];
  double Vmaxv2 = _params[_params_id_to_index["Vmaxv2"]];
  double Vmaxv21 = _params[_params_id_to_index["Vmaxv21"]];
  double Vmaxv22 = _params[_params_id_to_index["Vmaxv22"]];
  double Vmaxv23 = _params[_params_id_to_index["Vmaxv23"]];
  double Vmaxv24 = _params[_params_id_to_index["Vmaxv24"]];
  double Vmaxv25 = _params[_params_id_to_index["Vmaxv25"]];
  double Vmaxv26 = _params[_params_id_to_index["Vmaxv26"]];
  double Vmaxv27 = _params[_params_id_to_index["Vmaxv27"]];
  double Vmaxv28 = _params[_params_id_to_index["Vmaxv28"]];
  double Vmaxv29 = _params[_params_id_to_index["Vmaxv29"]];
  double Vmaxv3 = _params[_params_id_to_index["Vmaxv3"]];
  double Vmaxv4 = _params[_params_id_to_index["Vmaxv4"]];
  double Vmaxv5 = _params[_params_id_to_index["Vmaxv5"]];
  double Vmaxv6 = _params[_params_id_to_index["Vmaxv6"]];
  double Vmaxv7 = _params[_params_id_to_index["Vmaxv7"]];
  double Vmaxv9 = _params[_params_id_to_index["Vmaxv9"]];
  double alfav0 = _params[_params_id_to_index["alfav0"]];
  double kATPasev15 = _params[_params_id_to_index["kATPasev15"]];
  double kDPGMv8 = _params[_params_id_to_index["kDPGMv8"]];
  double kLDHv14 = _params[_params_id_to_index["kLDHv14"]];
  double protein1 = _params[_params_id_to_index["protein1"]];
  double protein2 = _params[_params_id_to_index["protein2"]];
  double Glcout = _params[_params_id_to_index["Glcout"]];
  double Lacex = _params[_params_id_to_index["Lacex"]];
  double PRPP = _params[_params_id_to_index["PRPP"]];
  double Phiex = _params[_params_id_to_index["Phiex"]];
  double Pyrex = _params[_params_id_to_index["Pyrex"]];
  
  /*----------------------------*/
  /* 2) Initialize metabolites  */
  /*----------------------------*/
  double ADPf = _s[_met_id_to_index["ADPf"]];
  double AMPf = _s[_met_id_to_index["AMPf"]];
  double ATPf = _s[_met_id_to_index["ATPf"]];
  double DHAP = _s[_met_id_to_index["DHAP"]];
  double E4P = _s[_met_id_to_index["E4P"]];
  double Fru16P2 = _s[_met_id_to_index["Fru16P2"]];
  double Fru6P = _s[_met_id_to_index["Fru6P"]];
  double GSH = _s[_met_id_to_index["GSH"]];
  double GSSG = _s[_met_id_to_index["GSSG"]];
  double Glc6P = _s[_met_id_to_index["Glc6P"]];
  double GlcA6P = _s[_met_id_to_index["GlcA6P"]];
  double Glcin = _s[_met_id_to_index["Glcin"]];
  double GraP = _s[_met_id_to_index["GraP"]];
  double Gri13P2 = _s[_met_id_to_index["Gri13P2"]];
  double Gri23P2f = _s[_met_id_to_index["Gri23P2f"]];
  double Gri2P = _s[_met_id_to_index["Gri2P"]];
  double Gri3P = _s[_met_id_to_index["Gri3P"]];
  double Lac = _s[_met_id_to_index["Lac"]];
  double MgADP = _s[_met_id_to_index["MgADP"]];
  double MgAMP = _s[_met_id_to_index["MgAMP"]];
  double MgATP = _s[_met_id_to_index["MgATP"]];
  double MgGri23P2 = _s[_met_id_to_index["MgGri23P2"]];
  double Mgf = _s[_met_id_to_index["Mgf"]];
  double NAD = _s[_met_id_to_index["NAD"]];
  double NADH = _s[_met_id_to_index["NADH"]];
  double NADPHf = _s[_met_id_to_index["NADPHf"]];
  double NADPf = _s[_met_id_to_index["NADPf"]];
  double P1NADP = _s[_met_id_to_index["P1NADP"]];
  double P1NADPH = _s[_met_id_to_index["P1NADPH"]];
  double P1f = _s[_met_id_to_index["P1f"]];
  double P2NADP = _s[_met_id_to_index["P2NADP"]];
  double P2NADPH = _s[_met_id_to_index["P2NADPH"]];
  double P2f = _s[_met_id_to_index["P2f"]];
  double PEP = _s[_met_id_to_index["PEP"]];
  double Phi = _s[_met_id_to_index["Phi"]];
  double Pyr = _s[_met_id_to_index["Pyr"]];
  double Rib5P = _s[_met_id_to_index["Rib5P"]];
  double Rul5P = _s[_met_id_to_index["Rul5P"]];
  double Sed7P = _s[_met_id_to_index["Sed7P"]];
  double Xul5P = _s[_met_id_to_index["Xul5P"]];
  
  /*----------------------------*/
  /* 3) Initialize dy/dt vector */
  /*----------------------------*/
  for (int i = 0; i < _m; i++)
  {
    dsdt[i] = 0.0;
  }
  
  /*----------------------------*/
  /* 4) Compute reaction rates  */
  /*----------------------------*/
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
  
  /*----------------------------*/
  /* 5) Compute ds/dt           */
  /*----------------------------*/
  
  /* Constants: Glcout Lacex PRPP Phiex Pyrex */
   
  /* v1 {1.0}$Glcout = {1.0}Glcin */
  dsdt[_met_id_to_index["Glcin"]]  -= v1;
  //dsdt[_met_id_to_index["Glcout"]] += v1;
  
  /* v2 {1.0}Glcin + {1.0}MgATP = {1.0}Glc6P + {1.0}MgADP */
  dsdt[_met_id_to_index["Glc6P"]] -= v2;
  dsdt[_met_id_to_index["MgADP"]] -= v2;
  dsdt[_met_id_to_index["Glcin"]] += v2;
  dsdt[_met_id_to_index["MgATP"]] += v2;
  
  /* v3 {1.0}Glc6P = {1.0}Fru6P */
  dsdt[_met_id_to_index["Fru6P"]] -= v3;
  dsdt[_met_id_to_index["Glc6P"]] += v3;
  
  /* v4 {1.0}Fru6P + {1.0}MgATP = {1.0}Fru16P2 + {1.0}MgADP */
  dsdt[_met_id_to_index["Fru16P2"]] -= v4;
  dsdt[_met_id_to_index["MgADP"]]   -= v4;
  dsdt[_met_id_to_index["Fru6P"]]   += v4;
  dsdt[_met_id_to_index["MgATP"]]   += v4;
  
  /* v5 {1.0}Fru16P2 = {1.0}GraP + {1.0}DHAP */
  dsdt[_met_id_to_index["GraP"]]    -= v5;
  dsdt[_met_id_to_index["DHAP"]]    -= v5;
  dsdt[_met_id_to_index["Fru16P2"]] += v5;
  
  /* v6 {1.0}DHAP = {1.0}GraP */
  dsdt[_met_id_to_index["GraP"]] -= v6;
  dsdt[_met_id_to_index["DHAP"]] += v6;
  
  /* v7 {1.0}GraP + {1.0}Phi + {1.0}NAD = {1.0}Gri13P2 + {1.0}NADH */
  dsdt[_met_id_to_index["Gri13P2"]] -= v7;
  dsdt[_met_id_to_index["NADH"]]    -= v7;
  dsdt[_met_id_to_index["GraP"]]    += v7;
  dsdt[_met_id_to_index["Phi"]]     += v7;
  dsdt[_met_id_to_index["NAD"]]     += v7;
  
  /* v8 {1.0}Gri13P2 + {1.0}MgADP = {1.0}Gri3P + {1.0}MgATP */
  dsdt[_met_id_to_index["Gri3P"]]   -= v8;
  dsdt[_met_id_to_index["MgATP"]]   -= v8;
  dsdt[_met_id_to_index["Gri13P2"]] += v8;
  dsdt[_met_id_to_index["MgADP"]]   += v8;
  
  /* v9 {1.0}Gri13P2 = {1.0}Gri23P2f */
  dsdt[_met_id_to_index["Gri23P2f"]] -= v9;
  dsdt[_met_id_to_index["Gri13P2"]]  += v9;
  
  /* v10 {1.0}Gri23P2f = {1.0}Gri3P + {1.0}Phi */
  dsdt[_met_id_to_index["Gri3P"]]    -= v10;
  dsdt[_met_id_to_index["Phi"]]      -= v10;
  dsdt[_met_id_to_index["Gri23P2f"]] += v10;
  
  /* v11 {1.0}Gri3P = {1.0}Gri2P */
  dsdt[_met_id_to_index["Gri2P"]] -= v11;
  dsdt[_met_id_to_index["Gri3P"]] += v11;
  
  /* v12 {1.0}Gri2P = {1.0}PEP */
  dsdt[_met_id_to_index["PEP"]]   -= v12;
  dsdt[_met_id_to_index["Gri2P"]] += v12;
  
  /* v13 {1.0}PEP + {1.0}MgADP = {1.0}Pyr + {1.0}MgATP */
  dsdt[_met_id_to_index["Pyr"]]   -= v13;
  dsdt[_met_id_to_index["MgATP"]] -= v13;
  dsdt[_met_id_to_index["PEP"]]   += v13;
  dsdt[_met_id_to_index["MgADP"]] += v13;
  
  /* v14 {1.0}Pyr + {1.0}NADH = {1.0}Lac + {1.0}NAD */
  dsdt[_met_id_to_index["Lac"]]  -= v14;
  dsdt[_met_id_to_index["NAD"]]  -= v14;
  dsdt[_met_id_to_index["Pyr"]]  += v14;
  dsdt[_met_id_to_index["NADH"]] += v14;
  
  /* v15 {1.0}Pyr + {1.0}NADPHf = {1.0}Lac + {1.0}NADPf */
  dsdt[_met_id_to_index["Lac"]]    -= v15;
  dsdt[_met_id_to_index["NADPf"]]  -= v15;
  dsdt[_met_id_to_index["Pyr"]]    += v15;
  dsdt[_met_id_to_index["NADPHf"]] += v15;
  
  /* v16 {1.0}MgATP = {1.0}MgADP + {1.0}Phi */
  dsdt[_met_id_to_index["MgADP"]] -= v16;
  dsdt[_met_id_to_index["Phi"]]   -= v16;
  dsdt[_met_id_to_index["MgATP"]] += v16;
  
  /* v17 {1.0}MgATP + {1.0}AMPf = {1.0}MgADP + {1.0}ADPf */
  dsdt[_met_id_to_index["MgADP"]] -= v17;
  dsdt[_met_id_to_index["ADPf"]]  -= v17;
  dsdt[_met_id_to_index["MgATP"]] += v17;
  dsdt[_met_id_to_index["AMPf"]]  += v17;
  
  /* v18 {1.0}Glc6P + {1.0}NADPf = {1.0}GlcA6P + {1.0}NADPHf */
  dsdt[_met_id_to_index["GlcA6P"]] -= v18;
  dsdt[_met_id_to_index["NADPHf"]] -= v18;
  dsdt[_met_id_to_index["Glc6P"]]  += v18;
  dsdt[_met_id_to_index["NADPf"]]  += v18;
  
  /* v19 {1.0}GlcA6P + {1.0}NADPf = {1.0}Rul5P + {1.0}NADPHf */
  dsdt[_met_id_to_index["Rul5P"]]  -= v19;
  dsdt[_met_id_to_index["NADPHf"]] -= v19;
  dsdt[_met_id_to_index["GlcA6P"]] += v19;
  dsdt[_met_id_to_index["NADPf"]]  += v19;
  
  /* v20 {1.0}GSSG + {1.0}NADPHf = {2.0}GSH + {1.0}NADPf */
  dsdt[_met_id_to_index["GSH"]]    -= 2.0*v20;
  dsdt[_met_id_to_index["NADPf"]]  -= v20;
  dsdt[_met_id_to_index["GSSG"]]   += v20;
  dsdt[_met_id_to_index["NADPHf"]] += v20;
  
  /* v21 {2.0}GSH = {1.0}GSSG */
  dsdt[_met_id_to_index["GSSG"]] -= v21;
  dsdt[_met_id_to_index["GSH"]]  += 2.0*v21;
  
  /* v22 {1.0}Rul5P = {1.0}Xul5P */
  dsdt[_met_id_to_index["Xul5P"]] -= v22;
  dsdt[_met_id_to_index["Rul5P"]] += v22;
  
  /* v23 {1.0}Rul5P = {1.0}Rib5P */
  dsdt[_met_id_to_index["Rib5P"]] -= v23;
  dsdt[_met_id_to_index["Rul5P"]] += v23;
  
  /* v24 {1.0}Rib5P + {1.0}Xul5P = {1.0}GraP + {1.0}Sed7P */
  dsdt[_met_id_to_index["GraP"]]  -= v24;
  dsdt[_met_id_to_index["Sed7P"]] -= v24;
  dsdt[_met_id_to_index["Rib5P"]] += v24;
  dsdt[_met_id_to_index["Xul5P"]] += v24;
  
  /* v25 {1.0}Sed7P + {1.0}GraP = {1.0}E4P + {1.0}Fru6P */
  dsdt[_met_id_to_index["E4P"]]   -= v25;
  dsdt[_met_id_to_index["Fru6P"]] -= v25;
  dsdt[_met_id_to_index["Sed7P"]] += v25;
  dsdt[_met_id_to_index["GraP"]]  += v25;
  
  /* v26 {1.0}Rib5P + {1.0}MgATP = {1.0}$PRPP + {1.0}MgAMP */
  //dsdt[_met_id_to_index["PRPP"]]  -= v26;
  dsdt[_met_id_to_index["MgAMP"]] -= v26;
  dsdt[_met_id_to_index["Rib5P"]] += v26;
  dsdt[_met_id_to_index["MgATP"]] += v26;
  
  /* v27 {1.0}E4P + {1.0}Xul5P = {1.0}GraP + {1.0}Fru6P */
  dsdt[_met_id_to_index["GraP"]]  -= v27;
  dsdt[_met_id_to_index["Fru6P"]] -= v27;
  dsdt[_met_id_to_index["E4P"]]   += v27;
  dsdt[_met_id_to_index["Xul5P"]] += v27;
  
  /* v28 {1.0}$Phiex = {1.0}Phi */
  dsdt[_met_id_to_index["Phi"]]   -= v28;
  //dsdt[_met_id_to_index["Phiex"]] += v28;
  
  /* v29 {1.0}$Lacex = {1.0}Lac */
  dsdt[_met_id_to_index["Lac"]]   -= v29;
  //dsdt[_met_id_to_index["Lacex"]] += v29;
  
  /* v30 {1.0}$Pyrex = {1.0}Pyr */
  dsdt[_met_id_to_index["Pyr"]]   -= v30;
  //dsdt[_met_id_to_index["Pyrex"]] += v30;
  
  /* v31 {1.0}MgATP = {1.0}ATPf + {1.0}Mgf */
  dsdt[_met_id_to_index["ATPf"]]  -= v31;
  dsdt[_met_id_to_index["Mgf"]]   -= v31;
  dsdt[_met_id_to_index["MgATP"]] += v31;
  
  /* v32 {1.0}MgADP = {1.0}ADPf + {1.0}Mgf */
  dsdt[_met_id_to_index["ADPf"]]  -= v32;
  dsdt[_met_id_to_index["Mgf"]]   -= v32;
  dsdt[_met_id_to_index["MgADP"]] += v32;
  
  /* v33 {1.0}MgAMP = {1.0}AMPf + {1.0}Mgf */
  dsdt[_met_id_to_index["AMPf"]]  -= v33;
  dsdt[_met_id_to_index["Mgf"]]   -= v33;
  dsdt[_met_id_to_index["MgAMP"]] += v33;
  
  /* v34 {1.0}MgGri23P2 = {1.0}Gri23P2f + {1.0}Mgf */
  dsdt[_met_id_to_index["Gri23P2f"]]  -= v34;
  dsdt[_met_id_to_index["Mgf"]]       -= v34;
  dsdt[_met_id_to_index["MgGri23P2"]] += v34;
  
  /* v35 {1.0}P1NADP = {1.0}P1f + {1.0}NADPf */
  dsdt[_met_id_to_index["P1f"]]    -= v35;
  dsdt[_met_id_to_index["NADPf"]]  -= v35;
  dsdt[_met_id_to_index["P1NADP"]] += v35;
  
  /* v36 {1.0}P1NADPH = {1.0}P1f + {1.0}NADPHf */
  dsdt[_met_id_to_index["P1f"]]     -= v36;
  dsdt[_met_id_to_index["NADPHf"]]  -= v36;
  dsdt[_met_id_to_index["P1NADPH"]] += v36;
  
  /* v37 {1.0}P2NADP = {1.0}P2f + {1.0}NADPf */
  dsdt[_met_id_to_index["P2f"]]    -= v37;
  dsdt[_met_id_to_index["NADPf"]]  -= v37;
  dsdt[_met_id_to_index["P2NADP"]] += v37;
  
  /* v38 {1.0}P2NADPH = {1.0}P2f + {1.0}NADPHf */
  dsdt[_met_id_to_index["P2f"]]     -= v38;
  dsdt[_met_id_to_index["NADPHf"]]  -= v38;
  dsdt[_met_id_to_index["P2NADPH"]] += v38;
}


