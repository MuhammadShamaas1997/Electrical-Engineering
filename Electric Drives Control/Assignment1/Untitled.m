clear;
Un=120;
In=20;
nn=3000*(2*pi/60);
Tn=7;
Ra=0.5;
La=2.5e-3;
kf=0.35;
J=0.001;
alphac=2*pi*500;
b = [0 0 alphac];
a = [1 alphac 0];
[r,p,k] = residue(b,a)

