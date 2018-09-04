
#include "Node.h"


/*----------------------------
 * CONSTRUCTORS
 *----------------------------*/

/**
 * \brief    Constructor
 * \details  --
 * \param    unsigned long long int identifier
 * \param    int generation
 * \return   \e void
 */
Node::Node( unsigned long long int identifier, int generation )
{
  assert(generation >= 0);
  _identifier = identifier;
  _generation = generation;
  _individual = NULL;
  _parent     = NULL;
  _children.clear();
  _node_class = MASTER_ROOT;
  _node_state = DEAD;
  _tagged     = false;
}

/**
 * \brief    Alive node constructor
 * \details  --
 * \param    Individual* individual
 * \return   \e void
 */
Node::Node( Individual* individual )
{
  _identifier = individual->get_identifier();
  _generation = individual->get_generation();
  _individual = new Individual(*individual);
  _individual->prepare_for_tree();
  _parent     = NULL;
  _children.clear();
  _node_class = NORMAL;
  _node_state = ALIVE;
  _tagged     = false;
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
Node::~Node( void )
{
  delete _individual;
  _individual = NULL;
  _children.clear();
}

/*----------------------------
 * PUBLIC METHODS
 *----------------------------*/

/**
 * \brief    Add a child
 * \details  --
 * \param    Node* node
 * \return   \e void
 */
void Node::add_child( Node* node )
{
  for (int i = 0; i < (int)_children.size(); i++)
  {
    assert(node->get_identifier() != _children[i]->get_identifier());
  }
  _children.push_back(node);
}

/**
 * \brief    Remove a child
 * \details  --
 * \param    Node* node
 * \return   \e void
 */
void Node::remove_child( Node* node )
{
  int pos = -1;
  for (int i = 0; i < (int)_children.size(); i++)
  {
    if (node->get_identifier() == _children[i]->get_identifier() && pos == -1)
    {
      pos = (int)i;
    }
    else if (node->get_identifier() == _children[i]->get_identifier() && pos >= 0)
    {
      printf("Error in Node::remove_child(): multiple occurences of a node in children list. Exit.\n");
      exit(EXIT_FAILURE);
    }
  }
  if (pos == -1)
  {
    printf("Error in Node::remove_child(): node to remove do not exist. Exit.\n");
    exit(EXIT_FAILURE);
  }
  else
  {
    _children.erase(_children.begin()+pos);
  }
}

/**
 * \brief    Replace this child by its own children
 * \details  --
 * \param    Node* node_to_remove
 * \return   \e void
 */
void Node::replace_children( Node* child_to_remove )
{
  /*---------------------------------------*/
  /* 1) remove the node from children list */
  /*---------------------------------------*/
  remove_child(child_to_remove);
  
  /*---------------------------------------*/
  /* 2) add children to the children list  */
  /*---------------------------------------*/
  for (int i = 0; i < child_to_remove->get_number_of_children(); i++)
  {
    add_child(child_to_remove->get_child(i));
  }
}

/**
 * \brief    Tag the lineage of this node
 * \details  --
 * \param    void
 * \return   \e void
 */
void Node::tag_lineage( void )
{
  _tagged = true;
  Node* node = _parent;
  while (node != NULL)
  {
    node->tag();
    node = node->get_parent();
    if (node != NULL)
    {
      if (node->isTagged())
      {
        node = NULL;
      }
    }
  }
}

/**
 * \brief    Untag the lineage of this node
 * \details  --
 * \param    void
 * \return   \e void
 */
void Node::untag_lineage( void )
{
  _tagged = false;
  Node* node = _parent;
  while (node != NULL)
  {
    node->untag();
    node = node->get_parent();
    if (node != NULL)
    {
      if (!node->isTagged())
      {
        node = NULL;
      }
    }
  }
}

/**
 * \brief    Compute the evolution rate of the lineage
 * \details  --
 * \param    double* nbfix
 * \param    double* evolrate
 * \return   \e void
 */
void Node::compute_evolution_rate( double* nbfix, double* evolrate )
{
  assert(nbfix != NULL);
  assert(evolrate != NULL);
  /*--------------------------------*/
  /* 1) Initialize variables        */
  /*--------------------------------*/
  int     m    = _individual->get_m();
  double* mean = new double[m];
  double* var  = new double[m];
  for (int i = 0; i < m; i++)
  {
    mean[i]     = 0.0;
    var[i]      = 0.0;
    nbfix[i]    = 0.0;
    evolrate[i] = 0.0;
  }
  Node* ancestor = get_ancestor();
  assert(ancestor != NULL);
  assert(ancestor->isRoot());
  double* ancestor_s = ancestor->get_individual()->get_s();
  
  /*--------------------------------*/
  /* 2) Evaluate mutational history */
  /*--------------------------------*/
  Node* node   = this;
  Node* parent = node->get_parent();
  while (parent != NULL && !parent->isMasterRoot())
  {
    bool    mutated  = node->get_individual()->isMutated();
    double* node_s   = node->get_individual()->get_s();
    double* parent_s = parent->get_individual()->get_s();
    for (int i = 0; i < m; i++)
    {
      double diff1 = fabs(node_s[i]-parent_s[i])/parent_s[i];
      double diff2 = fabs(node_s[i]-parent_s[i])/ancestor_s[i];
      if (mutated && diff1 > STEADY_STATE_DIFF_TH)
      {
        nbfix[i] += 1.0;
        mean[i]  += diff2;
        var[i]   += diff2*diff2;
      }
    }
    node   = parent;
    parent = node->get_parent();
  }
  /*--------------------------------*/
  /* 3) Compute the evolution rate  */
  /*--------------------------------*/
  for (int i = 0; i < m; i++)
  {
    if (nbfix[i] > 0.0)
    {
      mean[i] /= nbfix[i];
      var[i]  /= nbfix[i];
      var[i]  -= mean[i]*mean[i];
      evolrate[i] = var[i]/(double)_generation;
    }
  }
  
  /*--------------------------------*/
  /* 4) Free the memory             */
  /*--------------------------------*/
  delete[] mean;
  mean = NULL;
  delete[] var;
  var = NULL;
}

/**
 * \brief    Recover fixed mutations and save them in a file
 * \details  --
 * \param    std::string filename
 * \param    std::unordered_map<std::string, int>* mutable_param_to_index
 * \return   \e void
 */
void Node::recover_fixed_mutations( std::string filename, std::unordered_map<std::string, int>* mutable_param_to_index )
{
  Node* node     = this;
  Node* parent   = node->get_parent();
  Node* ancestor = get_ancestor();
  assert(ancestor != NULL);
  assert(ancestor->isRoot());
  double* ancestor_mutable_params = ancestor->get_individual()->get_mutable_params();
  std::ofstream file(filename, std::ios::out | std::ios::trunc);
  file << "g param size relative_size ancestor_relative_size diff_c\n";
  while (parent != NULL && !parent->isMasterRoot())
  {
    int     generation            = node->get_generation();
    bool    mutated               = node->get_individual()->isMutated();
    double* node_mutable_params   = node->get_individual()->get_mutable_params();
    double* parent_mutable_params = parent->get_individual()->get_mutable_params();
    if (mutated)
    {
      for (std::unordered_map<std::string, int>::iterator it = mutable_param_to_index->begin(); it != mutable_param_to_index->end(); ++it)
      {
        if (node_mutable_params[it->second] != parent_mutable_params[it->second])
        {
          double diff = node_mutable_params[it->second]-parent_mutable_params[it->second];
          double rel_diff = (node_mutable_params[it->second]-parent_mutable_params[it->second])/parent_mutable_params[it->second];
          double ancestor_diff = (node_mutable_params[it->second]-parent_mutable_params[it->second])/ancestor_mutable_params[it->second];
          double diff_c = node->get_individual()->get_c()-parent->get_individual()->get_c();
          file << generation << " " << it->first << " " << diff << " " << rel_diff << " " << ancestor_diff << " " << diff_c << "\n";
        }
      }
    }
    node   = parent;
    parent = node->get_parent();
  }
  file.close();
}

/*----------------------------
 * PROTECTED METHODS
 *----------------------------*/

