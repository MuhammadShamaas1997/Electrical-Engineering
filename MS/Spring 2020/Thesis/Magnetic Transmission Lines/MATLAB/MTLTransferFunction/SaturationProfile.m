clc;clear all;
max=5000;
MMF(1:max)=1:max;
K1=150;
K1exp=0.005;
K2=300;
K2exp=0.005;

ind=1;

for ind=1:max
        Ea(ind)=140+exp(-K1exp*MMF(ind))*K1-exp(-K2exp*MMF(ind))*K2;
end
Ea(ind)=150+exp(-0.005*u(1))*150-exp(-0.005*u(1))*300;
%Ea(ind)=u(1)*0.13-u(1)*u(1)*0.00003


plot(MMF,Ea)