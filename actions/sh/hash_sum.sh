#!/bin/bash

result=`zenity --list --title="Вычисление хеш-сумм" --text="Что вычислить?" \
	--radiolist --column "" --column "Функция" \
	FALSE "md5" \
	TRUE "sha256" \
	FALSE "sha1" \
	FALSE "sha224" \
	FALSE "sha384" \
	FALSE "sha512" \
	--height=270 \
	--width=220`

if [ "$result" = "" ]
then
	zenity --info --title="Отмена" --text="Операция отменена"
	exit
fi

result_sum="$result""sum"


if [[ $# -ge 2 ]]; then #>=
    count_f=$#
    procent=$((100/$count_f))
    counter=0
    progress=0
    (for file in "$@"; do
        name="$(echo ${file##*/})"
        echo $progress
        echo "# Вычисляю у $name\nОбработано $counter из $count_f..." 
        all="$all<b>$result</b>: \"$name\" <b>-></b> $($result_sum "$file" | awk '{print $1}')\n"
        counter=$(($counter+1))
        progress=$(($progress+$procent))
        if [[ $counter -eq $count_f ]]; then echo 100; zenity --info --title="Результат" --text="$all"; fi
    done)|zenity --progress --title="Вычисление $result" --auto-close --auto-kill --no-cancel --width=250
    
else
        name="$(echo ${@##*/})"
        all="$all<b>$result</b>: \"$name\" <b>-></b> $($result_sum "$@" | awk '{print $1}')\n"
        zenity --info --title="Результат" --text="$all"
fi

