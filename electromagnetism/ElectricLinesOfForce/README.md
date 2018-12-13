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

## 2.5 実験5 電荷が2つある場合(1/2)―非線形電気力線の描画
実験4まででは、電荷が1つで、電荷の符号と大きさも予め決まっている上で議論してきた。その為電気力線は必ず線形(正電荷なら半直線、負電荷なら線分)となっていた。  
実験5以降では、電荷が複数になった場合の電気力線を描画することを試みる。  
但し、実験5では簡単に考えるため、電荷は2個とする。  

### 2.5.1 実験5の手順
(1) [unitElectricField.m](https://github.com/17ec084/grade2-2/blob/e41675c75b1e4d99bc245b9ade0db2b54aa69c62/electromagnetism/ElectricLinesOfForce/unitElectricField.m) をもとに、電荷の置かれた2点、電荷の符号、始点を受け取り、その電場方向の単位ベクトルを求めるプログラム[unitElectricField2.m](https://github.com/17ec084/grade2-2/blob/62d24013567bd60da49e68bcd6a834b7a1a8d826/electromagnetism/ElectricLinesOfForce/unitElectricField2.m)を作った。  
また、電場方向の単位ベクトルが電荷に重なった場合、(NaN,0,0)を返す仕様にしてある。

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

## 2.6 実験6 電場ベクトルが零ベクトルとなる場合
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
[unitElectricField2.m](https://github.com/17ec084/grade2-2/blob/master/electromagnetism/ElectricLinesOfForce/unitElectricField2.m)について、

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

## 2.7 実験7 散乱による電気力線の発振防止
実験6のプログラムで、例えば次のようなものをコマンドラインに入力して実行すると、プログラムが停止しなくなる。

```MATLAB
a=[0,0,1,1];
b=[0,0];
c=[0,10];
plotEL1_2(a,b,c, 0,0,4.9);
```

<!--
今後の実験予定
〇2.1を3Dプロットする(2.2)
〇2.2で電場ベクトルの大きさが極端に小さくなってしまうから、大きさを固定(2.3)
〇負電荷に対応。電気力線(点ではないので注意)が電荷に重なった場合そこで電気力線を止める必要あり(2.4)
・電荷が複数ある場合(２つ。)(2.5、2.6)
・〇電気力線が曲線になることの確認
・・置き方によっては電気力線が線形で、しかし振動する。プログラムが止まらない
　　→途中点が同じになることがあるか調べると、使用メモリが大きくなってしまう
　　→原子密度atomDensityを定義して、原子にあたってランダムに反射するシミュレートをする
・電荷が複数ある場合(3次元行列を領域に見立てて電荷を書いておいたものを読み取る場合)
・途中で誘電率が変わる場合
・電気力線の密度によって電場の強さや電圧を求める
・double型変数の精度限界(uint64の整数型に移行←10の冪を掛け算してケタをずらす必要あり)
-->

# n.参考資料
[1]iOSアプリ「Verve」Hiroyuki KOBAYASHI氏開発 東京都立産業技術高等専門学校電気電子工学コース教材
