clc;clear all;
Costs=ones(9,3).*inf;
demands=ones(9,9).*inf;

f2=ones(9,9).*inf;
F2=ones(18,9).*inf;
F2min=ones(18,1).*inf;
P2min=zeros(18,1);

f3=ones(9,9).*inf;
F3=ones(18,9).*inf;
F3min=ones(18,1).*inf;
P3min=zeros(18,1);

Powers=[0;50;75;100;125;150;175;200;225];
Costs=[inf inf inf;
        810 750 806;
        1355 1155 1108.5;
        1460 1360 1411;
        1772.5 1655 1704.5;
        2085 1950 1998;
        2427.5 inf 2358;
        2760 inf inf;
        inf inf inf];
i1min=2;i2min=2;i3min=2;
i1max=8;i2max=6;i3max=7;

for r=i1min:i1max
    for c=i2min:i2max
        f2(r,c)=Costs(r,1)+Costs(c,2);
        if Powers(r)==0
            f2(r,c)=Costs(c,2);
        end
        if Powers(c)==0
            f2(r,c)=Costs(r,1);
        end
        demands(r,c)=Powers(r)+Powers(c);
    end
end

for r=1:9
    for c=1:9
        F2(r+c,c)=f2(r,c);
        F2min(r+c,1)=min(F2(r+c,:));
        if (f2(r,c)==min(F2(r+c,:)))&&(f2(r,c)~=inf)
            D12(r+c,1)=Powers(r)+Powers(c);
            P2min(r+c,1)=Powers(c,1);
        end
    end
end

for r=1:length(F2min)
    for c=i3min:i3max
        f3(r,c)=F2min(r,1)+Costs(c,3);
    end
end

for r=1:length(F2min)
    for c=2:7
        F3(r+c,c)=f3(r,c);        
        F3min(r+c,1)=min(F3(r+c,:));
        if (f3(r,c)==min(F3(r+c,:)))&&(f3(r,c)~=inf)
            P3min(r+c,1)=Powers(c,1);
            D123(r+c,1)=D12(r)+Powers(c,1);
        end
    end
end