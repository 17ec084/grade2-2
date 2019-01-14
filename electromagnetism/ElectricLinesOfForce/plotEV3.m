function [endX,endY,endZ]=plotEV3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N,isMQ )
%plotEV3 Mによって定められる電荷が作る電場ベクトルを点Pからプロットする
%   点P(x,y,z)
%   戻り値は電場ベクトルの終点(つまり可動正電荷の座標)
%   NはunitElectricField3に渡すためのものである。
%   Nについての説明はunitElectricField3における説明を参照せよ。
%   isMQは、行列Mの代わりに行列Qが与えられている場合にtrueとする。(実験10(4)で追加)
%   isMQはunitElectricField3に渡される。


%電場ベクトル(の大きさlengthOfEと単位ベクトルunitOfE)を求める
[Ex,Ey,Ez]=unitElectricField3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N,isMQ );
%lengthOfE=(Ex^2+Ey^2+Ez^2)^0.5;
%unitOfE=[Ex/lengthOfE,Ey/lengthOfE,Ez/lengthOfE];

if isnan(Ex)==true
%負電荷によって電気力線が収束しきった場合
 endX=NaN;
 endY=NaN;
 endZ=NaN;
else
 px=[0,Ex];
 py=[0,Ey];
 pz=[0,Ez];
 px=px+x;
 py=py+y;
 pz=pz+z;
 %電場ベクトルの終点
 endX=Ex+x;
 endY=Ey+y;
 endZ=Ez+z;
 %電場ベクトルを描画
 plot3(px,py,pz);
end





end

