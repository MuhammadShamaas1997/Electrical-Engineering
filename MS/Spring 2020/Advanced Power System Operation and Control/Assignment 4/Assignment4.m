clc;clear all;

Pload=[0 600 1000 900 500 400 300];
Vs(1,1)=10000;
Vsmin=[10 6 6 6 6 6 10]*1000;
Vsmax=[10 18 18 18 18 18 10]*1000;
clength=[1 0 0 0 0 0 0];
TC=ones(3000,7)*inf;
TC(1,1)=0;
for cindex=2:7
    for rindex=1:clength(cindex-1)
        for q=0:500:2600
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
                %TC(clength(cindex),cindex)=min(TC(clength(cindex),cindex),TC(rindex,cindex-1)+4*(700+4.8*PS(clength(cindex),cindex)+(PS(clength(cindex),cindex)*PS(clength(cindex),cindex))/2000));
                TC(clength(cindex),cindex)=TC(rindex,cindex-1)+4*(700+4.8*PS(clength(cindex),cindex)+(PS(clength(cindex),cindex)*PS(clength(cindex),cindex))/2000);
                TCold(clength(cindex),cindex)=TC(rindex,cindex-1);
            end
        end
    end
end

hold on;
for r=1:length(Vs)
    for c=2:7
        line(([c-1 c]-1)*4,[Vsold(r,c) Vs(r,c)]);
    end
end

    
hold on
xlabel('Time (Hour)')
ylabel('Storage Volume (acre.ft)')
axis([0 24 4000 20000])


minTC=min(TC);
find=minTC(1,7);
for col=7:-1:1
    for row=1:length(TC)
        if (TC(row,col)==find)
            find=TCold(row,col);
            Vs(row,col)
        end
    end
end
