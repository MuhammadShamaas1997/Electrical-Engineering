function [ Y ] = AddLine( Y,n1,n2,r,x,b )
%UNTITLED Adds a transmission line between two nodes
%   (1/(r12+x12))+(b12/2), (-1/(r12+x12))
%   (-1/(r12+x12)), (1/(r12+x12))+(b12/2)

Y(n1,n1)=Y(n1,n1)+(1/(r+x))+(b/2);
Y(n2,n2)=Y(n2,n2)+(1/(r+x))+(b/2);
Y(n1,n2)=Y(n1,n2)+(-1/(r+x));
Y(n2,n1)=Y(n2,n1)+(-1/(r+x));
end

