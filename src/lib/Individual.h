
#ifndef __ComplexMetabolicNetwork__Individual__
#define __ComplexMetabolicNetwork__Individual__

#include <iostream>
#include <assert.h>
#include <fstream>
#include <sstream>

#include "Macros.h"
#include "Enums.h"
#include "Structs.h"
#include "Prng.h"
#include "Parameters.h"
#include "ODESolver.h"


class Individual
{
  
public:
  
  /*----------------------------
   * CONSTRUCTORS
   *----------------------------*/
  Individual( void ) = delete;
  Individual( Parameters* parameters );
  Individual( const Individual& individual );
  
  /*----------------------------
   * DESTRUCTORS
   *----------------------------*/
  ~Individual( void );
  
  /*----------------------------
   * GETTERS
   *----------------------------*/
  inline unsigned long long int get_identifier( void ) const;
  inline unsigned long long int get_parent( void ) const;
  inline int                    get_generation( void ) const;
  inline int                    get_m( void ) const;
  inline bool                   isStable( void ) const;
  inline bool                   isMutated( void ) const;
  inline reaction_list*         get_reaction_list( void );
  inline ODESolver*             get_ode_solver( void );
  inline int                    get_degree( int i ) const;
  inline int                    get_in_degree( int i ) const;
  inline int                    get_out_degree( int i ) const;
  inline double                 get_s( int i ) const;
  inline double*                get_s( void );
  inline double                 get_c_opt( void ) const;
  inline double                 get_c( void ) const;
  inline double                 get_w( void ) const;
  
  /*----------------------------
   * SETTERS
   *----------------------------*/
  inline void set_identifier( unsigned long long int identifier );
  inline void set_parent( unsigned long long int parent );
  inline void set_generation( int g );
  
  /*----------------------------
   * PUBLIC METHODS
   *----------------------------*/
  
  /*----------------------------------------------------- MAIN METHODS */
  
  void initialize( void );
  void mutate( double sigma, double mu );
  void compute_steady_state( bool ancestor );
  void compute_c( void );
  void compute_fitness( void );
  
  /*----------------------------------------------------- STOICHIOMETRIC MATRIX */
  
  void create_stoichiometric_matrix( void );
  void copy_stoichiometric_matrix( reaction_type** S );
  void print_stoichiometric_matrix( void );
  void save_stoichiometric_matrix( std::string filename );
  void delete_stoichiometric_matrix( void );
  
  void generate_linear_pathway_matrix( void );
  void generate_random_network_matrix( void );
  void generate_scale_free_network_matrix( void );
  
  void DFS( int i, int* reached );
  
  /*----------------------------------------------------- REACTION LIST */
  
  void create_reaction_list( void );
  void copy_reaction_list( reaction_list* list );
  void print_reaction_list( void );
  void save_reaction_list( std::string reaction_list_filename, std::string adjacency_list_filename );
  void delete_reaction_list( void );
  
  void add_reaction( int s, int p, reaction_type rtype, double km_f, double vmax_f, double km_b, double vmax_b );
  void generate_random_reaction_list( void );
  
  /*----------------------------------------------------- ODE SOLVER */
  
  void create_ode_solver( void );
  void delete_ode_solver( void );
  
  /*----------------------------------------------------- PHENOTYPE */
  
  void initialize_concentration_vector( void );
  void save_indidivual_state( std::string filename );
  
  /*----------------------------------------------------- TREE MANAGEMENT */
  
  void prepare_for_tree( void );
  
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
  
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  Parameters*            _parameters; /*!< Parameters list                */
  Prng*                  _prng;       /*!< Pseudorandom numbers generator */
  unsigned long long int _identifier; /*!< Individual unique identifier   */
  unsigned long long int _parent;     /*!< Parent unique identifier       */
  int                    _g;          /*!< Individual's generation        */
  
  /*----------------------------------------------------- NETWORK STRUCTURE */
  
  int             _m;                /*!< Number of metabolites                */
  int             _Sdim;             /*!< S matrix dimension                   */
  reaction_type** _S;                /*!< Stoichiometric matrix                */
  int             _influx_index;     /*!< Influx index                         */
  int             _outflux_index;    /*!< Outflux index                        */
  int*            _degree;           /*!< Metabolite total degree              */
  int*            _in_degree;        /*!< Metabolite indegree                  */
  int*            _out_degree;       /*!< Metabolite outdegree                 */
  double*         _mean_km_f;        /*!< Mean KM_f per metabolite             */
  double*         _mean_vmax_f;      /*!< Mean Vmax_f per metabolite           */
  double*         _mean_km_b;        /*!< Mean KM_b per metabolite             */
  double*         _mean_vmax_b;      /*!< Mean Vmax_b per metabolite           */
  int*            _mean_counter;     /*!< Mean counter                         */
  double*         _in_mean_km_f;     /*!< Indegree mean KM_f per metabolite    */
  double*         _in_mean_vmax_f;   /*!< Indegree mean Vmax_f per metabolite  */
  double*         _in_mean_km_b;     /*!< Indegree mean KM_b per metabolite    */
  double*         _in_mean_vmax_b;   /*!< Indegree mean Vmax_b per metabolite  */
  int*            _in_mean_counter;  /*!< Indegree mean counter                */
  double*         _out_mean_km_f;    /*!< Outdegree mean KM_f per metabolite   */
  double*         _out_mean_vmax_f;  /*!< Outdegree mean Vmax_f per metabolite */
  double*         _out_mean_km_b;    /*!< Outdegree mean KM_b per metabolite   */
  double*         _out_mean_vmax_b;  /*!< Outdegree mean Vmax_b per metabolite */
  int*            _out_mean_counter; /*!< Outdegree mean counter               */
  
  /*----------------------------------------------------- PHENOTYPE */
  
  bool    _mutated; /*!< Is the network mutated?       */
  double* _s;       /*!< Concentration vector          */
  double* _old_s;   /*!< Previous concentration vector */
  double  _c;       /*!< Current sum                   */
  double  _old_c;   /*!< Previous sum                  */
  double  _c_opt;   /*!< Optimal sum                   */
  double  _w;       /*!< Fitness                       */
  
  /*----------------------------------------------------- REACTION LIST */
  
  reaction_list* _reaction_list; /*!< List of metabolic reactions */
  ODESolver*     _ode_solver;    /*!< ODE solver                  */
  double         _dt;            /*!< Current solving dt          */
  bool           _isStable;      /*!< Is the network stable?      */
  
  /*----------------------------------------------------- TREE MANAGEMENT */
  
  bool _prepared_for_tree;
  
};

/*----------------------------
 * GETTERS
 *----------------------------*/

/**
 * \brief    Get the identifier
 * \details  --
 * \param    void
 * \return   \e unsigned long long int
 */
inline unsigned long long int Individual::get_identifier( void ) const
{
  return _identifier;
}

/**
 * \brief    Get parent identifier
 * \details  --
 * \param    void
 * \return   \e unsigned long long int
 */
inline unsigned long long int Individual::get_parent( void ) const
{
  return _parent;
}

/**
 * \brief    Get the generation
 * \details  --
 * \param    void
 * \return   \e int
 */
inline int Individual::get_generation( void ) const
{
  return _g;
}

/**
 * \brief    Get the number of metabolites
 * \details  --
 * \param    void
 * \return   \e int
 */
inline int Individual::get_m( void ) const
{
  return _m;
}

/**
 * \brief    Is the metabolic network stable?
 * \details  --
 * \param    void
 * \return   \e bool
 */
inline bool Individual::isStable( void ) const
{
  return _isStable;
}

/**
 * \brief    Have the metabolic network been mutated?
 * \details  --
 * \param    void
 * \return   \e bool
 */
inline bool Individual::isMutated( void ) const
{
  return _mutated;
}

/**
 * \brief    Get the reaction list
 * \details  --
 * \param    void
 * \return   \e reaction_list*
 */
inline reaction_list* Individual::get_reaction_list( void )
{
  return _reaction_list;
}

/**
 * \brief    Get the ODE solver
 * \details  --
 * \param    void
 * \return   \e ODESolver*
 */
inline ODESolver* Individual::get_ode_solver( void )
{
  return _ode_solver;
}

/**
 * \brief    Get the degree for metabolite i
 * \details  --
 * \param    void
 * \return   \e ODESolver*
 */
inline int Individual::get_degree( int i ) const
{
  return _degree[i];
}

/**
 * \brief    Get the in degree for metabolite i
 * \details  --
 * \param    void
 * \return   \e ODESolver*
 */
inline int Individual::get_in_degree( int i ) const
{
  return _in_degree[i];
}

/**
 * \brief    Get the out degree for metabolite i
 * \details  --
 * \param    void
 * \return   \e ODESolver*
 */
inline int Individual::get_out_degree( int i ) const
{
  return _out_degree[i];
}

/**
 * \brief    Get concentration for metabolite i
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Individual::get_s( int i ) const
{
  assert(i >= 0);
  assert(i < _parameters->get_m());
  return _s[i];
}

/**
 * \brief    Get concentration vector
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double* Individual::get_s( void )
{
  return _s;
}

/**
 * \brief    Get c optimum (c_opt)
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Individual::get_c_opt( void ) const
{
  return _c_opt;
}

/**
 * \brief    Get sum of concentrations (c)
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Individual::get_c( void ) const
{
  return _c;
}

/**
 * \brief    Get fitness
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Individual::get_w( void ) const
{
  return _w;
}

/*----------------------------
 * SETTERS
 *----------------------------*/

/**
 * \brief    Set the identifier
 * \details  --
 * \param    unsigned long long int identifier
 * \return   \e void
 */
inline void Individual::set_identifier( unsigned long long int identifier )
{
  _identifier = identifier;
}

/**
 * \brief    Set the parent identifier
 * \details  --
 * \param    unsigned long long int parent
 * \return   \e void
 */
inline void Individual::set_parent( unsigned long long int parent )
{
  _parent = parent;
}

/**
 * \brief    Set the generation
 * \details  --
 * \param    int g
 * \return   \e void
 */
inline void Individual::set_generation( int g )
{
  _g = g;
}


#endif /* defined(__ComplexMetabolicNetwork__Individual__) */
