function phiAlphaBeta = getPhiAlphaBetaByA( A,N )
%GETPHIALPHABETABYA Aからφαβを求めるメソッド
%   つまり、φαβ(A)
%   仕様:Aは区間[0,N(N+1)]を一様分布,Rは約分により消去済み
%   ・使用例「Aが一様分布である際のφαβの分布」を見る際は、引数を"example1"とせよ
%   (この例は、厳密にいうならば「一様分布のAを10000000回代入したとき、φがどのような値に何回なるか」を示すものである) 
%   ・使用例「∂φαβ/∂A」を見る際は、引数を"example2"とせよ
if string(A)=="example1"
    fprintf("clear;\n");
    fprintf("y(1572)=0;\n");
    fprintf("x=linspace(0,pi,1572);\n");
    fprintf("for i=[1:10000000]\n");
    fprintf("    rnd1=rand();\n");
    fprintf("    n=1+int64(500.*getPhiAlphaBetaByA(rnd1*5000*5001,5000));\n");
    fprintf("    y(n)=y(n)+1;\n");
    fprintf("end\n");
    fprintf("plot(x,y)\n");
    phiAlphaBeta="example1";
    return;
end
if string(A)=="example2"
    fprintf("clear;\n");
    fprintf("N=5000;\n");
    fprintf("A=[0:N*(N+1)];\n");
    fprintf("d=1;\n");
    fprintf("y=(getPhiAlphaBetaByA(A+d,N)-getPhiAlphaBetaByA(A,N))./d;\n");
    fprintf("plot(A,y)\n");
    phiAlphaBeta="example2";
    return;
end



phiAlphaBeta=acos(real(((A./(N.^2)).*cos((((2*pi).*A))./N))./sqrt(1./(4.*(1-(A./(N.^2)).^2))-(A./(N.^2).*sin((((2*pi).*A))./N)).^2)));
%realについて・・・近似誤差によるものであると思われるが、phiAlphaBetaがごくまれに実数でなくなる場合が存在し、その場合は以下の通りであることが確認されている
%・純虚数である
%・Aは終点に近い
%後者の条件を利用するにはif文が必要になるが、rnd1がベクトルであるため、不適切である。
%その為、前者の条件を利用し、実部を取り出すことで、必ず実数になるように調節している。

end

