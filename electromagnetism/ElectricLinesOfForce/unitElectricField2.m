function [i,j,k] = unitElectricField2( a,b,c,x,y,z )
%unitElectricField2 �_A1�Ɠ_A2���_P�ɍ��d��x�N�g�������߂�B�A���傫����1�ɂȂ�悤�ɋ����I�Ɋg��k������
%   �_A1(a(1),b(1),c(1))�A�_A2(a(2),b(2),c(2))�A�_P(x,y,z)
%   b��c�͒���2�̃x�N�g���Aa�͒���4�̃x�N�g���ł���K�v������B
%   a(3)�͓_A1�̓d�ׂ̕������Ӗ�����B+�Ȃ�1���A-�Ȃ�-1���i�[���邱�ƁB
%   a(4)�͓_A2�̓d�ׂ̕������Ӗ�����B+�Ȃ�1���A-�Ȃ�-1���i�[���邱�ƁB

%E1
%=EA1��4�΃�/Q�{
%=(((x-a(1))^2+(y-b(1))^2+(z-c(1))^2)^-1.5)(x-a(1),y-b(1),z-c(1))
%=scalar1*(x-a(1),y-b(1),z-c(1))


scalar1=(((x-a(1))^2+(y-b(1))^2+(z-c(1))^2)^-1.5);
E1=[scalar1*(x-a(1)),scalar1*(y-b(1)),scalar1*(z-c(1))];

%E2
%=EA2��4�΃�/Q�{
%=((x-a(2))^2+(y-b(2))^2+(z-c(2))^2)^-1.5)
%=scalar2*(x-a(2),y-b(2),z-c(2))
scalar2=(((x-a(2))^2+(y-b(2))^2+(z-c(2))^2)^-1.5);
E2=[scalar2*(x-a(2)),scalar2*(y-b(2)),scalar2*(z-c(2))];

if ((a(3))^2~=1)||((a(4))^2~=1)
 fprintf("unitElectricField2�֐��̎��s���ɃG���[�BunitElectricField2�֐��̐������悭�ǂނ��ƁB\n")
 i=NaN;
 j=0;
 k=0;
 return
end

%E
%�����d��x�N�g��(��4�΃�/Q�{)
E=a(3)*E1+a(4)*E2;

%E����x�N�g���Ȃ�����ȗ������e�����ɉ�����
if ((E(1)==0)&&(E(2)==0))&&(E(3)==0)

    %�����̕��B�����͋��[-randWidth,randWidth]�ƂȂ�
    randWidth=0.1;
    
    E=2*randWidth*(rand(1,3)-[0.5,0.5,0.5]);
end

%E�̑傫��
absOfE=( (E(1))^2 +(E(2))^2 +(E(3))^2 )^0.5;

%E��P�ʃx�N�g���ɂ���
E=E/absOfE;

%�d��x�N�g�����d�ׂƂԂ��邩�ǂ���
%=�d��x�N�g����xy�p�x�ƁAyz�p�x�ӂƁA�C�ӂ̓d�ׂ̍��WL(l,m,n)�ƍ��̍��WP(x,y,z)�Ƃ̊Ԃ̈ʒu�֌W�̊p�x�ƁA�ӂ���v(�덷r[rad]�ȓ�)���A���O�҂̂ق����傫��
r=0.1;
for p=[1:2]
    l=a(p);
    m=b(p);
    n=c(p);
    
    %���ړd��L�Ɠd��x�N�g���̎n�_P�Ƃ����Ԑ���LP
    LP=[x-l,y-m,z-n];
    
    %����LP�̊p�x�Ƃ����[-��/2,��/2]�͈̔͂ŋ��߂�
    thetaOfLP=atan(LP(2)/LP(1));
    %����LP�̊p�x�ӂ����[-��/2,��/2]�͈̔͂ŋ��߂�
    phiOfLP=atan(LP(3)/LP(2));
    
    %�d��x�N�g��E�ɑ΂��Ă��������Ƃ�����
    thetaOfE=atan(E(2)/E(1));
    phiOfE=atan(E(3)/E(2));
    
    %�ӂƃƂ��ꂼ��̌덷[rad]��r�����ł��邩���ׂ�
    isTouchTheta=(abs(thetaOfLP(1)-thetaOfE(1))<=r);
    isTouchPhi=(abs(phiOfLP(1)-phiOfE(1))<=r);    
    
    if isnan(thetaOfLP) && isnan(thetaOfE)
    %thetaOf�`���ǂ����NaN�����s��`�̋t���ڂł������Ƃ�
        %�����̑傫����������Ƃ������Ƃ͂��蓾�Ȃ��ȏ�A
        %�s��`��0/0�ɂ���Đ������Ƃ�����B
        %0==0�Ȃ̂ŁAisTouchTheta��true�Ƃ��Ă悢�B
        isTouchTheta=true;
    end
    
    if isnan(thetaOfLP) && isnan(thetaOfE)
    %phiOf�`�ɂ��Ă������B
        isTouchPhi=true;        
    end
    
    if (isTouchTheta) && (isTouchPhi)
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
            if a(p+2)<0
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

