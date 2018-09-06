
#ifndef __Holzhutter2004__Enums__
#define __Holzhutter2004__Enums__

#include <iostream>
#include <cstring>
#include <stdlib.h>
#include <assert.h>


/******************************************************************************/

/**
 * \brief   Node class
 * \details Defines the class of a node in the tree (master root, root or normal).
 */
enum node_class
{
  MASTER_ROOT = 1, /*!< The node is the master root */
  ROOT        = 2, /*!< The node is a root          */
  NORMAL      = 3  /*!< The node is normal          */
};

/******************************************************************************/

/**
 * \brief   Node state
 * \details Defines the state of a node in the tree, depending on cell's status (dead or alive).
 */
enum node_state
{
  DEAD  = 1, /*!< The cell is dead  */
  ALIVE = 2  /*!< The cell is alive */
};


#endif /* defined(__ComplexMetabolicNetwork__Enums__) */
