clc;clearvars;close all; %to clear all the variables from workspace

f=53.33;
P=8;
nr=400;               %speed in rpm
w=0.8*nr*P*2*(pi/60);   %working speed (0.8per unit)in radian per second
T=1/f;
Ld=9.816e-3;
Lq=9.816e-3;
Rs=24.21e-3;
%%dt=1e-4;              %step size (0.0001second)
%%t=0;
%for t=0:dt:1
%update the values of time systematically to be used in sine & cosine(w*t)
%end

RL=4.2855;
LL=8.258e-3;
Rsnubber=1e3;
iqs=((w*7.030056*(RL+Rs))/((RL+Rs)*(RL+Rs)+w*w*(LL+Ld)*(LL+Lq)));
iqspu=iqs/(490*sqrt(2));
ids=((w*(LL+Lq)*iqs)/(Rs+6));
idspu=ids/(490*sqrt(2));
is=(iqs*iqs+ids*ids)^0.5;