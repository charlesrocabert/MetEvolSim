
#ifndef __Holzhutter2004__Population__
#define __Holzhutter2004__Population__

#include <iostream>
#include <cmath>
#include <sstream>
#include <unordered_map>
#include <tbb/tbb.h>
#include <cstring>
#include <stdlib.h>
#include <assert.h>

#include "Macros.h"
#include "Enums.h"
#include "Structs.h"
#include "Prng.h"
#include "Individual.h"
#include "Tree.h"


class Population
{
  
public:
  
  /*----------------------------
   * CONSTRUCTORS
   *----------------------------*/
  Population( void ) = delete;
  Population( Parameters* parameters );
  Population( const Population& population ) = delete;
  
  /*----------------------------
   * DESTRUCTORS
   *----------------------------*/
  ~Population( void );
  
  /*----------------------------
   * GETTERS
   *----------------------------*/
  inline int   get_generation( void ) const;
  inline Tree* get_tree( void );
  
  /*----------------------------
   * SETTERS
   *----------------------------*/
  Population& operator=(const Population&) = delete;
  
  /*----------------------------
   * PUBLIC METHODS
   *----------------------------*/
  void initialize( void );
  void next_generation( void );
  void compute_statistics( void );
  void open_statistic_files( void );
  void write_statistic_files( void );
  void close_statistic_files( void );
  void write_best_individual( void );
  
  /*----------------------------
   * PUBLIC ATTRIBUTES
   *----------------------------*/
  
protected:
  
  /*----------------------------
   * PROTECTED METHODS
   *----------------------------*/
  void evaluate_individual( int i );
  void create_fixed_param_to_index_map( void );
  void create_mutable_param_to_index_map( void );
  void create_met_to_index_map( void );
  
  /*----------------------------
   * PROTECTED ATTRIBUTES
   *----------------------------*/
  
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  Parameters* _parameters; /*!< Parameters list                */
  Prng*       _prng;       /*!< Pseudorandom numbers generator */
  Tree*       _tree;       /*!< Phylogenetic tree              */
  
  /*----------------------------------------------------- POPULATION */
  
  unsigned long long int _id;    /*!< Individual identifier */
  int                    _n;     /*!< Population size       */
  int                    _m;     /*!< Number of metabolites */
  int                    _g;     /*!< Current generation    */
  Individual**           _pop;   /*!< Population            */
  double*                _w_vec; /*!< Vector of fitnesses   */
  double                 _w_sum; /*!< Sum of fitnesses      */
  
  /*----------------------------------------------------- STATISTICS */
  
  int     _best_pos; /*!< Best individual index                */
  int     _best_w;   /*!< Best individual position             */
  double  _c_opt;    /*!< Optimal sum of concentrations        */
  double  _mean_c;   /*!< Mean sum of concentrations           */
  double  _var_c;    /*!< Sum of concentrations variance       */
  double  _mean_w;   /*!< Mean fitness in the population       */
  double  _var_w;    /*!< Fitness population variance          */
  double* _mean_s;   /*!< Mean of metabolic concentrations     */
  double* _var_s;    /*!< Variance of metabolic concentrations */
  double* _cv_s;     /*!< CV of metabolic concentrations       */
  
  std::ofstream _fitness_file; /*!< Fitness output file              */
  std::ofstream _mean_s_file;  /*!< Mean conc vector output file     */
  std::ofstream _var_s_file;   /*!< Conc vector variance output file */
  std::ofstream _cv_s_file;    /*!< Conc vector CV output file       */
  
  std::unordered_map<std::string, int> _fixed_param_to_index;   /*!< Fixed parameter to index map */
  std::unordered_map<std::string, int> _mutable_param_to_index; /*!< Fixed parameter to index map */
  std::unordered_map<std::string, int> _met_to_index;           /*!< Metabolite to index map      */
  
};


/*----------------------------
 * GETTERS
 *----------------------------*/

/**
 * \brief    Get current generation
 * \details  --
 * \param    void
 * \return   \e int
 */
inline int Population::get_generation( void ) const
{
  return _g;
}

/**
 * \brief    Get the phylogenetic tree
 * \details  --
 * \param    void
 * \return   \e Tree*
 */
inline Tree* Population::get_tree( void )
{
  return _tree;
}

/*----------------------------
 * SETTERS
 *----------------------------*/


#endif /* defined(__Holzhutter2004__Population__) */
