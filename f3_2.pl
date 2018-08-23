#!/usr/bin/perl -w

#use strict;

# use utf8;
#use open ':std', ':encoding(UTF-8)';
use DBI;
#use encoding 'utf8';

use Data::Dumper; 
use DateTime;
#use DateTime::Format::Strptime;
use DateTime::Duration;
use Time::Local;

my $dsn = 'DBI:mysql:esap:10.1.4.52';
my $db_user_name = 'esap';
my $db_password = 'esap123';
my $dbh = DBI->connect($dsn, $db_user_name, $db_password);
#$dbh->do("set names utf8") ;
#$dbh->do("set character set utf8");

$sql=qq(SELECT * FROM log ORDER BY id DESC LIMIT 1);#первая с конца строка из таблицы
$sth = $dbh->prepare( $sql );
$sth->execute();

while ( ($id, $uid, $level, $messaqe, $timestamap) = $sth->fetchrow_array) {
	($yyyy1, $mm1, $dd1, $HH1, $MM1, $SS1)=($timestamap =~ m/(\d+)-(\d+)-(\d+)\s+(\d+):(\d+):(\d+)/);

	 $dt = DateTime->new(
    year      => $yyyy1,
    month     => $mm1,
    day       => $dd1,
);
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
);
	 printf ("%-10d %-10d %-10s %-10s %-10s\n", $id, $uid, $level, $messaqe, $timestamap);
	print "\n";

}

# Прибавить1 день 
my $dt_duration = DateTime::Duration->new(
    days    => 1,
);

 $dt21 = DateTime->new(
    year      => '2015',
    month     => '09',
    day       => '09',
);
 $dt12 = DateTime->new(
    year      => '2015',
    month     => '09',
    day       => '10',
);
$d = $dt21->delta_days($dt12)->in_units('days');	
# $d = $dt2->delta_days($dt)->in_units('days');	


# my $begin=$dt2;
my $begin=$dt21;
my $next_dt=$begin+$dt_duration;

@student=();
@worker=();

my $count_all=0;

for($index=0;$index<$d;$index++){
    $next_dt=$begin+$dt_duration;
    print "счетчик $index \n";
    print $begin->datetime, "\n";
    print $next_dt->datetime, "\n";
    my $result = DateTime->compare( $begin, $next_dt);
    
        my $count_for_day=0;

        $dr=$begin->strftime("%Y-%m-%d ");#дата для поиска записей
        # print    $dr."\n";
        $sql=qq(SELECT * FROM log WHERE  timestamp like '$dr%' );#поиск записи по заданной дате
        $sth = $dbh->prepare( $sql );

        my ($id, $uid, $level, $message, $timestamp);
        # $sth->bind_columns(undef, \($id, $uid, $level, $messaqe, $timestamp));
        $sth->execute();

        my $count=0;

        while ( ($id, $uid, $level, $message, $timestamp) = $sth->fetchrow_array){ 
    #        printf ("%-10d %-10d %-10s %-10s %-10s\n", $id, $uid, $level, $messaqe, $timestamp);
	# print "\n";
         ($yyyy2, $mm2, $dd2, $HH2, $MM2, $SS2)=($timestamp =~ m/(\d+)-(\d+)-(\d+)\s+(\d+):(\d+):(\d+)/);
	     $dt3 = DateTime->new( year => $yyyy2, month => $mm2, day => $dd2, hour => $HH2, minute  => $MM2, second => $SS2, );
         $count_for_day++;


        # print "$messaqe\n";#создание\удаление акаунта, нужно встваить в фильтр за 1 день
        # print $messaqe."\n";
    printf "str={$message} \n";
    #  utf8::decode($message);
    #$message='Аккаунт marija_morozova создан: Морозова Мария Сергеевна, № зачётки 113015, паспорта 2463533. ( 10.105.12.105 )';
      if($message=~m/Аккаунт.*создан.*/){
        print "Аккаунт создан \n";#создание\удаление акаунта, нужно встваить в фильтр за 1 день
         $count++;
         print $count."\n";
        if($message=~/№ зачётки/){
             print "Это студент\n";
            $message=~/Аккаунт (.*?) создан/s;
            $message=~/[A-Za-z_]+/;
             $s=$&;
            push @student, $s;
        }elsif($message=~/ЛИН/){
             print "Это сотрудник\n";
            $message=~/Аккаунт (.*?) создан/s;
            $message=~/[A-Za-z_]+/;
            print $k=$&;
              print "\n";
            push @worker, $k;
        }else{ print "Это нечто!\n";}

     }
    elsif($message=~m/Из.БД.ESAP.*удаляю/){
         print "Акаунт удален \n";#создание\удаление акаунта, нужно встваить в фильтр за 1 день
         $count--;
         $message=~m/: /;#находим логин в сообщении/ нужно перенести в функцию
         $str=$';#логин который хотим удалить
         print $str."\n";
         #проверяем содержитсяли он в созданных
        if(&isStudent){
            print "Студент удален!\n";
        }elsif(&isWorker){
            print "Работник удален!\n";
        }
        else{
            print "Логин не был зарегестрирован\n";
        }
     }
     else{
         print "Не понятно\n";
     }


         $begin+=$dt_duration;
    }
     print "Записей за 1 день: $count_for_day\n";
     print "Изменено записей за 1 день: $count\n";

    
        $begin=$next_dt;
        # print "Записей за 1 день $count_for_day\n";
        $count_all+=$count_for_day;
}
     print "Всего записей $count_all\n";



$dbh->disconnect();

sub isStudent {
        for my $i(0 .. $#student){
            if($student[$i] eq $str){
                @student = grep $_ ne $student[$i], @student;
                # print "Студент найден!\n";
                return 1;
            }}
	    return 0;
        }
    sub isWorker {
        for my $i(0 .. $#worker){
            if($worker[$i] eq $str){
                @worker = grep $_ ne $worker[$i], @worker;
                return 1;
            }
            }
        return 0;
    }  