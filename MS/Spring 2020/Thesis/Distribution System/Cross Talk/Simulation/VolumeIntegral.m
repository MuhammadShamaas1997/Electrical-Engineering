clc;
clear all;
step=1;
ld=1/step;
space3D=zeros(2*ld+1,2*ld+1,2*ld+1);
radius=1;
n=0;
Volume=(4/3)*pi*(radius^3);

for x=-1:step:1
    for y=-1:step:1
        for z=-1:step:1
            if ((((x^2)+(y^2)+(z^2))^0.5)<=radius)
                space3D(round(ld*x+ld+1),round(ld*y+ld+1),round(ld*z+ld+1))=1;
                n=n+1;
            end
        end
    end
end

dV=Volume/n;
calcV=0;
for x=-1:step:1
    for y=-1:step:1
        for z=-1:step:1
            if (space3D(round(ld*x+ld+1),round(ld*y+ld+1),round(ld*z+ld+1))==1)
                space3D(round(ld*x+ld+1),round(ld*y+ld+1),round(ld*z+ld+1))=dV;
                calcV=calcV+dV;
            end
        end
    end
end

calcV=0;
for x=-1:step:1
    for y=-1:step:1
        for z=-1:step:1
                calcV=calcV+space3D(round(ld*x+ld+1),round(ld*y+ld+1),round(ld*z+ld+1));
        end
    end
end
