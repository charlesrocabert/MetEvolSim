
#ifndef __Holzhutter2004__Individual__
#define __Holzhutter2004__Individual__

#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <assert.h>

#include "Macros.h"
#include "Enums.h"
#include "Structs.h"
#include "Prng.h"
#include "Parameters.h"


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
  
  /*----------------------------------------------------- PHENOTYPE */
  
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
  void create_met_id_to_index_map( void );
  void create_params_id_to_index_map( void );
  void initialize_concentrations( void );
  void initialize_parameters( void );
  void initialize_concentration_vector( void );
  
  /*----------------------------
   * PROTECTED ATTRIBUTES
   *----------------------------*/
  
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  Parameters*            _parameters; /*!< Parameters list                */
  Prng*                  _prng;       /*!< Pseudorandom numbers generator */
  unsigned long long int _identifier; /*!< Individual unique identifier   */
  unsigned long long int _parent;     /*!< Parent unique identifier       */
  int                    _g;          /*!< Individual's generation        */
  
  /*----------------------------------------------------- METABOLIC NETWORK */
  
  int _m; /*!< Number of metabolites */
  int _p; /*!< Number of parameters  */
  
  std::unordered_map<std::string, int> _met_id_to_index;    /*!< Metabolite id to index map */
  std::unordered_map<std::string, int> _params_id_to_index; /*!< Parameter id to index map  */
  
  double* _initial_s;      /*!< Initial concentration values */
  double* _initial_params; /*!< Initial parameter values     */
  
  /*----------------------------------------------------- PHENOTYPE */
  
  bool    _mutated; /*!< Is the network mutated?       */
  double* _s;       /*!< Concentration vector          */
  double* _old_s;   /*!< Previous concentration vector */
  double  _c;       /*!< Current sum                   */
  double  _old_c;   /*!< Previous sum                  */
  double  _c_opt;   /*!< Optimal sum                   */
  double  _w;       /*!< Fitness                       */
  
  /*----------------------------------------------------- ODE SOLVER */
  
  double _dt;       /*!< Current solving dt     */
  bool   _isStable; /*!< Is the network stable? */
  
  /*----------------------------------------------------- TREE MANAGEMENT */
  
  bool _prepared_for_tree; /*!< Is the individual prepared for tree saving? */
  
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
 * \brief    Get concentration for metabolite i
 * \details  --
 * \param    void
 * \return   \e double
 */
inline double Individual::get_s( int i ) const
{
  assert(i >= 0);
  assert(i < _m);
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


#endif /* defined(__Holzhutter2004__Individual__) */
