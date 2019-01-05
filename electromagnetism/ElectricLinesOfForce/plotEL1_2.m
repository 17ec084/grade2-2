function plotEL1_2( a,b,c, dx,dy,dz, N)
%   plotEL1_2 点Aが作る電気力線を点Dからプロットする
%   点A(a,b,c)、点D(a+dx,b+dy,c+dz)
%   NはunitElectricField2に渡すためのものである。
%   Nについての説明はunitElectricField2における説明を参照せよ。

%まず、一番最初のプロットをやってしまう。
%左辺については後述の※のため。
[startX,startY,startZ]=plotEV2( a,b,c, dx,dy,dz, N );

if(isnan(startX)==true)
 return
else
 %次に、(可動正電荷、電気力線が)描画すべき空間を飛び出る(isEVInArea==falseとなる)
 %まで繰り返す。
 isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
 while isEVInArea==true
 %始点を「直前に作った電場ベクトルの終点」とするような電場ベクトルを追加描画。...※
 %左辺は、次のタイミングでの※のため。
 [startX,startY,startZ]=plotEV2(a,b,c, startX-a(1),startY-b(1),startZ-c(1), N);
 isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
 end
end

end
