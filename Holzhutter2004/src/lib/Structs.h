
#ifndef __Holzhutter2004__Structs__
#define __Holzhutter2004__Structs__

#include <iostream>
#include <vector>
#include <cstring>
#include <stdlib.h>
#include <assert.h>

#include "Macros.h"
#include "Enums.h"


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


#endif /* defined(__Holzhutter2004__Structs__) */
