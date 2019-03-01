#include "__cf_sp1450WECSminiProject1.h"
#include <math.h>
#include "sp1450WECSminiProject1_acc.h"
#include "sp1450WECSminiProject1_acc_private.h"
#include <stdio.h>
#include "simstruc.h"
#include "fixedpoint.h"
#define CodeFormat S-Function
#define AccDefine1 Accelerator_S-Function
static void mdlOutputs ( SimStruct * S , int_T tid ) { real_T B_0_11_0 ;
real_T B_0_13_0 ; real_T B_0_25_0 ; real_T B_0_7_0 ; real_T B_0_5_0 ; real_T
B_0_18_0 [ 3 ] ; real_T B_0_43_0 [ 3 ] ; real_T B_0_6_0 ; real_T B_0_10_0 ;
real_T B_0_44_0 [ 2 ] ; real_T B_0_65_0 ; int32_T i ; real_T unnamed_idx ;
real_T unnamed_idx_0 ; real_T unnamed_idx_1 ; B_sp1450WECSminiProject1_T *
_rtB ; P_sp1450WECSminiProject1_T * _rtP ; DW_sp1450WECSminiProject1_T *
_rtDW ; _rtDW = ( ( DW_sp1450WECSminiProject1_T * ) ssGetRootDWork ( S ) ) ;
_rtP = ( ( P_sp1450WECSminiProject1_T * ) ssGetDefaultParam ( S ) ) ; _rtB =
( ( B_sp1450WECSminiProject1_T * ) _ssGetBlockIO ( S ) ) ; B_0_7_0 =
muDoubleScalarSin ( _rtP -> P_6 * ssGetTaskTime ( S , 0 ) + _rtP -> P_7 ) *
_rtP -> P_4 + _rtP -> P_5 ; B_0_5_0 = muDoubleScalarSin ( _rtP -> P_10 *
ssGetTaskTime ( S , 0 ) + _rtP -> P_11 ) * _rtP -> P_8 + _rtP -> P_9 ;
unnamed_idx = muDoubleScalarSin ( _rtP -> P_2 * ssGetTaskTime ( S , 0 ) +
_rtP -> P_3 ) * _rtP -> P_0 + _rtP -> P_1 ; for ( i = 0 ; i < 3 ; i ++ ) {
B_0_43_0 [ i ] = _rtP -> P_12 [ i + 6 ] * B_0_5_0 + ( _rtP -> P_12 [ i + 3 ]
* B_0_7_0 + _rtP -> P_12 [ i ] * unnamed_idx ) ; } B_0_5_0 = ( (
X_sp1450WECSminiProject1_T * ) ssGetContStates ( S ) ) -> Integrator_CSTATE ;
B_0_6_0 = _rtP -> P_14 * B_0_5_0 ; B_0_7_0 = ( ( X_sp1450WECSminiProject1_T *
) ssGetContStates ( S ) ) -> Integrator2_CSTATE ; B_0_10_0 = ( B_0_6_0 - _rtP
-> P_16 * B_0_7_0 ) * _rtP -> P_17 ; B_0_11_0 = ( (
X_sp1450WECSminiProject1_T * ) ssGetContStates ( S ) ) -> Integrator1_CSTATE
; B_0_6_0 = _rtP -> P_19 * B_0_11_0 ; B_0_13_0 = ( (
X_sp1450WECSminiProject1_T * ) ssGetContStates ( S ) ) -> Integrator3_CSTATE
; B_0_6_0 = ( B_0_6_0 - _rtP -> P_21 * B_0_13_0 ) * _rtP -> P_22 ; for ( i =
0 ; i < 3 ; i ++ ) { B_0_18_0 [ i ] = _rtP -> P_23 [ i + 3 ] * B_0_6_0 + _rtP
-> P_23 [ i ] * B_0_10_0 ; } _rtB -> B_0_19_0 [ 0 ] = _rtP -> P_24 * B_0_18_0
[ 0 ] ; _rtB -> B_0_19_0 [ 1 ] = _rtP -> P_24 * B_0_18_0 [ 1 ] ; _rtB ->
B_0_19_0 [ 2 ] = _rtP -> P_24 * B_0_18_0 [ 2 ] ; ssCallAccelRunBlock ( S , 0
, 20 , SS_CALL_MDL_OUTPUTS ) ; _rtB -> B_0_41_0 = _rtP -> P_25 * B_0_18_0 [ 0
] ; _rtB -> B_0_40_0 = _rtP -> P_26 * B_0_18_0 [ 1 ] ; _rtB -> B_0_39_0 =
_rtP -> P_27 * B_0_18_0 [ 2 ] ; ssCallAccelRunBlock ( S , 0 , 24 ,
SS_CALL_MDL_OUTPUTS ) ; B_0_25_0 = ( ( X_sp1450WECSminiProject1_T * )
ssGetContStates ( S ) ) -> Integrator4_CSTATE ; _rtB -> B_0_39_0 = _rtP ->
P_29 * B_0_25_0 ; ssCallAccelRunBlock ( S , 0 , 27 , SS_CALL_MDL_OUTPUTS ) ;
B_0_65_0 = ( B_0_10_0 * B_0_11_0 - B_0_5_0 * B_0_6_0 ) * _rtP -> P_30 ; _rtB
-> B_0_39_0 = _rtP -> P_31 * B_0_65_0 ; ssCallAccelRunBlock ( S , 0 , 33 ,
SS_CALL_MDL_OUTPUTS ) ; _rtB -> B_0_39_0 = _rtP -> P_32 * B_0_43_0 [ 2 ] ;
_rtB -> B_0_40_0 = _rtP -> P_33 * B_0_43_0 [ 0 ] ; _rtB -> B_0_41_0 = _rtP ->
P_34 * B_0_43_0 [ 1 ] ; ssCallAccelRunBlock ( S , 0 , 37 ,
SS_CALL_MDL_OUTPUTS ) ; if ( ssIsSampleHit ( S , 1 , 0 ) ) { _rtB -> B_0_38_0
= _rtP -> P_35 ; } if ( ! ( _rtB -> B_0_38_0 > _rtP -> P_36 ) ) { _rtB ->
B_0_39_0 = 0.0 ; } if ( ! ( _rtB -> B_0_38_0 > _rtP -> P_37 ) ) { _rtB ->
B_0_40_0 = 0.0 ; } if ( ! ( _rtB -> B_0_38_0 > _rtP -> P_38 ) ) { _rtB ->
B_0_41_0 = 0.0 ; } ssCallAccelRunBlock ( S , 0 , 42 , SS_CALL_MDL_OUTPUTS ) ;
unnamed_idx = _rtP -> P_39 * _rtB -> B_0_39_0 ; unnamed_idx_0 = _rtP -> P_39
* _rtB -> B_0_40_0 ; unnamed_idx_1 = _rtP -> P_39 * _rtB -> B_0_41_0 ; for (
i = 0 ; i < 2 ; i ++ ) { B_0_44_0 [ i ] = _rtP -> P_40 [ i + 4 ] *
unnamed_idx_1 + ( _rtP -> P_40 [ i + 2 ] * unnamed_idx_0 + _rtP -> P_40 [ i ]
* unnamed_idx ) ; } if ( ssIsSampleHit ( S , 1 , 0 ) ) { _rtB -> B_0_45_0 =
_rtP -> P_41 ; _rtB -> B_0_47_0 = _rtP -> P_43 * _rtP -> P_42 ; } _rtB ->
B_0_57_0 = ( B_0_65_0 - _rtB -> B_0_47_0 ) * _rtP -> P_50 ; B_0_65_0 = _rtB
-> B_0_45_0 - _rtP -> P_55 * B_0_25_0 ; _rtB -> B_0_68_0 = ( B_0_44_0 [ 1 ] -
_rtP -> P_51 * B_0_10_0 ) - _rtB -> B_0_45_0 * B_0_11_0 ; _rtB -> B_0_69_0 =
( B_0_5_0 * _rtB -> B_0_45_0 - _rtP -> P_52 * B_0_6_0 ) + B_0_44_0 [ 0 ] ;
_rtB -> B_0_70_0 = ( _rtB -> B_0_45_0 - ( _rtP -> P_45 * B_0_7_0 - _rtP ->
P_44 * B_0_5_0 ) * _rtP -> P_48 * _rtP -> P_53 ) - B_0_65_0 * B_0_13_0 ; _rtB
-> B_0_71_0 = ( B_0_7_0 * B_0_65_0 - ( _rtP -> P_46 * B_0_13_0 - _rtP -> P_47
* B_0_11_0 ) * _rtP -> P_49 * _rtP -> P_54 ) + _rtB -> B_0_45_0 ;
UNUSED_PARAMETER ( tid ) ; }
#define MDL_UPDATE
static void mdlUpdate ( SimStruct * S , int_T tid ) {
B_sp1450WECSminiProject1_T * _rtB ; P_sp1450WECSminiProject1_T * _rtP ; _rtP
= ( ( P_sp1450WECSminiProject1_T * ) ssGetDefaultParam ( S ) ) ; _rtB = ( (
B_sp1450WECSminiProject1_T * ) _ssGetBlockIO ( S ) ) ; UNUSED_PARAMETER ( tid
) ; }
#define MDL_DERIVATIVES
static void mdlDerivatives ( SimStruct * S ) { B_sp1450WECSminiProject1_T *
_rtB ; P_sp1450WECSminiProject1_T * _rtP ; _rtP = ( (
P_sp1450WECSminiProject1_T * ) ssGetDefaultParam ( S ) ) ; _rtB = ( (
B_sp1450WECSminiProject1_T * ) _ssGetBlockIO ( S ) ) ; { ( (
XDot_sp1450WECSminiProject1_T * ) ssGetdX ( S ) ) -> Integrator_CSTATE = ( (
B_sp1450WECSminiProject1_T * ) _ssGetBlockIO ( S ) ) -> B_0_68_0 ; } { ( (
XDot_sp1450WECSminiProject1_T * ) ssGetdX ( S ) ) -> Integrator2_CSTATE = ( (
B_sp1450WECSminiProject1_T * ) _ssGetBlockIO ( S ) ) -> B_0_70_0 ; } { ( (
XDot_sp1450WECSminiProject1_T * ) ssGetdX ( S ) ) -> Integrator1_CSTATE = ( (
B_sp1450WECSminiProject1_T * ) _ssGetBlockIO ( S ) ) -> B_0_69_0 ; } { ( (
XDot_sp1450WECSminiProject1_T * ) ssGetdX ( S ) ) -> Integrator3_CSTATE = ( (
B_sp1450WECSminiProject1_T * ) _ssGetBlockIO ( S ) ) -> B_0_71_0 ; } { ( (
XDot_sp1450WECSminiProject1_T * ) ssGetdX ( S ) ) -> Integrator4_CSTATE = ( (
B_sp1450WECSminiProject1_T * ) _ssGetBlockIO ( S ) ) -> B_0_57_0 ; } } static
void mdlInitializeSizes ( SimStruct * S ) { ssSetChecksumVal ( S , 0 ,
1713265785U ) ; ssSetChecksumVal ( S , 1 , 1447366690U ) ; ssSetChecksumVal (
S , 2 , 1982501289U ) ; ssSetChecksumVal ( S , 3 , 506854827U ) ; { mxArray *
slVerStructMat = NULL ; mxArray * slStrMat = mxCreateString ( "simulink" ) ;
char slVerChar [ 10 ] ; int status = mexCallMATLAB ( 1 , & slVerStructMat , 1
, & slStrMat , "ver" ) ; if ( status == 0 ) { mxArray * slVerMat = mxGetField
( slVerStructMat , 0 , "Version" ) ; if ( slVerMat == NULL ) { status = 1 ; }
else { status = mxGetString ( slVerMat , slVerChar , 10 ) ; } }
mxDestroyArray ( slStrMat ) ; mxDestroyArray ( slVerStructMat ) ; if ( (
status == 1 ) || ( strcmp ( slVerChar , "8.1" ) != 0 ) ) { return ; } }
ssSetOptions ( S , SS_OPTION_EXCEPTION_FREE_CODE ) ; if ( ssGetSizeofDWork (
S ) != sizeof ( DW_sp1450WECSminiProject1_T ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal DWork sizes do "
"not match for accelerator mex file." ) ; } if ( ssGetSizeofGlobalBlockIO ( S
) != sizeof ( B_sp1450WECSminiProject1_T ) ) { ssSetErrorStatus ( S ,
"Unexpected error: Internal BlockIO sizes do "
"not match for accelerator mex file." ) ; } { int ssSizeofParams ;
ssGetSizeofParams ( S , & ssSizeofParams ) ; if ( ssSizeofParams != sizeof (
P_sp1450WECSminiProject1_T ) ) { static char msg [ 256 ] ; sprintf ( msg ,
"Unexpected error: Internal Parameters sizes do "
"not match for accelerator mex file." ) ; } } _ssSetDefaultParam ( S , (
real_T * ) & sp1450WECSminiProject1_rtDefaultP ) ; } static void
mdlInitializeSampleTimes ( SimStruct * S ) { } static void mdlTerminate (
SimStruct * S ) { }
#include "simulink.c"
