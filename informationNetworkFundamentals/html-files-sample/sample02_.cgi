#!/usr/local/bin/perl
print "Content-type: text/html\n\n";
print "<HTML>\n"; 
print "<HEAD><TITLE>�T���v��</TITLE></HEAD>\n";
print "<BODY>\n"; 
print "�����ɖ{�����\\�������<BR>\n";
( $sec , $min , $hour , $day , $mon , $year ) = localtime( time );
$mon =$mon+ 1; 
$year = $year + 1900;
printf("������%4d�N%02d��%02d���ł�\n",$year,$mon,$day);
print "</BODY>\n"; 
print "</HTML>\n";



