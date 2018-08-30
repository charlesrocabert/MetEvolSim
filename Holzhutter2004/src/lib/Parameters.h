
#ifndef __Holzhutter2004__Parameters__
#define __Holzhutter2004__Parameters__

#include <iostream>
#include <fstream>
#include <assert.h>

#include "Macros.h"
#include "Enums.h"
#include "Structs.h"
#include "Prng.h"


class Parameters
{
  
public:
  
  /*----------------------------
   * CONSTRUCTORS
   *----------------------------*/
  Parameters( void );
  Parameters( const Parameters& parameters );
  
  /*----------------------------
   * DESTRUCTORS
   *----------------------------*/
  ~Parameters( void );
  
  /*----------------------------
   * GETTERS
   *----------------------------*/
  
  /*----------------------------------------------------- PRNG */
  
  inline Prng*             get_prng( void );
  inline unsigned long int get_seed( void ) const;
  
  /*----------------------------------------------------- POPULATION */
  
  inline int get_generations( void ) const;
  inline int get_n( void ) const;
  inline int get_m( void ) const;
  
  /*----------------------------------------------------- MUTATIONS */
  
  inline double get_sigma( void ) const;
  inline double get_mu( void ) const;
  
  /*----------------------------------------------------- FITNESS FUNCTION */
  
  inline double get_w( void ) const;
  inline double get_alpha( void ) const;
  inline double get_beta( void ) const;
  inline double get_Q( void ) const;
  
  /*----------------------------------------------------- PARALLEL COMPUTING */
  
  inline bool get_parallel_computing( void ) const;
  
  /*----------------------------
   * SETTERS
   *----------------------------*/
  Parameters& operator=(const Parameters&) = delete;
  
  /*----------------------------------------------------- PRNG */
  
  inline void set_seed( unsigned long int seed );
  
  /*----------------------------------------------------- POPULATION */
  
  inline void set_generations( int generations );
  inline void set_n( int n );
  inline void set_m( int m );
  
  /*----------------------------------------------------- MUTATIONS */
  
  inline void set_sigma( double sigma );
  inline void set_mu( double mu );
  
  /*----------------------------------------------------- FITNESS FUNCTION */
  
  inline void set_w( double w );
  inline void set_alpha( double alpha );
  inline void set_beta( double beta );
  inline void set_Q( double Q );
  
  /*----------------------------------------------------- PARALLEL COMPUTING */
  
  inline void set_parallel_computing( bool PC );
  
  /*----------------------------
   * PUBLIC METHODS
   *----------------------------*/
  void print_parameters( void );
  void save_parameters( void );
  
  /*----------------------------
   * PUBLIC ATTRIBUTES
   *----------------------------*/
  
protected:
  
  /*----------------------------
   * PROTECTED METHODS
   *----------------------------*/
  
  /*----------------------------
   * PROTECTED ATTRIBUTES
   *----------------------------*/
  
  /*----------------------------------------------------- PRNG */
  
  Prng*             _prng; /*!< Pseudorandom numbers generator (MT19937) */
  unsigned long int _seed; /*!< Seed of the prng                         */
  
  /*----------------------------------------------------- POPULATION */
  
  double _generations; /*!< Number of generations */
  double _n;           /*!< Population size       */
  double _m;           /*!< Number of metabolites */
  
  /*----------------------------------------------------- MUTATIONS */
  
  double _sigma; /*!< Sigma (mutation size) */
  double _mu;    /*!< Mu (mutation rate)    */
  
  /*----------------------------------------------------- FITNESS FUNCTION */
  
  double _w;     /*!< Fitness function width         */
  double _alpha; /*!< Alpha (fitness function shape) */
  double _beta;  /*!< Beta (fitness function shape)  */
  double _Q;     /*!< Q (fitness function shape)     */
  
  /*----------------------------------------------------- PARALLEL COMPUTING */
  
  bool _parallel_computing; /*!< Activate parallel computing */
  
};

/*----------------------------
 * GETTERS
 *----------------------------*/

/**
 * \brief    Get the pseudorandom numbers generator
 * \details  --
 * \param    void
 * \return   \e Prng*
 */
inline Prng* Parameters::get_prng( void )
{
  return _prng;
}

/**
 * \brief    Get the seed of the pseudorandom numbers generator
 * \details  --
 * \param    void
 * \return   \e unsigned long int
 */
inline unsigned long int Parameters::get_seed( void ) const
{
  return _seed;
}

/**
 * \brief    Get the number of generations
 * \details  --
 * \param    void
 * \return   \e int
 */
inline int Parameters::get_generations( void ) const
{
  return _generations;
}

/**
 * \brief    Get population size
 * \details  --
 * \param    void
 * \return   \e int
 */
inline int Parameters::get_n( void ) const
{
  return _n;
}

/**
 * \brief    Get the number of metabolites
 * \details  --
 * \param    void
 * \return   \e int
 */
inline int Parameters::get_m( void ) const
{
  return _m;
}

/**
 * \brief    Get sigma
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Parameters::get_sigma( void ) const
{
  return _sigma;
}

/**
 * \brief    Get mu
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Parameters::get_mu( void ) const
{
  return _mu;
}

/**
 * \brief    Get w
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Parameters::get_w( void ) const
{
  return _w;
}

/**
 * \brief    Get alpha
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Parameters::get_alpha( void ) const
{
  return _alpha;
}

/**
 * \brief    Get beta
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Parameters::get_beta( void ) const
{
  return _beta;
}

/**
 * \brief    Get Q
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Parameters::get_Q( void ) const
{
  return _Q;
}

/**
 * \brief    Get parallel computing boolean
 * \details  --
 * \param    void
 * \return   \e bool
 */
inline bool Parameters::get_parallel_computing( void ) const
{
  return _parallel_computing;
}

/*----------------------------
 * SETTERS
 *----------------------------*/

/**
 * \brief    Set the seed of the pseudorandom numbers generator
 * \details  --
 * \param    unsigned long int seed
 * \return   \e void
 */
inline void Parameters::set_seed( unsigned long int seed )
{
  assert(seed > 0);
  _seed = seed;
  delete _prng;
  _prng = NULL;
  _prng = new Prng(seed);
}

/**
 * \brief    Set the number of generations
 * \details  --
 * \param    int generations
 * \return   \e void
 */
inline void Parameters::set_generations( int generations )
{
  assert(generations > 0);
  _generations = generations;
}

/**
 * \brief    Set the population size
 * \details  --
 * \param    int n
 * \return   \e void
 */
inline void Parameters::set_n( int n )
{
  assert(n > 0);
  _n = n;
}

/**
 * \brief    Set the number of metabolites
 * \details  --
 * \param    int m
 * \return   \e voi
 */
inline void Parameters::set_m( int m )
{
  assert(m > 0);
  _m = m;
}

/**
 * \brief    Set sigma
 * \details  --
 * \param    double sigma
 * \return   \e void
 */
inline void Parameters::set_sigma( double sigma )
{
  assert(sigma > 0.0);
  _sigma = sigma;
}

/**
 * \brief    Set mu
 * \details  --
 * \param    double mu
 * \return   \e void
 */
inline void Parameters::set_mu( double mu )
{
  assert(mu >= 0.0);
  assert(mu <= 1.0);
  _mu = mu;
}

/**
 * \brief    Set w
 * \details  --
 * \param    double w
 * \return   \e void
 */
inline void Parameters::set_w( double w )
{
  assert(w > 0.0);
  _w = w;
}

/**
 * \brief    Set alpha
 * \details  --
 * \param    double alpha
 * \return   \e void
 */
inline void Parameters::set_alpha( double alpha )
{
  assert(alpha > 0.0);
  _alpha = alpha;
}

/**
 * \brief    Set beta
 * \details  --
 * \param    double beta
 * \return   \e void
 */
inline void Parameters::set_beta( double beta )
{
  assert(beta >= 0.0);
  assert(beta <= 1.0);
  _beta = beta;
}

/**
 * \brief    Set Q
 * \details  --
 * \param    double Q
 * \return   \e void
 */
inline void Parameters::set_Q( double Q )
{
  assert(Q >= 2.0);
  _Q = Q;
}

/**
 * \brief    Set parallel computing boolean
 * \details  --
 * \param    bool PC
 * \return   \e void
 */
inline void Parameters::set_parallel_computing( bool PC )
{
  _parallel_computing = PC;
}


#endif /* defined(__Holzhutter2004__Parameters__) */
