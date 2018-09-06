
#ifndef __Holzhutter2004__SensitivityAnalysis__
#define __Holzhutter2004__SensitivityAnalysis__

#include <iostream>
#include <fstream>
#include <sstream>
#include <unordered_map>
#include <zlib.h>
#include <cstring>
#include <stdlib.h>
#include <assert.h>

#include "Macros.h"
#include "Enums.h"
#include "Structs.h"
#include "Prng.h"
#include "Parameters.h"


class SensitivityAnalysis
{
  
public:
  
  /*----------------------------
   * CONSTRUCTORS
   *----------------------------*/
  SensitivityAnalysis( void ) = delete;
  SensitivityAnalysis( Parameters* parameters );
  SensitivityAnalysis( const SensitivityAnalysis& sensitivity_analysis ) = delete;
  
  /*----------------------------
   * DESTRUCTORS
   *----------------------------*/
  ~SensitivityAnalysis( void );
  
  /*----------------------------
   * GETTERS
   *----------------------------*/
  
  /*----------------------------
   * SETTERS
   *----------------------------*/
  
  /*----------------------------
   * PUBLIC METHODS
   *----------------------------*/
  
  /*----------------------------------------------------- MAIN METHODS */
  
  void initialize( void );
  void run_analysis( void );
  void open_files( void );
  void write_files( std::string parameter );
  void close_files( void );
  void write_initial_concentrations( void );
  
  void analyze_parameter( int i, double sigma, int N );
  void mutate( int i, double sigma );
  void compute_steady_state( void );
  void compute_c( void );
  void compute_fitness( void );
  
  /*----------------------------
   * PUBLIC ATTRIBUTES
   *----------------------------*/
  
protected:
  
  /*----------------------------
   * PROTECTED METHODS
   *----------------------------*/
  void create_fixed_param_to_index_map( void );
  void create_mutable_param_to_index_map( void );
  void create_met_to_index_map( void );
  void create_degree_map( void );
  
  void initialize_fixed_parameters( void );
  void initialize_mutable_parameters( void );
  void initialize_concentrations( void );
  
  void initialize_fixed_parameters_vector( void );
  void initialize_mutable_parameters_vector( void );
  void initialize_concentration_vector( void );
  
  void solve( void );
  void ODE_system( double* dsdt );
  
  /*----------------------------
   * PROTECTED ATTRIBUTES
   *----------------------------*/
  
  /*----------------------------------------------------- MAIN PARAMETERS */
  
  Parameters* _parameters; /*!< Parameters list                */
  Prng*       _prng;       /*!< Pseudorandom numbers generator */
  
  /*----------------------------------------------------- METABOLIC NETWORK */
  
  int _p_fixed;   /*!< Number of fixed parameters   */
  int _p_mutable; /*!< Number of mutable parameters */
  int _m;         /*!< Number of metabolites        */
  
  std::unordered_map<std::string, int> _fixed_param_to_index;   /*!< Fixed parameter to index map */
  std::unordered_map<std::string, int> _mutable_param_to_index; /*!< Fixed parameter to index map */
  std::unordered_map<std::string, int> _met_to_index;           /*!< Metabolite to index map      */
  
  double* _initial_fixed_params;   /*!< Initial fixed parameter values   */
  double* _initial_mutable_params; /*!< Initial mutable parameter values */
  double* _initial_s;              /*!< Initial concentration values     */
  
  double* _fixed_params;   /*!< Fixed parameters vector   */
  double* _mutable_params; /*!< Mutable parameters vector */
  double* _s;              /*!< Concentration vector      */
  
  /*----------------------------------------------------- PHENOTYPE */
  
  double  _c;     /*!< Current sum */
  double  _c_opt; /*!< Optimal sum */
  double  _w;     /*!< Fitness     */
  
  /*----------------------------------------------------- ODE SOLVER */
  
  double _dt;       /*!< Current solving dt       */
  double _t;        /*!< Current integration time */
  double _timestep; /*!< Current ODE timestep     */
  bool   _isStable; /*!< Is the network stable?   */
  
  /*----------------------------------------------------- SENSITIVITY ANALYSIS */
  
  double*  _param_mean; /*!< Kinetic parameter mean        */
  double*  _param_var;  /*!< Kinetic parameter variance    */
  double** _conc_mean;  /*!< Concentration vector mean     */
  double** _conc_var;   /*!< Concentration vector variance */
  double*  _c_mean;     /*!< Sum of concentration mean     */
  double*  _c_var;      /*!< Sum of concentration variance */
  double*  _w_mean;     /*!< Fitness mean                  */
  double*  _w_var;      /*!< Fitness variance              */
  
  /*----------------------------------------------------- SAVING FILES */
  
  std::ofstream _param_file;     /*!< Parameters exploration file            */
  std::ofstream _mean_conc_file; /*!< Mean concentration vector file         */
  std::ofstream _var_conc_file;  /*!< Concentration vector variance file     */
  std::ofstream _sum_file;       /*!< Sum of concentrations exploration file */
  std::ofstream _fitness_file;   /*!< Fitness exploration file               */
};


/*----------------------------
 * GETTERS
 *----------------------------*/

/*----------------------------
 * SETTERS
 *----------------------------*/


#endif /* defined(__Holzhutter2004__SensitivityAnalysis__) */
