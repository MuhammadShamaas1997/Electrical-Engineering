Vb=200/sqrt(3);
Pb=(5*746)/3;
Ib=Pb/Vb;
f=60;
P=4;
wb=120*(f/P)*(2*pi/60)*(P/2);
Rs=0.277;
Rr=0.183;
Lm=0.0538;
Lr=0.05606;
Ls=0.0553;
J=0.0165;
Bt=0.05;
Vdc=285;
fc=2000;
Vcm=10;
Hc=0.333;
Hw=0.05;
Tw=0.002;
If=6;
Ra=Rs+Rr*(Ls/Lr);
Ka=1/Ra;
La=Ls-(Lm*Lm/Lr);
Ta=La/Ra;
Tm=J/Bt;
Kt=(3*P/4)*(Lm*Lm*If/Lr);
Km=(P/2)*(Kt/Bt);
Kb=(P/2)*(Kt/Bt)*(Ls*If);
Tin=1/(2*fc);
Kin=0.65*(Vdc/Vcm);

subplot(2,1,1);hold on; % Divides the figure to two subplots
%plot(iqs.time,iqs.data); grid on;%axis([0 5 1.56 1.57]);% This would plot the current
plot(iqs_k.time,iqs_k.data); grid on;axis([0.495 0.5 1.15*Ib 1.25*Ib]);% This would plot the current
xlabel('Time (s)'); ylabel('iqs (A)');

subplot(2,1,2);hold on;
plot(vqs.time,vqs.data); grid on;
xlabel('Time (s)'); ylabel('Vqs (V)');axis([0.495 0.5 -10 210]);