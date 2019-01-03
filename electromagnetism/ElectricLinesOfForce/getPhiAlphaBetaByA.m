function phiAlphaBeta = getPhiAlphaBetaByA( A,N )
%GETPHIALPHABETABYA A����Ӄ��������߂郁�\�b�h
%   �܂�A�Ӄ���(A)
%   �d�l:A�͋��[0,N(N+1)]����l���z,R�͖񕪂ɂ������ς�
%   �E�g�p��uA����l���z�ł���ۂ̃Ӄ����̕��z�v������ۂ́A������"example1"�Ƃ���
%   (���̗�́A�����ɂ����Ȃ�΁u��l���z��A��10000000���������Ƃ��A�ӂ��ǂ̂悤�Ȓl�ɉ���Ȃ邩�v���������̂ł���) 
%   �E�g�p��u�݃Ӄ���/��A�v������ۂ́A������"example2"�Ƃ���
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
%real�ɂ��āE�E�E�ߎ��덷�ɂ����̂ł���Ǝv���邪�AphiAlphaBeta�������܂�Ɏ����łȂ��Ȃ�ꍇ�����݂��A���̏ꍇ�͈ȉ��̒ʂ�ł��邱�Ƃ��m�F����Ă���
%�E�������ł���
%�EA�͏I�_�ɋ߂�
%��҂̏����𗘗p����ɂ�if�����K�v�ɂȂ邪�Arnd1���x�N�g���ł��邽�߁A�s�K�؂ł���B
%���ׁ̈A�O�҂̏����𗘗p���A���������o�����ƂŁA�K�������ɂȂ�悤�ɒ��߂��Ă���B

end

