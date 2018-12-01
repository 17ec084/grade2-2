#!/usr/local/bin/perl
print "Content-type: text/html\n\n";
print "<HTML>\n"; 
print "<HEAD><TITLE>サンプル</TITLE></HEAD>\n";
print "<BODY>\n"; 
print "ここに本文が表\示される<BR>\n";
( $sec , $min , $hour , $day , $mon , $year , $wday , $yday , $isdst) = localtime( time );
$mon =$mon+ 1; 

$greeting=
($hour <7)
?
"おはよう"
:
(
 ($hour <18)
 ?
 "こんにちは"
 :
 "こんばんは"
);

$year = $year + 1900;
printf("%s、今日は%4d年%02d月%02d日です<br>\n",$greeting,$year,$mon,$day);
printf("%4d年まで後",$year+1);

#来年元旦までの時間(hour)を求める。
#まず、年始からの日数が$ydayに格納されている。
#今年が閏年であるかを取得するには次のようにする。
if($year%4 !=0)
#4で割れなければ
{
 $isLeap=0;
 #閏年ではない。
}
else
#4で割れれば基本的には閏年であるが
{
 if($year%100 ==0)
 #100で割り切れてしまったら
 {
  if($year%400 ==0)
  #400で割れれば
  {
   $isLeap=1;
   #閏年といえるが
  }
  else
  #400で割れないと
  {
   $isLeap=0;
   #閏年といえない。
  }
 }
 else
 #100で割れなければ
 {
  $isLeap=1;
  #閏年といえる。
 }
}

#今年が閏年でない場合は、元旦、つまり$ydayが364になる日の次までの日数をまず知るべきである。
#今年が閏年の場合は、元旦、つまり$ydayが365になる次の日までの日数をまず知るべきである。
if(!$isLeap)
{
 $dayLeft=(364-$yday)+1;
}
else
{
 $dayLeft=(365-$yday)+1;
}

#この時点で、少なくとも
$hourLeftMinimum=($dayLeft-1)*24;
#だけ時間(hour)が残っていることが確定する。
#その上で、本日の残り時間
$hourLeftOfToday=24-$hour;
#を加算する必要がある。
#加算すると、
$hourLeft=$hourLeftMinimum+$hourLeftOfToday;
printf("%d時間です。",$hourLeft);
print "</BODY>\n"; 
print "</HTML>\n";


