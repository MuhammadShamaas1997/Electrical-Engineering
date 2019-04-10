clc
clear
F0=1000;
Grid_voltage_init = 0;
iq_ref_pu = 0;
% rectifer or inverter selection
% "1" --- rectifier
% "0" --- inverter
Rectifier_or_inverter=0;


Pb=2.3e6;% active power at the PCC
Vb=690*2^0.5/3^0.5;%563.3826
Fb=60;
Ib=Pb/(1.5*Vb);
Zb=Vb/Ib;
Omega_b=2*pi*Fb;
Lb=Zb/Omega_b;
Cb=1/(Omega_b*Zb);

% grid-side filter inductor
Lgrid_pu=0.2*Fb;
Lgrid=Lgrid_pu*Lb;
Rgrid_pu=0.005;
Rgrid=Rgrid_pu*Zb;
Power_loss=Rgrid_pu*Pb;

%dc link
Cdc=4*Cb;
Vdc_ref=(Lgrid_pu+1.0+0.05)*3^0.5;% in per unit
Vdc_capacitor_initial=Vdc_ref*Vb;

%dc supply voltage calculation according to series resistor
Rdc_series=0.1*Zb; % might be changed here

if Rectifier_or_inverter==1 % for rectifier operation case
    Idc=(Pb - Power_loss)/(Vdc_ref*Vb);
    Vdc_supply=Vdc_ref*Vb - Idc*Rdc_series;
elseif Rectifier_or_inverter==0% for inverter operation case
    Idc=(Pb + Power_loss)/(Vdc_ref*Vb);
    Vdc_supply=Vdc_ref*Vb + Idc*Rdc_series;
end

%switching frequency
Fs=2040;% 34 times fundamental frequency

% sampling frqquency for controller
Fsampling=10e3;% at least 2 times Fs recommended
