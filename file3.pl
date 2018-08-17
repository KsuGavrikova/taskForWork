#!/usr/bin/perl -w

# use utf8;
use open ':std', ':encoding(UTF-8)';
use DBI;
use encoding 'utf8';
use DateTime;
use Time::Local;

sub DataPars{
my ($yyyy, $mm, $dd, $SS, $MM, $HH)=($timestamap =~ m/(\d+)-(\d+)-(\d+)\s+(\d+):(\d+):(\d+)/);
return ($yyyy, $mm, $dd, $SS, $MM, $HH);
#printf ("%-d - %-d - %-d  %-d : %-d : %-d\n", $yyyy, $mm, $dd, $SS, $MM, $HH);
}

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
	($yyyy1, $mm1, $dd1, $SS1, $MM1, $HH1)=($timestamap =~ m/(\d+)-(\d+)-(\d+)\s+(\d+):(\d+):(\d+)/);
	#  printf ("%-10d %-10d %-10s %-10s %-10s\n", $id, $uid, $level, $messaqe, $timestamap);
	# print "\n";
	# my ($Ey, $Em, $Ed, $ES, $EM, $EH)=DataPars($timestamap);
}
# printf ("%-d - %-d - %-d  %-d : %-d : %-d\n", $Ey, $Em, $Ed, $ES, $EM, $EH);


 $sql=qq(SELECT * FROM log ORDER BY id LIMIT 1);#первая строка из таблицы
 $sth = $dbh->prepare( $sql );
$sth->execute();

while ( ($id, $uid, $level, $messaqe, $timestamap) = $sth->fetchrow_array) {
	($yyyy, $mm, $dd, $SS, $MM, $HH)=($timestamap =~ m/(\d+)-(\d+)-(\d+)\s+(\d+):(\d+):(\d+)/);
	# printf ("%-10d %-10d %-10s %-10s %-10s\n", $id, $uid, $level, $messaqe, $timestamap);
	# print "\n";
	# my ($Fy, $Fm, $Fd, $FS, $FM, $FH)=DataPars($timestamap);
}
# printf ("%-d - %-d - %-d  %-d : %-d : %-d\n", $Fy, $Fm, $Fd, $FS, $FM, $FH);
use Date::Calc qw(Delta_Days);
$count_days= Delta_Days($yyyy1, $mm1, $dd1, $yyyy, $mm, $dd);
print $count_days."\n";
my $date=($yyyy."-".$mm."-".$dd." ".$SS.":".$MM.":".$HH);
print $date."\n";
DateTime $date = DateTime.Now.AddDays(1); 
print $date."\n";

# $maxi=100;
# for($i=0;$i<$maxi;$i++){
# $date='2013-09-06%';
# $sql=qq(SELECT * FROM log WHERE  timestamap like $date);
# $sth = $dbh->prepare( $sql );
# $sth->execute();

# while ( ($id, $uid, $level, $messaqe, $timestamap) = $sth->fetchrow_array) {
# 	 printf ("%-10d %-10d %-10s %-10s %-10s\n", $id, $uid, $level, $messaqe, $timestamap);
# 	print "\n";
	
# }
#  DateTime $date = DateTime.Now.AddDays(1); 
# }


# my $sql=qq(SELECT *
#            FROM log WHERE  timestamap like '2013-09-06%');

# my $sth = $dbh->prepare( $sql );

# $sth->execute();

# while ( my($id, $uid, $level, $messaqe, $timestamap) = $sth->fetchrow_array) {
# 	printf ("%-10d %-10d %-10s %-10s %-10s\n", $id, $uid, $level, $messaqe, $timestamap);
# 	print "\n";
# }

$dbh->disconnect();
#
# my $sth=$dbh->prepare($sql);
# $sth->execute();  
# my (@matrix) = ();
# while (my @ary = $sth->fetchrow_array())
# {
#     push(@matrix, [@ary]);  # [@ary] это ссылка
# }
# $sth->finish();
#    $dbh->disconnect();

#    foreach (@matrix)
#    {
#        print $_."\n";
#    }