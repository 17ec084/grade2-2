function plotEL1_3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N,isMQ )
%   plotEL1_3 M�����d�C�͐���_P����v���b�g����
%   �_P(x,y,z)
%   N��unitElectricField3�ɓn�����߂̂��̂ł���B
%   N�ɂ��Ă̐�����unitElectricField3�ɂ�����������Q�Ƃ���B
%   isMQ�́A�s��M�̑���ɍs��Q���^�����Ă���ꍇ��true�Ƃ���B(����10(4)�Œǉ�)
%   isMQ��unitElectricField3�ɓn�����B

%�܂��A��ԍŏ��̃v���b�g������Ă��܂��B
%���ӂɂ��Ă͌�q�́��̂��߁B
[startX,startY,startZ]=plotEV3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,x,y,z,N,isMQ );
%fprintf("�ŏ��A(%f,%f,%f)\n(%f,%f,%f)\n",x,y,z,startX,startY,startZ);
if(isnan(startX)==true)
 return
else
 %���ɁA(�����d�ׁA�d�C�͐���)�`�悷�ׂ���Ԃ��яo��(isEVInArea==false�ƂȂ�)
 %�܂ŌJ��Ԃ��B
 isEVInArea= ...
 ((xMin<=startX && startX<=xMax)&&(yMin<=startY && startY<=yMax)) ...
 && ...   
 (zMin<=startZ && startZ<=zMax);
 while isEVInArea==true
 %�n�_���u���O�ɍ�����d��x�N�g���̏I�_�v�Ƃ���悤�ȓd��x�N�g����ǉ��`��B...��
 %���ӂ́A���̃^�C�~���O�ł́��̂��߁B
 [startX,startY,startZ]=plotEV3( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,startX,startY,startZ,N,isMQ );
%fprintf("(%f,%f,%f)\n",startX,startY,startZ);
 isEVInArea= ...
 ((xMin<=startX && startX<=xMax)&&(yMin<=startY && startY<=yMax)) ...
 && ...   
 (zMin<=startZ && startZ<=zMax);
 end
end

end
