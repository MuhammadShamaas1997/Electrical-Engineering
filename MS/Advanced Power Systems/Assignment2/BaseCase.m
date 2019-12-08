%base case
clc;clear all;
r12=0.02;
r13=0.08;
r14=0;
r15=0;
r23=0.06;
r24=0.06;
r25=0.04;
r34=0.01;
r35=0;
r45=0.08;

x12=1i*0.06;
x13=1i*0.24;
x14=1i*0;
x15=1i*0;
x23=1i*0.18;
x24=1i*0.18;
x25=1i*0.12;
x34=1i*0.03;
x35=1i*0;
x45=1i*0.24;

b12=1i*0.06;
b13=1i*0.05;
b14=0;
b15=0;
b23=1i*0.04;
b24=1i*0.04;
b25=1i*0.03;
b34=1i*0.02;
b35=0;
b45=1i*0.05;

Y=[
    (1/(r12+x12))+(b12/2)+(1/(r13+x13))+(b13/2), (-1/(r12+x12)), (-1/(r13+x13)), 0, 0;
    (-1/(r12+x12)), (1/(r12+x12))+(b12/2)+(1/(r23+x23))+(b23/2)+(1/(r24+x24))+(b24/2)+(1/(r25+x25))+(b25/2), (-1/(r23+x23)), (-1/(r24+x24)), (-1/(r25+x25));
    (-1/(r13+x13)), (-1/(r23+x23)), (1/(r13+x13))+(b13/2)+(1/(r23+x23))+(b23/2)+(1/(r34+x34))+(b34/2), (-1/(r34+x34)), 0;
    0, (-1/(r24+x24)), (-1/(r34+x34)), (1/(r24+x24))+(b24/2)+(1/(r34+x34))+(b34/2)+(1/(r45+x45))+(b45/2), (-1/(r45+x45));
    0, (-1/(r25+x25)), 0, (-1/(r45+x45)), (1/(r25+x25))+(b25/2)+(1/(r45+x45))+(b45/2);
    ];


n=5;
GenP=[0;0.4;0;0;0];
GenQ=[0;0;0;0;0];
LoadP=[0;.20;.45;.40;.60];
LoadQ=[0;.10;.15;.05;.10];
NetP=GenP-LoadP;
NetQ=GenQ-LoadQ;
Vm=[1.06;1;1;1;1];
Vp=[0;0;0;0;0];
Ym=zeros(n,n);
Yp=zeros(n,n);
maxiter=7;

VoltageMagnitudes=[];
VoltagePhases=[];
BusActivePowers=[];
BusReactivePowers=[];

for t=1:n
    for k=1:n
        Ym(t,k)=abs(Y(t,k));
        Yp(t,k)=phase(Y(t,k));
    end
end

    
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
    
    J2(1,1)=0;
    J2(2,1)=0;
    J2(3,1)=0;
    J2(4,1)=0;
    J4(1,1)=1;
    J4(2,1)=0;
    J4(3,1)=0;
    J4(4,1)=0;
    
    J=[J1 J2;J3 J4];
    DeltaVoltage=inv(J)*DeltaPowers;
    iteration
    Vm
    Vp
    Y
    CalcP
    CalcQ
    J
    inv(J)
    DeltaPowers
    DeltaVoltage
    
    VoltageMagnitudes(:,iteration)=Vm;
    VoltagePhases(:,iteration)=Vp;
    BusActivePowers(:,iteration)=CalcP;
    BusReactivePowers(:,iteration)=CalcQ;
    
    Vp=Vp+[0; DeltaVoltage(1:n-1,1)];
    Vm=Vm+[0;0; DeltaVoltage((n+1):(2*(n-1)),1);];
    GenQ(2,1)=GenQ(2,1)+DeltaVoltage(n,1);

end


s1=subplot(2,2,1);
plot(1:maxiter,VoltageMagnitudes(2,:),1:maxiter,VoltageMagnitudes(3,:),1:maxiter,VoltageMagnitudes(4,:),1:maxiter,VoltageMagnitudes(5,:));
title('Bus Voltage Magnitudes');
xlabel('Iteration Number');
legend('South','Lake','Main','Elm');

subplot(2,2,2);
plot(VoltagePhases(n,:));
plot(1:maxiter,VoltagePhases(2,:),1:maxiter,VoltagePhases(3,:),1:maxiter,VoltagePhases(4,:),1:maxiter,VoltagePhases(5,:));
title('Bus Voltage Phases');
xlabel('Iteration Number');
legend('South','Lake','Main','Elm');

subplot(2,2,3);
plot(1:maxiter,BusActivePowers(2,:),1:maxiter,BusActivePowers(3,:),1:maxiter,BusActivePowers(4,:),1:maxiter,BusActivePowers(5,:));
title('Bus Active Powers');
xlabel('Iteration Number');
legend('South','Lake','Main','Elm');

subplot(2,2,4);
plot(1:maxiter,BusReactivePowers(2,:),1:maxiter,BusReactivePowers(3,:),1:maxiter,BusReactivePowers(4,:),1:maxiter,BusReactivePowers(5,:));
title('Bus Reactive Powers');
xlabel('Iteration Number');
legend('South','Lake','Main','Elm');
