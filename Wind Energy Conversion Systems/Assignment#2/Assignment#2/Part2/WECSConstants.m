Xls=0.0022*2*pi*50;
Xm=0.127*2*pi*50;
Xs=Xls+Xm;
Xlr=0.0022*2*pi*50;
Xr=Xlr+Xm;
Rs=1.2;
Rr=1.2;
P=4;
f=50;
wb=2*pi*f;
ws=pi*f;
H=1;
B=inv([
    (Xs/wb) 0       0        (Xm/wb) 0       0;
    0       (Xs/wb) 0        0       (Xm/wb) 0;
    0       0       (Xls/wb) 0       0       0;
    (Xm/wb) 0       0        (Xr/wb) 0       0;
    0       (Xm/wb) 0        0       (Xr/wb) 0;
    0       0       0        0       0       (Xlr/wb)
    ]);

Z=[
    Rs              ((ws/wb)*Xs)   0  0               ((ws/wb)*Xm)   0;
    -((ws/wb)*Xs)   Rs             0  -((ws/wb)*Xm)   0              0;
    0               0              Rs 0               0              0;
    0               (((ws)/wb)*Xm) 0  Rr              (((ws)/wb)*Xr) 0;
    -(((ws)/wb)*Xm) 0              0  -(((ws)/wb)*Xr) Rr             0;
    0               0              0  0               0              Rr
    ];

%%-B*[Rs ((ws/wb)*Xs) 0 0 ((ws/wb)*Xm) 0;-((ws/wb)*Xs) Rs 0 -((ws/wb)*Xm) 0 0;0 0 Rs 0 0 0;0 (((ws-(u(1)/P))/wb)*Xm) 0 Rr (((ws-(u(1)/P))/wb)*Xr) 0;-(((ws-(u(1)/P))/wb)*Xm) 0 0 (((ws-(u(1)/P))/wb)*Xr) Rr 0;0 0 0 0 0 Rr]*[u(2);u(3);u(4);u(5);u(6);u(7)]
