
#ifndef __ComplexMetabolicNetwork__Macros__
#define __ComplexMetabolicNetwork__Macros__

/****************************/
/* Kinetic parameters range */
/****************************/

#define KM_F_MIN  1e-7*1e+9  /*!< Minimal forward KM value */
#define KM_F_MAX  1e-1*1e+9  /*!< Maximal forward KM value */

#define VMAX_F_MIN  6.0   /*!< Minimal forward Vmax value */
#define VMAX_F_MAX  6e+4  /*!< Maximal forward Vmax value */

#define KM_B_MIN  1e-7*1e+9  /*!< Minimal backward KM value */
#define KM_B_MAX  1e-1*1e+9  /*!< Maximal backward KM value */

#define VMAX_B_MIN  6.0   /*!< Minimal backward Vmax value */
#define VMAX_B_MAX  6e+4  /*!< Maximal backward Vmax value */

#define S_KM_F_RATIO_MIN  1e-4  /*!< Minimal [S]/KM ratio */
#define S_KM_F_RATIO_MAX  1e+4  /*!< Maximal [S]/KM ratio */

#define SATURATION_RATIO  0.5                          /*!< Saturation ratio */
#define INFLUX            VMAX_F_MIN*SATURATION_RATIO  /*!< Influx value     */

/****************************/
/* ODE solver parameters    */
/****************************/

#define ERR_ABS                 1e-20  /*!< ODE solver absolute precision     */
#define ERR_REL                 1e-02  /*!< ODE solver relative precision     */
#define DT_INIT                 1.0    /*!< ODE solver initial dt             */
#define MINIMUM_CONCENTRATION   1e-06  /*!< Minimum concentration             */
#define MAXIMUM_CONCENTRATION   1e+06  /*!< Maximum concentration             */
#define STEADY_STATE_DIFF_TH    1e-08  /*!< Steady-state difference threshold */
#define ANC_STEADY_STATE_MAX_T  1e+04  /*!< Maximum integration time          */
#define IND_STEADY_STATE_MAX_T  1e+04  /*!< Maximum integration time          */

/****************************/
/* Simulation parameters    */
/****************************/

#define STATISTICS_GENERATION_STEP  100  /*!< Generation step used to save stats */


#endif /* defined(__ComplexMetabolicNetwork__Macros__) */
