function [endX,endY,endZ]=plotEV( a,b,c, dx,dy,dz)
%plotEV 点Aが作る電場ベクトルを点Dからプロットする
%   点A(a,b,c)、点D(a+dx,b+dy,c+dz)
%   戻り値は電場ベクトルの終点(つまり可動正電荷の座標)

%点Aと点Dが重なってしまうと方向が決まらないのでエラーを返す。
if [dx,dy,dz]==[0,0,0]
 fprintf("plotEVメソッド実行中にエラー。電荷の存在する座標から出発することはできない。\n");
 return
end


x=a+dx;
y=b+dy;
z=c+dz;

%電場ベクトル(の大きさlengthOfEと単位ベクトルunitOfE)を求める
[Ex,Ey,Ez]=unitElectricField( a,b,c, x,y,z );
%lengthOfE=(Ex^2+Ey^2+Ez^2)^0.5;
%unitOfE=[Ex/lengthOfE,Ey/lengthOfE,Ez/lengthOfE];


x=[0,Ex];
y=[0,Ey];
z=[0,Ez];
x=x+a+dx;
y=y+b+dy;
z=z+c+dz;


%電場ベクトルの終点

endX=Ex+a+dx;
endY=Ey+b+dy;
endZ=Ez+c+dz;

%電場ベクトルを描画
plot3(x,y,z);






end

