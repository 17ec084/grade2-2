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
