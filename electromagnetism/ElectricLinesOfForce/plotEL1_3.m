function plotEL1_3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N,isMQ )
%   plotEL1_3 Mが作る電気力線を点Pからプロットする
%   点P(x,y,z)
%   NはunitElectricField3に渡すためのものである。
%   Nについての説明はunitElectricField3における説明を参照せよ。
%   isMQは、行列Mの代わりに行列Qが与えられている場合にtrueとする。(実験10(4)で追加)
%   isMQはunitElectricField3に渡される。

%まず、一番最初のプロットをやってしまう。
%左辺については後述の※のため。
[startX,startY,startZ]=plotEV3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N,isMQ );
%fprintf("最初、(%f,%f,%f)\n(%f,%f,%f)\n",x,y,z,startX,startY,startZ);
if(isnan(startX)==true)
 return
else
 %次に、(可動正電荷、電気力線が)描画すべき空間を飛び出る(isEVInArea==falseとなる)
 %まで繰り返す。
 isEVInArea= ...
 ((xMin<=startX && startX<=xMax)&&(yMin<=startY && startY<=yMax)) ...
 && ...   
 (zMin<=startZ && startZ<=zMax);
 while isEVInArea==true
 %始点を「直前に作った電場ベクトルの終点」とするような電場ベクトルを追加描画。...※
 %左辺は、次のタイミングでの※のため。
 [startX,startY,startZ]=plotEV3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,startX,startY,startZ,N,isMQ );
%fprintf("(%f,%f,%f)\n",startX,startY,startZ);
 isEVInArea= ...
 ((xMin<=startX && startX<=xMax)&&(yMin<=startY && startY<=yMax)) ...
 && ...   
 (zMin<=startZ && startZ<=zMax);
 end
end

end
