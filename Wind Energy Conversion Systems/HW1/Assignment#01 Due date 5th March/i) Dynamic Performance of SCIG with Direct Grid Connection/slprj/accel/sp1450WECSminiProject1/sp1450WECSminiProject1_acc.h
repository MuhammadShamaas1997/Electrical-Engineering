#include "__cf_sp1450WECSminiProject1.h"
#ifndef RTW_HEADER_sp1450WECSminiProject1_acc_h_
#define RTW_HEADER_sp1450WECSminiProject1_acc_h_
#ifndef sp1450WECSminiProject1_acc_COMMON_INCLUDES_
#define sp1450WECSminiProject1_acc_COMMON_INCLUDES_
#include <stdlib.h>
#include <stddef.h>
#define S_FUNCTION_NAME simulink_only_sfcn 
#define S_FUNCTION_LEVEL 2
#define RTW_GENERATED_S_FUNCTION
#include "rtwtypes.h"
#include "simstruc.h"
#include "fixedpoint.h"
#include "mwmathutil.h"
#include "rt_defines.h"
#endif
#include "sp1450WECSminiProject1_acc_types.h"
typedef struct { real_T B_0_38_0 ; real_T B_0_45_0 ; real_T B_0_47_0 ; real_T
B_0_57_0 ; real_T B_0_68_0 ; real_T B_0_69_0 ; real_T B_0_70_0 ; real_T
B_0_71_0 ; real_T B_0_19_0 [ 3 ] ; real_T B_0_41_0 ; real_T B_0_40_0 ; real_T
B_0_39_0 ; } B_sp1450WECSminiProject1_T ; typedef struct { struct { void *
LoggedData ; } Current_PWORK ; struct { void * LoggedData ; } Currents_PWORK
; struct { void * LoggedData ; } Speed_PWORK ; struct { void * LoggedData ; }
Torque_PWORK ; struct { void * LoggedData ; } Voltages_PWORK ; struct { void
* LoggedData ; } Voltages1_PWORK ; } DW_sp1450WECSminiProject1_T ; typedef
struct { real_T Integrator_CSTATE ; real_T Integrator2_CSTATE ; real_T
Integrator1_CSTATE ; real_T Integrator3_CSTATE ; real_T Integrator4_CSTATE ;
} X_sp1450WECSminiProject1_T ; typedef struct { real_T Integrator_CSTATE ;
real_T Integrator2_CSTATE ; real_T Integrator1_CSTATE ; real_T
Integrator3_CSTATE ; real_T Integrator4_CSTATE ; }
XDot_sp1450WECSminiProject1_T ; typedef struct { boolean_T Integrator_CSTATE
; boolean_T Integrator2_CSTATE ; boolean_T Integrator1_CSTATE ; boolean_T
Integrator3_CSTATE ; boolean_T Integrator4_CSTATE ; }
XDis_sp1450WECSminiProject1_T ; typedef struct { real_T Integrator_CSTATE ;
real_T Integrator2_CSTATE ; real_T Integrator1_CSTATE ; real_T
Integrator3_CSTATE ; real_T Integrator4_CSTATE ; }
CStateAbsTol_sp1450WECSminiProject1_T ; struct P_sp1450WECSminiProject1_T_ {
real_T P_0 ; real_T P_1 ; real_T P_2 ; real_T P_3 ; real_T P_4 ; real_T P_5 ;
real_T P_6 ; real_T P_7 ; real_T P_8 ; real_T P_9 ; real_T P_10 ; real_T P_11
; real_T P_12 [ 9 ] ; real_T P_13 ; real_T P_14 ; real_T P_15 ; real_T P_16 ;
real_T P_17 ; real_T P_18 ; real_T P_19 ; real_T P_20 ; real_T P_21 ; real_T
P_22 ; real_T P_23 [ 6 ] ; real_T P_24 ; real_T P_25 ; real_T P_26 ; real_T
P_27 ; real_T P_28 ; real_T P_29 ; real_T P_30 ; real_T P_31 ; real_T P_32 ;
real_T P_33 ; real_T P_34 ; real_T P_35 ; real_T P_36 ; real_T P_37 ; real_T
P_38 ; real_T P_39 ; real_T P_40 [ 6 ] ; real_T P_41 ; real_T P_42 ; real_T
P_43 ; real_T P_44 ; real_T P_45 ; real_T P_46 ; real_T P_47 ; real_T P_48 ;
real_T P_49 ; real_T P_50 ; real_T P_51 ; real_T P_52 ; real_T P_53 ; real_T
P_54 ; real_T P_55 ; } ; extern P_sp1450WECSminiProject1_T
sp1450WECSminiProject1_rtDefaultP ;
#endif
