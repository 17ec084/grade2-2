function plotEL1( a,b,c, dx,dy,dz)
%   plotEL1 �_A�����d�C�͐���_D����v���b�g����
%   �_A(a,b,c)�A�_D(a+dx,b+dy,c+dz)

%�܂��A��ԍŏ��̃v���b�g������Ă��܂��B
%���ӂɂ��Ă͌�q�́��̂��߁B
[startX,startY,startZ]=plotEV( a,b,c, dx,dy,dz );

%���ɁA(�����d�ׁA�d�C�͐���)�`�悷�ׂ���Ԃ��яo��(isEVInArea==false�ƂȂ�)
%�܂ŌJ��Ԃ��B
isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
while isEVInArea==true
%�n�_���u���O�ɍ�����d��x�N�g���̏I�_�v�Ƃ���悤�ȓd��x�N�g����ǉ��`��B...��
%���ӂ́A���̃^�C�~���O�ł́��̂��߁B
[startX,startY,startZ]=plotEV(a,b,c, startX,startY,startZ);

isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
end

