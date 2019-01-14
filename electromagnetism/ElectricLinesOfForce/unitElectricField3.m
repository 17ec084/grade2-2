function [i,j,k] = unitElectricField3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N,isMQ )
%unitElectricField3 Mによって定められる電荷が点Pに作る電場ベクトルを求める。但し大きさは1になるように強制的に拡大縮小する
%   点P(x,y,z)
%   Mは3次元行列である必要があり、xの範囲はxmin～xmaxである。
%   また、abs(N)回に1回、
%   Nが正なら反射が、
%   Nが負なら消滅が起こる。
%   Nが0なら何も起こらない
%   isMQは、行列Mの代わりに行列Qが与えられている場合にtrueとする。(実験10(4)で追加)

%実験10(4)で追加ここから

%isMQがfalseなら
if isMQ==false

%実験10(4)で追加ここまで

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
                
                    %始点が電荷に衝突していた場合にアラートする。
                    if ((Q(cnt,2)==x)&&(Q(cnt,3)==y))&&(Q(cnt,4)==z)
                        fprintf("unitElectricField3メソッド実行中にエラー。電荷の存在する座標から出発することはできない。\n");
                        return;
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

%実験10(4)で追加ここから
else
%isMQがtrueなら
    Q=M;
    tmp=size(Q);
    cnt=tmp(1);
end
%実験10(4)で追加ここまで

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

