# ElectricLinesOfForce
MatLabで、電荷の電気力線を3Dプロットするプログラムを書こう。

# 1.目的
コンデンサを用いた比誘電率測定器の開発をしたい。  
比誘電率測定器で測るものの厚さの上限を例えば3cmとすると、端効果を無視するにはそれ相応の広い極板が必要になるが、これでは使い勝手が悪いため、端効果を考慮した上での設計となる。  
コンデンサの端効果は初等関数では説明しきれないということがわかっている。  
電磁気学の教授に伺ったところ、複素関数論の「等角写像」の知識が必要であるそう。  
等角写像を理解するのは大変そうであったことや、コンデンサの条件を少し変えたときに視覚的にその影響が容易にわかれば便利だということで、  
電荷を置いたら電気力線を3Dプロットするプログラムを書こうと思いついた。

# 2.実験

## 2.1 実験1 単純な電場計算プログラムの開発
電気力線とはつまり「電場を可視化したもの」である。  
電場はベクトル場であるから、それを可視化した電気力線は「電場ベクトルの軌跡」に他ならない。  
従って、電気力線をプロットするためには、任意の座標における電場ベクトルの計算が必要になる。 

### 2.1.1 実験1の手順 
 
空間εにおいて、点(a,b,c)にある電荷Qが点(x,y,z)に作る電場は、  
(Q/(4πε(((x-a)^2+(y-b)^2+(z-c)^2)^1.5)))(x-a,y-b,z-c)  
である。これを求める関数electricField(a,b,c,x,y,z)をMatLabで作ろう。  
但し、Q=16,ε=1で一定とする。  
次のようなMatLab関数[electricField.m](https://github.com/17ec084/grade2-2/blob/96adb7e4543562fb58701f2d5ab23abdfc28660d/electromagnetism/ElectricLinesOfForce/electricField.m) を作成した。
```MATLAB
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

end

 
```

### 2.1.2 実験1の結果

MATLABのコマンドラインで次のように入力した。

```
[i,k,j]=electricField(1,0,0,0,0,0);
v=[i,k,j];

``` 

これは(1,0,0)に置いた電荷が(0,0,0)に作る電場ベクトルを求めるものである。  

すると変数vは`[-1.273239544735163,0,0]`となった。これは電場ベクトルが(-1.273239544735163,0,0)であるということを意味する。  
今回Q=16,ε=1と置いたので、Q/4πε=16/4πとなる。これをWolfram Alphaで計算すると   1.273239544735162686151070106980114896275677165923651589981...  
となった。大きさについて誤差率を求めると、  
2.46496...×10^-14 [%]となった。  
方向については、電荷の座標と電場ベクトルの始点でy座標及びz座標が一致していることからy方向とz方向に垂直であることが分かり、  
x座標は1が0を遠ざける向き、即ち-1の向きであるため負の向きとなる。  
これらは実験結果と一致する。

## 2.2 実験2 単純な電気力線のプロット
電気力線、電場ベクトルの軌跡とはつまり、可動な正電荷の軌跡である。  
そのため電気力線をプロットする一つの方法として、電場ベクトルに従って正電荷を動かし、正電荷の軌跡をプロットするというものが挙げられる。 
### 2.2.1 実験1の手順 
 
これを実現するためには、次の手順を踏む必要がある。  
但し点(a,b,c)はもともと存在している電荷の座標、点(x,y,z)は電気力線をプロットすべき座標(つまり可動正電荷の座標)とする。  
またプロットすべき3D空間は|x|<100,|y|<100,|z|<100とする。  
(1) (x,y,z)≒(a,b,c)とし(但し等号不可)、これを電気力線の始点とする。  
(2) (x,y,z)をelectricField(a,b,c,x,y,z)だけ動かし、これを電気力線の終点とする  
(3) その点を次の電気力線の始点とする  
(4) (2)と(3)を、(x,y,z)がプロットすべき空間を飛び出るまで繰り返す  

(1)(2)次のようなMatLab関数 [plotEV.m](https://github.com/17ec084/grade2-2/blob/96adb7e4543562fb58701f2d5ab23abdfc28660d/electromagnetism/ElectricLinesOfForce/plotEV.m) を作成した。  

```MATLAB

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
[Ex,Ey,Ez]=electricField( a,b,c, x,y,z );
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
 
```

このプログラムでは `[Ex,Ey,Ez]=electricField( a,b,c, x,y,z );` で点Aが点Dに作る電場ベクトルを求め、  

```
x=[0,Ex];
y=[0,Ey];
z=[0,Ez];
x=x+a+dx;
y=y+b+dy;
z=z+c+dz;

```

で電場ベクトルの始点を点Dに移動し、 `plot3(x,y,z)` でその電場ベクトルを描画するものである。  
また、関数自体の戻り値は、始点を点Dに移動したときの電場ベクトルの終点座標である。  

(3)(4)次のようなMatLab関数[plotEL1.m](https://github.com/17ec084/grade2-2/blob/96adb7e4543562fb58701f2d5ab23abdfc28660d/electromagnetism/ElectricLinesOfForce/plotEL1.m)を作成した。  

```
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


```

このプログラムでは、点Aが作る電気力線を、電場ベクトルのつなぎ合わせにより表現するものである。  
まず `[startX,startY,startZ]=plotEV( a,b,c, dx,dy,dz );` により点Dからの電場ベクトルを1度だけ描写する。  
すると `[startX,startY,startZ]` には電場ベクトルの終点D2の座標が格納される。  
次に `[startX,startY,startZ]=plotEV(a,b,c, startX,startY,startZ);` にて点D2からの電場ベクトルを描画し、  
`[startX,startY,startZ]` には電場ベクトルの終点D3の座標が格納される。  
これを繰り返し、ベクトルDD2、ベクトルD2D3、ベクトルD3D4、...の描画により電気力線を描画する。  
プログラム終了のタイミングは電場ベクトルの終点が指定された領域を飛び出ることにより決定される。  
これは `(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2)` が非0即ち `true` になることに同値である。  
 `(startX^2<100^2)` は「終点ベクトルのx座標を2乗したとき、100の2乗を超えない」といえるときに非0を、超えるときに非0を返却する。  
この条件は、「終点ベクトルのx座標の絶対値が100を超えない」ことと同じである。  
 `(startY^2<100^2)` と `(startZ^2<100^2)` も同様なので、これらの条件がすべて成立した場合のみ非0が3回掛け算され、その答えも非0となる。  
逆にどれか一つでも成立しなかった場合、0が掛け算されるためその答えは0となる。

### 2.2.2 実験2の結果 

MATLABのコマンドラインで次のように入力した。

```
hold off
hold on
plotEL1(0,0,0, 1,0,1)

``` 

`hold off` は既存のグラフデータを破棄するもので、  
`hold on` は以降データを描画していく際に、古いデータを破棄せずに重ねて描画していくための命令である。  
`plotEL1(0,0,0, 1,0,1)` は(0,0,0)に置いた電荷が作る電気力線を(1,0,1)を始点に描画するものである。  

すると、処理が半永久的に終了しなかった。これは電場ベクトルの始点(つまり可動な正電荷)が電荷から離れてゆくにつれて電場ベクトルの大きさが小さくなるため、電場ベクトルが領域の外に出るまで指数関数時間を要するからである。  
(さらに、領域内で電場ベクトルが処理系にて0ベクトルに近似された場合、電場ベクトルは永遠に静止し、プログラムは永遠に停止しなくなる)

## 2.3 実験3 実験2のプログラムの修正
実験2のプログラムが停止しなかったのは、電場ベクトルの大きさが0に近づいたからである。  
その為、電場ベクトルの大きさを強制的に一定値に拡大または縮小するよう修正する必要がある。

### 2.3.1 実験3の手順
[electricField.m](https://github.com/17ec084/grade2-2/blob/master/electromagnetism/ElectricLinesOfForce/electricField.m) をもとに、電場ベクトルではなく電場方向の単位ベクトルを求めるプログラム[unitElectricField.m](https://github.com/17ec084/grade2-2/blob/master/electromagnetism/ElectricLinesOfForce/unitElectricField.m)を作った。

```
function [i,j,k] = unitElectricField( a,b,c,x,y,z )
%unitElectricField 点Aが点Pに作る電場ベクトルを求める。但し大きさは1になるように強制的に拡大縮小する
%   点A(a,b,c)、点P(x,y,z)

%unitE=((x-a)^2+(y-b)^2+(z-c)^2)^-0.5)(x-a,y-b,z-c)

scalar=((x-a)^2+(y-b)^2+(z-c)^2)^(-0.5);
i=scalar*(x-a);
j=scalar*(y-b);
k=scalar*(z-c);

end

```
[electricField.m](https://github.com/17ec084/grade2-2/blob/master/electromagnetism/ElectricLinesOfForce/electricField.m) との違いは、scalarの大きさだけである。どちらのプログラムでもscalarの((x-a)^2+(y-b)^2+(z-c)^2)^0.5倍が電場ベクトルの大きさとなる。  

続いて[plotEV.m](https://github.com/17ec084/grade2-2/blob/master/electromagnetism/ElectricLinesOfForce/plotEV.m) について、  
electricField関数を呼び出す記述をunitElectricField関数を呼び出す記述に書き換えた。

### 2.3.2 実験3の結果 

MATLABのコマンドラインで次のように入力した。

```
hold off
hold on
plotEL1(0,0,0, 1,0,1)

``` 

各コマンドの意味は、2.2.2項に示すとおりである。  

すると、図2.3.2.1のようなグラフが得られた。但しこの図は得られたグラフに軸の名前を付け、3D回転を加え、補助線などを後から加筆したものである。  
![図2.3.2.1](https://github.com/17ec084/grade2-2/blob/master/electromagnetism/data/2321.png)  
図2.3.2.1 実験3でplotEL1(0,0,0, 1,0,1)を実行した結果  

この図から、電気力線が(1,0,1)とおよそ(101,0,101)を結ぶ線分となっていることが確認できる。


## 2.4 実験4 電荷が2つある場合(1/2)―非線形電気力線の描画
実験3まででは、電荷が1つだけの場合について考えていた。その為電気力線は必ず線形(半直線)となっていた。  
実験4以降では、電荷が複数になった場合の電気力線を描画することを試みる。  
但し、実験4では簡単に考えるため、電荷は2個とし、その強さも±16[C]とする。  

### 2.4.1 実験4の手順
[unitElectricField.m](https://github.com/17ec084/grade2-2/blob/master/electromagnetism/ElectricLinesOfForce/unitElectricField.m) をもとに、電場ベクトルではなく電場方向の単位ベクトルを求めるプログラム[unitElectricField.m](https://github.com/17ec084/grade2-2/blob/master/electromagnetism/ElectricLinesOfForce/unitElectricField.m)を作った。

<!--
今後の実験予定
〇2.1を3Dプロットする(2.2)
〇2.2で電場ベクトルの大きさが極端に小さくなってしまうから、大きさを固定(2.3)
・電荷が複数ある場合(２つ。)(2.4、2.5)
・・電気力線が曲線になることの確認
・・置き方によっては電気力線が線形で、しかし振動する。プログラムが止まらない→他の電荷に対してまっすぐな線を描画しない工夫
・電荷が複数ある場合(3次元行列を領域に見立てて電荷を書いておいたものを読み取る場合)
・途中で誘電率が変わる場合
-->
