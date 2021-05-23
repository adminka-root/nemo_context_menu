#!/bin/bash

if [[ ${#@} -gt 0 ]]; then  # если были переданы параметры

    # функция преобразования документов
    convert_f () { $1 --convert-to pdf "$file" --outdir "$out_dir" && count_gf=$[count_gf + 1] && good_files="$good_files\n$file"; }

    bad_files=""  # переменная для сбора "плохих" файлов
    good_files=""  # переменная для сбора "хороших" файлов
    count_gf=0  # число "хороших" файлов

    for file in "$@"; do
        out_dir="${file%/*}"
        if [[ ! -d "$out_dir" || ! -w "$out_dir" || ! -f "$file" || ! -r "$file" ]]; then bad_files="$bad_files\n$file"; continue; fi

        exp_file="${file##*.}"  # получаем расширение
        exp_file="${exp_file,,}"  # переводим в нижний регистр
        case "$exp_file" in
            xls|xsls|ods) convert_f "localc";;
            odp|pptx|ppt) convert_f "loimpress";;
            doc|docx|odt|rtf|txt) convert_f "lowriter";;
            *) bad_files="$bad_files\n$file";;
        esac
    done

    if [[ $count_gf -ne ${#@} ]]; then  # если какие-то файлы были плохими
        if [[  $count_gf -eq 0 ]]; then  # если все файлы были плохими
            notify-send -t 10000 -i "gtk-cancel" "Преобразование в PDF документов" "<b>Ошибка: ни один из указанных файлов не был конвертирован!</b>"
        else
            notify-send -t 10000 -i "dialog-warning" "Преобразование в PDF" \
            "<b>Успешно конвертированы:</b>$good_files\n\n<b>В конвертировании отказано:</b>$bad_files"
        fi
    else
        notify-send -t 10000 -i "gtk-ok" "Преобразование в PDF документов" "Все файлы успешно конвертированы!"
    fi
else
    notify-send -t 10000 -i "gtk-cancel" "Преобразование в PDF документов" "<b>Ошибка: нечего преобразовывать!</b>"
fi

