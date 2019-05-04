%HVDC Light
clc;clear all;

n=14+2;
%% system MVA base
baseMVA = 100;

%%
Preg=0.25;
Qreg=0.06;
%% bus data
%bus_i	type	Pd	Qd	Gs	Bs	area    Vm	Va	baseKV	zone	Vmax	Vmin
bus = [
	1	3	0       0       0	0	1	1.06	0       0	1	1.06	0.94;
	2	2	21.7	12.7	0	0	1	1.045	-4.98	0	1	1.06	0.94;
	3	2	94.2	19      0	0	1	1.01	-12.72	0	1	1.06	0.94;
	4	1	47.8	-3.9	0	0	1	1.019	-10.33	0	1	1.06	0.94;
	5	1	7.6     1.6     0	0	1	1.02	-8.78	0	1	1.06	0.94;
	6	2	11.2	7.5     0	0	1	1.07	-14.22	0	1	1.06	0.94;
	7	1	0       0       0	0	1	1.062	-13.37	0	1	1.06	0.94;
	8	2	0       0       0	0	1	1.09	-13.36	0	1	1.06	0.94;
	9	1	29.5	16.6	0	19	1	1.056	-14.94	0	1	1.06	0.94;
	10	1	9       5.8     0	0	1	1.051	-15.1	0	1	1.06	0.94;
	11	1	3.5     1.8     0	0	1	1.057	-14.79	0	1	1.06	0.94;
	12	1	6.1     1.6     0	0	1	1.055	-15.07	0	1	1.06	0.94;
	13	1	13.5	5.8     0	0	1	1.05	-15.16	0	1	1.06	0.94;
	14	1	14.9	5       0	0	1	1.036	-16.04	0	1	1.06	0.94;
];

for b=1:14
    LoadP(bus(b,1),1)=bus(b,3)/baseMVA;
    LoadQ(bus(b,1),1)=bus(b,4)/baseMVA;
    Vm(bus(b,1),1)=bus(b,8);
    Vp(bus(b,1),1)=bus(b,9)*(pi/180);
end

    LoadP(15,1)=Preg;
    LoadQ(15,1)=0;
    LoadP(16,1)=0;
    LoadQ(16,1)=0;
    
    Vm(15,1)=1.06;
    Vp(15,1)=0;
    Vm(16,1)=1.06;
    Vp(16,1)=0;
    Vm(13,1)=1.06;
    
%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin
gen = [
	1	232.4	-16.9	10	0	1.06	100	1	332.4	0;
	2	40      42.4	50	-40	1.045	100	1	140     0;
	3	0       23.4	40	0	1.01	100	1	100     0;
	6	0       12.2	24	-6	1.07	100	1	100     0;
	8	0       17.4	24	-6	1.09	100	1	100     0;
];

for g=1:5
    GenP(gen(g,1),1)=gen(g,2)/baseMVA;
    GenQ(gen(g,1),1)=gen(g,3)/baseMVA;
end
    GenP(15,1)=0;
    GenQ(15,1)=0;
    GenP(16,1)=Preg;
    GenQ(16,1)=-Qreg;
    
%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status
branch = [
	1	2	0.01938 0.05917	0.0528	9900	1	1	1       0	1;
	1	5	0.05403	0.22304	0.0492	9900	1	1	1       0	1;
	2	3	0.04699	0.19797	0.0438	9900	1	1	1       0	1;
	2	4	0.05811	0.17632	0.034	9900	1	1	1       0	1;
	2	5	0.05695	0.17388	0.0346	9900	1	1	1       0	1;
	3	4	0.06701	0.17103	0.0128	9900	1	1	1       0	1;
	4	5	0.01335	0.04211	0       9900	0	1	1       1	1;
	4	7	0       0.20912	0       9900	0	0	0.978	0	1;
	4	9	0       0.55618	0       9900	0	0	0.969	0	1;
	5	6	0       0.25202	0       9900	0	0	0.932	0	1;
	6	11	0.09498	0.1989	0       9900	0	1	1       0	1;
	6	12	0.12291	0.25581	0       9900	0	1	1       0	1;
	6	13	0.06615	0.13027	0       9900	0	1	1       0	1;
	7	8	0       0.17615	0       9900	0	0	1       1	1;
	7	9	0       0.11001	0       9900	0	0	1       1	1;
	9	10	0.03181	0.0845	0       9900	0	1	1       0	1;
	9	14	0.12711	0.27038	0       9900	0	0	1       0	1;
	10	11	0.08205	0.19207	0       9900	0	0	1       0	1;
	12	13	0.22092	0.19988	0       9900	0	0	1       0	1;
	13	14	0.17093	0.34802	0       9900	0	0	1       0	1;
];


Y=zeros(n,n);
for b=1:19
    Y=AddLine(Y,branch(b,1),branch(b,2),branch(b,3)*1i,branch(b,4)*1i,branch(b,5)*1i,branch(b,9)*exp(-1i*(pi/180)*branch(b,10)));
end

Y=AddLine(Y,13,15,0      ,0.01*1j,0,1);
Y=AddLine(Y,14,16,0.17093,0.01*1j,0,1);


%%
NetP=GenP-LoadP;
NetQ=GenQ-LoadQ;
Ym=zeros(n,n);
Yp=zeros(n,n);
maxiter=7;

PowerMeasurements1=[];
PowerMeasurements2=[];
PhaseMeasurements=[];
MagnitudeMeasurements=[];


for t=1:n
    for k=1:n
        Ym(t,k)=abs(Y(t,k));
        Yp(t,k)=phase(Y(t,k));
    end
end

%%    
for iteration=1:maxiter


    J1=zeros(n-1,n-1);
    J2=zeros(n-1,n-1);
    J3=zeros(n-1,n-1);
    J4=zeros(n-1,n-1);
    DeltaP=zeros(n-1,1);
    DeltaQ=zeros(n-1,1);
    DeltaPowers =zeros(2*(n-1),1);
    CalcP=zeros(n,1);
    CalcQ=zeros(n,1);
    for x=1:n
        P=0;
        Q=0;
        for k=1:n
            P=P+abs(Vm(x))*abs(Y(x,k))*abs(Vm(k))*cos(phase(Y(x,k))-(Vp(x))+(Vp(k)));
            Q=Q-abs(Vm(x))*abs(Y(x,k))*abs(Vm(k))*sin(phase(Y(x,k))-(Vp(x))+(Vp(k)));
        end
        CalcP(x,1)=P;
        CalcQ(x,1)=Q;
    end


    DeltaP=NetP-CalcP;
    DeltaP=DeltaP(2:n,1);
    DeltaQ=NetQ-CalcQ;
    DeltaQ=DeltaQ(2:n,1);
    DeltaPowers=[DeltaP;DeltaQ];

    for y=2:n
        for o=2:n
            if (y==o)
                for k=1:n
                    if (k~=y)
                        J1(y-1,o-1)=J1(y-1,o-1)+abs(Vm(y))*abs(Y(y,k))*abs(Vm(k))*sin(phase(Y(y,k))-(Vp(y))+(Vp(k)));
                        J2(y-1,o-1)=J2(y-1,o-1)+           abs(Y(y,k))*abs(Vm(k))*cos(phase(Y(y,k))-(Vp(y))+(Vp(k)));
                        J3(y-1,o-1)=J3(y-1,o-1)+abs(Vm(y))*abs(Y(y,k))*abs(Vm(k))*cos(phase(Y(y,k))-(Vp(y))+(Vp(k)));
                        J4(y-1,o-1)=J4(y-1,o-1)-           abs(Y(y,k))*abs(Vm(k))*sin(phase(Y(y,k))-(Vp(y))+(Vp(k)));
                    else
                        J1(y-1,o-1)=J1(y-1,o-1)+0;
                        J2(y-1,o-1)=J2(y-1,o-1)+2*abs(Y(y,k))*abs(Vm(k))*cos(phase(Y(y,k))-(Vp(y))+(Vp(k)));
                        J3(y-1,o-1)=J3(y-1,o-1)+0;
                        J4(y-1,o-1)=J4(y-1,o-1)-2*abs(Y(y,k))*abs(Vm(k))*sin(phase(Y(y,k))-(Vp(y))+(Vp(k)));
                    end
                end
            else
                J1(y-1,o-1)=J1(y-1,o-1)-abs(Vm(y))*abs(Y(y,o))*abs(Vm(o))*sin(phase(Y(y,o))-(Vp(y))+(Vp(o)));
                J2(y-1,o-1)=J2(y-1,o-1)+           abs(Y(y,o))*abs(Vm(o))*cos(phase(Y(y,o))-(Vp(y))+(Vp(o)));
                J3(y-1,o-1)=J3(y-1,o-1)-abs(Vm(y))*abs(Y(y,o))*abs(Vm(o))*cos(phase(Y(y,o))-(Vp(y))+(Vp(o)));
                J4(y-1,o-1)=J4(y-1,o-1)-           abs(Y(y,o))*abs(Vm(o))*sin(phase(Y(y,o))-(Vp(y))+(Vp(o)));
            end
        end
    end
   
    J=[J1 J2;J3 J4];

    for b=1:(2*(n-1))
        J(b,n)=0;
        J(b,n+1)=0;
        J(b,n+4)=0;
        J(b,n+6)=0;
        J(b,2*(n-1)-1)=0;
    end
    
    J(n,n)=1;
    J(n+1,n+1)=1;
    J(n+4,n+4)=1;
    J(n+6,n+6)=1;
    J(2*(n-1)-1,2*(n-1)-1)=1;
    
    DeltaVoltage=inv(J)*DeltaPowers;
%     iteration
%     Vm
%     Vp
%     Y
%     CalcP
%     CalcQ
%     J
%     inv(J)
%     DeltaPowers
%     DeltaVoltage

        PowerMeasurements1(iteration)=CalcP(n-1,1);
        PowerMeasurements2(iteration)=CalcQ(n,1);
        PhaseMeasurements(iteration)=Vp(n-1)*(180/pi);
        MagnitudeMeasurements(iteration)=Vm(n);

    
        Vp=Vp+[0; DeltaVoltage(1:n-1,1)];
        Vm=Vm+[0;0;0;DeltaVoltage(n+2,1);DeltaVoltage(n+3,1);0;DeltaVoltage(n+5,1);0;DeltaVoltage((n+7),1);DeltaVoltage((n+8),1);DeltaVoltage((n+9),1);DeltaVoltage((n+10),1);0;DeltaVoltage((n+12),1);0;DeltaVoltage((n+14),1)];
        GenP(2,1)=CalcP(2,1)+LoadP(2,1);
        GenP(3,1)=CalcP(3,1)+LoadP(3,1);
        GenP(6,1)=CalcP(6,1)+LoadP(6,1);
        GenP(8,1)=CalcP(8,1)+LoadP(8,1);
        GenQ(2,1)=CalcQ(2,1)+LoadQ(2,1);
        GenQ(3,1)=CalcQ(3,1)+LoadQ(3,1);
        GenQ(6,1)=CalcQ(6,1)+LoadQ(6,1);
        GenQ(8,1)=CalcQ(8,1)+LoadQ(8,1);
        LoadQ(n-1,1)=-CalcQ(n-1,1);
end

%%
subplot(2,2,1);
plot(PowerMeasurements1);title('Rectifier Real Power');
xlabel('Iteration Number');
subplot(2,2,2);
plot(PowerMeasurements2);title('Inverter Reactive Power');
xlabel('Iteration Number');
subplot(2,2,3);
plot(PhaseMeasurements);title('Rectifier Voltage Phase');
xlabel('Iteration Number');
subplot(2,2,4);
plot(MagnitudeMeasurements);title('Inverter Voltage Magnitude');
xlabel('Iteration Number');
