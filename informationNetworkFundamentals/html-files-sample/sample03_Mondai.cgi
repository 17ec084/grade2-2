print "Content-type: text/html\n\n";
print "<HTML>\n"; 
print "<HEAD><TITLE>�T���v��</TITLE></HEAD>\n";
print "<BODY>\n"; 
( $sec , $min , $hour , $day , $mon , $year ) = localtime( time );
printf("������%4d�N%02d��%02d���ł�<BR>\n",$Year,$mon,$day);
$b = 3;
$a = $sec / $b;
$M = ($a == 0)?"���݂̕b���͂R�Ŋ���؂�܂�":"���݂̕b���͂R�Ŋ���؂�܂���";
print "$M";
print "�Ⓦ�K�_\n"; 
print "</BODY>\n"; 
print "</HTML>\n";

