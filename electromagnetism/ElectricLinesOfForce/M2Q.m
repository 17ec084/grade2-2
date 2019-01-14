function Q = M2Q( M,szX,szY,szZ,xMin,xMax,yMin,yMax,zMin,zMax,alert,x,y,z)
%M2Q 3�����s��M��3������ԂƂ݂邱�Ƃɂ���Ē�߂���d�ׂ̏����A
%   �d�ׂ̍��W���Ɠd�C�ʂ��i�[����4�����s��Q�ɏ��������邱�ƂŃR���p�N�g��
%   �\�����Ȃ���
%   M��3�����s��ł���K�v������Ax�͈̔͂�xmin�`xmax�ł���B
%   alert��true�Ƃ���ƁA�_(x,y,z)��ɓd�ׂ����݂��邩���ׁA�u������return����v
%   �������݂����ꍇ�A�G���[���b�Z�[�W��fprintf����B
%   ���̋@�\�̗p�r�́A�_(x,y,z)��d�C�͐��̎n�_�ɂł��邩�ۂ���m�邱�Ƃł���B

    %�܂��A�s��M����0�łȂ��l�������i�[����Ă��邩���ׂ�B
    %���̌�cnt���d�ׂ̐��ł���B
    %�����ɂ��ꂼ��̓d�ׂ̏����s��Q�Ɋi�[����B

    cnt=0;
    [Mi,Mj,Mk]=size(M);
    for M_i=[1:Mi]
        for M_j=[1:Mj]
            for M_k=[1:Mk]
                if(M(M_i,M_j,M_k)~=0)
                    cnt=cnt+1;
                    %(*��������)
                    Q(cnt,1)=M(M_i,M_j,M_k);
                    Q(cnt,2)=((M_i-1)*(xMax-xMin)/(szX-1))+xMin;
                    Q(cnt,3)=((M_j-1)*(yMax-yMin)/(szY-1))+yMin;
                    Q(cnt,4)=((M_k-1)*(zMax-zMin)/(szZ-1))+zMin;
                    %(*�����܂�)
                
                    if alert
                        %�n�_���d�ׂɏՓ˂��Ă����ꍇ�ɃA���[�g����B
                        if ((Q(cnt,2)==x)&&(Q(cnt,3)==y))&&(Q(cnt,4)==z)
                            fprintf("M2Q(alert==true)���\�b�h���s���ɃG���[�B�d�ׂ̑��݂�����W����o�����邱�Ƃ͂ł��Ȃ��B\n");
                            return;
                        end
                    end
                end
            end
        end
    end
    %{
    �ȏ�̏����ɂ��A
    num�Ԗڂ̓d�ׂ̓d�C�ʂ�Q(num,1)�ɁA
    num�Ԗڂ̓d�ׂ̂����W��Q(num,2)�ɁA
    num�Ԗڂ̓d�ׂ̂����W��Q(num,3)�ɁA
    num�Ԗڂ̓d�ׂ̂����W��Q(num,4)�ɁA
    ���ꂼ��i�[���ꂽ
    %}

end
