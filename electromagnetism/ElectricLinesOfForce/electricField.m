function [i,j,k] = electricField( a,b,c,x,y,z )
%electricField 点Aが点Pに作る電場ベクトルを求める
%   点A(a,b,c)、点P(x,y,z)

%E=(Q/(4πε(((x-a)^2+(y-b)^2+(z-c)^2)^1.5)))(x-a,y-b,z-c)
%まずスカラを求める。
%(ベクトル自体の長さがあるので、スカラはrの2乗ではなく3乗で割ること。
Q=16;
epsilon=1;
scalar=Q/(4*pi*epsilon*(((x-a)^2+(y-b)^2+(z-c)^2)^1.5));
i=scalar*(x-a);
j=scalar*(y-b);
k=scalar*(z-c);

end

