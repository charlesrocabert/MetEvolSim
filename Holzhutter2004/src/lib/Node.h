
#ifndef __Holzhutter2004__Node__
#define __Holzhutter2004__Node__

#include <iostream>
#include <vector>
#include <assert.h>

#include "Macros.h"
#include "Enums.h"
#include "Structs.h"
#include "Individual.h"


class Node
{
  
public:
  
  /*----------------------------
   * CONSTRUCTORS
   *----------------------------*/
  Node( void ) = delete;
  Node( unsigned long long int identifier, int generation );
  Node( Individual* individual );
  Node( const Node& node ) = delete;
  
  /*----------------------------
   * DESTRUCTORS
   *----------------------------*/
  ~Node( void );
  
  /*----------------------------
   * GETTERS
   *----------------------------*/
  inline unsigned long long int get_identifier( void ) const;
  inline int                    get_generation( void ) const;
  inline Individual*            get_individual( void );
  inline Node*                  get_parent( void );
  inline Node*                  get_ancestor( void );
  inline Node*                  get_child( int pos );
  inline int                    get_number_of_children( void ) const;
  inline node_class             get_node_class( void ) const;
  inline node_state             get_node_state( void ) const;
  inline bool                   isTagged( void ) const;
  inline bool                   isMasterRoot( void ) const;
  inline bool                   isRoot( void ) const;
  inline bool                   isNormal( void ) const;
  inline bool                   isDead( void ) const;
  inline bool                   isAlive( void ) const;
  inline bool                   isAncestor( unsigned long long int ancestor_id );
  
  /*----------------------------
   * SETTERS
   *----------------------------*/
  Node& operator=(const Node&) = delete;
  
  inline void set_parent( Node* node );
  inline void tag( void );
  inline void untag( void );
  inline void set_root( void );
  inline void set_normal( void );
  inline void set_dead( void );
  inline void set_alive( void );
  
  /*----------------------------
   * PUBLIC METHODS
   *----------------------------*/
  void add_child( Node* node );
  void remove_child( Node* node );
  void replace_children( Node* child_to_remove );
  void tag_lineage( void );
  void untag_lineage( void );
  void compute_evolution_rate( double* nbfix, double* evolrate );
  
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
  unsigned long long int _identifier; /*!< Node's identifier                        */
  int                    _generation; /*!< Node's generation                        */
  Individual*            _individual; /*!< Individual                               */
  Node*                  _parent;     /*!< Parent of the node                       */
  std::vector<Node*>     _children;   /*!< Children of the node                     */
  node_class             _node_class; /*!< Node class (master root, root or normal) */
  node_state             _node_state; /*!< Node state (dead or alive)               */
  bool                   _tagged;     /*!< Indicates if the node is tagged          */
};


/*----------------------------
 * GETTERS
 *----------------------------*/

/**
 * \brief    Get node identifier
 * \details  --
 * \param    void
 * \return   \e unsigned long long int
 */
inline unsigned long long int Node::get_identifier( void ) const
{
  return _identifier;
}

/**
 * \brief    Get node's generation
 * \details  --
 * \param    void
 * \return   \e int
 */
inline int Node::get_generation( void ) const
{
  return _generation;
}

/**
 * \brief    Get the individual
 * \details  --
 * \param    void
 * \return   \e Individual*
 */
inline Individual* Node::get_individual( void )
{
  return _individual;
}

/**
 * \brief    Get the parent node
 * \details  --
 * \param    void
 * \return   \e Node*
 */
inline Node* Node::get_parent( void )
{
  return _parent;
}

/**
 * \brief    Get the ancestor node
 * \details  --
 * \param    void
 * \return   \e Node*
 */
inline Node* Node::get_ancestor( void )
{
  Node* node = _parent;
  while (node != NULL && !node->isRoot())
  {
    node = node->get_parent();
  }
  if (node->isRoot())
  {
    return node;
  }
  return NULL;
}

/**
 * \brief    Get the child at position 'pos'
 * \details  --
 * \param    int pos
 * \return   \e Node*
 */
inline Node* Node::get_child( int pos )
{
  assert(pos < (int)_children.size());
  return _children[pos];
}

/**
 * \brief    Get the number of children
 * \details  --
 * \param    void
 * \return   \e int
 */
inline int Node::get_number_of_children( void ) const
{
  return (int)_children.size();
}

/**
 * \brief    Get the node class
 * \details  --
 * \param    void
 * \return   \e node_class
 */
inline node_class Node::get_node_class( void ) const
{
  return _node_class;
}

/**
 * \brief    Get the node state
 * \details  --
 * \param    void
 * \return   \e node_state
 */
inline node_state Node::get_node_state( void ) const
{
  return _node_state;
}

/**
 * \brief    Check if the node is tagged or not
 * \details  --
 * \param    void
 * \return   \e bool
 */
inline bool Node::isTagged( void ) const
{
  return _tagged;
}

/**
 * \brief    Check if the node is the master root
 * \details  --
 * \param    void
 * \return   \e bool
 */
inline bool Node::isMasterRoot( void ) const
{
  return (_node_class == MASTER_ROOT);
}

/**
 * \brief    Check if the node is a root or not
 * \details  --
 * \param    void
 * \return   \e bool
 */
inline bool Node::isRoot( void ) const
{
  return (_node_class == ROOT);
}

/**
 * \brief    Check if the node is normal or not
 * \details  --
 * \param    void
 * \return   \e bool
 */
inline bool Node::isNormal( void ) const
{
  return (_node_class == NORMAL);
}

/**
 * \brief    Check if the node is dead
 * \details  --
 * \param    void
 * \return   \e bool
 */
inline bool Node::isDead( void ) const
{
  return (_node_state == DEAD);
}

/**
 * \brief    Check if the node is alive
 * \details  --
 * \param    void
 * \return   \e bool
 */
inline bool Node::isAlive( void ) const
{
  return (_node_state == ALIVE);
}

/**
 * \brief    Check if the given identifier is an ancestor
 * \details  --
 * \param    unsigned long long int ancestor_id
 * \return   \e bool
 */
inline bool Node::isAncestor( unsigned long long int ancestor_id )
{
  Node* node = get_parent();
  while (node != NULL)
  {
    if (node->get_identifier() == ancestor_id)
    {
      return true;
    }
    node = node->get_parent();
  }
  return false;
}

/*----------------------------
 * SETTERS
 *----------------------------*/

/**
 * \brief    Add a parent
 * \details  --
 * \param    Node* node
 * \return   \e void
 */
inline void Node::set_parent( Node* node )
{
  _parent = node;
}

/**
 * \brief    Tag the node
 * \details  --
 * \param    void
 * \return   \e void
 */
inline void Node::tag( void )
{
  _tagged = true;
}

/**
 * \brief    Untag the node
 * \details  --
 * \param    void
 * \return   \e void
 */
inline void Node::untag( void )
{
  _tagged = false;
}

/**
 * \brief    Set the node class as root
 * \details  --
 * \param    void
 * \return   \e void
 */
inline void Node::set_root( void )
{
  _node_class = ROOT;
}

/**
 * \brief    Set the node class as normal
 * \details  --
 * \param    void
 * \return   \e void
 */
inline void Node::set_normal( void )
{
  _node_class = NORMAL;
}

/**
 * \brief    Set the node state dead
 * \details  --
 * \param    void
 * \return   \e void
 */
inline void Node::set_dead( void )
{
  _node_state = DEAD;
}


#endif /* defined(__Holzhutter2004__Node__) */
