function plotEL1_2( a,b,c, dx,dy,dz)
%   plotEL1_2 �_A�����d�C�͐���_D����v���b�g����
%   �_A(a,b,c)�A�_D(a+dx,b+dy,c+dz)

%�܂��A��ԍŏ��̃v���b�g������Ă��܂��B
%���ӂɂ��Ă͌�q�́��̂��߁B
[startX,startY,startZ]=plotEV2( a,b,c, dx,dy,dz );

if(isnan(startX)==true)
 return
else
 %���ɁA(�����d�ׁA�d�C�͐���)�`�悷�ׂ���Ԃ��яo��(isEVInArea==false�ƂȂ�)
 %�܂ŌJ��Ԃ��B
 isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
 while isEVInArea==true
 %�n�_���u���O�ɍ�����d��x�N�g���̏I�_�v�Ƃ���悤�ȓd��x�N�g����ǉ��`��B...��
 %���ӂ́A���̃^�C�~���O�ł́��̂��߁B
 [startX,startY,startZ]=plotEV2(a,b,c, startX-a(1),startY-b(1),startZ-c(1));
 isEVInArea=(startX^2<100^2)*(startY^2<100^2)*(startZ^2<100^2);
 end
end

end
