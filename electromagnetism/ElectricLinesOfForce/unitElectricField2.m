function [i,j,k] = unitElectricField2( a,b,c,x,y,z,N )
%unitElectricField2 点A1と点A2が点Pに作る電場ベクトルを求める。但し大きさは1になるように強制的に拡大縮小する
%   点A1(a(1),b(1),c(1))、点A2(a(2),b(2),c(2))、点P(x,y,z)
%   bとcは長さ2のベクトル、aは長さ4のベクトルである必要がある。
%   a(3)は点A1の電荷の符号を意味する。+なら1を、-なら-1を格納すること。
%   a(4)は点A2の電荷の符号を意味する。+なら1を、-なら-1を格納すること。
%   また、abs(N)回に1回、
%   Nが正なら反射が、
%   Nが負なら消滅が起こる。
%   Nが0なら何も起こらない

%Nは実験7で追加された。

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
 fprintf("unitElectricField2関数の引数ベクトルaまたはbにエラー。unitElectricField2関数の説明をよく読むこと。\n")
 i=NaN;
 j=0;
 k=0;
 return
end

%E
%合成電場ベクトル(の4πε/Q倍)
E=a(3)*E1+a(4)*E2;

%Eが零ベクトルなら微小な乱数を各成分に加える
if ((E(1)==0)&&(E(2)==0))&&(E(3)==0)

    %乱数の幅。乱数は区間[-randWidth,randWidth]となる
    randWidth=0.1;
    
    E=2*randWidth*(rand(1,3)-[0.5,0.5,0.5]);
end

%Eの大きさ
absOfE=( (E(1))^2 +(E(2))^2 +(E(3))^2 )^0.5;

%Eを単位ベクトルにする
E=E/absOfE;

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
else
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

