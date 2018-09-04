
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
  create_fixed_param_to_index_map();
  create_mutable_param_to_index_map();
  create_met_to_index_map();
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
  _fixed_param_to_index.clear();
  _mutable_param_to_index.clear();
  _met_to_index.clear();
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
  file << "name s nbfix evolrate\n";
  for (std::unordered_map<std::string, int>::iterator it = _met_to_index.begin(); it != _met_to_index.end(); ++it)
  {
    file << it->first << " " << best_s[it->second] << " " << nbfix[it->second] << " " << evolrate[it->second] << "\n";
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
  file << "name s nbfix evolrate\n";
  for (std::unordered_map<std::string, int>::iterator it = _met_to_index.begin(); it != _met_to_index.end(); ++it)
  {
    file << it->first << " " << mean_s[it->second] << " " << mean_nbfix[it->second] << " " << mean_evolrate[it->second] << "\n";
  }
  file.close();
  delete[] mean_s;
  mean_s = NULL;
  delete[] mean_nbfix;
  mean_nbfix = NULL;
  delete[] mean_evolrate;
  mean_evolrate = NULL;
}

/**
 * \brief    Recover best individual's fixed mutations
 * \details  Data is written in a text file
 * \param    std::string filename
 * \return   \e void
 */
void Tree::recover_best_fixed_mutations( std::string filename )
{
  Node* best = get_best_alive_node();
  best->recover_fixed_mutations(filename, &_mutable_param_to_index);
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

/**
 * \brief    Create the fixed parameter to index map
 * \details  --
 * \param    void
 * \return   \e void
 */
void Tree::create_fixed_param_to_index_map( void )
{
  _fixed_param_to_index.clear();
  _fixed_param_to_index["Atot"]     = 0;
  _fixed_param_to_index["EqMult"]   = 1;
  _fixed_param_to_index["GStotal"]  = 2;
  _fixed_param_to_index["Inhibv1"]  = 3;
  _fixed_param_to_index["L0v12"]    = 4;
  _fixed_param_to_index["L0v3"]     = 5;
  _fixed_param_to_index["Mgtot"]    = 6;
  _fixed_param_to_index["NADPtot"]  = 7;
  _fixed_param_to_index["NADtot"]   = 8;
  _fixed_param_to_index["alfav0"]   = 9;
  _fixed_param_to_index["protein1"] = 10;
  _fixed_param_to_index["protein2"] = 11;
  _fixed_param_to_index["Glcout"]   = 12;
  _fixed_param_to_index["Lacex"]    = 13;
  _fixed_param_to_index["PRPP"]     = 14;
  _fixed_param_to_index["Phiex"]    = 15;
  _fixed_param_to_index["Pyrex"]    = 16;
}

/**
 * \brief    Create the mutable parameter to index map
 * \details  --
 * \param    void
 * \return   \e void
 */
void Tree::create_mutable_param_to_index_map( void )
{
  _mutable_param_to_index.clear();
  _mutable_param_to_index["K13P2Gv6"]    = 0;
  _mutable_param_to_index["K13P2Gv7"]    = 1;
  _mutable_param_to_index["K1v23"]       = 2;
  _mutable_param_to_index["K1v24"]       = 3;
  _mutable_param_to_index["K1v26"]       = 4;
  _mutable_param_to_index["K23P2Gv1"]    = 5;
  _mutable_param_to_index["K23P2Gv8"]    = 6;
  _mutable_param_to_index["K23P2Gv9"]    = 7;
  _mutable_param_to_index["K2PGv10"]     = 8;
  _mutable_param_to_index["K2PGv11"]     = 9;
  _mutable_param_to_index["K2v23"]       = 10;
  _mutable_param_to_index["K2v24"]       = 11;
  _mutable_param_to_index["K2v26"]       = 12;
  _mutable_param_to_index["K3PGv10"]     = 13;
  _mutable_param_to_index["K3PGv7"]      = 14;
  _mutable_param_to_index["K3v23"]       = 15;
  _mutable_param_to_index["K3v24"]       = 16;
  _mutable_param_to_index["K3v26"]       = 17;
  _mutable_param_to_index["K4v23"]       = 18;
  _mutable_param_to_index["K4v24"]       = 19;
  _mutable_param_to_index["K4v26"]       = 20;
  _mutable_param_to_index["K5v23"]       = 21;
  _mutable_param_to_index["K5v24"]       = 22;
  _mutable_param_to_index["K5v26"]       = 23;
  _mutable_param_to_index["K6PG1v18"]    = 24;
  _mutable_param_to_index["K6PG2v18"]    = 25;
  _mutable_param_to_index["K6v23"]       = 26;
  _mutable_param_to_index["K6v24"]       = 27;
  _mutable_param_to_index["K6v26"]       = 28;
  _mutable_param_to_index["K7v23"]       = 29;
  _mutable_param_to_index["K7v24"]       = 30;
  _mutable_param_to_index["K7v26"]       = 31;
  _mutable_param_to_index["KADPv16"]     = 32;
  _mutable_param_to_index["KAMPv16"]     = 33;
  _mutable_param_to_index["KAMPv3"]      = 34;
  _mutable_param_to_index["KATPv12"]     = 35;
  _mutable_param_to_index["KATPv16"]     = 36;
  _mutable_param_to_index["KATPv17"]     = 37;
  _mutable_param_to_index["KATPv18"]     = 38;
  _mutable_param_to_index["KATPv25"]     = 39;
  _mutable_param_to_index["KATPv3"]      = 40;
  _mutable_param_to_index["KDHAPv4"]     = 41;
  _mutable_param_to_index["KDHAPv5"]     = 42;
  _mutable_param_to_index["KFru16P2v12"] = 43;
  _mutable_param_to_index["KFru16P2v4"]  = 44;
  _mutable_param_to_index["KFru6Pv2"]    = 45;
  _mutable_param_to_index["KFru6Pv3"]    = 46;
  _mutable_param_to_index["KG6Pv17"]     = 47;
  _mutable_param_to_index["KGSHv19"]     = 48;
  _mutable_param_to_index["KGSSGv19"]    = 49;
  _mutable_param_to_index["KGlc6Pv1"]    = 50;
  _mutable_param_to_index["KGlc6Pv2"]    = 51;
  _mutable_param_to_index["KGraPv4"]     = 52;
  _mutable_param_to_index["KGraPv5"]     = 53;
  _mutable_param_to_index["KGraPv6"]     = 54;
  _mutable_param_to_index["KMGlcv1"]     = 55;
  _mutable_param_to_index["KMg23P2Gv1"]  = 56;
  _mutable_param_to_index["KMgADPv12"]   = 57;
  _mutable_param_to_index["KMgADPv7"]    = 58;
  _mutable_param_to_index["KMgATPMgv1"]  = 59;
  _mutable_param_to_index["KMgATPv1"]    = 60;
  _mutable_param_to_index["KMgATPv3"]    = 61;
  _mutable_param_to_index["KMgATPv7"]    = 62;
  _mutable_param_to_index["KMgv1"]       = 63;
  _mutable_param_to_index["KMgv3"]       = 64;
  _mutable_param_to_index["KMinv0"]      = 65;
  _mutable_param_to_index["KMoutv0"]     = 66;
  _mutable_param_to_index["KNADHv6"]     = 67;
  _mutable_param_to_index["KNADPHv17"]   = 68;
  _mutable_param_to_index["KNADPHv18"]   = 69;
  _mutable_param_to_index["KNADPHv19"]   = 70;
  _mutable_param_to_index["KNADPv17"]    = 71;
  _mutable_param_to_index["KNADPv18"]    = 72;
  _mutable_param_to_index["KNADPv19"]    = 73;
  _mutable_param_to_index["KNADv6"]      = 74;
  _mutable_param_to_index["KPEPv11"]     = 75;
  _mutable_param_to_index["KPEPv12"]     = 76;
  _mutable_param_to_index["KPGA23v17"]   = 77;
  _mutable_param_to_index["KPGA23v18"]   = 78;
  _mutable_param_to_index["KPv6"]        = 79;
  _mutable_param_to_index["KR5Pv22"]     = 80;
  _mutable_param_to_index["KR5Pv25"]     = 81;
  _mutable_param_to_index["KRu5Pv21"]    = 82;
  _mutable_param_to_index["KRu5Pv22"]    = 83;
  _mutable_param_to_index["KX5Pv21"]     = 84;
  _mutable_param_to_index["Kd1"]         = 85;
  _mutable_param_to_index["Kd2"]         = 86;
  _mutable_param_to_index["Kd23P2G"]     = 87;
  _mutable_param_to_index["Kd3"]         = 88;
  _mutable_param_to_index["Kd4"]         = 89;
  _mutable_param_to_index["KdADP"]       = 90;
  _mutable_param_to_index["KdAMP"]       = 91;
  _mutable_param_to_index["KdATP"]       = 92;
  _mutable_param_to_index["Keqv0"]       = 93;
  _mutable_param_to_index["Keqv1"]       = 94;
  _mutable_param_to_index["Keqv10"]      = 95;
  _mutable_param_to_index["Keqv11"]      = 96;
  _mutable_param_to_index["Keqv12"]      = 97;
  _mutable_param_to_index["Keqv13"]      = 98;
  _mutable_param_to_index["Keqv14"]      = 99;
  _mutable_param_to_index["Keqv16"]      = 100;
  _mutable_param_to_index["Keqv17"]      = 101;
  _mutable_param_to_index["Keqv18"]      = 102;
  _mutable_param_to_index["Keqv19"]      = 103;
  _mutable_param_to_index["Keqv2"]       = 104;
  _mutable_param_to_index["Keqv21"]      = 105;
  _mutable_param_to_index["Keqv22"]      = 106;
  _mutable_param_to_index["Keqv23"]      = 107;
  _mutable_param_to_index["Keqv24"]      = 108;
  _mutable_param_to_index["Keqv25"]      = 109;
  _mutable_param_to_index["Keqv26"]      = 110;
  _mutable_param_to_index["Keqv27"]      = 111;
  _mutable_param_to_index["Keqv28"]      = 112;
  _mutable_param_to_index["Keqv29"]      = 113;
  _mutable_param_to_index["Keqv3"]       = 114;
  _mutable_param_to_index["Keqv4"]       = 115;
  _mutable_param_to_index["Keqv5"]       = 116;
  _mutable_param_to_index["Keqv6"]       = 117;
  _mutable_param_to_index["Keqv7"]       = 118;
  _mutable_param_to_index["Keqv8"]       = 119;
  _mutable_param_to_index["Keqv9"]       = 120;
  _mutable_param_to_index["KiGraPv4"]    = 121;
  _mutable_param_to_index["KiiGraPv4"]   = 122;
  _mutable_param_to_index["Kv20"]        = 123;
  _mutable_param_to_index["Vmax1v1"]     = 124;
  _mutable_param_to_index["Vmax2v1"]     = 125;
  _mutable_param_to_index["Vmaxv0"]      = 126;
  _mutable_param_to_index["Vmaxv10"]     = 127;
  _mutable_param_to_index["Vmaxv11"]     = 128;
  _mutable_param_to_index["Vmaxv12"]     = 129;
  _mutable_param_to_index["Vmaxv13"]     = 130;
  _mutable_param_to_index["Vmaxv16"]     = 131;
  _mutable_param_to_index["Vmaxv17"]     = 132;
  _mutable_param_to_index["Vmaxv18"]     = 133;
  _mutable_param_to_index["Vmaxv19"]     = 134;
  _mutable_param_to_index["Vmaxv2"]      = 135;
  _mutable_param_to_index["Vmaxv21"]     = 136;
  _mutable_param_to_index["Vmaxv22"]     = 137;
  _mutable_param_to_index["Vmaxv23"]     = 138;
  _mutable_param_to_index["Vmaxv24"]     = 139;
  _mutable_param_to_index["Vmaxv25"]     = 140;
  _mutable_param_to_index["Vmaxv26"]     = 141;
  _mutable_param_to_index["Vmaxv27"]     = 142;
  _mutable_param_to_index["Vmaxv28"]     = 143;
  _mutable_param_to_index["Vmaxv29"]     = 144;
  _mutable_param_to_index["Vmaxv3"]      = 145;
  _mutable_param_to_index["Vmaxv4"]      = 146;
  _mutable_param_to_index["Vmaxv5"]      = 147;
  _mutable_param_to_index["Vmaxv6"]      = 148;
  _mutable_param_to_index["Vmaxv7"]      = 149;
  _mutable_param_to_index["Vmaxv9"]      = 150;
  _mutable_param_to_index["kATPasev15"]  = 151;
  _mutable_param_to_index["kDPGMv8"]     = 152;
  _mutable_param_to_index["kLDHv14"]     = 153;
}

/**
 * \brief    Create the metabolite to index map
 * \details  --
 * \param    void
 * \return   \e void
 */
void Tree::create_met_to_index_map( void )
{
  _met_to_index.clear();
  _met_to_index["ADPf"]      = 0;
  _met_to_index["AMPf"]      = 1;
  _met_to_index["ATPf"]      = 2;
  _met_to_index["DHAP"]      = 3;
  _met_to_index["E4P"]       = 4;
  _met_to_index["Fru16P2"]   = 5;
  _met_to_index["Fru6P"]     = 6;
  _met_to_index["GSH"]       = 7;
  _met_to_index["GSSG"]      = 8;
  _met_to_index["Glc6P"]     = 9;
  _met_to_index["GlcA6P"]    = 10;
  _met_to_index["Glcin"]     = 11;
  _met_to_index["GraP"]      = 12;
  _met_to_index["Gri13P2"]   = 13;
  _met_to_index["Gri23P2f"]  = 14;
  _met_to_index["Gri2P"]     = 15;
  _met_to_index["Gri3P"]     = 16;
  _met_to_index["Lac"]       = 17;
  _met_to_index["MgADP"]     = 18;
  _met_to_index["MgAMP"]     = 19;
  _met_to_index["MgATP"]     = 20;
  _met_to_index["MgGri23P2"] = 21;
  _met_to_index["Mgf"]       = 22;
  _met_to_index["NAD"]       = 23;
  _met_to_index["NADH"]      = 24;
  _met_to_index["NADPHf"]    = 25;
  _met_to_index["NADPf"]     = 26;
  _met_to_index["P1NADP"]    = 27;
  _met_to_index["P1NADPH"]   = 28;
  _met_to_index["P1f"]       = 29;
  _met_to_index["P2NADP"]    = 30;
  _met_to_index["P2NADPH"]   = 31;
  _met_to_index["P2f"]       = 32;
  _met_to_index["PEP"]       = 33;
  _met_to_index["Phi"]       = 34;
  _met_to_index["Pyr"]       = 35;
  _met_to_index["Rib5P"]     = 36;
  _met_to_index["Rul5P"]     = 37;
  _met_to_index["Sed7P"]     = 38;
  _met_to_index["Xul5P"]     = 39;
}

