function [i,j,k] = unitElectricField( a,b,c,x,y,z )
%unitElectricField 点Aが点Pに作る電場ベクトルを求める。但し大きさは1になるように強制的に拡大縮小する
%   点A(a,b,c)、点P(x,y,z)

%unitE=((x-a)^2+(y-b)^2+(z-c)^2)^-0.5)(x-a,y-b,z-c)

scalar=((x-a)^2+(y-b)^2+(z-c)^2)^(-0.5);
i=scalar*(x-a);
j=scalar*(y-b);
k=scalar*(z-c);

end

