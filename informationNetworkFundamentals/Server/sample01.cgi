#!/usr/local/bin/perl
print "Content-type: text/html\n\n";
print "<HTML>\n"; 
print "<HEAD><TITLE>サンプル</TITLE></HEAD>\n";
print "<BODY>\n"; 
for($i=0;$i<1000000;$i++){
print "<font color='#";
print $i;
print "'>ここに本文が表\示される<BR></font>\n";
}
print "</BODY>\n"; 
print "</HTML>\n";
