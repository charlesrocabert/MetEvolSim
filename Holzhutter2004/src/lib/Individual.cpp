
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
  
  _m = 40;
  _p = 171;
  create_met_id_to_index_map();
  create_params_id_to_index_map();
  initialize_concentrations();
  initialize_parameters();
  
  /*----------------------------------------------------- PHENOTYPE */
  
  _mutated = false;
  _s       = NULL;
  _old_s   = NULL;
  _s       = new double[_m];
  _old_s   = new double[_m];
  initialize_concentration_vector();
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

  _m = 40;
  _p = 171;
  create_met_id_to_index_map();
  create_params_id_to_index_map();
  memcpy(_initial_s, individual._initial_s, sizeof(double)*_m);
  memcpy(_initial_params, individual._initial_params, sizeof(double)*_p);
  
  /*----------------------------------------------------- PHENOTYPE */
  
  _mutated = individual._mutated;
  _s       = NULL;
  _old_s   = NULL;
  _s       = new double[_m];
  _old_s   = new double[_m];
  memcpy(_s, individual._s, sizeof(double)*_m);
  memcpy(_old_s, individual._old_s, sizeof(double)*_m);
  _c     = individual._c;
  _old_c = individual._old_c;
  _c_opt = individual._c_opt;
  _w     = individual._w;
  
  /*----------------------------------------------------- ODE SOLVER */
  
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
    /* TODO */
  }
  
  /*----------------------------------------------------- PHENOTYPE */
  
  delete[] _s;
  _s = NULL;
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
 * \brief    Initialize concentration values
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::initialize_concentrations( void )
{
  assert(_initial_s == NULL);
  _initial_s = new double[_m];
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
 * \brief    Initialize parameter values
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::initialize_parameters( void )
{
  assert(_initial_params == NULL);
  _initial_params = new double[_p];
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
 * \brief    Initialize the concentration vector
 * \details  --
 * \param    void
 * \return   \e void
 */
void Individual::initialize_concentration_vector( void )
{
  memcpy(_s, _initial_s, sizeof(double)*_m);
}

