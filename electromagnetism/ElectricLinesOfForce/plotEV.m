function plotEV( a,b,c, dx,dy,dz )
%   electricField 点Aが作る電場ベクトルを点Dからプロットする
%   点A(a,b,c)、点D(a+dx,b+dy,c+dz)

%点Aと点Dが重なってしまうと方向が決まらないのでエラーを返す。
if [dx,dy,dz]==[0,0,0]
 fprintf("plotEL1メソッド実行中にエラー。電荷の存在する座標から出発することはできない。\n");
 return
end


x=a+dx;
y=b+dy;
z=c+dz;

%電場ベクトルの大きさlengthOfEと単位ベクトルunitOfEを求める
[Ex,Ey,Ez]=electricField( a,b,c, x,y,z );
lengthOfE=(Ex^2+Ey^2+Ez^2)^0.5;
unitOfE=[Ex/lengthOfE,Ey/lengthOfE,Ez/lengthOfE];


distance=1;
%plot3のプロット間隔



x=[0:distance:Ex];
y=linspace(0,Ey,length(x));
z=linspace(0,Ez,length(x));

x=x+a+dx;
y=y+b+dy;
z=z+c+dz;

hold on;

plot3(x,y,z);







end

