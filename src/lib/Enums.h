
#ifndef __ComplexMetabolicNetwork__Enums__
#define __ComplexMetabolicNetwork__Enums__

#include <iostream>
#include <assert.h>


/******************************************************************************/

/**
 * \brief   Structure of metabolic network
 * \details --
 */
enum network_struct
{
  LINEAR_PATHWAY     = 0, /*!< Linear pathway         */
  RANDOM_NETWORK     = 1, /*!< Random network         */
  SCALE_FREE_NETWORK = 2, /*!< Scale-free network     */
  LOAD_MODEL         = 3  /*!< Load a model from file */
};

/******************************************************************************/

/**
 * \brief   Type of reaction
 * \details --
 */
enum reaction_type
{
  NO_REACTION           = 0, /*!< No reaction           */
  INFLOWING_REACTION    = 1, /*!< Inflowing reaction    */
  OUTFLOWING_REACTION   = 2, /*!< Outflowing reaction   */
  IRREVERSIBLE_REACTION = 3, /*!< Irreversible reaction */
  REVERSIBLE_REACTION   = 4  /*!< Reversible reaction   */
};

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
