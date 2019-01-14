function [i,j,k] = unitElectricField3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N,isMQ )
%unitElectricField3 M�ɂ���Ē�߂���d�ׂ��_P�ɍ��d��x�N�g�������߂�B�A���傫����1�ɂȂ�悤�ɋ����I�Ɋg��k������
%   �_P(x,y,z)
%   M��3�����s��ł���K�v������Ax�͈̔͂�xmin�`xmax�ł���B
%   �܂��Aabs(N)���1��A
%   N�����Ȃ甽�˂��A
%   N�����Ȃ���ł��N����B
%   N��0�Ȃ牽���N����Ȃ�
%   isMQ�́A�s��M�̑���ɍs��Q���^�����Ă���ꍇ��true�Ƃ���B(����10(4)�Œǉ�)

%����10(4)�Œǉ���������

%isMQ��false�Ȃ�
if isMQ==false

%����10(4)�Œǉ������܂�

    %�܂��A�s��M����0�łȂ��l�������i�[����Ă��邩���ׂ�B
    %���̌�cnt���d�ׂ̐��ł���B
    %�����ɂ��ꂼ��̓d�ׂ̏����s��Q�Ɋi�[����B

    cnt=0;
    [Mi,Mj,Mk]=size(M);
    for M_i=[1:Mi]
        for M_j=[1:Mj]
            for M_k=[1:Mk]
                if(M(M_i,M_j,M_k)~=0)
                    cnt=cnt+1;
                    %(*��������)
                    Q(cnt,1)=M(M_i,M_j,M_k);
                    Q(cnt,2)=((M_i-1)*(xMax-xMin)/(szX-1))+xMin;
                    Q(cnt,3)=((M_j-1)*(yMax-yMin)/(szY-1))+yMin;
                    Q(cnt,4)=((M_k-1)*(zMax-zMin)/(szZ-1))+zMin;
                    %(*�����܂�)
                
                    %�n�_���d�ׂɏՓ˂��Ă����ꍇ�ɃA���[�g����B
                    if ((Q(cnt,2)==x)&&(Q(cnt,3)==y))&&(Q(cnt,4)==z)
                        fprintf("unitElectricField3���\�b�h���s���ɃG���[�B�d�ׂ̑��݂�����W����o�����邱�Ƃ͂ł��Ȃ��B\n");
                        return;
                    end
                end
            end
        end
    end
    %{
    �ȏ�̏����ɂ��A
    num�Ԗڂ̓d�ׂ̓d�C�ʂ�Q(num,1)�ɁA
    num�Ԗڂ̓d�ׂ̂����W��Q(num,2)�ɁA
    num�Ԗڂ̓d�ׂ̂����W��Q(num,3)�ɁA
    num�Ԗڂ̓d�ׂ̂����W��Q(num,4)�ɁA
    ���ꂼ��i�[���ꂽ
    %}

%����10(4)�Œǉ���������
else
%isMQ��true�Ȃ�
    Q=M;
    tmp=size(Q);
    cnt=tmp(1);
end
%����10(4)�Œǉ������܂�

%���ɁAnum�Ԗڂ̓d�ׂ��_P(x,y,z)�ɍ��d��x�N�g����4�΃Ô{�ł���
%(e(num,1),e(num,2),e(num,3))�����߂�B
scalar(cnt)=0; ...������
e(cnt,3)=0;
for num=[1:cnt]
    scalar(num)=Q(num,1)*(((x-Q(num,2))^2+(y-Q(num,3))^2+(z-Q(num,4))^2)^-1.5);
    e(num,1)=scalar(num)*(x-Q(num,2));
    e(num,2)=scalar(num)*(y-Q(num,3));
    e(num,3)=scalar(num)*(z-Q(num,4));
end
%�x�N�g��e�̑��a��E�Ɋi�[
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
%N��-1�ȉ��Ȃ�A-N���1��̊����œd�C�͐���r�₦������
    if(rand()*(-N)>(-N-1))
       i=NaN;
       j=0;
       k=0;
       return;
   end 
elseif(-1<N && N<1)
%-1<N<1�Ȃ�
    if(N~=0)
    %N��0�łȂ��Ȃ�
        fprintf("unitElectricField3�֐��̈���N�ɃG���[�BunitElectricField3�֐��̐������悭�ǂނ��ƁB\n")
        i=NaN;
        j=0;
        k=0;
        return
    else
    %N==0�Ȃ�
        %�������Ȃ�
    end
elseif(rand()*(N)>(N-1))
%N��1�ȏ�Ȃ�AN���1��̊����œd�C�͐��𔽎˂�����
    %{
    ��������Ԃ��l���A
    �d�C�͐��̐i�s������-�������Ƃ����Ƃ��A
    �������֌������p�x��
    2*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2)))�ŋ��߂���B
    �������֌������p�x��
    2*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2)))�ŋ��߂���B

    �������̒P�ʃx�N�g���͕K��-E�ł���B
    �܂��A�����������̂悤�ɒ�߂邱�Ƃɂ���B
    �y�����y��z������-E�̂��̂Ɠ����ł���
    ��������ɐ����ł���
    ���̂悤�Ɍ��߂邱�ƂŁA����������ӂɒ�܂�B
    �������ɂ��ẮA�������̒P�ʃx�N�g���ƃ������̒P�ʃx�N�g���̊O�ςɂ���߂�������Ƃ���B
    %}
    
    %�܂��A�������̒P�ʃx�N�g��unitBeta���߂�B
    unitBeta=-E;
    
    %���ɁA�������̒P�ʃx�N�g��unitAlpha���߂�B
    unitAlpha=[NaN,unitBeta(2),unitBeta(3)];
    %unitAlpha(1)�́AunitAlpha�unitBeta=0�ƂȂ�悤�ɒ�܂�B
    unitAlpha(1)=-(unitBeta(2)*unitBeta(2)+unitBeta(3)*unitBeta(3))/unitBeta(1);
    
    if(unitBeta(1)==0)
    %{
    �������AunitBeta(1)��0�ł������ꍇ�AunitAlpha���߂邱�Ƃ��ł��Ȃ����߁A
    �������̒�`��
    �x�����y��z������-E�̂��̂Ɠ����ł���
    ��������ɐ����ł���
    �ɕύX����
    %}
        unitAlpha=[0,NaN,unitBeta(3)];
        %unitAlpha(2)�́AunitAlpha�unitBeta=0�ƂȂ�悤�ɒ�܂�B
        unitAlpha(2)=-(unitBeta(1)*unitBeta(1)+unitBeta(3)*unitBeta(3))/unitBeta(2);       
        
        if(unitBeta(2)==0)
        %unitBeta(1)��unitBeta(2)��0�ł���ꍇ�ɂ��ẮA�Ⴆ��
        unitAlpha=[1,0,0];
        %���K�����ɐ����ɂȂ邽�߁A������������̒P�ʃx�N�g���Ƃ��Ă��܂��Ă悢�B
        end
    end
    
    %unitAlpha��P�ʃx�N�g���ɂ���B
    unitAlpha=unitAlpha./sqrt(unitAlpha(1)^2+unitAlpha(2)^2+unitAlpha(3)^2);
    %�������̒P�ʃx�N�g��unitGamma=unitAlpha�~unitBeta�����߂�
    unitGamma=cross(unitAlpha,unitBeta);
    
    %{
    �����āA���ˌ�̓d��x�N�g�������߁AE�ɏ㏑������B
    ���ˌ�̓d��x�N�g���̕�����
    ��������tan(2*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2)))),
    ��������-1,
    ��������tan(2*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2))))
    �Ƃ���x�N�g���̕����Ɉ�v����B
    %}
    rnd1=rand();
    rnd2=rand();
    E=unitAlpha.*tan(2*acos(((rnd1.*cos(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(sin(2*pi*rnd2)).^2))));
    E=E+unitBeta.*(-1);
    E=E+unitGamma.*tan(2*acos(((rnd1.*sin(2*pi*rnd2))./sqrt(1./(4.*(1-(rnd1.^2)))-(rnd1.^2).*(cos(2*pi*rnd2)).^2))));
    
    %E�̑傫��
    absOfE=( (E(1))^2 +(E(2))^2 +(E(3))^2 )^0.5;

    %E��P�ʃx�N�g���ɂ���
    E=E/absOfE;
    
end

r=0.01;
for num=[1:cnt]
    l=Q(num,2);
    m=Q(num,3);
    n=Q(num,4);
    
    %���ړd��L�Ɠd��x�N�g���̎n�_P�Ƃ����Ԑ���LP
    LP=[x-l,y-m,z-n];
    
%{
�Ƃƃӂ����ꂼ�����Ă��A���������Ɍ����Ă��܂����Ƃ�����B
��:��=0,��=�΂ƁA��=��,��=0�͓��������������B
���������āA�Ƃƃӂ��g�����@�ł͌딻�肪������\�������邽�ߓK�؂ł͂Ȃ��B
��ֈĂƂ��āALP��E�����ꂼ��P�ʃx�N�g���Ƃ��A�e�����̌덷�������ׂ�r*0.01[%]�ȓ��ł��邩�ǂ������m�F���邱�Ƃɂ����B

(�Ƃƃӂ����ꂼ�ꉽ��\������Y��Ă���ꍇ�Agithub��̃R�~�b�g�������Q�Ƃ̂��ƁB)
%}

%LP�̒P�ʃx�N�g�������߂�B
absOfLP=(((LP(1))^2)+((LP(2))^2)+((LP(3))^2))^0.5;
unitLP(1)=-LP(1)/absOfLP;
unitLP(2)=-LP(2)/absOfLP;
unitLP(3)=-LP(3)/absOfLP;

%E�͗\�ߒP�ʃx�N�g���B

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
    %�d��x�N�g�����d�ׂɏd�Ȃ肤������ł���ꍇ�ŁA
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
        %�Ȃ����d��x�N�g���̂ق��������ꍇ�A
            if Q(num,1)<0
            %���ړd�ׂ����d�ׂł����
                %�d�Ȃ����Ɣ��f����
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

