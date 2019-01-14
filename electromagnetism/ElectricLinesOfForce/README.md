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
但し、Q=16(つまり正電荷),ε=1で一定とする。  
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

```MATLAB
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

## 2.2 実験2 正電荷による単純な電気力線のプロット
電気力線、電場ベクトルの軌跡とはつまり、可動な正電荷の軌跡である。  
そのため電気力線をプロットする一つの方法として、電場ベクトルに従って正電荷を動かし、正電荷の軌跡をプロットするというものが挙げられる。 
### 2.2.1 実験1の手順 
 
これを実現するためには、次の手順を踏む必要がある。  
但し点(a,b,c)はもともと存在している(固定)正電荷の座標、点(x,y,z)は電気力線をプロットすべき座標(つまり可動正電荷の座標)とする。  
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

```MATLAB
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

```MATLAB
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

```MATLAB
hold off
hold on
plotEL1(0,0,0, 1,0,1)

``` 

`hold off` は既存のグラフデータを破棄するもので、  
`hold on` は以降データを描画していく際に、古いデータを破棄せずに重ねて描画していくための命令である。  
`plotEL1(0,0,0, 1,0,1)` は(0,0,0)に置いた正電荷が作る電気力線を(1,0,1)を始点に描画するものである。  

すると、処理が半永久的に終了しなかった。これは電場ベクトルの始点(つまり可動な正電荷)が電荷から離れてゆくにつれて電場ベクトルの大きさが小さくなるため、電場ベクトルが領域の外に出るまで指数関数時間を要するからである。  
(さらに、領域内で電場ベクトルが処理系にて0ベクトルに近似された場合、電場ベクトルは永遠に静止し、プログラムは永遠に停止しなくなる)

## 2.3 実験3 実験2のプログラムの修正
実験2のプログラムが停止しなかったのは、電場ベクトルの大きさが0に近づいたからである。  
その為、電場ベクトルの大きさを強制的に一定値に拡大または縮小するよう修正する必要がある。

### 2.3.1 実験3の手順
(1) [electricField.m](https://github.com/17ec084/grade2-2/blob/96adb7e4543562fb58701f2d5ab23abdfc28660d/electromagnetism/ElectricLinesOfForce/electricField.m) をもとに、電場ベクトルではなく電場方向の単位ベクトルを求めるプログラム[unitElectricField.m](https://github.com/17ec084/grade2-2/blob/e41675c75b1e4d99bc245b9ade0db2b54aa69c62/electromagnetism/ElectricLinesOfForce/unitElectricField.m)を作った。

```MATLAB
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
[electricField.m](https://github.com/17ec084/grade2-2/blob/96adb7e4543562fb58701f2d5ab23abdfc28660d/electromagnetism/ElectricLinesOfForce/electricField.m) との違いは、scalarの大きさだけである。どちらのプログラムでもscalarの((x-a)^2+(y-b)^2+(z-c)^2)^0.5倍が電場ベクトルの大きさとなる。  

(2) [plotEV.m](https://github.com/17ec084/grade2-2/blob/c8ab7a4d49a2659d725d8086107a83d908ded34f/electromagnetism/ElectricLinesOfForce/plotEV.m) について、  
electricField関数を呼び出す記述をunitElectricField関数を呼び出す記述に書き換えた。

### 2.3.2 実験3の結果 

MATLABのコマンドラインで次のように入力した。

```MATLAB
hold off
hold on
plotEL1(0,0,0, 1,0,1)

``` 

各コマンドの意味は、2.2.2項に示すとおりである。  

すると、図2.3.2.1のようなグラフが得られた。但しこの図は得られたグラフに軸の名前を付け、3D回転を加え、補助線などを後から加筆したものである。  
![図2.3.2.1](https://github.com/17ec084/grade2-2/blob/3658baabffb6de6a5585f189f77d98639afb5f9d/electromagnetism/data/2321.png)  
図2.3.2.1 実験3でplotEL1(0,0,0, 1,0,1)を実行した結果  

この図から、電気力線が(1,0,1)とおよそ(101,0,101)を結ぶ線分となっていることが確認できる。

## 2.4 実験4 固定電荷が負の場合
固定電荷が負の場合、電気力線は電荷に吸い込まれる。この場合、実験3までのプログラムのままでは電場ベクトルの始点が領域を飛び出ることがないため、プログラムが停止しない。  
その為、電場ベクトルが電荷に重なることが分かった場合、そこでプログラムを停止するように種々のmファイルを書き換える必要がある。

### 2.4.1 実験4の手順
(1) [unitElectricField.m](https://github.com/17ec084/grade2-2/blob/b424df54ed34c70fb81c15886baeb1fc4f125ded/electromagnetism/ElectricLinesOfForce/unitElectricField.m)を次のように書き換えた。  

```MATLAB
function [i,j,k] = unitElectricField( a,b,c,x,y,z )
%unitElectricField 点Aが点Pに作る電場ベクトルを求める。但し大きさは1になるように強制的に拡大縮小する
%   点A(a,b,c)、点P(x,y,z)

%unitE=((x-a)^2+(y-b)^2+(z-c)^2)^-0.5)(x-a,y-b,z-c)

scalar=((x-a)^2+(y-b)^2+(z-c)^2)^(-0.5);
i=-scalar*(x-a); %実験4で訂正(ア)
j=-scalar*(y-b); %実験4で訂正(ア)
k=-scalar*(z-c); %実験4で訂正(ア)

%実験4で加筆(イ)ここから

%電場ベクトルが電荷にふれた場合
%=(負電荷かつ)電場ベクトルが電荷との距離よりも大きくなった時
if scalar>=1
 i=NaN;
end

%実験4で加筆(イ)ここまで

end

```
(ア)により、電場ベクトルの向きが電荷の座標に近づく向きとなる。  
(イ)により、電場ベクトルが電荷の座標を超えそうになった時、第一戻り値をNaN(非数)とするようになる。  
MATLABでは `isnan(A)` という関数により引数AがNaNであるか否かを判定できるので、これをunitElectricFieldを呼び出しているplotEV、plotEL1関数に埋め込めば、電場ベクトルが電荷に触れたときにplotEVやplotEL1に処理を停止させる指示を出すことができるようになる。

(2) [plotEV.m](https://github.com/17ec084/grade2-2/blob/b424df54ed34c70fb81c15886baeb1fc4f125ded/electromagnetism/ElectricLinesOfForce/plotEV.m)を次のように書き換えた。  

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
[Ex,Ey,Ez]=unitElectricField( a,b,c, x,y,z );
%lengthOfE=(Ex^2+Ey^2+Ez^2)^0.5;
%unitOfE=[Ex/lengthOfE,Ey/lengthOfE,Ez/lengthOfE];

if isnan(Ex)==true %実験4による加筆ここから
%負電荷によって電気力線が収束しきった場合
 endX=NaN;
 endY=NaN;
 endZ=NaN;
else %実験5による加筆ここまで
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
end %この行も実験4による加筆

end

```

加筆により、unitElectricField関数の第一戻り値がNaNであったときにプロットを行わず、またplotEV自身の戻り値を3つともNaNにすることした。  

(3) [plotEL1](https://github.com/17ec084/grade2-2/blob/b424df54ed34c70fb81c15886baeb1fc4f125ded/electromagnetism/ElectricLinesOfForce/plotEL1.m)を次のように書き換えた。  

```MATLAB
function plotEL1( a,b,c, dx,dy,dz)
%   plotEL1 点Aが作る電気力線を点Dからプロットする
%   点A(a,b,c)、点D(a+dx,b+dy,c+dz)

%まず、一番最初のプロットをやってしまう。
%左辺については後述の※のため。
[startX,startY,startZ]=plotEV( a,b,c, dx,dy,dz );

if(isnan(startX)==true) %実験4による加筆ここから
 return
else %実験4による加筆ここまで
 %次に、(可動正電荷、電気力線が)描画すべき空間を飛び出る(isEVInArea==falseとなる)
 %まで繰り返す。
 isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
 while isEVInArea==true
 %始点を「直前に作った電場ベクトルの終点」とするような電場ベクトルを追加描画。...※
 %左辺は、次のタイミングでの※のため。
  [startX,startY,startZ]=plotEV(a,b,c, startX,startY,startZ);
  isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
 end
end %この行も実験4による加筆
end

```  
この加筆により、plotEL1の戻り値がNaNであったとき、プロットを行うプログラム全体を停止するようにした。  

### 2.4.2 実験4の結果

```MATLAB
hold off
hold on
plotEL1(0,0,0, 2,0,2)

``` 
このコマンドは(0,0,0)に置いた負電荷が作る電気力線を(2,0,2)を始点に描画するものである。  
すると、図2.4.2.1のようなグラフが得られた。但しこの図は得られたグラフに軸の名前を付け、3D回転を加え、補助線などを後から加筆したものである。   
![https://github.com/17ec084/grade2-2/blob/8a0de84909a183085915d8d824db8fad689c0ecb/electromagnetism/data/2421.png](https://github.com/17ec084/grade2-2/blob/master/electromagnetism/data/2421.png)  
図2.4.2.1 実験4でplotEL1(0,0,0, 2,0,2)を実行した結果  
この図から、(2,0,2)、(2-√2,0,2-√2)を両端とする線分が示されたということが読み取れる。  
この線分の長さは2であり、方向は(2,0,2)と(0,0,0)を結ぶ方向であるため、妥当であるといえる。

## 2.5 実験5 電荷が2つある場合(1/3)―非線形電気力線の描画
実験4まででは、電荷が1つで、電荷の符号と大きさも予め決まっている上で議論してきた。その為電気力線は必ず線形(正電荷なら半直線、負電荷なら線分)となっていた。  
実験5以降では、電荷が複数になった場合の電気力線を描画することを試みる。  
但し、実験5では簡単に考えるため、電荷は2個とする。  

### 2.5.1 実験5の手順
(1) [unitElectricField.m](https://github.com/17ec084/grade2-2/blob/e41675c75b1e4d99bc245b9ade0db2b54aa69c62/electromagnetism/ElectricLinesOfForce/unitElectricField.m) をもとに、電荷の置かれた2点、電荷の符号、始点を受け取り、その電場方向の単位ベクトルを求めるプログラム[unitElectricField2.m](https://github.com/17ec084/grade2-2/blob/62d24013567bd60da49e68bcd6a834b7a1a8d826/electromagnetism/ElectricLinesOfForce/unitElectricField2.m)を作った。  
また、電場方向の単位ベクトルが電荷に重なった場合、(NaN,0,0)を返す仕様にしてある。この処理の意味は2.9節で解説する。

```MATLAB
function [i,j,k] = unitElectricField2( a,b,c,x,y,z )
%unitElectricField2 点A1と点A2が点Pに作る電場ベクトルを求める。但し大きさは1になるように強制的に拡大縮小する
%   点A1(a(1),b(1),c(1))、点A2(a(2),b(2),c(2))、点P(x,y,z)
%   bとcは長さ2のベクトル、aは長さ4のベクトルである必要がある。
%   a(3)は点A1の電荷の符号を意味する。+なら1を、-なら-1を格納すること。
%   a(4)は点A2の電荷の符号を意味する。+なら1を、-なら-1を格納すること。

%E1
%=EA1の4πε/Q倍
%=(((x-a(1))^2+(y-b(1))^2+(z-c(1))^2)^-1.5)(x-a(1),y-b(1),z-c(1))
%=scalar1*(x-a(1),y-b(1),z-c(1))
scalar1=(((x-a(1))^2+(y-b(1))^2+(z-c(1))^2)^-1.5);
E1=[scalar1*(x-a(1)),scalar1*(y-b(1)),scalar1*(z-c(1))];

%E2
%=EA2の4πε/Q倍
%=((x-a(2))^2+(y-b(2))^2+(z-c(2))^2)^-1.5)
%=scalar2*(x-a(2),y-b(2),z-c(2))
scalar2=(((x-a(2))^2+(y-b(2))^2+(z-c(2))^2)^-1.5);
E2=[scalar2*(x-a(2)),scalar2*(y-b(2)),scalar2*(z-c(2))];

if ((a(3))^2~=1)||((a(4))^2~=1)
 fprintf("unitElectricField2関数の実行中にエラー。unitElectricField2関数の説明をよく読むこと。\n")
 i=NaN;
 j=0;
 k=0;
 return
end

%E
%合成電場ベクトル(の4πε/Q倍)
E=a(3)*E1+a(4)*E2;

%Eの大きさ
absOfE=( (E(1))^2 +(E(2))^2 +(E(3))^2 )^0.5;

%Eを単位ベクトルにする
E=E/absOfE;

%電場ベクトルが電荷とぶつかるかどうか
%=電場ベクトルのxy角度θ、yz角度φと、任意の電荷の座標L(l,m,n)と今の座標P(x,y,z)との間の位置関係の角度θ、φが一致(誤差r[rad]以内)し、かつ前者のほうが大きい
r=0.1;
for p=[1:2]
    l=a(p);
    m=b(p);
    n=c(p);
    
    %着目電荷Lと電場ベクトルの始点Pとを結ぶ線分LP
    LP=[x-l,y-m,z-n];
    
    %線分LPの角度θを区間[-π/2,π/2]の範囲で求める
    thetaOfLP=atan(LP(2)/LP(1));
    %線分LPの角度φを区間[-π/2,π/2]の範囲で求める
    phiOfLP=atan(LP(3)/LP(2));
    
    %電場ベクトルEに対しても同じことをする
    thetaOfE=atan(E(2)/E(1));
    phiOfE=atan(E(3)/E(2));
    
    %φとθそれぞれの誤差[rad]がr未満であるか調べる
    isTouchTheta=(abs(thetaOfLP(1)-thetaOfE(1))<=r);
    isTouchPhi=(abs(phiOfLP(1)-phiOfE(1))<=r);    
    
    if isnan(thetaOfLP) && isnan(thetaOfE)
    %thetaOf～がどちらもNaN即ち不定形の逆正接であったとき
        %成分の大きさが無限大ということはあり得ない以上、
        %不定形は0/0によって生じたといえる。
        %0==0なので、isTouchThetaはtrueとしてよい。
        isTouchTheta=true;
    end
    
    if isnan(thetaOfLP) && isnan(thetaOfE)
    %phiOf～についても同じ。
        isTouchPhi=true;        
    end
    
    if (isTouchTheta) && (isTouchPhi)
    %電場ベクトルが電荷に重なりうる方向である場合で、
        if ...
        ( ...
            abs(LP(1))<=abs(E(1))...
            && ...
            abs(LP(2))<=abs(E(2))...
        ) ...
        && ...
        ( ...
            abs(LP(3))<=abs(E(3)) ...
        ) ...
        %なおかつ電場ベクトルのほうが長い場合、
            if a(p+2)<0
            %着目電荷が負電荷であれば
                %重なったと判断する
                i=NaN;
                j=0;
                k=0;
            return;
            end
        end
    end
    
end

i=E(1);
j=E(2);
k=E(3);

end


```

上記は初代のunitElectricField2.mであるが、実際には過不足があったため何度か大幅な修正を加えている。  
[最新版のunitElectricField2.mを見る場合はこちら](https://github.com/17ec084/grade2-2/blob/master/electromagnetism/ElectricLinesOfForce/unitElectricField2.m)を参照されたい。  
[unitElectricField2.mの書き換えの履歴を参照する場合はこちら](https://github.com/17ec084/grade2-2/commits/master/electromagnetism/ElectricLinesOfForce/unitElectricField2.m)を参照されたい。

(2)
コマンドラインで次を実行し、電場ベクトルが電荷にぶつかったときに第1戻り値がNaNになっているか、その裏も成立しているか確認した。  
同時に返却される電場ベクトルの妥当性も検討した。    
(2-1)正電荷の座標を(0,0,0)、負電荷の座標を(0,0,1.9)、電場ベクトルの始点を(0,0,1)とする場合  

```MATLAB
a=[0,0,1,-1];
b=[0,0];
c=[0,1.9];
[i,j,k]=unitElectricField2(a,b,c, 0,0,1);
```

(2-2)正電荷の座標を(0,0,0)、負電荷の座標を(0,0,2.1)、電場ベクトルの始点を(0,0,1)とする場合  

```MATLAB
a=[0,0,1,-1];
b=[0,0];
c=[0,2.1];
[i,j,k]=unitElectricField2(a,b,c, 0,0,1);
```

(2-3)正電荷の座標を(-0.5,0,0)、負電荷の座標を(0,0.5,0)、電場ベクトルの始点を(0,0,0)とする場合  

```MATLAB
a=[-0.5,0,1,-1];
b=[0,0.5];
c=[0,0];
[i,j,k]=unitElectricField2(a,b,c, 0,0,0);
```

(3)
[plotEV.m](https://github.com/17ec084/grade2-2/blob/b424df54ed34c70fb81c15886baeb1fc4f125ded/electromagnetism/ElectricLinesOfForce/plotEV.m) をもとに、  
unitElectricField関数を呼び出す仕様からunitElectricField2関数を呼び出す仕様に書き換えたmファイル[plotEV2.m](https://github.com/17ec084/grade2-2/blob/52d467842e23b63771e252e4502f5697e8bd823e/electromagnetism/ElectricLinesOfForce/plotEV2.m)を作った。  
```MATLAB
function [endX,endY,endZ]=plotEV2( a,b,c, dx,dy,dz)
%plotEV2 点Aが作る電場ベクトルを点Dからプロットする
%   点A(a,b,c)、点D(a+dx,b+dy,c+dz)
%   戻り値は電場ベクトルの終点(つまり可動正電荷の座標)

%点Aと点Dが重なってしまうと方向が決まらないのでエラーを返す。
if [dx,dy,dz]==[0,0,0]
 fprintf("plotEV2メソッド実行中にエラー。電荷の存在する座標から出発することはできない。\n");
 return
end


x=a(1)+dx; %実験5(3)で変更
y=b(1)+dy; %実験5(3)で変更
z=c(1)+dz; %実験5(3)で変更

%電場ベクトル(の大きさlengthOfEと単位ベクトルunitOfE)を求める
[Ex,Ey,Ez]=unitElectricField2( a,b,c, x,y,z ); %実験5(3)で変更
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
 x=x+a(1)+dx; %実験5(3)で変更
 y=y+b(1)+dy; %実験5(3)で変更
 z=z+c(1)+dz; %実験5(3)で変更
 %電場ベクトルの終点
 endX=Ex+a(1)+dx; %実験5(3)で変更
 endY=Ey+b(1)+dy; %実験5(3)で変更
 endZ=Ez+c(1)+dz; %実験5(3)で変更
 %電場ベクトルを描画
 plot3(x,y,z);
end





end



```

(4) [plotEL1](https://github.com/17ec084/grade2-2/blob/b424df54ed34c70fb81c15886baeb1fc4f125ded/electromagnetism/ElectricLinesOfForce/plotEL1.m)をもとに、  
plotEV関数を呼び出す仕様からplotEV2関数を呼び出す仕様に書き換えたmファイル[plotEL1_2.m](https://github.com/17ec084/grade2-2/blob/aa7c98c1d344badcbf8a00555e86b59ecbb17bd0/electromagnetism/ElectricLinesOfForce/plotEL1_2.m)を作った。  

```MATLAB
function plotEL1_2( a,b,c, dx,dy,dz)
%   plotEL1_2 点Aが作る電気力線を点Dからプロットする
%   点A(a,b,c)、点D(a+dx,b+dy,c+dz)

%まず、一番最初のプロットをやってしまう。
%左辺については後述の※のため。
[startX,startY,startZ]=plotEV2( a,b,c, dx,dy,dz ); %実験5(4)で変更

if(isnan(startX)==true)
 return
else
 %次に、(可動正電荷、電気力線が)描画すべき空間を飛び出る(isEVInArea==falseとなる)
 %まで繰り返す。
 isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
 while isEVInArea==true
 %始点を「直前に作った電場ベクトルの終点」とするような電場ベクトルを追加描画。...※
 %左辺は、次のタイミングでの※のため。
 [startX,startY,startZ]=plotEV2(a,b,c, startX-a(1),startY-b(1),startZ-c(1));%実験5(4)で変更
 isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
 end
end

end
```

### 2.5.2 実験5の結果
(1)(2)を行った結果、次のようになった。  
(2-1)  
結果:i=NaN,j=0,k=0  
妥当性:まず合成される電場ベクトルの向きはz方向である。  
従って電場ベクトルは(0,0,1)となる。  
始点は(0,0,1)なので、終点は(0,0,2)となる。  
負電荷の座標(0,0,1.9)がこの線分上にあるので、  
この関数の戻り値は(NaN,0,0)となるべきである。  
したがって、結果は妥当である。  

(2-2)  
結果:i=0,j=0,k=1  
妥当性:まず合成される電場ベクトルの向きはz方向である。  
したがって電場ベクトルは(0,0,1)となる。  
始点は(0,0,1)なので、終点は(0,0,2)となる。  
2つの電荷は線分上にないので、  
この関数の戻り値はそのまま電場ベクトルとなるべきである。  
したがって、結果は妥当である。  

(2-3)  
結果:i=0.7071,j=0.7071,k=0  
妥当性:まず合成される電場ベクトルの向きはxからyへπ/4[rad]の方向である。  
したがって電場ベクトルは(cos(π/4),sin(π/4),0)、つまり(0.7071,0.7071,0)となる。  
始点は(0,0,0)なので、終点は(0.7071,0.7071,0)となる。  
2つの電荷は線分上にないので、  
この関数の戻り値はそのまま電場ベクトルとなるべきである。  
したがって、結果は妥当である。  

また(3)(4)を行い、次のようにコマンドラインに入力した結果、図2.5.2.1のようなグラフが得られた。但しこの図は得られたグラフに軸の名前を付け、3D回転を加え、補助線などを後から加筆したものである。
![](https://github.com/17ec084/grade2-2/blob/9486e7e910bd67425cd67b78c74cdedfe266f339/electromagnetism/data/2521_2.png)  
図2.5.2.1 実験5でplotEL1_2([0,0,-1,-1],[0,0],[0,2.1], 5,0,1)した結果(xz平面)  
  
この結果を、参考資料[1]による電界(電場)のシミュレート(図2.5.2.2)と比較すると、実験5では電場ベクトルの長さを固定したためにシミュレートと比較して角張ってしまっていることがわかる。しかし、その事実を除けば、図2.5.2.3からもわかる通り、ほぼ正確に電気力線を引くことができたといえる。  
![](https://github.com/17ec084/grade2-2/blob/9486e7e910bd67425cd67b78c74cdedfe266f339/electromagnetism/data/2522.png)  
図2.5.2.2 (0,0,0)と(0,0,2.1)に負電荷を置き、(5,0,1)から電気力線を引くシミュレーション  
  
![](https://github.com/17ec084/grade2-2/blob/9486e7e910bd67425cd67b78c74cdedfe266f339/electromagnetism/data/2523.png)  
図2.5.2.3 図2.5.2.1と図2.5.2.2を重ね合わせて比較した図

## 2.6 実験6 電荷が2つある場合(2/3)―電場ベクトルが零ベクトルとなる場合
実験5のプログラムで、例えば次のようなものをコマンドラインに入力して実行すると、プロットが行われない。

```MATLAB
a=[0,0,1,1];
b=[0,0];
c=[0,10];
plotEL1_2(a,b,c, 0,0,5);
```

このコマンドでは(0,0,0)と(0,0,10)に正電荷を置いたときの電気力線を(0,0,5)を始点に描こうとするものである。  
(0,0,5)における電場を計算すると零ベクトルとなるが、これを無理やり単位ベクトルにするため、0で除算し、結果として電場ベクトルは(NaN,NaN,NaN)となる。  
このことを解決すべく、単位ベクトルにする前の電場ベクトルが零ベクトルであった場合、各成分に微小な乱数を加えるようにする。  

### 2.6.1 実験6の手順
[unitElectricField2.m](https://github.com/17ec084/grade2-2/blob/a178a4f5eedc8386a9e2cd38961103b9df10ed0f/electromagnetism/ElectricLinesOfForce/unitElectricField2.m)について、

```MATLAB
%E
%合成電場ベクトル(の4πε/Q倍)
E=a(3)*E1+a(4)*E2;
```

と  

```MATLAB
%Eの大きさ
absOfE=( (E(1))^2 +(E(2))^2 +(E(3))^2 )^0.5;
```

の間に、次のものを挿入した。  


```MATLAB
%E
%合成電場ベクトル(の4πε/Q倍)
E=a(3)*E1+a(4)*E2;

%Eが零ベクトルなら微小な乱数を各成分に加える
if ((E(1)==0)&&(E(2)==0))&&(E(3)==0)

    %乱数の幅。乱数は区間[-randWidth,randWidth]となる
    randWidth=0.1;
    
    E=2*randWidth*(rand(1,3)-[0.5,0.5,0.5]);
end
```

### 2.6.2 実験6の結果
次のコマンドを実行した結果、例えば図2.6.2.1、図2.6.2.2、図2.6.2.3のように2つの正電荷(0,0,0)、(0,0,10)の両方から遠ざかるような電気力線が描かれた。但し、3つの図はすべて一回の実験で得られたものであり、同じ結果を様々な角度から見た図である。
```MATLAB
a=[0,0,1,1];
b=[0,0];
c=[0,10];
plotEL1_2(a,b,c, 0,0,5);
```

## 2.7 実験7 電荷が2つある場合(3/3)―散乱により実現する電気力線の発振防止
実験6のプログラムで、例えば次のようなものをコマンドラインに入力して実行すると、プログラムが停止しなくなる。

```MATLAB
a=[0,0,1,1];
b=[0,0];
c=[0,10];
plotEL1_2(a,b,c, 0,0,4.9);
```

これは等しい大きさを持つ2つの正電荷を(0,0,0)と(0,0,10)におき、電気力線を(0,0,4.9)から描くものである。  
電気力線は(0,0,4.9)からまず+x方向に距離1である点(0,0,5.9)へ向かう。その後-x方向に距離1である点(0,0,4.9)へ向かう。  
以下、これを無限に繰り返すことになる。ゆえにプログラムも停止しなくなってしまう。  
これを防ぐための方法として、まず発振の起こりうる場合を検知してその電気力線を描画しないなどの工夫をすることが考えられる。  
しかし、これを検知するために別の計算をするのでは冗長になる恐れがある。  
そこで、原子核などの他の球体にぶつかった場合を想定してその反射を再現することにした。  
ただし、衝突する球体の中心は無作為に決まるものとし、その球体に衝突した直後、反射後の方向に進む距離は常に1であるとする。

### 2.7.1 実験7の手順
電気力線の方向(可動な正電荷の進行方向)を-βとするαβγ空間を考える。衝突する球体を半径Rとする。この球体の中心からr(区間[0,R]を一様分布する)離れ、かつα方向からγ方向へ角度θ(区間[0,2π]を一様分布する)の方向で球体と衝突した場合を考える。  
即ち図2.7.1.1のような場合を考える。  
![](https://github.com/17ec084/grade2-2/blob/9e8bfcd25197275e01403af600e7d30e05902746/electromagnetism/data/2711.png)  
図2.7.1.1 可動な正電荷の球体への衝突


(1)反射する方向が-βからαへどのような角度か、また-βからγへどのような角度か、それぞれ求めた。  
(2)(1)の結果を用いて、確率1/|N|で球体に衝突(または消滅)するよう、[unitElectricField2.m](https://github.com/17ec084/grade2-2/blob/22cabfda7087d5cee9957d1b67b1f5bbbdd1de28/electromagnetism/ElectricLinesOfForce/unitElectricField2.m)  
について、

```MATLAB
%Eの大きさ
absOfE=( (E(1))^2 +(E(2))^2 +(E(3))^2 )^0.5;

%Eを単位ベクトルにする
E=E/absOfE;
```

の直後に次のものを挿入した。  
(引数Nも追加した)

```MATLAB
%実験7で加筆ここから

if(N<=-1)
%Nが-1以下なら、-N回に1回の割合で電気力線を途絶えさせる
    if(rand()*(-N)>(-N-1))
       i=NaN;
       j=0;
       k=0;
       return;
   end 
elseif(-1<N && N<1)
%-1<N<1なら
    if(N~=0)
    %Nが0でないなら
        fprintf("unitElectricField2関数の引数Nにエラー。unitElectricField2関数の説明をよく読むこと。\n")
        i=NaN;
        j=0;
        k=0;
        return
    else
    %N==0なら
        %何もしない
    end
elseif(rand()*(N)>(N-1))
%Nが1以上なら、N回に1回の割合で電気力線を反射させる
    %{
    αβγ空間を考え、
    電気力線の進行方向を-β方向としたとき、
    α方向へ向かう角度は
    2*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2)))で求められる。
    γ方向へ向かう角度は
    2*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2)))で求められる。

    β方向の単位ベクトルは必ず-Eである。
    また、α方向を次のように定めることにする。
    ･y成分及びz成分が-Eのものと同じである
    ･β方向に垂直である
    このように決めることで、α方向が一意に定まる。
    γ方向については、α方向の単位ベクトルとβ方向の単位ベクトルの外積により定められる方向とする。
    %}
    
    %まず、β方向の単位ベクトルunitBetaを定める。
    unitBeta=-E;
    
    %次に、α方向の単位ベクトルunitAlphaを定める。
    unitAlpha=[NaN,unitBeta(2),unitBeta(3)];
    %unitAlpha(1)は、unitAlpha･unitBeta=0となるように定まる。
    unitAlpha(1)=-(unitBeta(2)*unitBeta(2)+unitBeta(3)*unitBeta(3))/unitBeta(1);
    
    if(unitBeta(1)==0)
    %{
    しかし、unitBeta(1)が0であった場合、unitAlphaを定めることができないため、
    α方向の定義を
    ･x成分及びz成分が-Eのものと同じである
    ･β方向に垂直である
    に変更する
    %}
        unitAlpha=[0,NaN,unitBeta(3)];
        %unitAlpha(2)は、unitAlpha･unitBeta=0となるように定まる。
        unitAlpha(2)=-(unitBeta(1)*unitBeta(1)+unitBeta(3)*unitBeta(3))/unitBeta(2);       
        
        if(unitBeta(2)==0)
        %unitBeta(1)もunitBeta(2)も0である場合については、例えば
        unitAlpha=[1,0,0];
        %が必ずβに垂直になるため、これをα方向の単位ベクトルとしてしまってよい。
        end
    end
    
    %unitAlphaを単位ベクトルにする。
    unitAlpha=unitAlpha./sqrt(unitAlpha(1)^2+unitAlpha(2)^2+unitAlpha(3)^2);
    %γ方向の単位ベクトルunitGamma=unitAlpha×unitBetaを求める
    unitGamma=cross(unitAlpha,unitBeta);
    
    %{
    続いて、反射後の電場ベクトルを求め、Eに上書きする。
    反射後の電場ベクトルの方向は
    α成分をtan(2*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2)))),
    β成分を-1,
    γ成分をtan(2*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2))))
    とするベクトルの方向に一致する。
    %}
    rnd1=rand();
    rnd2=rand();
    E=unitAlpha.*tan(2*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2))));
    E=E+unitBeta.*(-1);
    E=E+unitGamma.*tan(2*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2))));
    
    %Eの大きさ
    absOfE=( (E(1))^2 +(E(2))^2 +(E(3))^2 )^0.5;

    %Eを単位ベクトルにする
    E=E/absOfE;
    
end
%実験7で加筆ここまで
```

また、[plotEV2.m](https://github.com/17ec084/grade2-2/blob/d253c41cc606884cf2a74de94cd63b91646b2c4e/electromagnetism/ElectricLinesOfForce/plotEV2.m)、[plotEL1_2.m](https://github.com/17ec084/grade2-2/blob/d253c41cc606884cf2a74de94cd63b91646b2c4e/electromagnetism/ElectricLinesOfForce/plotEL1_2.m)も、引数Nを受け取ってunitElectricField2に渡すように書き換えた。

### 2.7.2 実験7の結果
(1)  
図2.7.1.1をα方向から観測すると図2.7.2.1のようになる。  
したがって、  
sinε=(r*sinθ)/R、  
l=R*cosε=R*√(1-((r*sinθ)/R)^2)  
の式が成り立つ。  
次に、図2.7.1.1をγ方向から観測すると、図2.7.2.2のようになる。  
したがって、  
cosδ=(r*cosθ)/(R*√(1-((r*sinθ)/R)^2))  
である。  
反射する方向の-βからαへの角度の成分は  
180°-2×(90°-δ)=2δ  
である。  
また、-βからγへの角度の成分も、同様の議論により求められる。  
したがって、反射する方向は、  
-βからαへ2arccos((r*cosθ)/(R*√(1-((r*sinθ)/R)^2)))  
-βからγへ2arccos((r*sinθ)/(R*√(1-((r*cosθ)/R)^2)))  
である。

![](https://github.com/17ec084/grade2-2/blob/6ef2581cbc4fdf17135090435bf8f5a630c6e520/electromagnetism/data/2721.png)  
図2.7.2.1 図2.7.1.1をα方向から眺めた図  

![](https://github.com/17ec084/grade2-2/blob/6ef2581cbc4fdf17135090435bf8f5a630c6e520/electromagnetism/data/2722.png)  
図2.7.2.2 図2.7.1.1をγ方向から眺めた図  

(2)  
次のようなものをコマンドラインに入力して実行した結果、図2.7.2.3のように無作為な方向に電気力線が反射した。  

```MATLAB
a=[0,0,1,1];
b=[0,0];
c=[0,10];
plotEL1_2(a,b,c, 0,0,4.9,100);
```

![](https://github.com/17ec084/grade2-2/blob/613777791e035bb62cc0ffdf37e1ad4e0c71687e/electromagnetism/data/2723__.png)  
図2.7.2.3 反射により発振を防ぐ例  
  
また、次のようなものをコマンドラインに入力して実行した結果、(0,0,4.9)と(0,0,5.9)を両端とする線分が出力された。
```MATLAB
a=[0,0,1,1];
b=[0,0];
c=[0,10];
plotEL1_2(a,b,c, 0,0,4.9,-100);
```
## 2.8 実験8 電荷が無数にある場合(1/3)―3次元行列Mの導入
実験7までのプログラムでは空間に配置できる電荷は高々2つであった。さらに電荷の大きさも自由に設定することができなかった。  
実験8以降では3次元行列Mを定義し、例えば  
点(1,4,5)に正電荷10[C]を配置する場合、  
`M(1,4,5)=10;`  
のようにすることで点電荷を容易に配置できる仕様を実現する。  
実験8ではこの3次元行列と、点Pを入力として受け取り、電場の単位ベクトルを求めるプログラムを作成する。  
<!-- 
この時点では、関数にはしない。関数にしてしまうとunitElectricFieldとの役割の違いが後々わかりにくくなってしまう
-->
### 2.8.1 実験8の手順
(1)次のようなプログラムを作成した。  
```MATLAB
%まず、行列M内に0でない値がいくつ格納されているか調べる。
%この個数cntが電荷の数である。
%同時にそれぞれの電荷の情報を行列Qに格納する。

cnt=0;
[Mi,Mj,Mk]=size(M);
for M_i=[1:Mi]
    for M_j=[1:Mj]
        for M_k=[1:Mk]
            if(M(M_i,M_j,M_k)~=0)
                cnt=cnt+1;
                %(*ここから)
                Q(cnt,1)=M(M_i,M_j,M_k);
                Q(cnt,2)=M_i;
                Q(cnt,3)=M_j;
                Q(cnt,4)=M_k;
                %(*ここまで)
            end
        end
    end
end

%{
以上の処理により、
num番目の電荷の電気量はQ(num,1)に、
num番目の電荷のｘ座標はQ(num,2)に、 
num番目の電荷のｙ座標はQ(num,3)に、 
num番目の電荷のｚ座標はQ(num,4)に、 
それぞれ格納された
%}

%次に、num番目の電荷が点P(x,y,z)に作る電場ベクトルの4πε倍である
%(e(num,1),e(num,2),e(num,3))を求める。

for num=[1:cnt]
    scalar(num)=Q(num,1)*(((x-Q(num,2))^2+(y-Q(num,3))^2+(z-Q(num,4))^2)^-1.5);
    e(num,1)=scalar(num)*(x-Q(num,2));
    e(num,2)=scalar(num)*(y-Q(num,3));
    e(num,3)=scalar(num)*(z-Q(num,4));
end

%ベクトルeの総和をEに格納
E=[0,0,0];

for num=[1:cnt]
    E(1)=E(1)+e(num,1);
    E(2)=E(2)+e(num,2);
    E(3)=E(3)+e(num,3);
end

fprintf("E=(%f,%f,%f)\n",E(1),E(2),E(3));
```

(2)(1)では点(x,y,z)に置かれた電荷の電気量をM(x,y,z)で表現していた。  
その為、例えば点(-9,1.2,0)のように、負の値を含む座標や小数で表現される値を含む座標、0を含む座標を表現することができない。  
また、原点から極端に離れた座標を表現するためには、その分だけ行列のサイズを大きくしなくてはいけない。  
これでは不便であるため、(1)のプログラムの「*」の範囲を次のように書き換えた。

```matlab
Q(cnt,1)=M(M_i,M_j,M_k);
Q(cnt,2)=((M_i-1)*(xMax-xMin)/(szX-1))+xMin;
Q(cnt,3)=((M_j-1)*(yMax-yMin)/(szY-1))+yMin;
Q(cnt,4)=((M_k-1)*(zMax-zMin)/(szZ-1))+zMin;
```

このプログラムはxの範囲がxMin以上xMax以下、(y、zも同様に範囲を決める)になるように行列Mのインデックスとの対応を変えたものである。  
例えば、`size(M)`が`[szX,szY,szZ]`である場合、  
`M(i,j,k)`は座標(((i-1)×(xMax-xMin)/(szX-1))+xMin,((j-1)×(yMax-yMin)/(szY-1))+yMin,((k-1)×(zMax-zMin)/(szZ-1))+zMin)における電荷の電気量を意味する。  
即ちインデックス全体を用いて、範囲を等間隔で表現している。  



### 2.8.2 実験8の結果
(1)次のように入力したのち、プログラムを実行した。

```MATLAB
M(1,1,1)=1;
M(9,1,2)=-9.1;
M(3,2,1)=6;
x=3;
y=5;
z=5;
```

すると、E=(0.123863,0.086116,0.153217)が得られた。  
妥当性を検証しよう。  
入力は  
点(1,1,1)に1[C]、  
点(9,1,2)に-9.1[C]、  
点(3,2,1)に6[C]  
の電荷を置いたときに、  
点(3,5,5)にできる電場を求めるためのものであるため、プログラムを実行した結果として、次のように計算される電場ベクトルが求められるべきである。  
![](https://github.com/17ec084/grade2-2/blob/78fb1f18f2dd9933a29a2c1950fffc72bb5f48e0/electromagnetism/data/8_1.png)  
したがって、この結果は妥当である。  
  
(2)次のように入力したのち、プログラムを実行した。

```MATLAB
szX=1001;
szY=1001;
szZ=1001;
xMax=10;
xMin=-10;
yMax=10;
yMin=-10;
zMax=10;
zMin=-10;
M(501,551,451)=1.7;
M(46,451,1)=3;
M(651,351,251)=-2.1;
x=3;
y=5;
z=5;
```

すると、E=(0.015119,0.008463,0.016883)が得られた。  
妥当性を検証しよう。  
![](https://github.com/17ec084/grade2-2/blob/a1042da3dfd5ac1b26ec585c533810077b799af9/electromagnetism/data/8_2.png)  

## 2.9 実験9 電荷が無数にある場合(2/3)―電場ベクトルが電荷とぶつかかることの判定  
電気力線が負電荷に到達した場合、実際にはそこが電気力線の終点となる。  
しかし、今作っているプログラムでは、電気力線を単位長さ毎に描画しているため、電気力線は負電荷を通り越しては引き返すことを永久に繰り返してしまい、プログラムが停止しなくなってしまう恐れがある。  
その為、実験5で作成した2つの電荷により作られる電場単位ベクトルを求める関数[unitElectricField2.m](https://github.com/17ec084/grade2-2/blob/22cabfda7087d5cee9957d1b67b1f5bbbdd1de28/electromagnetism/ElectricLinesOfForce/unitElectricField2.m)では、電場ベクトルが負電荷と重なった場合にそこで電気力線の描画を強制停止するようにしてある。  
実験9ではこの強制停止の機能を、無数の電荷を扱う場合にも実現させるために、実験8と同じ3次元行列Mと点Pに対して、電場ベクトルが負電荷と重なりうるか否かを判定するプログラムの作成を行う。  


### 2.9.1 実験9の手順
次のようなプログラムを書いた。  
```MATLAB
%電場の単位ベクトルが電荷とぶつかるかどうか
%=電場ベクトルのxy角度θ、yz角度φと、任意の電荷の座標L(l,m,n)と今の座標P(x,y,z)との間の位置関係の角度θ、φが一致(誤差r[rad]以内)し、かつ前者のほうが大きい

r=0.1;
r2=0.01;
for num=[1:cnt]
    l=Q(num,2);
    m=Q(num,3);
    n=Q(num,4);
    
    %着目電荷Lと電場ベクトルの始点Pとを結ぶ線分LP
    LP=[x-l,y-m,z-n];
    
%{
θとφがそれぞれ違っても、同じ方向に向いてしまうことがある。
例:θ=0,φ=πと、θ=π,φ=0は同じ方向を向く。
したがって、θとφを使う方法では誤判定が生じる可能性があるため適切ではない。
代替案として、LPとEをそれぞれ単位ベクトルとし、各成分の誤差率がすべてr*0.01[%]以内であるかどうかを確認することにした。

(θとφがそれぞれ何を表すかを忘れている場合、github上のコミット履歴を参照のこと。)
%}

%LPの単位ベクトルを求める。
absOfLP=(((LP(1))^2)+((LP(2))^2)+((LP(3))^2))^0.5;
unitLP(1)=-LP(1)/absOfLP;
unitLP(2)=-LP(2)/absOfLP;
unitLP(3)=-LP(3)/absOfLP;

%Eは予め単位ベクトル。

isTouchableDirection ...
= ...
( ...
    abs((E(1)-unitLP(1)))<=r ...
    && ...
    abs((E(2)-unitLP(2)))<=r ...
) ...
    && ...
    abs((E(3)-unitLP(3)))<=r ...
;
    
    if (isTouchableDirection)
    %電場ベクトルが電荷に重なりうる方向である場合で、
        if ...
        ( ...
            abs(LP(1))<=abs(E(1))...
            && ...
            abs(LP(2))<=abs(E(2))...
        ) ...
        && ...
        ( ...
            abs(LP(3))<=abs(E(3)) ...
        ) ...
        %なおかつ電場ベクトルのほうが長い場合、
            if Q(num,1)<0
            %着目電荷が負電荷であれば
                %重なったと判断する
                fprintf("点(%f,%f,%f)を始点とする電場の単位ベクトルは、点(%f,%f,%f)に置かれた%f[C]の電荷と衝突することが確認された。\n",x,y,z,Q(num,2),Q(num,3),Q(num,4),Q(num,1));
                i=NaN;
                j=0;
                k=0;
            return;
            end
        end
    end
    
end
fprintf("点(%f,%f,%f)を始点とする電場の単位ベクトルはどの負電荷にも衝突しないことが確認された。\n",x,y,z);  
```
### 2.9.2 実験9の結果
次のように入力したのち、実験8(2)のプログラムを実行し、得られたベクトルの各成分を、ベクトルの長さで割ることで単位ベクトルにし、続けて実験9のプログラムを実行した。  
```MATLAB
szX=1001;
szY=1001;
szZ=1001;
xMax=10;
xMin=-10;
yMax=10;
yMin=-10;
zMax=10;
zMin=-10;
M(501,551,451)=1.7;
M(46,451,1)=3;
M(651,351,251)=-2.1;
x=2.5;
y=-3;
z=-5;
```
すると、次のように表示された。  

`点(2.500000,-3.000000,-5.000000)を始点とする電場の単位ベクトルは、点(3.000000,-3.000000,-5.000000)に置かれた-2.100000[C]の電荷と衝突することが確認された。`  

妥当性を検証しよう。  
![](https://github.com/17ec084/grade2-2/blob/ea0f080277f719fe203fe577cb3651ff1a051d2a/electromagnetism/data/9.png)  

また、 `M(676,351,251)=100;` を追加して同様のことをした。このことにより、点(3.5,-3,-5)に正電荷100[C]が追加される。  
すると、次のように表示された。

`点(2.500000,-3.000000,-5.000000)を始点とする電場の単位ベクトルはどの負電荷にも衝突しないことが確認された。`

妥当性を検証しよう。  
![](https://github.com/17ec084/grade2-2/blob/660bb3d3a162aec36ae44492ddfe2792e39020eb/electromagnetism/data/9_2.png)

## 2.10 実験10 電荷が無数にある場合(3/3)―関数の作成  
実験10では、実験8および実験9で作ったプログラムを関数unitElectricField3.mに組み込む。  
また、unitElectricField3関数を用いて電気力線全体を描画する実験も行う。  

### 2.10.1 実験10の手順
(1)次のような関数[unitElectricField3.m](https://github.com/17ec084/grade2-2/blob/16ad29f1459048e7d203b344560dcb50e1d3731a/electromagnetism/ElectricLinesOfForce/unitElectricField3.m)を作った。

```Matlab
function [i,j,k] = unitElectricField3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N )
%unitElectricField3 Mによって定められる電荷が点Pに作る電場ベクトルを求める。但し大きさは1になるように強制的に拡大縮小する
%   点P(x,y,z)
%   Mは3次元行列である必要があり、xの範囲はxmin～xmaxである。
%   また、abs(N)回に1回、
%   Nが正なら反射が、
%   Nが負なら消滅が起こる。
%   Nが0なら何も起こらない

%まず、行列M内に0でない値がいくつ格納されているか調べる。
%この個数cntが電荷の数である。
%同時にそれぞれの電荷の情報を行列Qに格納する。
cnt=0;
[Mi,Mj,Mk]=size(M);
for M_i=[1:Mi]
    for M_j=[1:Mj]
        for M_k=[1:Mk]
            if(M(M_i,M_j,M_k)~=0)
                cnt=cnt+1;
                %(*ここから)
                Q(cnt,1)=M(M_i,M_j,M_k);
                Q(cnt,2)=((M_i-1)*(xMax-xMin)/(szX-1))+xMin;
                Q(cnt,3)=((M_j-1)*(yMax-yMin)/(szY-1))+yMin;
                Q(cnt,4)=((M_k-1)*(zMax-zMin)/(szZ-1))+zMin;
                %(*ここまで)
            end
        end
    end
end
%{
以上の処理により、
num番目の電荷の電気量はQ(num,1)に、
num番目の電荷のｘ座標はQ(num,2)に、
num番目の電荷のｙ座標はQ(num,3)に、
num番目の電荷のｚ座標はQ(num,4)に、
それぞれ格納された
%}
%次に、num番目の電荷が点P(x,y,z)に作る電場ベクトルの4πε倍である
%(e(num,1),e(num,2),e(num,3))を求める。
scalar(cnt)=0; ...高速化
e(cnt,3)=0;
for num=[1:cnt]
    scalar(num)=Q(num,1)*(((x-Q(num,2))^2+(y-Q(num,3))^2+(z-Q(num,4))^2)^-1.5);
    e(num,1)=scalar(num)*(x-Q(num,2));
    e(num,2)=scalar(num)*(y-Q(num,3));
    e(num,3)=scalar(num)*(z-Q(num,4));
end
%ベクトルeの総和をEに格納
E=[0,0,0];
for num=[1:cnt]
    E(1)=E(1)+e(num,1);
    E(2)=E(2)+e(num,2);
    E(3)=E(3)+e(num,3);
end
absOfE=(((E(1))^2)+((E(2))^2)+((E(3))^2))^0.5;
E(1)=E(1)/absOfE;
E(2)=E(2)/absOfE;
E(3)=E(3)/absOfE;

if(N<=-1)
%Nが-1以下なら、-N回に1回の割合で電気力線を途絶えさせる
    if(rand()*(-N)>(-N-1))
       i=NaN;
       j=0;
       k=0;
       return;
   end 
elseif(-1<N && N<1)
%-1<N<1なら
    if(N~=0)
    %Nが0でないなら
        fprintf("unitElectricField3関数の引数Nにエラー。unitElectricField3関数の説明をよく読むこと。\n")
        i=NaN;
        j=0;
        k=0;
        return
    else
    %N==0なら
        %何もしない
    end
elseif(rand()*(N)>(N-1))
%Nが1以上なら、N回に1回の割合で電気力線を反射させる
    %{
    αβγ空間を考え、
    電気力線の進行方向を-β方向としたとき、
    α方向へ向かう角度は
    2*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2)))で求められる。
    γ方向へ向かう角度は
    2*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2)))で求められる。

    β方向の単位ベクトルは必ず-Eである。
    また、α方向を次のように定めることにする。
    ･y成分及びz成分が-Eのものと同じである
    ･β方向に垂直である
    このように決めることで、α方向が一意に定まる。
    γ方向については、α方向の単位ベクトルとβ方向の単位ベクトルの外積により定められる方向とする。
    %}
    
    %まず、β方向の単位ベクトルunitBetaを定める。
    unitBeta=-E;
    
    %次に、α方向の単位ベクトルunitAlphaを定める。
    unitAlpha=[NaN,unitBeta(2),unitBeta(3)];
    %unitAlpha(1)は、unitAlpha･unitBeta=0となるように定まる。
    unitAlpha(1)=-(unitBeta(2)*unitBeta(2)+unitBeta(3)*unitBeta(3))/unitBeta(1);
    
    if(unitBeta(1)==0)
    %{
    しかし、unitBeta(1)が0であった場合、unitAlphaを定めることができないため、
    α方向の定義を
    ･x成分及びz成分が-Eのものと同じである
    ･β方向に垂直である
    に変更する
    %}
        unitAlpha=[0,NaN,unitBeta(3)];
        %unitAlpha(2)は、unitAlpha･unitBeta=0となるように定まる。
        unitAlpha(2)=-(unitBeta(1)*unitBeta(1)+unitBeta(3)*unitBeta(3))/unitBeta(2);       
        
        if(unitBeta(2)==0)
        %unitBeta(1)もunitBeta(2)も0である場合については、例えば
        unitAlpha=[1,0,0];
        %が必ずβに垂直になるため、これをα方向の単位ベクトルとしてしまってよい。
        end
    end
    
    %unitAlphaを単位ベクトルにする。
    unitAlpha=unitAlpha./sqrt(unitAlpha(1)^2+unitAlpha(2)^2+unitAlpha(3)^2);
    %γ方向の単位ベクトルunitGamma=unitAlpha×unitBetaを求める
    unitGamma=cross(unitAlpha,unitBeta);
    
    %{
    続いて、反射後の電場ベクトルを求め、Eに上書きする。
    反射後の電場ベクトルの方向は
    α成分をtan(2*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2)))),
    β成分を-1,
    γ成分をtan(2*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2))))
    とするベクトルの方向に一致する。
    %}
    rnd1=rand();
    rnd2=rand();
    E=unitAlpha.*tan(2*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2))));
    E=E+unitBeta.*(-1);
    E=E+unitGamma.*tan(2*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2))));
    
    %Eの大きさ
    absOfE=( (E(1))^2 +(E(2))^2 +(E(3))^2 )^0.5;

    %Eを単位ベクトルにする
    E=E/absOfE;
    
end

r=0.01;
for num=[1:cnt]
    l=Q(num,2);
    m=Q(num,3);
    n=Q(num,4);
    
    %着目電荷Lと電場ベクトルの始点Pとを結ぶ線分LP
    LP=[x-l,y-m,z-n];
    
%{
θとφがそれぞれ違っても、同じ方向に向いてしまうことがある。
例:θ=0,φ=πと、θ=π,φ=0は同じ方向を向く。
したがって、θとφを使う方法では誤判定が生じる可能性があるため適切ではない。
代替案として、LPとEをそれぞれ単位ベクトルとし、各成分の誤差率がすべてr*0.01[%]以内であるかどうかを確認することにした。

(θとφがそれぞれ何を表すかを忘れている場合、github上のコミット履歴を参照のこと。)
%}

%LPの単位ベクトルを求める。
absOfLP=(((LP(1))^2)+((LP(2))^2)+((LP(3))^2))^0.5;
unitLP(1)=-LP(1)/absOfLP;
unitLP(2)=-LP(2)/absOfLP;
unitLP(3)=-LP(3)/absOfLP;

%Eは予め単位ベクトル。

isTouchableDirection ...
= ...
( ...
    abs((E(1)-unitLP(1)))<=r ...
    && ...
    abs((E(2)-unitLP(2)))<=r ...
) ...
    && ...
    abs((E(3)-unitLP(3)))<=r ...
;
    
    if (isTouchableDirection)
    %電場ベクトルが電荷に重なりうる方向である場合で、
        if ...
        ( ...
            abs(LP(1))<=abs(E(1))...
            && ...
            abs(LP(2))<=abs(E(2))...
        ) ...
        && ...
        ( ...
            abs(LP(3))<=abs(E(3)) ...
        ) ...
        %なおかつ電場ベクトルのほうが長い場合、
            if Q(num,1)<0
            %着目電荷が負電荷であれば
                %重なったと判断する
                i=NaN;
                j=0;
                k=0;
            return;
            end
        end
    end
    
end
i=E(1);
j=E(2);
k=E(3);

end
```
(2)[plotEV3.m](https://github.com/17ec084/grade2-2/blob/caed04c8a3faa77b88b44f1f087a9a279d919a7f/electromagnetism/ElectricLinesOfForce/plotEV3.m)を作成した。次の通り。
```matlab
function [endX,endY,endZ]=plotEV3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N)
%plotEV3 Mによって定められる電荷が作る電場ベクトルを点Pからプロットする
%   点P(x,y,z)
%   戻り値は電場ベクトルの終点(つまり可動正電荷の座標)
%   NはunitElectricField3に渡すためのものである。
%   Nについての説明はunitElectricField3における説明を参照せよ。


%電場ベクトル(の大きさlengthOfEと単位ベクトルunitOfE)を求める
[Ex,Ey,Ez]=unitElectricField3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N);
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
```  

(3)[plotEL1_3.m](https://github.com/17ec084/grade2-2/blob/7aeff3f14a0614b248d5413bf80cb3b8e21bd1b5/electromagnetism/ElectricLinesOfForce/plotEL1_3.m)を作成した。次の通り。  
```matlab
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
```  

(4)  
2.10.2項に示した実験10(3)の結果に示したことから、(4)では次のような修正を加える実験を行った。  
・plotEL1_3関数、plotEV3関数、unitElectricField3関数に、MのかわりにQを渡すことも出来るように修正する  
(Mはインデックスを3次元空間座標に見立てた3次元行列であり、Qは電荷の座標3成分と電気量を格納する4次元行列である。  
Mの大きさは空間の広さに従うが、Qの大きさは電荷の個数に従うため、電荷の数密度が大きくない限りはQのほうが遥かにコンパクトに電荷の情報を表現できる。)  
・isEVInAreaの設定を適切にする  
  
[unitElectricField3.m](https://github.com/17ec084/grade2-2/blob/b3c8df53883146c2f466892cad8571ad334c0c25/electromagnetism/ElectricLinesOfForce/unitElectricField3.m)について、  
・まず引数にisMQを追加した。  
・処理の一番最初に `if isMQ==false` を追加した。  
・次のコメント  
```matlab
    %{
    以上の処理により、
    num番目の電荷の電気量はQ(num,1)に、
    num番目の電荷のｘ座標はQ(num,2)に、
    num番目の電荷のｙ座標はQ(num,3)に、
    num番目の電荷のｚ座標はQ(num,4)に、
    それぞれ格納された
    %}
```
のあとに、次のものを挿入した。  
```matlab
else
%isMQがtrueなら
    Q=M;
    tmp=size(Q);
    cnt=tmp(1);
end
```
  
また、[plotEV3.m](https://github.com/17ec084/grade2-2/blob/b3c8df53883146c2f466892cad8571ad334c0c25/electromagnetism/ElectricLinesOfForce/plotEV3.m)と[plotEL1_3.m](https://github.com/17ec084/grade2-2/blob/835399612f2f493ede72835331a498071c28c1df/electromagnetism/ElectricLinesOfForce/plotEL1_3.m)について、  
引数isMQを受け取ってunitElectricField3.mに渡すように修正した。  
  
さらに、[plotEL1_3](https://github.com/17ec084/grade2-2/blob/835399612f2f493ede72835331a498071c28c1df/electromagnetism/ElectricLinesOfForce/plotEL1_3.m)については、  
isEVInAreaを次のように変更した(2か所)。
```matlab
 isEVInArea= ...
 ((xMin<=startX && startX<=xMax)&&(yMin<=startY && startY<=yMax)) ...
 && ...   
 (zMin<=startZ && startZ<=zMax);
```  
  
最後に、次のような[M2Q.m](https://github.com/17ec084/grade2-2/blob/b3c8df53883146c2f466892cad8571ad334c0c25/electromagnetism/ElectricLinesOfForce/M2Q.m)を作成した。  
これは、行列M及び座標の範囲を入力すると、行列Qを出力するプログラムである。
```matlab
function Q = M2Q( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,alert,x,y,z)
%M2Q 3次元行列Mを3次元空間とみることによって定められる電荷の情報を、
%   電荷の座標情報と電気量を格納する4次元行列Qに書き換えることでコンパクトに
%   表現しなおす
%   Mは3次元行列である必要があり、xの範囲はxmin～xmaxである。
%   alertをtrueとすると、点(x,y,z)上に電荷が存在するか調べ、「そこでreturnする」
%   もし存在した場合、エラーメッセージをfprintfする。
%   この機能の用途は、点(x,y,z)を電気力線の始点にできるか否かを知ることである。

    %まず、行列M内に0でない値がいくつ格納されているか調べる。
    %この個数cntが電荷の数である。
    %同時にそれぞれの電荷の情報を行列Qに格納する。

    cnt=0;
    [Mi,Mj,Mk]=size(M);
    for M_i=[1:Mi]
        for M_j=[1:Mj]
            for M_k=[1:Mk]
                if(M(M_i,M_j,M_k)~=0)
                    cnt=cnt+1;
                    %(*ここから)
                    Q(cnt,1)=M(M_i,M_j,M_k);
                    Q(cnt,2)=((M_i-1)*(xMax-xMin)/(szX-1))+xMin;
                    Q(cnt,3)=((M_j-1)*(yMax-yMin)/(szY-1))+yMin;
                    Q(cnt,4)=((M_k-1)*(zMax-zMin)/(szZ-1))+zMin;
                    %(*ここまで)
                
                    if alert
                        %始点が電荷に衝突していた場合にアラートする。
                        if ((Q(cnt,2)==x)&&(Q(cnt,3)==y))&&(Q(cnt,4)==z)
                            fprintf("M2Q(alert==true)メソッド実行中にエラー。電荷の存在する座標から出発することはできない。\n");
                            return;
                        end
                    end
                end
            end
        end
    end
    %{
    以上の処理により、
    num番目の電荷の電気量はQ(num,1)に、
    num番目の電荷のｘ座標はQ(num,2)に、
    num番目の電荷のｙ座標はQ(num,3)に、
    num番目の電荷のｚ座標はQ(num,4)に、
    それぞれ格納された
    %}

end
```


### 2.10.2 実験10の結果
(1)
  
```matlab
M(501,551,451)=1.7;
M(46,451,1)=3;
M(651,351,251)=-2.1;
M(676,351,251)=100;
```

をコマンドラインに入力した後に、続けて次のように入力した。  

```matlab
[vx,vy,vz]=unitElectricField3(M, 1001, 1001, 1001, -10, 10, -10, 10, -10, 10, 2.5, -3, -5, 0);
```

すると、

```matlab
vx=-1.000000;
vy=-0.000345;
vz=-0.000236;
```

が得られた。2.9.2項に示した通り、この結果は妥当である。  

(2)  
  
```matlab
M(501,551,451)=1.7;
M(46,451,1)=3;
M(651,351,251)=-2.1;
M(676,351,251)=100;
```

をコマンドラインに入力した後に、続けて次のように入力した。  
```matlab
plotEV3(M, 1001, 1001, 1001, -10, 10, -10, 10, -10, 10, 2.5, -3, -5, 0);
```

すると、図2.10.2.1のように2点(2.5,-3,-5)、(1.5,-3.003453,-5.002356)を結ぶ線分が得られた。  
![](https://github.com/17ec084/grade2-2/blob/d4f54a7262fe14df75964d6d63ad490c5aa3403e/electromagnetism/data/10_1.png)  
この線分は、(2.5,-3,-5)を始点にベクトル(-1,-0.003453,-0.002356)だけ進行したものであるということができる。  
したがって、この結果は妥当である。  

(3)
  
```matlab
M(501,551,451)=1.7;
M(46,451,1)=3;
M(651,351,251)=-2.1;
M(676,351,251)=100;
```

をコマンドラインに入力した後に、続けて次のように入力した。  
```matlab
plotEL1_3(M, 1001, 1001, 1001, -10, 10, -10, 10, -10, 10, 2.5, -3, -5, -100);
```

すると、10分ほど経過したのち、以下の点たちを結ぶ線分によって構成させる電気力線を得た。
```
(2.500000,-3.000000,-5.000000)
(1.500000,-3.000345,-5.000236)
(0.500002,-3.002076,-5.001392)
(-0.499983,-3.006636,-5.004259)
(-1.499934,-3.015358,-5.009065)
(-2.499823,-3.029061,-5.014789)
(中略)
(-63.023197,-7.359934,0.922992)
(-64.016597,-7.428381,1.015030)
(-65.010002,-7.496809,1.107033)
(-66.003412,-7.565218,1.199000)
(-66.996825,-7.633610,1.290935)
(NaN,NaN,NaN)
```
(これらの情報はプログラム中にfprintfを挿入することで得られた)    
但し、(NaN,NaN,NaN)は領域外進出以外の原因で電気力線が途絶えたことを意味する。
この結果を検証しよう。  
まず、このプログラムの実行に10分という長時間を要した原因は、一つ一つの点を求める際に行列Mを読み込み、計算する必要があるからである。  
また、点(NaN,NaN,NaN)は、plotEL1_3の最後の引数N=-100によって、100回に1回の確率で電気力線が強制停止することが発生したことを意味すると考えられる。  
また、xMin,xMax,yMin,yMax,zMin,zMaxの設定より、すべての点の成分の絶対値は10以下でなければならないが、そのことを満たしていない。これは、plotEL1_3関数内で、着目している点が領域内にあるか領域外にあるか判断する変数isEVInAreaの設定を適切に行わなかったためである。  

(4)  
```matlab
M(501,551,451)=1.7;
M(46,451,1)=3;
M(651,351,251)=-2.1;
M(676,351,251)=100;
```

をコマンドラインに入力した後に、続けて次のように入力した。  
```matlab
Q=M2Q(M,1001,1001,1001,-10,10,-10,10,-10,10,true,33,-3,-5);
```  
続いて、次のように入力した。  
```matlab
plotEL1_3(Q,1001,1001,1001,-10,10,-10,10,-10,10,2.5,-3,-5,-100,true);
```

すると、数秒以内に図2.10.2.2のような結果を得た。  


![](https://github.com/17ec084/grade2-2/blob/1056121bb88e8dfee402c4a1c3f3929752f98668/electromagnetism/data/21022.png)  
図2.10.2.2 plotEL1_3(Q,1001,1001,1001,-10,10,-10,10,-10,10,2.5,-3,-5,-100,true)の結果

# 3.今後の展望

実験10までで、電荷の置かれた任意の3次元空間全体に電気力線を描画することが可能となった。これを利用して、  
1.電荷の周りに放射状に電気力線の始点を設けて描画する  
2.誘電率の変化によって、電気力線を合流させたり分流させたりする
を行うと、次のことが可能になる。
3.電気力線の密度から、各点ごとの電場を求めることができる。  
4.線積分により、電圧が求められる。  





<!--
(2/3)では電場ベクトルが電荷とぶつかるかどうかの判断をするプログラムを作る。
実際にunitElectricFieldなどの関数に組み込むのは(3/3)で。
-->


<!-- 
(1)のことをその都度計算するのは処理能力を無駄に使うことになってしまうため、確率を適切に調整した乱数を用いて反射を再現することにした。  
そのために必要な、反射角度の確率密度関数を考えよう。  
便宜上、-βからα方向への角度を2φαβ、  
-βからγ方向への角度を2φγβとする。  
次のプログラムを実行することでφαβおよびΦγβの確率密度関数を求めることができる。  

```MATLAB
%  Φαβの相対的な出やすさ(y)とΦγβの相対的な出やすさ(z)をrとθで求める。
%  rnd1=r
%  rnd2=θ
clear;
y(1572)=0;
z(1572)=0;
x=linspace(0,pi,1572);
for i=[1:20000000]
rnd1=rand();
rnd2=rand();
n=uint64(500*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2))));
m=uint64(500*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2))));
y(n+1)=y(n+1)+1;
z(n+1)=z(n+1)+1;
end
plot3(x,y,z)
```

このプログラムは、φαβおよびΦγβの値域[0,π]を等間隔で1572つの点に分け(つまり1572-1=1571等分し)、次の試行を20000000回繰り返し、その結果をプロットするものである。  
試行1:rとθを無作為に決定し、φαβとΦγβを求める。  
試行2:求められたφαβに対応する点nを1572つの点から選び、その点が選ばれた回数を記録する。  
この回数がn番目の点のy座標となる(x座標は必ずn)。  
試行3:求められたφγβに対応する点nを1572つの点から選び、その点が選ばれた回数を記録する。  
この回数がn番目の点のz座標となる。  
この方法により、xがφαβやφγβの値を、yがφαβの値の相対的な出やすさを、zがφγβの値の相対的な出やすさを、表すようになる。  

結果は図2.7.2.3のようになった。  
![](https://github.com/17ec084/grade2-2/blob/9d8c86e5e1fd1c07e37845bd8b3c529e91aea8b8/electromagnetism/data/2723_.png)
図2.7.2.3 φαβおよびφγβの確率密度関数(実証)  
  
しかし、φαβとφγβは無関係に決まるのではなく、どちらも共通するrとθによって定まるため、φαβとφγβの確率密度を独立させて考えるよりは、(φαβ)π×100+φγβの確率密度を考えるほうが適切である。  
(φαβ)π×100+φγβの確率密度を求めるため、次のプログラムを実行した。  

```MATLAB
%  100Φαβの相対的な出やすさ(πの位)とΦγβの相対的な出やすさ(1の位)をrとθで求める。
%  但し、計算上では100Φαβの相対的な出やすさは1572の位で考えている。
%  rnd1=r
%  rnd2=θ
clear;
y(157080*(1572+1))=0;

x=linspace(0,100*pi*pi*(1573/1572),157080*(1572+1));
for i=[1:20000000]
rnd1=rand();
rnd2=rand();
n=uint64(50000*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2))));
m=uint64(500*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2))));
l=n*1572+m;
y(l+1)=y(l+1)+1;
end
plot(x,y)
```

このプログラムは、(φαβ)π×100+φγβの値域[0,π^2+Δ]を等間隔で1572×1573つの点に分け、次の試行を20000000回繰り返し、その結果をプロットするものである。  
試行1:rとθを無作為に決定し、(φαβ)π×100+φγβを求める。  
試行2:求められた(φαβ)π×100+φγβに対応する点nを1572×1573つの点から選び、その点が選ばれた回数を記録する。  
この回数がn番目の点のy座標となる(x座標は必ずn)。  

プログラムを実行した結果、図2.7.2.4を得た。  
![](https://github.com/17ec084/grade2-2/blob/afcda302bad6eb4c31bef7779ffa7198f3b3b256/electromagnetism/data/2724.png)  
図2.7.2.4 (φαβ)π×100+φγβの確率密度  
  
次に、図2.7.2.4を数学関数で近似することを考える。  
大雑把に[0,100],[100,400],[400,(100*pi*pi*(1573/1572))/2]にわけて考えることができそうである。
(3)  
(φαβ)π×100+φγβがaになる確率は、  
(「(φαβ)π×100+φγβが[0,a]内の値にきまることの起こりやすさ」-「(φαβ)π×100+φγβが[0,a)内の値にきまることの起こりやすさ」)/「(φαβ)π×100+φγβが[0,π^2+Δ]内の値にきまることの起こりやすさ」  
である。図2.7.2.4でいえば、  
「x=aである点のy座標」/「1572×1573つの点のy座標の合計」  
といえる。  
したがって区間[0,「1572×1573つの点のy座標の合計」]を一様分布する乱数rndが、  
「x<aである点のy座標の合計」<=rnd<=「x<=aである点のy座標の合計」  
に決まることによって、(φαβ)π×100+φγβ=aが起こることは再現できる。  
φαβはa/(π×100)によりおおよそ求めることができ、  
φγβはaをπ×100で割った余剰により求めることができる。  
  
以上のことを用いて、rndを受け取ってφαβとφγβを返却する関数を作成する。  
function [phiAlphaBeta,phiGammaBeta] = getPhiByRnd(rnd)
%GETPHIBYRND rndからφαβとφγβを求めるメソッド
%   (φαβ)π×100+φγβの確率密度関数を示すのに必要なファイルgetPhiByRnd.matをワークスペースに読み込んでおく必要がある。
%   
-->


<!--
今後の実験予定
〇2.1を3Dプロットする(2.2)
〇2.2で電場ベクトルの大きさが極端に小さくなってしまうから、大きさを固定(2.3)
〇負電荷に対応。電気力線(点ではないので注意)が電荷に重なった場合そこで電気力線を止める必要あり(2.4)
〇電荷が複数ある場合(２つ。)(2.5、2.6)
・〇電気力線が曲線になることの確認
・〇置き方によっては電気力線が線形で、しかし振動する。プログラムが止まらない
　　→途中点が同じになることがあるか調べると、使用メモリが大きくなってしまう
　　→原子密度atomDensityを定義して、原子にあたってランダムに反射するシミュレートをする
・電荷が複数ある場合(3次元行列を領域に見立てて電荷を書いておいたものを読み取る場合)
・途中で誘電率が変わる場合
・電気力線の密度によって電場の強さや電圧を求める
・double型変数の精度限界(uint64の整数型に移行←10の冪を掛け算してケタをずらす必要あり)
-->

# 4.参考資料
[1]iOSアプリ「Verve」Hiroyuki KOBAYASHI氏開発 東京都立産業技術高等専門学校電気電子工学コース教材
