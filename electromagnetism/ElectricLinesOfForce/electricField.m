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

%電場ベクトルが電荷に触れた場合
%負電荷かつ電場ベクトルが電荷との距離よりも大きくなった場合
if ((Q<0)*(scalar>=1))
 i=NaN;
end

end

