#!/usr/bin/perl -w
use utf8;
use open ':std', ':encoding(UTF-8)';


open(MYFILE, "test1.txt")||die "Ошибка при открытии файла $!\n";

#можно создать ассоциативный массив где ключ-логин а значение статус
@student=();
@worker=();

while(<MYFILE>){
chomp;#убрать \n в последнем поле
    ($mes, $data)=/(.*);(.*)/;#записываем 
push @mes, $mes;
push @data, $data;
}


$count=0;

for ( $i = 0; $i <= $#mes; $i++) {#работа с сообщением
   $_=$mes[$i];#создание\удаление акаунта, нужно встваить в фильтр за 1 день
    if(m/Аккаунт.*создан/){
         $count++;
        if($_=~m/№ зачётки/){
            m/Аккаунт (.*?) создан/s;
            m/[A-Za-z_]+/;
            $s=$&;
            push @student, $s;
        }elsif($_=~m/ЛИН/){
            m/Аккаунт (.*?) создан/s;
            m/[A-Za-z_]+/;
            $k=$&;
            push @worker, $k;
        }else{ print "Это нечто!\n";}

     }
    elsif(m/Из БД ESAP.*удаляю/){
         $count--;
         $_= m/: /;#находим логин в сообщении/ нужно перенести в функцию
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
}
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

print "Количество: $count\n";