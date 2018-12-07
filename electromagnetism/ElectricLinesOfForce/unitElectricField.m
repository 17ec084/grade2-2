function [i,j,k] = unitElectricField( a,b,c,x,y,z )
%unitElectricField �_A���_P�ɍ��d��x�N�g�������߂�B�A���傫����1�ɂȂ�悤�ɋ����I�Ɋg��k������
%   �_A(a,b,c)�A�_P(x,y,z)

%unitE=((x-a)^2+(y-b)^2+(z-c)^2)^-0.5)(x-a,y-b,z-c)

scalar=((x-a)^2+(y-b)^2+(z-c)^2)^(-0.5);
i=-scalar*(x-a);
j=-scalar*(y-b);
k=-scalar*(z-c);

%�d��x�N�g�����d�ׂɂӂꂽ�ꍇ
%=(���d�ׂ���)�d��x�N�g�����d�ׂƂ̋��������傫���Ȃ�����
if scalar>=1
 i=NaN;
end

end

