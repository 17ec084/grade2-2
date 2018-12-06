function plotEV( a,b,c, dx,dy,dz )
%   electricField �_A�����d��x�N�g����_D����v���b�g����
%   �_A(a,b,c)�A�_D(a+dx,b+dy,c+dz)

%�_A�Ɠ_D���d�Ȃ��Ă��܂��ƕ��������܂�Ȃ��̂ŃG���[��Ԃ��B
if [dx,dy,dz]==[0,0,0]
 fprintf("plotEL1���\�b�h���s���ɃG���[�B�d�ׂ̑��݂�����W����o�����邱�Ƃ͂ł��Ȃ��B\n");
 return
end


x=a+dx;
y=b+dy;
z=c+dz;

%�d��x�N�g���̑傫��lengthOfE�ƒP�ʃx�N�g��unitOfE�����߂�
[Ex,Ey,Ez]=electricField( a,b,c, x,y,z );
lengthOfE=(Ex^2+Ey^2+Ez^2)^0.5;
unitOfE=[Ex/lengthOfE,Ey/lengthOfE,Ez/lengthOfE];


distance=1;
%plot3�̃v���b�g�Ԋu



x=[0:distance:Ex];
y=linspace(0,Ey,length(x));
z=linspace(0,Ez,length(x));

x=x+a+dx;
y=y+b+dy;
z=z+c+dz;

hold on;

plot3(x,y,z);







end

