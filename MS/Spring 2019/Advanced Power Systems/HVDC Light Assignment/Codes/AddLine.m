function [ Y ] = AddLine( Y,n1,n2,r,x,b,ratio )
%UNTITLED Adds a transmission line between two nodes
%   (1/(r12+x12))+(b12/2), (-1/(r12+x12))
%   (-1/(r12+x12)), (1/(r12+x12))+(b12/2)

Y(n1,n1)=Y(n1,n1)+(ratio/(r+x))+(b/2);
Y(n2,n2)=Y(n2,n2)+(ratio/(r+x))+(b/2);
Y(n1,n2)=Y(n1,n2)+(-ratio/(r+x));
Y(n2,n1)=Y(n2,n1)+(-ratio/(r+x));
end

