Xls_pu=0.09231;
Xm_pu=3.95279;
Xs_pu=Xls_pu+Xm_pu;
Xlr_pu=0.09955;
Xr_pu=Xlr_pu+Xm_pu;
Rs_pu=0.00488;
Rr_pu=0.00549;
P=6;
f=60;
wb=2*pi*f;
ws=wb;
%%((120*f)/P)*(2*pi/60);
wr=P*ws;
H=3.5;
B=inv([
    (Xs_pu/wb) 0          0           (Xm_pu/wb) 0          0;
    0          (Xs_pu/wb) 0           0          (Xm_pu/wb) 0;
    0          0          (Xls_pu/wb) 0          0          0;
    (Xm_pu/wb) 0          0           (Xr_pu/wb) 0          0;
    0          (Xm_pu/wb) 0           0          (Xr_pu/wb) 0;
    0          0          0           0          0          (Xlr_pu/wb)
    ]);

Z=[
    Rs_pu              ((ws/wb)*Xs_pu)   0     0                  ((ws/wb)*Xm_pu)   0;
    -((ws/wb)*Xs_pu)   Rs_pu             0     -((ws/wb)*Xm_pu)   0                 0;
    0                  0                 Rs_pu 0                  0                 0;
    0                  (((ws)/wb)*Xm_pu) 0     Rr_pu              (((ws)/wb)*Xr_pu) 0;
    -(((ws)/wb)*Xm_pu) 0                 0     -(((ws)/wb)*Xr_pu) Rr_pu             0;
    0                  0                 0     0                  0                 Rr_pu
    ];

%%-B*[Rs ((ws/wb)*Xs) 0 0 ((ws/wb)*Xm) 0;-((ws/wb)*Xs) Rs 0 -((ws/wb)*Xm) 0 0;0 0 Rs 0 0 0;0 (((ws-(u(1)/P))/wb)*Xm) 0 Rr (((ws-(u(1)/P))/wb)*Xr) 0;-(((ws-(u(1)/P))/wb)*Xm) 0 0 (((ws-(u(1)/P))/wb)*Xr) Rr 0;0 0 0 0 0 Rr]*[u(2);u(3);u(4);u(5);u(6);u(7)]

Pb=(2e6)/3;
Vb=690/(3^0.5);
Ib=Pb/Vb;
Zb=Vb/Ib;

Xls=Zb*Xls_pu;
Xm=Zb*Xm_pu;
Xs=(Xls+Xm);
Xlr=Zb*Xlr_pu;
Xr=(Xlr+Xm);
Rs=Zb*Rs_pu;
Rr=Zb*Rr_pu;



C=14e-3;
Xg=Zb*0.3;
VDC0=1200;
Lg=Xg/wb;
Lr=Xr/wb;
Lm=Xm/wb;
Ls=Xs/wb;
sigma=1-(Lm*Lm)/(Ls*Lr);
Kp=1;
Ki=2;
