% %base case
% r12=0.02;
% r13=0.08;
% r14=0;
% r15=0;
% r23=0.06;
% r24=0.06;
% r25=0.04;
% r34=0.01;
% r35=0;
% r45=0.08;
% 
% x12=1i*0.06;
% x13=1i*0.24;
% x14=1i*0;
% x15=1i*0;
% x23=1i*0.18;
% x24=1i*0.18;
% x25=1i*0.12;
% x34=1i*0.03;
% x35=1i*0;
% x45=1i*0.24;
% 
% b12=1i*0.06;
% b13=1i*0.05;
% b14=0;
% b15=0;
% b23=1i*0.04;
% b24=1i*0.04;
% b25=1i*0.03;
% b34=1i*0.02;
% b35=0;
% b45=1i*0.05;
% 
% Y=[
%     (1/(r12+x12))+(b12/2)+(1/(r13+x13))+(b13/2), (-1/(r12+x12)), (-1/(r13+x13)), 0, 0;
%     (-1/(r12+x12)), (1/(r12+x12))+(b12/2)+(1/(r23+x23))+(b23/2)+(1/(r24+x24))+(b24/2)+(1/(r25+x25))+(b25/2), (-1/(r23+x23)), (-1/(r24+x24)), (-1/(r25+x25));
%     (-1/(r13+x13)), (-1/(r23+x23)), (1/(r13+x13))+(b13/2)+(1/(r23+x23))+(b23/2)+(1/(r34+x34))+(b34/2), (-1/(r34+x34)), 0;
%     0, (-1/(r24+x24)), (-1/(r34+x34)), (1/(r24+x24))+(b24/2)+(1/(r34+x34))+(b34/2)+(1/(r45+x45))+(b45/2), (-1/(r45+x45));
%     0, (-1/(r25+x25)), 0, (-1/(r45+x45)), (1/(r25+x25))+(b25/2)+(1/(r45+x45))+(b45/2);
%     ];
% 
% 
% n=5;
% GenP=[0;0.4;0;0;0];
% GenQ=[0;0;0;0;0];
% LoadP=[0;.20;.45;.40;.60];
% LoadQ=[0;.10;.15;.05;.10];
% NetP=GenP-LoadP;
% NetQ=GenQ-LoadQ;
% Vm=[1.06;1;1;1;1];
% Vp=[0;0;0;0;0];
% Ym=zeros(n,n);
% Yp=zeros(n,n);
% maxiter=10;
% 
% 
% for t=1:n
%     for k=1:n
%         Ym(t,k)=abs(Y(t,k));
%         Yp(t,k)=phase(Y(t,k));
%     end
% end
% 
%     
% for iteration=1:maxiter
% 
% 
%     J1=zeros(n-1,n-1);
%     J2=zeros(n-1,n-1);
%     J3=zeros(n-1,n-1);
%     J4=zeros(n-1,n-1);
%     DeltaP=zeros(n-1,1);
%     DeltaQ=zeros(n-1,1);
%     DeltaPowers =zeros(2*(n-1),1);
%     CalcP=zeros(n,1);
%     CalcQ=zeros(n,1);
%     for x=1:n
%         P=0;
%         Q=0;
%         for k=1:n
%             P=P+abs(Vm(x))*abs(Y(x,k))*abs(Vm(k))*cos(phase(Y(x,k))-(Vp(x))+(Vp(k)));
%             Q=Q-abs(Vm(x))*abs(Y(x,k))*abs(Vm(k))*sin(phase(Y(x,k))-(Vp(x))+(Vp(k)));
%         end
%         CalcP(x,1)=P;
%         CalcQ(x,1)=Q;
%     end
% 
% 
%     DeltaP=NetP-CalcP;
%     DeltaP=DeltaP(2:n,1);
%     DeltaQ=NetQ-CalcQ;
%     DeltaQ=DeltaQ(2:n,1);
%     DeltaPowers=[DeltaP;DeltaQ];
% 
%     for y=2:n
%         for o=2:n
%             if (y==o)
%                 for k=1:n
%                     if (k~=y)
%                         J1(y-1,o-1)=J1(y-1,o-1)+abs(Vm(y))*abs(Y(y,k))*abs(Vm(k))*sin(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                         J2(y-1,o-1)=J2(y-1,o-1)+           abs(Y(y,k))*abs(Vm(k))*cos(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                         J3(y-1,o-1)=J3(y-1,o-1)+abs(Vm(y))*abs(Y(y,k))*abs(Vm(k))*cos(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                         J4(y-1,o-1)=J4(y-1,o-1)-           abs(Y(y,k))*abs(Vm(k))*sin(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                     else
%                         J1(y-1,o-1)=J1(y-1,o-1)+0;
%                         J2(y-1,o-1)=J2(y-1,o-1)+2*abs(Y(y,k))*abs(Vm(k))*cos(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                         J3(y-1,o-1)=J3(y-1,o-1)+0;
%                         J4(y-1,o-1)=J4(y-1,o-1)-2*abs(Y(y,k))*abs(Vm(k))*sin(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                     end
%                 end
%             else
%                 J1(y-1,o-1)=J1(y-1,o-1)-abs(Vm(y))*abs(Y(y,o))*abs(Vm(o))*sin(phase(Y(y,o))-(Vp(y))+(Vp(o)));
%                 J2(y-1,o-1)=J2(y-1,o-1)+           abs(Y(y,o))*abs(Vm(o))*cos(phase(Y(y,o))-(Vp(y))+(Vp(o)));
%                 J3(y-1,o-1)=J3(y-1,o-1)-abs(Vm(y))*abs(Y(y,o))*abs(Vm(o))*cos(phase(Y(y,o))-(Vp(y))+(Vp(o)));
%                 J4(y-1,o-1)=J4(y-1,o-1)-           abs(Y(y,o))*abs(Vm(o))*sin(phase(Y(y,o))-(Vp(y))+(Vp(o)));
%             end
%         end
%     end
%     
%     J2(1,1)=0;
%     J2(2,1)=0;
%     J2(3,1)=0;
%     J2(4,1)=0;
%     J4(1,1)=1;
%     J4(2,1)=0;
%     J4(3,1)=0;
%     J4(4,1)=0;
%     
%     J=[J1 J2;J3 J4];
%     DeltaVoltage=inv(J)*DeltaPowers;
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
% 
%     Vp=Vp+[0; DeltaVoltage(1:n-1,1)];
%     Vm=Vm+[0;0; DeltaVoltage((n+1):(2*(n-1)),1);];
%     GenQ(2,1)=GenQ(2,1)+DeltaVoltage(n,1);
% 
% end



























%HVDC Light
% clc;clear all;
% % it=1;
% % Vvr1=1.005;
% % Vvr2=1;
% % Vpvr1=0.1;
% % Vpvr2=1.71*(pi/180);
% % Gvr1=0;
% % Gvr2=0;
% % Vm=[1.036;1.029;1;1.006;0.999];
% % Vp=[0;-0.0245;-0.0818;-0.0625; -0.0824];
% % hold on;
% % for bvr1=-0.1:0.0001:0.1
% % y1(it)=-abs(Vvr1)*abs(Vm(3))*(bvr1*sin(Vpvr1-Vp(3)));
% % y2(it)=-abs(Vvr2)*abs(Vm(4))*(bvr1*sin(Vpvr2-Vp(4)));
% % it=it+1;    
% % end
% % plot(-0.1:0.0001:0.1,y1);
% % plot(-0.1:0.0001:0.1,y2);
% 
% r12=0.02;
% r13=0.08;
% r14=0;
% r15=0;
% r23=0.06;
% r24=0.06;
% r25=0.04;
% r34=0.01;
% r35=0;
% r45=0.08;
% 
% x12=1i*0.06;
% x13=1i*0.24;
% x14=1i*0;
% x15=1i*0;
% x23=1i*0.18;
% x24=1i*0.18;
% x25=1i*0.12;
% x34=1i*0.03;
% x35=1i*0;
% x45=1i*0.24;
% 
% b12=1i*0.06;
% b13=1i*0.05;
% b14=0;
% b15=0;
% b23=1i*0.04;
% b24=1i*0.04;
% b25=1i*0.03;
% b34=1i*0.02;
% b35=0;
% b45=1i*0.05;
% 
% PowerMeasurements=[];
% PhaseMeasurements=[];
% MagnitudeMeasurements=[];
% 
% Y=[
%     (1/(r12+x12))+(b12/2)+(1/(r13+x13))+(b13/2), (-1/(r12+x12)), (-1/(r13+x13)), 0, 0;
%     (-1/(r12+x12)), (1/(r12+x12))+(b12/2)+(1/(r23+x23))+(b23/2)+(1/(r24+x24))+(b24/2)+(1/(r25+x25))+(b25/2), (-1/(r23+x23)), (-1/(r24+x24)), (-1/(r25+x25));
%     (-1/(r13+x13)), (-1/(r23+x23)), (1/(r13+x13))+(b13/2)+(1/(r23+x23))+(b23/2)+(1/(r34+x34))+(b34/2), (-1/(r34+x34)), 0;
%     0, (-1/(r24+x24)), (-1/(r34+x34)), (1/(r24+x24))+(b24/2)+(1/(r34+x34))+(b34/2)+(1/(r45+x45))+(b45/2), (-1/(r45+x45));
%     0, (-1/(r25+x25)), 0, (-1/(r45+x45)), (1/(r25+x25))+(b25/2)+(1/(r45+x45))+(b45/2);
%     ];
% 
% 
% n=5;
% GenP=[0;0.8847;0;0;0];
% GenQ=[0;0;0;0;0];
% LoadP=[0;.20;.45;.40;.60];
% LoadQ=[0;.10;.15;.05;.10];
% NetP=GenP-LoadP;
% NetQ=GenQ-LoadQ;
% Vm=[1.036;1.029;1;1.006;0.999];
% Vp=[0;-0.0245;-0.0818;-0.0625; -0.0824];
% Ym=zeros(n,n);
% Yp=zeros(n,n);
% Vvr1=1.005;
% Vvr2=1.001;
% Vpvr1=0.1066;
% Vpvr2=1.71*(pi/180);
% % Bvr1=-0.0275;
% % Bvr2=-0.055;
% Bvr1=-1.350;
% Bvr2=-2.70;
% 
% Gvr1=0;
% Gvr2=0;
% maxiter=10;
% 
% 
% for t=1:n
%     for k=1:n
%         Ym(t,k)=abs(Y(t,k));
%         Yp(t,k)=phase(Y(t,k));
%     end
% end
% 
%     
% for iteration=1:maxiter
% 
% 
%     J1=zeros(n-1,n-1);
%     J2=zeros(n-1,n-1);
%     J3=zeros(n-1,n-1);
%     J4=zeros(n-1,n-1);
%     
%     DeltaP=zeros(n-1,1);
%     DeltaQ=zeros(n-1,1);
%     DeltaPowers =zeros(2*(n-1),1);
%     CalcP=zeros(n,1);
%     CalcQ=zeros(n,1);
%     for x=1:n
%         P=0;
%         Q=0;
%         for k=1:n
%             P=P+abs(Vm(x))*abs(Y(x,k))*abs(Vm(k))*cos(phase(Y(x,k))-(Vp(x))+(Vp(k)));
%             Q=Q-abs(Vm(x))*abs(Y(x,k))*abs(Vm(k))*sin(phase(Y(x,k))-(Vp(x))+(Vp(k)));
%         end
%         CalcP(x,1)=P;
%         CalcQ(x,1)=Q;
%     end
% 
%     CalcP(3,1)=CalcP(3,1)-abs(Vm(3))*abs(Y(3,4))*abs(Vm(4))*cos(phase(Y(3,4))-(Vp(3))+(Vp(4)));
%     CalcP(4,1)=CalcP(4,1)-abs(Vm(4))*abs(Y(4,3))*abs(Vm(3))*cos(phase(Y(4,3))-(Vp(4))+(Vp(3)));
%     CalcQ(3,1)=CalcQ(3,1)+abs(Vm(3))*abs(Y(3,4))*abs(Vm(4))*sin(phase(Y(3,4))-(Vp(3))+(Vp(4)));
%     CalcQ(4,1)=CalcQ(4,1)+abs(Vm(4))*abs(Y(4,3))*abs(Vm(3))*sin(phase(Y(4,3))-(Vp(4))+(Vp(3)));
% 
%     CalcP(3,1)=CalcP(3,1)+abs(Vm(3))*abs(Vm(3))*Gvr1-abs(Vm(3))*abs(Vvr1)*(Gvr1*cos(Vp(3)-Vpvr1)+Bvr1*sin(Vp(3)-Vpvr1));
%     CalcP(4,1)=CalcP(4,1)+abs(Vm(4))*abs(Vm(4))*Gvr2-abs(Vm(4))*abs(Vvr2)*(Gvr2*cos(Vp(4)-Vpvr2)+Bvr2*sin(Vp(4)-Vpvr2));
%     CalcQ(3,1)=CalcQ(3,1)-abs(Vm(3))*abs(Vm(3))*Bvr1-abs(Vm(3))*abs(Vvr1)*(Gvr1*sin(Vp(3)-Vpvr1)-Bvr1*cos(Vp(3)-Vpvr1));
%     CalcQ(4,1)=CalcQ(4,1)-abs(Vm(4))*abs(Vm(4))*Bvr2-abs(Vm(4))*abs(Vvr2)*(Gvr2*sin(Vp(4)-Vpvr2)-Bvr2*cos(Vp(4)-Vpvr2));
%     
%     Pbb=abs(Vvr1)*abs(Vvr1)*Gvr1-abs(Vvr1)*abs(Vm(3))*(Gvr1*cos(Vpvr1-Vp(3))+Bvr1*sin(Vpvr1-Vp(3)))-abs(Vvr2)*abs(Vvr2)*Gvr2+abs(Vvr2)*abs(Vm(4))*(Gvr2*cos(Vpvr2-Vp(4))+Bvr2*sin(Vpvr2-Vp(4)));
%     
%     %Prec
%     abs(Vvr1)*abs(Vvr1)*Gvr1-abs(Vvr1)*abs(Vm(3))*(Gvr1*cos(Vpvr1-Vp(3))+Bvr1*sin(Vpvr1-Vp(3)))
%     %Pinv
%     abs(Vvr2)*abs(Vvr2)*Gvr2-abs(Vvr2)*abs(Vm(4))*(Gvr2*cos(Vpvr2-Vp(4))+Bvr2*sin(Vpvr2-Vp(4)))
%     %Qrec
%     -abs(Vm(3))*abs(Vm(3))*Bvr1-abs(Vm(3))*abs(Vvr1)*(Gvr1*sin(Vp(3)-Vpvr1)-Bvr1*cos(Vp(3)-Vpvr1))
%     %Qinv
%     -abs(Vm(4))*abs(Vm(4))*Bvr2-abs(Vm(4))*abs(Vvr2)*(Gvr2*sin(Vp(4)-Vpvr2)-Bvr2*cos(Vp(4)-Vpvr2))
%     
%     DeltaP=NetP-CalcP;
%     DeltaP=DeltaP(2:n,1);
%     DeltaQ=NetQ-CalcQ;
%     DeltaQ=DeltaQ(2:n,1);
%     DeltaPowers=[DeltaP;DeltaQ;Pbb];
% 
%     for y=2:n
%         for o=2:n
%             if (y==o)
%                 for k=1:n
%                     if (k~=y)
%                         if ((y==3 && k==3)||(y==4 && k==4)||(y==3 && k==4)||(y==4 && k==3))
%                         else
%                         J1(y-1,o-1)=J1(y-1,o-1)+abs(Vm(y))*abs(Y(y,k))*abs(Vm(k))*sin(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                         J2(y-1,o-1)=J2(y-1,o-1)+           abs(Y(y,k))*abs(Vm(k))*cos(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                         J3(y-1,o-1)=J3(y-1,o-1)+abs(Vm(y))*abs(Y(y,k))*abs(Vm(k))*cos(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                         J4(y-1,o-1)=J4(y-1,o-1)-           abs(Y(y,k))*abs(Vm(k))*sin(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                         end
%                     else
%                         if ((y==3 && k==3)||(y==4 && k==4)||(y==3 && k==4)||(y==4 && k==3))
%                         else
%                         J1(y-1,o-1)=J1(y-1,o-1)+0;
%                         J2(y-1,o-1)=J2(y-1,o-1)+2*abs(Y(y,k))*abs(Vm(k))*cos(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                         J3(y-1,o-1)=J3(y-1,o-1)+0;
%                         J4(y-1,o-1)=J4(y-1,o-1)-2*abs(Y(y,k))*abs(Vm(k))*sin(phase(Y(y,k))-(Vp(y))+(Vp(k)));
%                         end
%                     end
%                 end
%             else
%                 if ((y==3 && k==3)||(y==4 && k==4)||(y==3 && k==4)||(y==4 && k==3))
%                 else
%                 J1(y-1,o-1)=J1(y-1,o-1)-abs(Vm(y))*abs(Y(y,o))*abs(Vm(o))*sin(phase(Y(y,o))-(Vp(y))+(Vp(o)));
%                 J2(y-1,o-1)=J2(y-1,o-1)+           abs(Y(y,o))*abs(Vm(o))*cos(phase(Y(y,o))-(Vp(y))+(Vp(o)));
%                 J3(y-1,o-1)=J3(y-1,o-1)-abs(Vm(y))*abs(Y(y,o))*abs(Vm(o))*cos(phase(Y(y,o))-(Vp(y))+(Vp(o)));
%                 J4(y-1,o-1)=J4(y-1,o-1)-           abs(Y(y,o))*abs(Vm(o))*sin(phase(Y(y,o))-(Vp(y))+(Vp(o)));
%                 end
%             end
%         end
%     end
%     
%     J2(1,1)=0;
%     J2(2,1)=0;
%     J2(3,1)=0;
%     J2(4,1)=0;
%     J4(1,1)=1;
%     J4(2,1)=0;
%     J4(3,1)=0;
%     J4(4,1)=0;
%     
%     J=[J1 J2;J3 J4];
% 
%     for h=1:8
%        % J(h,6)=J(h,7);
%         J(h,7)=J(h,8);
%         J(h,8)=0;
%     end
% 
%     %P3p3
%     J(2,2)=                -abs(Vm(3))*abs(Vvr1)*(-Gvr1*sin(Vp(3)-Vpvr1)+Bvr1*cos(Vp(3)-Vpvr1));
%     %P3p4
%     J(2,3)=0;
%     %P3m3
%     %J(2,6)=2*abs(Vm(3))*Gvr1-           abs(Vvr1)*(Gvr1*cos(Vp(3)-Vpvr1)+Bvr1*sin(Vp(3)-Vpvr1));
%     %P3m4
%     J(2,6)=0;
%   %P3pvr1
%   J(2,8)=                 -abs(Vm(3))*abs(Vvr1)*(Gvr1*sin(Vp(3)-Vpvr1)-Bvr1*cos(Vp(3)-Vpvr1));
%   %P3pvr2
%   %J(2,9)=0; 
%   %P3mvr1
%   %J(2,9)=                 -abs(Vm(3))*          (Gvr1*cos(Vp(3)-Vpvr1)+Bvr1*sin(Vp(3)-Vpvr1));
%   %P3mvr2
%   J(2,9)=0; 
%   
%  
%     %P4p3
%     J(3,2)=0;
%     %P4p4
%     J(3,3)=                -abs(Vm(4))*abs(Vvr2)*(-Gvr2*sin(Vp(4)-Vpvr2)+Bvr1*cos(Vp(4)-Vpvr2));
%     %P4m3
%     %J(3,6)=0;
%     %P4m4
%     J(3,6)=2*abs(Vm(4))*Gvr2-           abs(Vvr2)*(Gvr2*cos(Vp(4)-Vpvr2)+Bvr2*sin(Vp(4)-Vpvr2));
%   %P4pvr1
%   J(3,8)=0;
%   %P4pvr2
%   %J(3,9)=                -abs(Vm(4))*abs(Vvr2)*(Gvr2*sin(Vp(4)-Vpvr2)-Bvr2*cos(Vp(4)-Vpvr2)); 
%   %P4mvr1
%   %J(3,9)=0;
%   %P4mvr2
%   J(3,9)=                 -abs(Vm(4))*          (Gvr2*cos(Vp(4)-Vpvr2)+Bvr2*sin(Vp(4)-Vpvr2)); 
%   
%  
%     %Q3p3
%     J(6,2)=                 -abs(Vm(3))*abs(Vvr1)*(Gvr1*cos(Vp(3)-Vpvr1)+Bvr1*sin(Vp(3)-Vpvr1));
%     %Q3p4
%     J(6,3)=0;
%     %Q3m3
%     %J(6,6)=2*abs(Vm(3))*Gvr1-abs(Vvr1)*           (Gvr1*cos(Vp(3)-Vpvr1)+Bvr1*sin(Vp(3)-Vpvr1));
%     %Q3m4
%     J(6,6)=0;
%   %Q3pvr1
%   J(6,8)=                -abs(Vm(3))*abs(Vvr1)*(-Gvr1*cos(Vp(3)-Vpvr1)-Bvr1*sin(Vp(3)-Vpvr1));
%   %Q3pvr2
%   %J(6,9)=0;
%   %Q3mvr1
%   %J(6,9)=                -abs(Vm(3))*           (Gvr1*sin(Vp(3)-Vpvr1)-Bvr1*cos(Vp(3)-Vpvr1));
%   %Q3mvr2
%   J(6,9)=0;      
% 
%     %Q4p3
%     J(7,2)=0;
%     %Q4p4
%     J(7,3)=                 -abs(Vm(4))*abs(Vvr2)*(Gvr2*cos(Vp(4)-Vpvr2)+Bvr2*sin(Vp(4)-Vpvr2));
%     %Q4m3
%     %J(7,6)=0;
%     %Q4m4
%     J(7,6)=2*abs(Vm(4))*Bvr2-           abs(Vvr2)*(Gvr2*sin(Vp(4)-Vpvr2)-Bvr2*cos(Vp(4)-Vpvr2));
%   %Q4pvr1
%   J(7,8)=0;
%   %Q4pvr2
%   %J(7,9)=                -abs(Vm(4))*abs(Vvr2)*(-Gvr2*cos(Vp(4)-Vpvr2)-Bvr2*sin(Vp(4)-Vpvr2));
%   %Q4mvr1
%   %J(7,9)=0;
%   %Q4mvr2
%   J(7,9)=                -abs(Vm(4))*           (Gvr2*sin(Vp(4)-Vpvr2)-Bvr2*cos(Vp(4)-Vpvr2));      
%   
% 
%   %Pbbp3
%   J(9,2)=-abs(Vvr1)*abs(Vm(3))*(Gvr1*sin(Vpvr1-Vp(3))-Bvr1*cos(Vpvr1-Vp(3)));
%   %Pbbp4
%   J(9,3)=                                                                    +abs(Vvr2)*abs(Vm(4))*(Gvr2*sin(Vpvr2-Vp(4))-Bvr2*cos(Vpvr2-Vp(4)));
%   %Pbbm3
%   %J(9,6)=+           abs(Vvr1)*(Gvr1*cos(Vp(3)-Vpvr1)+Bvr1*sin(Vp(3)-Vpvr1));
%   %Pbbm4
%   J(9,6)=                                                                    +abs(Vvr2)            *(Gvr2*cos(Vpvr2-Vp(4))+Bvr2*sin(Vpvr2-Vp(4)));
% %Pbbpvr1
% J(9,8)=-abs(Vvr1)*abs(Vm(3))*(-Gvr1*sin(Vpvr1-Vp(3))+Bvr1*cos(Vpvr1-Vp(3)));
% %Pbbpvr2
% %J(9,9)=                                                                     +abs(Vm(4))*abs(Vvr2)*(Gvr2*sin(Vp(4)-Vpvr2)-Bvr2*cos(Vp(4)-Vpvr2));
% %Pbbmvr1
% %J(9,9)=+abs(Vm(3))          *(Gvr1*cos(Vp(3)-Vpvr1)+Bvr1*sin(Vp(3)-Vpvr1));
% %Pbbmvr2
% J(9,9)=                                                     -2*abs(Vvr2)*Gvr2+          abs(Vm(4))*(Gvr2*cos(Vpvr2-Vp(4))+Bvr2*sin(Vpvr2-Vp(4)));
% 
%     
%     DeltaVoltage=inv(J)*DeltaPowers;
% %     iteration
% %     Vm
% %     Vp
% %     Y
% %     CalcP
% %     CalcQ
% %     J
% %     inv(J)
% %     DeltaPowers
% %     DeltaVoltage
% 
%     PowerMeasurements(iteration)=abs(Vvr1)*abs(Vvr1)*Gvr1-abs(Vvr1)*abs(Vm(3))*(Gvr1*cos(Vpvr1-Vp(3))+Bvr1*sin(Vpvr1-Vp(3)));
%     PhaseMeasurements(iteration)=Vpvr1;
%     MagnitudeMeasurements(iteration)=Vvr2;
% 
%     
%     %Vp=Vp+[0; DeltaVoltage(1:n-1,1)];
%     %Vm=Vm+[0;0;0;0; DeltaVoltage(n+2,1);];
%     Vpvr1=Vpvr1-DeltaVoltage(8,1);
%     Vvr2=Vvr2+DeltaVoltage(9,1);
%     GenQ(2,1)=GenQ(2,1)+DeltaVoltage(n,1);
% 
% end
% 
% subplot(3,1,1);
% plot(PowerMeasurements);title('Rectifier Power');
% subplot(3,1,2);
% plot(PhaseMeasurements);title('Inverter Voltage Phase');
% subplot(3,1,3);
% plot(MagnitudeMeasurements);title('Rectifier Voltage Magnitude');




























%HVDC Light
clc;clear all;
r12=0.02;
r13=0.08;
r14=0;
r15=0;
r16=0;
r17=0;
r23=0.06;
r24=0.06;
r25=0.04;
r26=0;
r27=0;
%r34=0.01;
r34=0;
r35=0;
r36=0;
r37=0;
r45=0.08;
r46=0;
%r47=0.01;
r47=0.0094;
r56=0;
r57=0;
r67=0;

x12=1i*0.06;
x13=1i*0.24;
x14=1i*0;
x15=1i*0;
x16=1i*0;
x17=1i*0;
x23=1i*0.18;
x24=1i*0.18;
x25=1i*0.12;
x26=1i*0;
x27=1i*0;
%x34=1i*0.03;
x34=1i*0;
x35=1i*0;
x36=-1i*0.753;
x37=1i*0;
x45=1i*0.24;
x46=1i*0;
% x47=-1i*0.01193;
x47=-1i*0.0000002;
x56=1i*0;
x57=1i*0;
x67=1i*0;

b12=1i*0.06;
b13=1i*0.05;
b14=0;
b15=0;
b16=0;
b17=0;
b23=1i*0.04;
b24=1i*0.04;
b25=1i*0.03;
b26=1i*0;
b27=1i*0;
%b34=1i*0.02;
b34=0;
b35=0;
b36=0;
b37=0;
b45=1i*0.05;
b46=0;
b47=0;
b56=0;
b57=0;
b67=0;


% Z=[
%     (1/(r12+x12))+(b12/2)+(1/(r13+x13))+(b13/2), (-1/(r12+x12)), (-1/(r13+x13)), 0, 0;
%     (-1/(r12+x12)), (1/(r12+x12))+(b12/2)+(1/(r23+x23))+(b23/2)+(1/(r24+x24))+(b24/2)+(1/(r25+x25))+(b25/2), (-1/(r23+x23)), (-1/(r24+x24)), (-1/(r25+x25));
%     (-1/(r13+x13)), (-1/(r23+x23)), (1/(r13+x13))+(b13/2)+(1/(r23+x23))+(b23/2)+(1/(r34+x34))+(b34/2), (-1/(r34+x34)), 0;
%     0, (-1/(r24+x24)), (-1/(r34+x34)), (1/(r24+x24))+(b24/2)+(1/(r34+x34))+(b34/2)+(1/(r45+x45))+(b45/2), (-1/(r45+x45));
%     0, (-1/(r25+x25)), 0, (-1/(r45+x45)), (1/(r25+x25))+(b25/2)+(1/(r45+x45))+(b45/2);
%     ];


n=7;
Y=zeros(n,n);
Y=AddLine(Y,1,2,r12,x12,b12);
Y=AddLine(Y,1,3,r13,x13,b13);
Y=AddLine(Y,2,3,r23,x23,b23);
Y=AddLine(Y,2,4,r24,x24,b24);
Y=AddLine(Y,2,5,r25,x25,b25);
Y=AddLine(Y,3,6,r36,x36,b36);
Y=AddLine(Y,4,5,r45,x45,b45);
Y=AddLine(Y,4,7,r47,x47,b47);


GenP=[0;0.8847;0;0;0;0;0.25];
GenQ=[0;0;0;0;0;0;-.06];
LoadP=[0;.20;.45;.40;.60;0.25;0];
LoadQ=[0;.10;.15;.05;.10;0;0];
NetP=GenP-LoadP;
NetQ=GenQ-LoadQ;
Vm=[1.036;1.029;1;1;1;1.005;1];
Vp=[0;0;0;0;0;0;1.71*(pi/180)];
Ym=zeros(n,n);
Yp=zeros(n,n);
maxiter=5;

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
    J2(5,1)=0;
    J2(6,1)=0;
    J4(1,1)=1;
    J4(2,1)=0;
    J4(3,1)=0;
    J4(4,1)=0;
    J4(5,1)=0;
    J4(6,1)=0;
    
    J=[J1 J2;J3 J4];
    J(1,11)=0;
    J(2,11)=0;
    J(3,11)=0;
    J(4,11)=0;
    J(5,11)=0;
    J(6,11)=0;
    J(7,11)=0;
    J(8,11)=0;
    J(9,11)=0;
    J(10,11)=0;
    J(11,11)=1;
    J(12,11)=0;
    
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

        PowerMeasurements1(iteration)=-abs(Vm(6))*abs(Vm(3))*((1/abs(x36))*sin(Vp(6)-Vp(3)));
        PowerMeasurements2(iteration)=NetQ(7,1)-DeltaPowers(12,1);
        PhaseMeasurements(iteration)=Vp(6);
        MagnitudeMeasurements(iteration)=Vm(7);

    
    Vp=Vp+[0; DeltaVoltage(1:n-1,1)];
    Vm=Vm+[0;0;0;DeltaVoltage((n+2),1);DeltaVoltage((n+3),1);0;DeltaVoltage((n+5),1)];
    GenQ(2,1)=GenQ(2,1)+DeltaVoltage(n,1);
    LoadQ(6,1)=LoadQ(6,1)-DeltaVoltage(n+4,1);
end

subplot(4,1,1);
plot(PowerMeasurements1);title('Rectifier Real Power');
subplot(4,1,2);
plot(PowerMeasurements2);title('Inverter Reactive Power');
subplot(4,1,3);
plot(PhaseMeasurements);title('Rectifier Voltage Phase');
subplot(4,1,4);
plot(MagnitudeMeasurements);title('Inverter Voltage Magnitude');
