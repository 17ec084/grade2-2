#!/usr/local/bin/perl
print "Content-type: text/html\n\n";
print "<HTML>\n"; 
print "<HEAD><TITLE>サンプル</TITLE></HEAD>\n";
print "<BODY>\n"; 
print "ここに本文が表\示される<BR>\n";
( $sec , $min , $hour , $day , $mon , $year ) = localtime( time );
$mon =$mon+ 1; 
$year = $year + 1900;
printf("今日は%4d年%02d月%02d日です\n",$year,$mon,$day);
if（5< $hour && $hour < 11）
  {print"おはよう<br>\n";}
elsif（$hour >10 && $hour < 16）
　{print"こんにちは<br>\n";}
else
  {print"こんばんは<br>\n";}
print "</BODY>\n"; 
print "</HTML>\n";

