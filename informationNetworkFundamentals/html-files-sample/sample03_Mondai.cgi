print "Content-type: text/html\n\n";
print "<HTML>\n"; 
print "<HEAD><TITLE>サンプル</TITLE></HEAD>\n";
print "<BODY>\n"; 
( $sec , $min , $hour , $day , $mon , $year ) = localtime( time );
printf("今日は%4d年%02d月%02d日です<BR>\n",$Year,$mon,$day);
$b = 3;
$a = $sec / $b;
$M = ($a == 0)?"現在の秒数は３で割り切れます":"現在の秒数は３で割り切れません";
print "$M";
print "坂東幸浩\n"; 
print "</BODY>\n"; 
print "</HTML>\n";

