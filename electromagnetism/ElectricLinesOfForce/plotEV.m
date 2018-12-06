function [endX,endY,endZ]=plotEV( a,b,c, dx,dy,dz)
%plotEV �_A�����d��x�N�g����_D����v���b�g����
%   �_A(a,b,c)�A�_D(a+dx,b+dy,c+dz)
%   �߂�l�͓d��x�N�g���̏I�_(�܂�����d�ׂ̍��W)

%�_A�Ɠ_D���d�Ȃ��Ă��܂��ƕ��������܂�Ȃ��̂ŃG���[��Ԃ��B
if [dx,dy,dz]==[0,0,0]
 fprintf("plotEV���\�b�h���s���ɃG���[�B�d�ׂ̑��݂�����W����o�����邱�Ƃ͂ł��Ȃ��B\n");
 return
end


x=a+dx;
y=b+dy;
z=c+dz;

%�d��x�N�g��(�̑傫��lengthOfE�ƒP�ʃx�N�g��unitOfE)�����߂�
[Ex,Ey,Ez]=unitElectricField( a,b,c, x,y,z );
%lengthOfE=(Ex^2+Ey^2+Ez^2)^0.5;
%unitOfE=[Ex/lengthOfE,Ey/lengthOfE,Ez/lengthOfE];


x=[0,Ex];
y=[0,Ey];
z=[0,Ez];
x=x+a+dx;
y=y+b+dy;
z=z+c+dz;


%�d��x�N�g���̏I�_

endX=Ex+a+dx;
endY=Ey+b+dy;
endZ=Ez+c+dz;

%�d��x�N�g����`��
plot3(x,y,z);






end

