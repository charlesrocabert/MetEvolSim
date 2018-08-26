
#include "ODESolver.h"


/*----------------------------
 * CONSTRUCTORS
 *----------------------------*/

/**
 * \brief    Constructor
 * \details  --
 * \param    reaction_list* list
 * \param    double* s
 * \return   \e void
 */
ODESolver::ODESolver( reaction_list* list, double* s )
{
  assert(list != NULL);
  assert(s != NULL);
  _reaction_list = list;
  _s             = s;
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
ODESolver::~ODESolver( void )
{
  _reaction_list = NULL;
  _s             = NULL;
}

/*----------------------------
 * PUBLIC METHODS
 *----------------------------*/

/**
 * \brief    Solve the ODE system for one timestep
 * \details  --
 * \param    double& dt
 * \param    double& t
 * \param    double timestep
 * \return   \e double
 */
void ODESolver::solve( double& dt, double& t, double timestep )
{
  int     m    = _reaction_list->m;
  double* DSDT = new double[m];
  double* OLDS = new double[m];
  double  Tend = t+timestep;
  while (t < Tend)
  {
    /*---------------------------------------*/
    /* 1) Save previous state                */
    /*---------------------------------------*/
    memcpy(OLDS, _s, sizeof(double)*m);
    
    /*---------------------------------------*/
    /* 2) Compute next state with current dt */
    /*---------------------------------------*/
    ODE_system(_s, DSDT, _reaction_list);
    for (int i = 0; i < m; i++)
    {
      _s[i] += DSDT[i]*dt;
    }
    
    /*---------------------------------------*/
    /* 3) Check solving consistency          */
    /*---------------------------------------*/
    
    /*** Evaluate the concentration vector ***/
    bool decrease_h = false;
    for (int i = 0; i < m; i++)
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
      memcpy(_s, OLDS, sizeof(double)*m);
      dt /= 2.0;
    }
    else
    {
      t += dt;
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
 * \param    reaction_list* list
 * \return   \e void
 */
void ODESolver::ODE_system( const double* s, double* dsdt, reaction_list* list )
{
  /*----------------------------*/
  /* 1) Initialize variables    */
  /*----------------------------*/
  int                         nb_met        = list->m;
  int                         nb_reactions  = list->r;
  std::vector<int>&           substrate     = list->s;
  std::vector<int>&           product       = list->p;
  std::vector<reaction_type>& reaction_type = list->type;
  std::vector<double>&        km_f          = list->km_f;
  std::vector<double>&        vmax_f        = list->vmax_f;
  std::vector<double>&        km_b          = list->km_b;
  std::vector<double>&        vmax_b        = list->vmax_b;
  
  /*----------------------------*/
  /* 2) Initialize dy/dt vector */
  /*----------------------------*/
  for (int i = 0; i < nb_met; i++)
  {
    dsdt[i] = 0.0;
  }
  
  /*----------------------------*/
  /* 3) Apply reaction rules    */
  /*----------------------------*/
  for (int i = 0; i < nb_reactions; i++)
  {
    /*** Inflowing reaction ***/
    if (reaction_type[i] == INFLOWING_REACTION)
    {
      double ds         = INFLUX;
      dsdt[product[i]] += ds;
    }
    /*** Outflowing reaction ***/
    else if (reaction_type[i] == OUTFLOWING_REACTION)
    {
      double ds           = (vmax_f[i]*s[substrate[i]])/(km_f[i]+s[substrate[i]]);
      dsdt[substrate[i]] -= ds;
    }
    /*** Irreversible reaction ***/
    else if (reaction_type[i] == IRREVERSIBLE_REACTION)
    {
      double ds           = (vmax_f[i]*s[substrate[i]])/(km_f[i]+s[substrate[i]]);
      dsdt[substrate[i]] -= ds;
      dsdt[product[i]]   += ds;
    }
    /*** Reversible reaction ***/
    else if (reaction_type[i] == REVERSIBLE_REACTION)
    {
      double ds           = ( vmax_f[i]*s[substrate[i]]/km_f[i] - vmax_b[i]*s[product[i]]/km_b[i] )/( 1.0 + s[substrate[i]]/km_f[i] + s[product[i]]/km_b[i] );
      dsdt[substrate[i]] -= ds;
      dsdt[product[i]]   += ds;
    }
  }
}

/*----------------------------
 * PROTECTED METHODS
 *----------------------------*/

