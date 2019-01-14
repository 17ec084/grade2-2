function [endX,endY,endZ]=plotEV3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N,isMQ )
%plotEV3 M�ɂ���Ē�߂���d�ׂ����d��x�N�g����_P����v���b�g����
%   �_P(x,y,z)
%   �߂�l�͓d��x�N�g���̏I�_(�܂�����d�ׂ̍��W)
%   N��unitElectricField3�ɓn�����߂̂��̂ł���B
%   N�ɂ��Ă̐�����unitElectricField3�ɂ�����������Q�Ƃ���B
%   isMQ�́A�s��M�̑���ɍs��Q���^�����Ă���ꍇ��true�Ƃ���B(����10(4)�Œǉ�)
%   isMQ��unitElectricField3�ɓn�����B


%�d��x�N�g��(�̑傫��lengthOfE�ƒP�ʃx�N�g��unitOfE)�����߂�
[Ex,Ey,Ez]=unitElectricField3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N,isMQ );
%lengthOfE=(Ex^2+Ey^2+Ez^2)^0.5;
%unitOfE=[Ex/lengthOfE,Ey/lengthOfE,Ez/lengthOfE];

if isnan(Ex)==true
%���d�ׂɂ���ēd�C�͐����������������ꍇ
 endX=NaN;
 endY=NaN;
 endZ=NaN;
else
 px=[0,Ex];
 py=[0,Ey];
 pz=[0,Ez];
 px=px+x;
 py=py+y;
 pz=pz+z;
 %�d��x�N�g���̏I�_
 endX=Ex+x;
 endY=Ey+y;
 endZ=Ez+z;
 %�d��x�N�g����`��
 plot3(px,py,pz);
end





end

