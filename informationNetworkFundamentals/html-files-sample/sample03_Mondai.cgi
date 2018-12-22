print "Content-type: text/html\n\n";
print "<HTML>\n"; 
print "<HEAD><TITLE>ƒTƒ“ƒvƒ‹</TITLE></HEAD>\n";
print "<BODY>\n"; 
( $sec , $min , $hour , $day , $mon , $year ) = localtime( time );
printf("¡“ú‚Í%4d”N%02dŒ%02d“ú‚Å‚·<BR>\n",$Year,$mon,$day);
$b = 3;
$a = $sec / $b;
$M = ($a == 0)?"Œ»İ‚Ì•b”‚Í‚R‚ÅŠ„‚èØ‚ê‚Ü‚·":"Œ»İ‚Ì•b”‚Í‚R‚ÅŠ„‚èØ‚ê‚Ü‚¹‚ñ";
print "$M";
print "â“ŒK_\n"; 
print "</BODY>\n"; 
print "</HTML>\n";

