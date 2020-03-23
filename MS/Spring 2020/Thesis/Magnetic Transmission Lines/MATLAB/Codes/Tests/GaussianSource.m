clc;clear all;
omega=100;
t0=0;
width=250;
tmax=1000;
tstart=0;
tstep=0.001;
n=1;
for t=tstart:tstep:tmax
    f(n)=exp(-i*omega*t-(t-t0)*(t-t0)*(1/(2*width*width)));
    n=n+1;
end
n=1;
for t=tstart:tstep:(tmax-tstep)
    df(n)=(f(n+1)-f(n))/0.001;
    df(n)=df(n)*(1/(-i*omega));
    n=n+1;
end
hold on;
plot(tstart:tstep:(tmax-tstep),real(df))
plot(tstart:tstep:(tmax-tstep),imag(df),'r')
plot(tstart:tstep:(tmax-tstep),abs(df),'k')
