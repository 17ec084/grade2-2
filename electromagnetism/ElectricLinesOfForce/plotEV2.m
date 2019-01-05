function [endX,endY,endZ]=plotEV2( a,b,c, dx,dy,dz, N)
%plotEV2 点Aが作る電場ベクトルを点Dからプロットする
%   点A(a,b,c)、点D(a+dx,b+dy,c+dz)
%   戻り値は電場ベクトルの終点(つまり可動正電荷の座標)
%   NはunitElectricField2に渡すためのものである。
%   Nについての説明はunitElectricField2における説明を参照せよ。

%点Aと点Dが重なってしまうと方向が決まらないのでエラーを返す。
if [dx,dy,dz]==[0,0,0]
 fprintf("plotEV2メソッド実行中にエラー。電荷の存在する座標から出発することはできない。\n");
 return
end


x=a(1)+dx;
y=b(1)+dy;
z=c(1)+dz;

%電場ベクトル(の大きさlengthOfEと単位ベクトルunitOfE)を求める
[Ex,Ey,Ez]=unitElectricField2( a,b,c, x,y,z, N );
%lengthOfE=(Ex^2+Ey^2+Ez^2)^0.5;
%unitOfE=[Ex/lengthOfE,Ey/lengthOfE,Ez/lengthOfE];

if isnan(Ex)==true
%負電荷によって電気力線が収束しきった場合
 endX=NaN;
 endY=NaN;
 endZ=NaN;
else
 x=[0,Ex];
 y=[0,Ey];
 z=[0,Ez];
 x=x+a(1)+dx;
 y=y+b(1)+dy;
 z=z+c(1)+dz;
 %電場ベクトルの終点
 endX=Ex+a(1)+dx;
 endY=Ey+b(1)+dy;
 endZ=Ez+c(1)+dz;
 %電場ベクトルを描画
 plot3(x,y,z);
end





end

