
#ifndef __Holzhutter2004__Macros__
#define __Holzhutter2004__Macros__

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


#endif /* defined(__Holzhutter2004__Macros__) */
