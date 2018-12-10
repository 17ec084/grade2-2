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

