function plotEL1( a,b,c, dx,dy,dz)
%   plotEL1 点Aが作る電気力線を点Dからプロットする
%   点A(a,b,c)、点D(a+dx,b+dy,c+dz)

%まず、一番最初のプロットをやってしまう。
%左辺については後述の※のため。
[startX,startY,startZ]=plotEV( a,b,c, dx,dy,dz );

%次に、(可動正電荷、電気力線が)描画すべき空間を飛び出る(isEVInArea==falseとなる)
%まで繰り返す。
isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
while isEVInArea==true
%始点を「直前に作った電場ベクトルの終点」とするような電場ベクトルを追加描画。...※
%左辺は、次のタイミングでの※のため。
[startX,startY,startZ]=plotEV(a,b,c, startX,startY,startZ);

isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
end

