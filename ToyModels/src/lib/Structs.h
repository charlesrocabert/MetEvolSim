
#ifndef __ComplexMetabolicNetwork__Structs__
#define __ComplexMetabolicNetwork__Structs__

#include <iostream>
#include <assert.h>
#include <vector>

#include "Macros.h"
#include "Enums.h"


/******************************************************************************/

/**
 * \brief   Reaction list struct
 * \details Contains the list of metabolic reactions
 */
typedef struct
{
  std::vector<int>           s;      /*!< substrate index         */
  std::vector<int>           p;      /*!< Product index           */
  std::vector<reaction_type> type;   /*!< Reaction type           */
  std::vector<double>        km_f;   /*!< Forward KM constants    */
  std::vector<double>        vmax_f; /*!< Forward Vmax constants  */
  std::vector<double>        km_b;   /*!< Backward KM constants   */
  std::vector<double>        vmax_b; /*!< Backward Vmax constants */
  int                        m;      /*!< Number of metabolites   */
  int                        r;      /*!< Number of reactions     */
} reaction_list;

/******************************************************************************/

/**
 * \brief   Mutation struct
 * \details --
 */
typedef struct
{
  int    pos;       /*!< Position of the mutation */
  double old_value; /*!< Old concentration value  */
  double new_value; /*!< New concentration value  */
  
} mutation;

/******************************************************************************/


#endif /* defined(__ComplexMetabolicNetwork__Structs__) */
