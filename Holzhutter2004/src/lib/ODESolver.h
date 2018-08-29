
#ifndef __ComplexMetabolicNetwork__ODESolver__
#define __ComplexMetabolicNetwork__ODESolver__

#include <iostream>
#include <cmath>
#include <cstring>
#include <assert.h>

#include "Macros.h"
#include "Enums.h"
#include "Structs.h"


class ODESolver
{
  
public:
  
  /*----------------------------
   * CONSTRUCTORS
   *----------------------------*/
  ODESolver( void ) = delete;
  ODESolver( reaction_list* list, double* s );
  ODESolver( const ODESolver& ode_solver ) = delete;
  
  /*----------------------------
   * DESTRUCTORS
   *----------------------------*/
  ~ODESolver( void );
  
  /*----------------------------
   * GETTERS
   *----------------------------*/
  
  /*----------------------------
   * SETTERS
   *----------------------------*/
  ODESolver& operator=(const ODESolver&) = delete;
  
  /*----------------------------
   * PUBLIC METHODS
   *----------------------------*/
  void solve( double& dt, double& t, double timestep );
  void ODE_system( const double* s, double* dsdt, reaction_list* list );
  
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
  
  reaction_list* _reaction_list; /*!< List of reactions    */
  double*        _s;             /*!< Concentration vector */
  
};


/*----------------------------
 * GETTERS
 *----------------------------*/

/*----------------------------
 * SETTERS
 *----------------------------*/


#endif /* defined(__ComplexMetabolicNetwork__ODESolver__) */
