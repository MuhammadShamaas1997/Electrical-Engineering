A=[-1 0; 0 -2];
B=[0; 0];
C=[0 0];
D=[0];
gensys = ss(A,B,C,D);
step(ss);