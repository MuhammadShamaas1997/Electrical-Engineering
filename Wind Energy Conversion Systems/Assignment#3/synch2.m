clc;clearvars;close all; %to clear all the variables from workspace

f=53.33;
P=8;
nr=400;               %speed in rpm
w=0.8*nr*P*2*(pi/60);   %working speed (0.8per unit)in radian per second
T=1/f;
Ld=9.816e-3;
Lq=9.816e-3;
Rs=24.21e-3;
RL=6;
%%dt=1e-4;              %step size (0.0001second)
%%t=0;
%for t=0:dt:1
%update the values of time systematically to be used in sine & cosine(w*t)
%end