#!/usr/bin/perl -w

use utf8;
use open ':std', ':encoding(UTF-8)';
use DBI;
use encoding 'utf8';

my $dsn = 'DBI:mysql:esap:10.1.4.52';
my $db_user_name = 'esap';
my $db_password = 'esap123';
my $dbh = DBI->connect($dsn, $db_user_name, $db_password);
#$dbh->do("SET NAMES 'utf8'");
#$dbh -> do(q{SET NAMES "cp1251"}); 
$dbh->do("set names utf8") ;
$dbh->do("set character set utf8");


my $sql=qq(SELECT *
           FROM log WHERE  timestamp like '2013-09-06%');

my $sth = $dbh->prepare( $sql );

$sth->execute();

while ( my($id, $uid, $level, $messaqe, $timesmap) = $sth->fetchrow_array) {
	printf ("%-10d %-10d %-10s %-10s %-10s\n", $id, $uid, $level, $messaqe, $timesmap);
	print "\n";
}

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