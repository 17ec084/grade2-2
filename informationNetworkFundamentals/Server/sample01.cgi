#!/usr/local/bin/perl
print "Content-type: text/html\n\n";
print "<HTML>\n"; 
print "<HEAD><TITLE>�T���v��</TITLE></HEAD>\n";
print "<BODY>\n"; 
for($i=0;$i<1000000;$i++){
print "<font color='#";
print $i;
print "'>�����ɖ{�����\\�������<BR></font>\n";
}
print "</BODY>\n"; 
print "</HTML>\n";
