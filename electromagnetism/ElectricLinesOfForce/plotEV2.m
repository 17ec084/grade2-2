function [endX,endY,endZ]=plotEV2( a,b,c, dx,dy,dz, N)
%plotEV2 �_A�����d��x�N�g����_D����v���b�g����
%   �_A(a,b,c)�A�_D(a+dx,b+dy,c+dz)
%   �߂�l�͓d��x�N�g���̏I�_(�܂�����d�ׂ̍��W)
%   N��unitElectricField2�ɓn�����߂̂��̂ł���B
%   N�ɂ��Ă̐�����unitElectricField2�ɂ�����������Q�Ƃ���B

%�_A�Ɠ_D���d�Ȃ��Ă��܂��ƕ��������܂�Ȃ��̂ŃG���[��Ԃ��B
if [dx,dy,dz]==[0,0,0]
 fprintf("plotEV2���\�b�h���s���ɃG���[�B�d�ׂ̑��݂�����W����o�����邱�Ƃ͂ł��Ȃ��B\n");
 return
end


x=a(1)+dx;
y=b(1)+dy;
z=c(1)+dz;

%�d��x�N�g��(�̑傫��lengthOfE�ƒP�ʃx�N�g��unitOfE)�����߂�
[Ex,Ey,Ez]=unitElectricField2( a,b,c, x,y,z, N );
%lengthOfE=(Ex^2+Ey^2+Ez^2)^0.5;
%unitOfE=[Ex/lengthOfE,Ey/lengthOfE,Ez/lengthOfE];

if isnan(Ex)==true
%���d�ׂɂ���ēd�C�͐����������������ꍇ
 endX=NaN;
 endY=NaN;
 endZ=NaN;
else
 x=[0,Ex];
 y=[0,Ey];
 z=[0,Ez];
 x=x+a(1)+dx;
 y=y+b(1)+dy;
 z=z+c(1)+dz;
 %�d��x�N�g���̏I�_
 endX=Ex+a(1)+dx;
 endY=Ey+b(1)+dy;
 endZ=Ez+c(1)+dz;
 %�d��x�N�g����`��
 plot3(x,y,z);
end





end

