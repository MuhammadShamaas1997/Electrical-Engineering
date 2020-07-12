clc;clear all;

Pload=[0 600 1000 900 500 400 300];
Vs(1,1)=10000;
Vsmin=[10 6 6 6 6 6 10]*1000;
Vsmax=[10 18 18 18 18 18 10]*1000;
clength=[1 0 0 0 0 0 0];
for cindex=2:7
    for rindex=1:clength(cindex-1)
        for q=0:500:2600
            Vsnew=Vs(rindex,cindex-1)+4*1000-4*q;
            if ((Vsnew>=Vsmin(cindex))&&(Vsnew<=Vsmax(cindex))&&(mod(Vsnew,2000)==0))
                clength(cindex)=clength(cindex)+1;
                Vs(clength(cindex),cindex)=Vsnew;
                Vsold(clength(cindex),cindex)=Vs(rindex,cindex-1);
                PH(clength(cindex),cindex)=(q-260)/10;
                PS(clength(cindex),cindex)=Pload(cindex)-PH(clength(cindex),cindex);
%                 TC(clength(cindex),cindex)=PS
            end
        end
    end
end

hold on;
for r=1:2562
    for c=2:7
        line([c-1 c],[Vsold(r,c) Vs(r,c)]);
    end
end