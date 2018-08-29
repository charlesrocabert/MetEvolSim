
#ifndef __Holzhutter2004__Prng__
#define __Holzhutter2004__Prng__

#include <iostream>
#include <assert.h>
#include <cmath>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>


class Prng
{
  
public:
  
  /*----------------------------
   * CONSTRUCTORS
   *----------------------------*/
  Prng( void );
  Prng( unsigned long int seed );
  Prng( const Prng& prng );
  
  /*----------------------------
   * DESTRUCTORS
   *----------------------------*/
  ~Prng( void );
  
  /*----------------------------
   * GETTERS
   *----------------------------*/
  
  /*----------------------------
   * SETTERS
   *----------------------------*/
  Prng& operator=(const Prng&) = delete;
  
  inline void set_seed( unsigned long int seed );
  
  /*----------------------------
   * PUBLIC METHODS
   *----------------------------*/
  double uniform( void );
  int    uniform( int min, int max );
  int    bernouilli( double p );
  int    binomial( int n, double p );
  void   multinomial( unsigned int* draws, double* probas, int N, int K );
  double gaussian( double mu, double sigma );
  double lognormal( double mu, double sigma );
  int    exponential( double mu );
  int    poisson( double lambda );
  int    roulette_wheel( double* probas, double sum, int N );
  
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
  gsl_rng* _prng; /*!< Pseudorandom numbers generator */
  
};


/*----------------------------
 * GETTERS
 *----------------------------*/

/*----------------------------
 * SETTERS
 *----------------------------*/

/**
 * \brief    Set prng seed
 * \details  --
 * \param    unsigned long int seed
 * \return   \e double
 */
inline void Prng::set_seed( unsigned long int seed )
{
  gsl_rng_set(_prng, seed);
}


#endif /* defined(__Holzhutter2004__Prng__) */
