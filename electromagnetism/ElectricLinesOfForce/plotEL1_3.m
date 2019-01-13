function plotEL1_3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N )
%   plotEL1_3 Mが作る電気力線を点Pからプロットする
%   点P(x,y,z)
%   NはunitElectricField3に渡すためのものである。
%   Nについての説明はunitElectricField3における説明を参照せよ。

%まず、一番最初のプロットをやってしまう。
%左辺については後述の※のため。
[startX,startY,startZ]=plotEV3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N );
fprintf("最初、(%f,%f,%f)\n",startX,startY,startZ);
if(isnan(startX)==true)
 return
else
 %次に、(可動正電荷、電気力線が)描画すべき空間を飛び出る(isEVInArea==falseとなる)
 %まで繰り返す。
 isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
 while isEVInArea==true
 %始点を「直前に作った電場ベクトルの終点」とするような電場ベクトルを追加描画。...※
 %左辺は、次のタイミングでの※のため。
 [startX,startY,startZ]=plotEV3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,startX,startY,startZ,N );
 fprintf("(%f,%f,%f)\n",startX,startY,startZ);
 isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
 end
end

end
