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
%�����d��x�N�g��
E=a(3)*E1+a(4)*E2;

%E�̑傫��
absOfE=( (E(1))^2 +(E(2))^2 +(E(3))^2 )^0.5;

%E��P�ʃx�N�g���ɂ���
E=E/absOfE;

%�d��x�N�g�����d�ׂƂԂ��邩�ǂ���
%=�d��x�N�g���̐�����ƁA�C�ӂ̓d�ׂ̍��W(l,m,n)�ƍ��̍��W(x,y,z)�Ƃ̊Ԃ̈ʒu�֌W�̐����䂪��v(�덷��r�ȓ�)���A���O�҂̂ق����傫��
r=0.001;
for p=[1:2]
    l=a(p);
    m=b(p);
    n=c(p);
    if ((l-x)/(m-y)-E(1)/E(2))/(E(1)/E(2))<r
    %x,y�䂪��v����ꍇ
        if ((m-y)/(n-z)-E(2)/E(3))/(E(2)/E(3))<r
        %y,z�䂪��v����ꍇ
            if ((l-x)/(n-z)-E(1)/E(3))/(E(1)/E(3))<r
            %x,z�䂪��v����ꍇ
                if (l-x)<E(1)
                %�d��x�N�g���̂ق����傫���ꍇ
                    %�d��x�N�g���Ɠd�ׂ��Ԃ���Ƃ�����
                    i=NaN;
                    j=0;
                    k=0;
                    return
                end
            end
        end
    end
    
end

i=E(1);
j=E(2);
k=E(3);

end

