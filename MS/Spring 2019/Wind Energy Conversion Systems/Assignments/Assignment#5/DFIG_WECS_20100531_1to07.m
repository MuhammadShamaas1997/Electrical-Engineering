%%%%%%%%%%%%%%%% IDFIG parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear all;

Fb=50;
Omegabase=2*pi*Fb;
Rr=0.00263;
Rs=0.00265;
Lls=0.1687e-3;
Llr=0.1337e-3;
Lm=5.4749e-3;
Ls=Lls+Lm;
Lr=Llr+Lm;


Zlr=Omegabase*Llr;
Zls=Omegabase*Lls;
Zm=Omegabase*Lm;

P=2;
n_rated=1750;
slip_rated=(1500-1750)/1500;
Omegamech=(1750/60)*2*pi;

Vp=(690*(2^.5))/(3^.5);
PFs=1;
Angle_Is=-acos(PFs);

Is=1068.2173453003495*2^.5*(cos(Angle_Is)+i*sin(Angle_Is));
Vm=Vp - Is.*(Rs + Zls*i);
Im=Vm/(Zm*i);
Ir_cal=Im-Is;
Vr_cal=Vm+Ir_cal.*(Rr/slip_rated+i*Zlr);
Pmech=((1-slip_rated)/slip_rated)*Rr*abs(Ir_cal)^2*1.5-1.5*(real(Vr_cal*conj(Ir_cal)))*((1-slip_rated));
 
Pbase=-1.5e6;
Trated=8185;
PFs=-1;
Sbase=Pbase/PFs;
Vbase=(690)/(3^.5);
Ibase=Sbase/(3*Vbase);
Zbase=Vbase/Ibase;

Omegabase=2*pi*Fb;
Omegabase_mech=Omegabase/P;
nbase=(Omegabase_mech*60)/(2*pi);
Lbase=Zbase/Omegabase;
Cbase=1/(Omegabase*Zbase);
Fluxbase=Vbase/Omegabase;
Tbase=Sbase/Omegabase;
Trated_pu=Trated/Tbase;
Pmech_pu=Pmech/Sbase;

Rr_pu=Rr/Zbase;
Rs_pu=Rs/Zbase;
Lls_pu=Lls/Lbase;
Llr_pu=Llr/Lbase;
Lm_pu=Lm/Lbase;
Lr_pu=Lr/Lbase;
Ls_pu=Ls/Lbase;

H=1.1;
J_SCIG=98.26;



Grid_Angle_init=0;
Lgrid=0.0775e-3;
XLgrid_pu=Lgrid*Omegabase/Zbase;
Cdc=130.73e-3;
Vdc_ref=436.2/Vbase;
Qgsc_ref=0;
Ps_ref=0.6;
Qs_ref=0;
Grid_Angle_init=0;

F0=1000;

Kp=1;
Ki=10;
Ron=0;
%switching frequency
Fs=500;% 34 times fundamental frequency
Ts=1/Fs;

% sampling frqquency for controller
Fsampling=1e3;% at least 2 times Fs recommended