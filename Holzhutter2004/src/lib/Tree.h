
#ifndef __Holzhutter2004__Tree__
#define __Holzhutter2004__Tree__

#include <iostream>
#include <vector>
#include <unordered_map>
#include <cmath>
#include <fstream>
#include <sstream>
#include <cstring>
#include <stdlib.h>
#include <assert.h>

#include "Macros.h"
#include "Enums.h"
#include "Structs.h"
#include "Parameters.h"
#include "Individual.h"
#include "Node.h"


class Tree
{
  
public:
  
  /*----------------------------
   * CONSTRUCTORS
   *----------------------------*/
  Tree( void ) = delete;
  Tree( Parameters* parameters );
  Tree( const Tree& tree ) = delete;
  
  /*----------------------------
   * DESTRUCTORS
   *----------------------------*/
  ~Tree( void );
  
  /*----------------------------
   * GETTERS
   *----------------------------*/
  inline int   get_number_of_nodes( void ) const;
  inline Node* get_node( unsigned long long int identifier );
  inline Node* get_first_node( void );
  inline Node* get_next_node( void );
  inline Node* get_best_alive_node( void );
  
  /*----------------------------
   * SETTERS
   *----------------------------*/
  Tree& operator=(const Tree&) = delete;
  
  /*----------------------------
   * PUBLIC METHODS
   *----------------------------*/
  void add_root( Individual* individual );
  void set_dead( unsigned long long int node_identifier );
  void add_reproduction_event( Individual* individual );
  void delete_node( unsigned long long int node_identifier );
  void prune();
  void compute_best_evolution_rate( std::string filename );
  void compute_mean_evolution_rate( std::string filename );
  void recover_best_fixed_mutations( std::string filename );
  
  /*----------------------------
   * PUBLIC ATTRIBUTES
   *----------------------------*/
  
protected:
  
  /*----------------------------
   * PROTECTED METHODS
   *----------------------------*/
  inline void tag_tree();
  inline void untag_tree();
  void        tag_offspring( Node* node, std::vector<Node*>* tagged_nodes );
  void        create_fixed_param_to_index_map( void );
  void        create_mutable_param_to_index_map( void );
  void        create_met_to_index_map( void );
  
  /*----------------------------
   * PROTECTED ATTRIBUTES
   *----------------------------*/
  Parameters*                                                 _parameters; /*!< Main parameters   */
  std::unordered_map<unsigned long long int, Node*>           _node_map;   /*!< Tree nodes map    */
  std::unordered_map<unsigned long long int, Node*>::iterator _iterator;   /*!< Tree map iterator */
  
  std::unordered_map<std::string, int> _fixed_param_to_index;   /*!< Fixed parameter to index map */
  std::unordered_map<std::string, int> _mutable_param_to_index; /*!< Fixed parameter to index map */
  std::unordered_map<std::string, int> _met_to_index;           /*!< Metabolite to index map      */
  
};


/*----------------------------
 * GETTERS
 *----------------------------*/

/**
 * \brief    Get the number of nodes of the tree
 * \details  --
 * \param    void
 * \return   \e int
 */
inline int Tree::get_number_of_nodes( void ) const
{
  return (int)_node_map.size();
}

/**
 * \brief    Get the node by its identifier
 * \details  Return NULL if the node do not exist
 * \param    unsigned long long int identifier
 * \return   \e Node*
 */
inline Node* Tree::get_node( unsigned long long int identifier )
{
  if (_node_map.find(identifier) != _node_map.end())
  {
    return _node_map[identifier];
  }
  return NULL;
}

/**
 * \brief    Get the first node of the map
 * \details  Return NULL if the tree is empty
 * \param    void
 * \return   \e Node*
 */
inline Node* Tree::get_first_node( void )
{
  _iterator = _node_map.begin();
  if (_iterator != _node_map.end())
  {
    return _iterator->second;
  }
  return NULL;
}

/**
 * \brief    Get the next node
 * \details  Return NULL if the end of the tree is reached
 * \param    void
 * \return   \e Node*
 */
inline Node* Tree::get_next_node( void )
{
  _iterator++;
  if (_iterator != _node_map.end())
  {
    return _iterator->second;
  }
  return NULL;
}

/**
 * \brief    Get best alive node
 * \details  --
 * \param    void
 * \return   \e Node*
 */
inline Node* Tree::get_best_alive_node( void )
{
  double best_w    = 0.0;
  Node*  best_node = NULL;
  for (_iterator = _node_map.begin(); _iterator != _node_map.end(); ++_iterator)
  {
    if (_iterator->second->isAlive())
    {
      if (best_w < _iterator->second->get_individual()->get_w())
      {
        best_w    = _iterator->second->get_individual()->get_w();
        best_node = _iterator->second;
      }
    }
  }
  return best_node;
}

/*----------------------------
 * SETTERS
 *----------------------------*/

/*----------------------------
 * PROTECTED METHODS
 *----------------------------*/

/**
 * \brief    Tag all the nodes
 * \details  --
 * \param    void
 * \return   \e void
 */
inline void Tree::tag_tree()
{
  for (_iterator = _node_map.begin(); _iterator != _node_map.end(); ++_iterator)
  {
    _iterator->second->tag();
  }
}

/**
 * \brief    Untag all the nodes
 * \details  --
 * \param    void
 * \return   \e void
 */
inline void Tree::untag_tree()
{
  for (_iterator = _node_map.begin(); _iterator != _node_map.end(); ++_iterator)
  {
    _iterator->second->untag();
  }
}


#endif /* defined(__Holzhutter2004__Tree__) */
