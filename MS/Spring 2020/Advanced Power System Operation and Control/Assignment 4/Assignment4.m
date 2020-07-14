clc;clear all;

Pload=[0 600 1000 900 500 400 300];
Vs(1,1)=10000;
Vsmin=[10 6 6 6 6 6 10]*1000;
Vsmax=[10 18 18 18 18 18 10]*1000;
clength=[1 0 0 0 0 0 0];
TCactual=ones(3000,7)*inf;
TCactual(1,1)=0;
for cindex=2:7
    for rindex=1:clength(cindex-1)
        for q=0:500:2260
            Vsnew=Vs(rindex,cindex-1)+4*1000-4*q;
            PHnew=((q-260)/10);
            if (q==0)
                    PHnew=0;
            end
            PSnew=(Pload(cindex)-PHnew);
            if ((Vsnew>=Vsmin(cindex))&&(Vsnew<=Vsmax(cindex))&&(mod(Vsnew,2000)==0)&&(PSnew>=200)&&(PSnew<=1200))
                clength(cindex)=clength(cindex)+1;
                Vs(clength(cindex),cindex)=Vsnew;
                Vsold(clength(cindex),cindex)=Vs(rindex,cindex-1);
                PH(clength(cindex),cindex)=((q-260)/10);
                if (q==0)
                    PH(clength(cindex),cindex)=0;
                end
                PS(clength(cindex),cindex)=(Pload(cindex)-PH(clength(cindex),cindex));
                TCactual(clength(cindex),cindex)=TCactual(rindex,cindex-1)+4*(700+4.8*PS(clength(cindex),cindex)+(PS(clength(cindex),cindex)*PS(clength(cindex),cindex))/2000);
                rindold(clength(cindex),cindex)=rindex;
            end
        end
    end
end

TC=ones(7,18,18)*inf;
for row=1:length(TCactual)
    for col=2:7
        if (TCactual(row,col)~=inf)
            TC(col,Vsold(row,col)/1000,Vs(row,col)/1000)=min(TC(col,Vsold(row,col)/1000,Vs(row,col)/1000),TCactual(row,col));
        end
    end
end
hold on;
for r=1:length(Vs)
    for c=2:6
        line(([c-1 c]-1)*4,[Vsold(r,c) Vs(r,c)]);
    end
end

    
hold on
xlabel('Time (Hour)')
ylabel('Storage Volume (acre.ft)')
axis([0 24 4000 20000])


find=min(TCactual(:,7));
for row=1:length(TCactual)
    if (TCactual(row,7)==find)
        find=rindold(row,7);
        minTCpath(1,7)=Vs(row,7);
    end
end

for col=6:-1:1
    minTCpath(1,col)=Vs(find,col);
    find=rindold(find,col);
end

figure;
plot(0:4:24,minTCpath)
hold on
title('Trajectory for minimum production cost')
xlabel('Time (Hour)')
ylabel('Storage Volume (acre.ft)')
axis([0 24 4000 20000])
