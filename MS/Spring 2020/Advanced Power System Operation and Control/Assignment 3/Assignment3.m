clc;clear all;

D12=zeros(27,1);
Ans12=zeros(27,1);
D123=zeros(27,1);
Ans123=zeros(27,1);

Powers=[0;50;75;100;125;150;175;200;225];
Costs=[ inf    inf  inf;
        810    750  806;
        1355   1155 1108.5;
        1460   1360 1411;
        1772.5 1655 1704.5;
        2085   1950 1998;
        2427.5 inf  2358;
        2760   inf  inf;
        inf    inf  inf];

for r=1:9
    for c=1:9
        D12(r,1)=Powers(r,1);
        D12(r+c,1)=max(D12(r+c,1),Powers(r)+Powers(c));
        D12(r,2)=Costs(r,1);
        D12(r+c,c+2)=Costs(r,1)+Costs(c,2);
    end
end

for r=1:18
    for c=1:8
        if (D12(r,c+1)==0)
            D12(r,c+1)=inf;
        end
        if (D12(r,10)==inf)
            D12(r,10)=0;
        end
    end
end

for r=1:18
    for c=3:8
        D12(r,9)=min(D12(r,3:8));
        if (min(D12(r,3:8))~=inf)
            if (D12(r,9)==D12(r,c))
                D12(r,10)=Powers(c-2);
            end
            if (D12(r,9)==D12(r,c))
                D12(r,11)=D12(r,1)-D12(r,10);
            end
        end
    end
end

D12(1:14,:)
Ans12=[D12(:,1) D12(:,9) D12(:,10) D12(:,11)];
Ans12(1:15,1:3)

for r=1:18
    for c=1:9
        D123(r,1)=Ans12(r,1);
        D123(r+c,1)=max(D123(r+c,1),Ans12(r,1)+Powers(c));
        D123(r,2)=Ans12(r,2);
        D123(r+c,c+2)=Ans12(r,2)+Costs(c,3);
    end
end

for r=1:27
    for c=1:8
        if (D123(r,c+1)==0)
            D123(r,c+1)=inf;
        end
        if (D123(r,10)==inf)
            D123(r,10)=0;
        end
    end
end

for r=1:27
    for c=3:8
        D123(r,10)=min(D123(r,3:9));
        if (min(D123(r,3:9))~=inf)
            if (D123(r,10)==D123(r,c))
                D123(r,11)=Powers(c-2);
            end
        end
    end
end

for r123=1:27
    for r12=1:18
        if ((D123(r123,1)-D123(r123,11))==Ans12(r12,1))
            D123(r123,12)=Ans12(r12,3);
            D123(r123,13)=Ans12(r12,4);
        end
    end
end

D123(12:13,1:11)
Ans123=[D123(:,1) D123(:,10) D123(:,11) D123(:,12) D123(:,13)];
Ans123(12:13,:)