
#include "Tree.h"


/*----------------------------
 * CONSTRUCTORS
 *----------------------------*/

/**
 * \brief    Constructor
 * \details  The tree starts with one node called the master root
 * \param    Parameters* parameters
 * \return   \e void
 */
Tree::Tree( Parameters* parameters )
{
  assert(parameters != NULL);
  _parameters = parameters;
  _node_map.clear();
  _iterator         = _node_map.begin();
  Node* master_root = new Node(0, 0);
  _node_map[0]      = master_root;
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
Tree::~Tree( void )
{
  _parameters = NULL;
  _iterator   = _node_map.begin();
  for (_iterator = _node_map.begin(); _iterator != _node_map.end(); ++_iterator)
  {
    delete _iterator->second;
    _iterator->second = NULL;
  }
  _node_map.clear();
}

/*----------------------------
 * PUBLIC METHODS
 *----------------------------*/

/**
 * \brief    Add a root to the tree
 * \details  --
 * \param    Individual* individual
 * \return   \e void
 */
void Tree::add_root( Individual* individual )
{
  /*-----------------------------*/
  /* 1) Get the master root      */
  /*-----------------------------*/
  Node* master_root = _node_map[0];
  
  /*-----------------------------*/
  /* 2) Create the node          */
  /*-----------------------------*/
  Node* node = new Node(individual);
  
  /*-----------------------------*/
  /* 3) Update nodes attributes  */
  /*-----------------------------*/
  node->set_root();
  node->set_parent(master_root);
  master_root->add_child(node);
  
  /*-----------------------------*/
  /* 4) Add the node to the tree */
  /*-----------------------------*/
  assert(_node_map.find(node->get_identifier()) == _node_map.end());
  _node_map[node->get_identifier()] = node;
}


/**
 * \brief    Set the node dead
 * \details  --
 * \param    unsigned long long int node_identifier
 * \return   \e void
 */
void Tree::set_dead( unsigned long long int node_identifier )
{
  assert(_node_map.find(node_identifier) != _node_map.end());
  _node_map[node_identifier]->set_dead();
}

/**
 * \brief    Add a reproduction event
 * \details  --
 * \param    Individual* parent
 * \param    Individual* child
 * \return   \e void
 */
void Tree::add_reproduction_event( Individual* individual )
{
  /*---------------------------------*/
  /* 1) Get parental node            */
  /*---------------------------------*/
  assert(_node_map.find(individual->get_parent()) != _node_map.end());
  Node* parent_node = _node_map[individual->get_parent()];
  
  /*---------------------------------*/
  /* 2) Create child node            */
  /*---------------------------------*/
  Node* child_node = new Node(individual);
  
  /*---------------------------------*/
  /* 3) Update child node attributes */
  /*---------------------------------*/
  child_node->set_parent(parent_node);
  parent_node->add_child(child_node);
  
  /*---------------------------------*/
  /* 4) Add child node to the tree   */
  /*---------------------------------*/
  _node_map[child_node->get_identifier()] = child_node;
}

/**
 * \brief    Delete a node and remove all links
 * \details  --
 * \param    unsigned long long int node_identifier
 * \return   \e void
 */
void Tree::delete_node( unsigned long long int node_identifier )
{
  assert(_node_map.find(node_identifier) != _node_map.end());
  Node* node = _node_map[node_identifier];
  assert(node->get_identifier() == node_identifier);
  assert(!node->isAlive());
  
  /*----------------------------------*/
  /* 1) Update parental children list */
  /*----------------------------------*/
  node->get_parent()->replace_children(node);
  
  /*-----------------------------------*/
  /* 2) Set the new parent of children */
  /*-----------------------------------*/
  for (int i = 0; i < node->get_parent()->get_number_of_children(); i++)
  {
    node->get_parent()->get_child(i)->set_parent(node->get_parent());
  }
  
  /*----------------------------------*/
  /* 3) Delete node                   */
  /*----------------------------------*/
  delete _node_map[node_identifier];
  _node_map[node_identifier] = NULL;
  _node_map.erase(node_identifier);
}

/**
 * \brief    Prune the tree
 * \details  Remove all dead branches
 * \param    void
 * \return   \e void
 */
void Tree::prune()
{
  untag_tree();
  
  /*-------------------------------------*/
  /* 1) Tag alive cells lineage          */
  /*-------------------------------------*/
  for (_iterator = _node_map.begin(); _iterator != _node_map.end(); ++_iterator)
  {
    assert(_iterator->first == _iterator->second->get_identifier());
    if (_iterator->second->isAlive())
    {
      _iterator->second->tag_lineage();
    }
  }
  
  /*-------------------------------------*/
  /* 2) Build the list of untagged nodes */
  /*-------------------------------------*/
  std::vector<unsigned long long int> remove_list;
  for (_iterator = _node_map.begin(); _iterator != _node_map.end(); ++_iterator)
  {
    if (!_iterator->second->isTagged() && !_iterator->second->isMasterRoot())
    {
      remove_list.push_back(_iterator->first);
    }
  }
  
  /*-------------------------------------*/
  /* 3) Delete untagged nodes            */
  /*-------------------------------------*/
  for (size_t i = 0; i < remove_list.size(); i++)
  {
    delete_node(remove_list[i]);
  }
  remove_list.clear();
  
  /*-------------------------------------*/
  /* 4) Set master root children as root */
  /*-------------------------------------*/
  Node* master_root = _node_map[0];
  for (int i = 0; i < master_root->get_number_of_children(); i++)
  {
    master_root->get_child(i)->set_root();
  }
}

/**
 * \brief    Compute the best evolution rate
 * \details  Data is written in a text file
 * \param    std::string filename
 * \return   \e void
 */
void Tree::compute_best_evolution_rate( std::string filename )
{
  double* nbfix    = new double[_parameters->get_m()];
  double* evolrate = new double[_parameters->get_m()];
  Node*   best     = get_best_alive_node();
  double* best_s   = best->get_individual()->get_s();
  best->compute_evolution_rate(nbfix, evolrate);
  std::ofstream file(filename, std::ios::out | std::ios::trunc);
  file << "s nbfix evolrate\n";
  for (int i = 0; i < _parameters->get_m(); i++)
  {
    file << best_s[i] << " " << nbfix[i] << " " << evolrate[i] << "\n";
  }
  file.close();
  delete[] nbfix;
  nbfix = NULL;
  delete[] evolrate;
  evolrate = NULL;
}

/**
 * \brief    Compute the mean evolution rate
 * \details  Data is written in a text file
 * \param    std::string filename
 * \return   \e void
 */
void Tree::compute_mean_evolution_rate( std::string filename )
{
  double* mean_s        = new double[_parameters->get_m()];
  double* mean_nbfix    = new double[_parameters->get_m()];
  double* mean_evolrate = new double[_parameters->get_m()];
  double  counter       = 0.0;
  double  sum_w         = 0.0;
  for (int i = 0; i < _parameters->get_m(); i++)
  {
    mean_s[i]        = 0.0;
    mean_nbfix[i]    = 0.0;
    mean_evolrate[i] = 0.0;
  }
  for (_iterator = _node_map.begin(); _iterator != _node_map.end(); ++_iterator)
  {
    Node* node = _iterator->second;
    if (node->isAlive())
    {
      double  w        = node->get_individual()->get_w();
      double* s        = node->get_individual()->get_s();
      double* nbfix    = new double[_parameters->get_m()];
      double* evolrate = new double[_parameters->get_m()];
      node->compute_evolution_rate(nbfix, evolrate);
      for (int i = 0; i < _parameters->get_m(); i++)
      {
        mean_s[i]        += s[i];
        mean_nbfix[i]    += nbfix[i];
        mean_evolrate[i] += evolrate[i];
      }
      sum_w += w;
      delete[] nbfix;
      nbfix = NULL;
      delete[] evolrate;
      evolrate = NULL;
      counter += 1.0;
    }
  }
  for (int i = 0; i < _parameters->get_m(); i++)
  {
    mean_s[i]        /= counter;
    mean_nbfix[i]    /= counter;
    mean_evolrate[i] /= counter;
  }
  std::ofstream file(filename, std::ios::out | std::ios::trunc);
  file << "s nbfix evolrate\n";
  for (int i = 0; i < _parameters->get_m(); i++)
  {
    file << mean_s[i] << " " << mean_nbfix[i] << " " << mean_evolrate[i] << "\n";
  }
  file.close();
  delete[] mean_s;
  mean_s = NULL;
  delete[] mean_nbfix;
  mean_nbfix = NULL;
  delete[] mean_evolrate;
  mean_evolrate = NULL;
}

/*----------------------------
 * PROTECTED METHODS
 *----------------------------*/

/**
 * \brief    Tag all the offspring of this node
 * \details  --
 * \param    Node* node
 * \param    std::vector<Node*>* tagged_nodes
 * \return   \e void
 */
void Tree::tag_offspring( Node* node, std::vector<Node*>* tagged_nodes )
{
  untag_tree();
  tagged_nodes->clear();
  tagged_nodes->push_back(node);
  bool end = false;
  while (!end)
  {
    end = true;
    for (int i = 0; i < (int)tagged_nodes->size(); i++)
    {
      for (int j = 0; j < tagged_nodes->at(i)->get_number_of_children(); j++)
      {
        if (!tagged_nodes->at(i)->get_child(j)->isTagged())
        {
          end = false;
          tagged_nodes->at(i)->get_child(j)->tag();
          tagged_nodes->push_back(tagged_nodes->at(i)->get_child(j));
        }
      }
    }
  }
}

