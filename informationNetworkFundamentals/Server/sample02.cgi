#!/usr/local/bin/perl
print "Content-type: text/html\n\n";
print "<HTML>\n"; 
print "<HEAD><TITLE>�T���v��</TITLE></HEAD>\n";
print "<BODY>\n"; 
print "�����ɖ{�����\\�������<BR>\n";
( $sec , $min , $hour , $day , $mon , $year , $wday , $yday , $isdst) = localtime( time );
$mon =$mon+ 1; 

$greeting=
($hour <7)
?
"���͂悤"
:
(
 ($hour <18)
 ?
 "����ɂ���"
 :
 "����΂��"
);

$year = $year + 1900;
printf("%s�A������%4d�N%02d��%02d���ł�<br>\n",$greeting,$year,$mon,$day);
printf("%4d�N�܂Ō�",$year+1);

#���N���U�܂ł̎���(hour)�����߂�B
#�܂��A�N�n����̓�����$yday�Ɋi�[����Ă���B
#���N���[�N�ł��邩���擾����ɂ͎��̂悤�ɂ���B
if($year%4 !=0)
#4�Ŋ���Ȃ����
{
 $isLeap=0;
 #�[�N�ł͂Ȃ��B
}
else
#4�Ŋ����Ί�{�I�ɂ͉[�N�ł��邪
{
 if($year%100 ==0)
 #100�Ŋ���؂�Ă��܂�����
 {
  if($year%400 ==0)
  #400�Ŋ�����
  {
   $isLeap=1;
   #�[�N�Ƃ����邪
  }
  else
  #400�Ŋ���Ȃ���
  {
   $isLeap=0;
   #�[�N�Ƃ����Ȃ��B
  }
 }
 else
 #100�Ŋ���Ȃ����
 {
  $isLeap=1;
  #�[�N�Ƃ�����B
 }
}

#���N���[�N�łȂ��ꍇ�́A���U�A�܂�$yday��364�ɂȂ���̎��܂ł̓������܂��m��ׂ��ł���B
#���N���[�N�̏ꍇ�́A���U�A�܂�$yday��365�ɂȂ鎟�̓��܂ł̓������܂��m��ׂ��ł���B
if(!$isLeap)
{
 $dayLeft=(364-$yday)+1;
}
else
{
 $dayLeft=(365-$yday)+1;
}

#���̎��_�ŁA���Ȃ��Ƃ�
$hourLeftMinimum=($dayLeft-1)*24;
#��������(hour)���c���Ă��邱�Ƃ��m�肷��B
#���̏�ŁA�{���̎c�莞��
$hourLeftOfToday=24-$hour;
#�����Z����K�v������B
#���Z����ƁA
$hourLeft=$hourLeftMinimum+$hourLeftOfToday;
printf("%d���Ԃł��B",$hourLeft);
print "</BODY>\n"; 
print "</HTML>\n";


