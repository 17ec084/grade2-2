function [i,j,k] = electricField( a,b,c,x,y,z )
%electricField �_A���_P�ɍ��d��x�N�g�������߂�
%   �_A(a,b,c)�A�_P(x,y,z)

%E=(Q/(4�΃�(((x-a)^2+(y-b)^2+(z-c)^2)^1.5)))(x-a,y-b,z-c)
%�܂��X�J�������߂�B
%(�x�N�g�����̂̒���������̂ŁA�X�J����r��2��ł͂Ȃ�3��Ŋ��邱�ƁB
Q=16;
epsilon=1;
scalar=Q/(4*pi*epsilon*(((x-a)^2+(y-b)^2+(z-c)^2)^1.5));
i=scalar*(x-a);
j=scalar*(y-b);
k=scalar*(z-c);

%�d��x�N�g�����d�ׂɐG�ꂽ�ꍇ
%���d�ׂ��d��x�N�g�����d�ׂƂ̋��������傫���Ȃ����ꍇ
if ((Q<0)*(scalar>=1))
 i=NaN;
end

end

