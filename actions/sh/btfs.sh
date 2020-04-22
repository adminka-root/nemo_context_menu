#!/bin/bash
#04.04.19
# Скрипт для монтирования/размонтирования торрент-файлов средствами btfs от root/adminka
# Зависимости: btfs, zenity, gawk, sed, wc

help="Должна быть указана только одна из перечисленных ниже опции:\n\t<b>-m</b> patch\t\tопция монтирования, patch - полный путь до монтируемого торрент-файла\n\t<b>-u</b>\t\t\t\tопция размонтирования, <u>путь указывать не нужно</u>, он сам извлекается из /etc/mtab"

# по пути монтирования; -ge это больше или равно
if [[ $# -ge 2 && "$1" = "-m" ]]; then
    # чуток извращения))) в цикле отсчет ведем от значений после -m
    patch_mas=("$@");
    for i in "${patch_mas[@]:1:$[${#patch_mas[@]} - 1]}"; do
        if [[ ! -f  "$i" || ! -r  "$i" ]]; then patch_err_mas=("${patch_err_mas[@]}" "$i\n\n")
        else patch_good_mas=("${patch_good_mas[@]}" "$i"); fi
    done
    if [[ ${#patch_err_mas[@]} > 0 ]]; then
        if [[ ${#patch_err_mas[@]} = 1 ]]; then zenity --error --width=700 --title="Операция отменена" --text="Файл\n\n<b>$(echo ${patch_err_mas[@]})</b>не существует или не доступен для чтения!"
        else zenity --error --width=700 --title="Операция отменена" --text="Файлы\n\n<b>$(echo ${patch_err_mas[@]})</b>не существуют или не доступны для чтения!"; fi
        exit 1
    fi

    for i in "${patch_good_mas[@]}"; do
        # значение 0 - надо вызвать zenity окно с вопросом, 1 - окно уже было вызвано, нужно вывести ошибку
        test_patch=0
        while [[ $test_patch = 0 || $(ls -s "$mount_point" | grep итого | awk '{print $2}') != 0 || ! -w "$mount_point" || ! -r "$mount_point" ]]; do
            if [[ $test_patch = 0 ]]; then
                mount_point=`zenity --title="Куда монтировать ${i##*/}?" --file-selection --directory --filename="$i"`
                if [[ $? = 1 ]]; then mount_point=""; break; fi
                test_patch=1
            else
                if [[ ! -w "$mount_point" || ! -r "$mount_point" ]]
                then text_err="Директория <b><i>$mount_point</i></b> не доступна чтения и/или записи!"
                else text_err="Точка монтирования <b><i>$mount_point</i></b> должна быть пустой!"; fi

                zenity --question --ok-label="Да" --cancel-label="Нет" --width=500 --title="Ошибка выбора директории" --text="$text_err <i>Хотите указать другую?</i>"
                if [[ $? = 1 ]]; then mount_point=""; break; else test_patch=0; fi
            fi
        done

        if [[ "$mount_point" = "" ]]
        then zenity --warning --width=500 --text="Вы не указали директорию монтирования для файла \"<b><i>${i##*/}</i></b>\", поэтому он будет пропущен!"
        else btfs "$i" "$mount_point"; fi
    done
# по пути размонтирования
elif [[ $# = 1 && "$1" = "-u" ]]; then
    ###$[(i+1)/2]""p" - последние добавленные снизу (при этом i=1; i<=count); patch_mas[$count-1]='TRUE'
    ###$[(count-i)/2]""p" - последние добав. вверху (при этом i=0; i<count); patch_mas[0]='TRUE'
    ###Все ради ЧЁТНОСТИ при делении на 2
    count=$(sed -n '/btfs/p' /etc/mtab | wc -l)
    if [[ $count = 0 ]]; then zenity --info --width=300 --title="Нечего отмонтировать" --text="Файл <b>/etc/mtab</b> не содержит информации о наличии примонтированных торрент-файлов!"; exit; fi
    count=$[count*2]
    for ((i=0; i<count; i=i+2))
    do
        patch_mas[$i]='""'
        patch_mas[$i+1]="$(sed -n '/btfs/p' /etc/mtab | awk '{print $2}' | sed 's/\\040/\ /g' | sed -n "$[(count-i)/2]""p")"
    done

    patch_mas[0]='TRUE'

    upatch=`zenity --list --title="Что отмонтировать?" --text="Укажите, какие папки должны быть отмонтированы" \
    --checklist --separator="\n" --hide-header --column="" --column="" \
    "${patch_mas[@]}"`

    zenity --question --ok-label="Да" --cancel-label="Нет" --width=500 --title="Удалить пустые папки?" --text="Удалить директорий бывших точек монтирования?"
    if [[ $? = 0 ]]; then rm_dir="yes"; fi

    #извлекаем значения и отмонтируем
    count="$(echo "$upatch" | wc -l)"
    for ((i=1; i<=count; i++)); do
        umount_point=$(echo "$upatch" | sed -n "$i""p");
        fusermount -u "$umount_point"
        if [[ $? = 1 ]]
            then zenity --error --width=500 --title="Ошибка размонтирования" --text="Директория \"<b>$umount_point</b>\" занята!"
            else if [[ "$rm_dir" = "yes" ]]; then rm -rf "$umount_point"; fi
        fi
    done
# $# равен нулю
else zenity --error --width=700 --title="Неверные параметры!" --text="$help"; exit; fi


