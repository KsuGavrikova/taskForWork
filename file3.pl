#!/usr/bin/perl -w

# use utf8;
use open ':std', ':encoding(UTF-8)';
use DBI;
use encoding 'utf8';

use Data::Dumper; 
use DateTime;
#use DateTime::Format::Strptime;
use DateTime::Duration;
use Time::Local;

my $dsn = 'DBI:mysql:esap:10.1.4.52';
my $db_user_name = 'esap';
my $db_password = 'esap123';
my $dbh = DBI->connect($dsn, $db_user_name, $db_password);
$dbh->do("set names utf8") ;
$dbh->do("set character set utf8");

$sql=qq(SELECT * FROM log ORDER BY id DESC LIMIT 1);#первая с конца строка из таблицы
$sth = $dbh->prepare( $sql );
$sth->execute();

while ( ($id, $uid, $level, $messaqe, $timestamap) = $sth->fetchrow_array) {
	($yyyy1, $mm1, $dd1, $HH1, $MM1, $SS1)=($timestamap =~ m/(\d+)-(\d+)-(\d+)\s+(\d+):(\d+):(\d+)/);

	 $dt = DateTime->new(
    year      => $yyyy1,
    month     => $mm1,
    day       => $dd1,
    hour      => $HH1,
    minute    => $MM1,
	second     => $SS1,
);
	# $dt_format = DateTime::Format::Strptime->new( pattern  => '%Y-%m-%d\s+%H:%M:%S',);
	# $dt = $dt_format->parse_datetime($timestamap);
	 printf ("%-10d %-10d %-10s %-10s %-10s\n", $id, $uid, $level, $messaqe, $timestamap);
	 print "\n";
	
}

 $sql=qq(SELECT * FROM log ORDER BY id LIMIT 1);#первая строка из таблицы
 $sth = $dbh->prepare( $sql );
$sth->execute();

while ( ($id, $uid, $level, $messaqe, $timestamap) = $sth->fetchrow_array) {
	($yyyy2, $mm2, $dd2, $HH2, $MM2, $SS2)=($timestamap =~ m/(\d+)-(\d+)-(\d+)\s+(\d+):(\d+):(\d+)/);
	 $dt2 = DateTime->new(
    year      => $yyyy2,
    month     => $mm2,
    day       => $dd2,
    hour      => $HH2,
    minute    => $MM2,
	second     => $SS2,
);
	 printf ("%-10d %-10d %-10s %-10s %-10s\n", $id, $uid, $level, $messaqe, $timestamap);
	print "\n";

}

# Прибавить1 день 
my $dt_duration = DateTime::Duration->new(
    years   => 0,
    months  => 0,
    days    => 1,
    hours   => 0,
    minutes => 0,
    seconds => 0,
);
#   $dt2 = $dt + $dt_duration;

#   print $dt2->year."\n";
#   print $dt2->month."\n";
#   print $dt2->day."\n";
#   print $dt2->hour."\n";
#   print $dt2->minute."\n";
#   print $dt2->second."\n";

  # Сравнить даты
# my $result = DateTime->compare( $dt, $dt2 ); # результат: -1 т. к. $dt < $dt2

# Интервал между датами
$interval = $dt2->delta_days( $dt );

print $interval."\n";
print $se = ($dt - $dt2)->years;


$dbh->disconnect();