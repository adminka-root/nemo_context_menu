#!/bin/bash

AAA=`yad --title="Scan for threats..." --width=250 --window-icon=/usr/share/pixmaps/clamtk.png --form --item-separator="|" --separator="," --field="Удалять зараженные файлы:CHK" 'TRUE' --field="Проверять вложенные каталоги:CHK" 'TRUE' --field="Включить псевдопрогресс:CHK" 'TRUE' --field="Политика symbolic link:CB" "^По умолчанию (следовать, если ссылка передана в качестве аргумента)|Следовать для директорий и файлов" `

if [[ -z "$AAA" ]]; then
    echo "Операция отменена!"; exit
fi

remove="$(echo $AAA | awk -F ',' '{print $1}')"
recursive="$(echo $AAA | awk -F ',' '{print $2}')"
progress="$(echo $AAA | awk -F ',' '{print $3}')"
symlinks_c="$(echo $AAA | awk -F ',' '{print $4}')"
type_of_scan=''

if [[ "$remove" = "TRUE" ]]; then remove='--remove=yes'; else remove=''; fi
if [[ "$recursive" = "TRUE" ]]; then recursive='-r'; else recursive=''; fi

if [[ "$symlinks_c" = 'По умолчанию (следовать' ]]; then symlinks_c=''
else symlinks_c='--follow-dir-symlinks=2 --follow-file-symlinks=2'; fi;

    if [[ "$recursive" = "-r" ]]; then

        final_options_f='-type f'
        if [[ "$symlinks_c" = '' ]]
        then
            type_of_scan='Обрабатывать только файлы и папки + явно заданные в аргументе symlink-и (с рекурсивным вхождением)'
            first_options_f='-H'
        else
            type_of_scan='Обрабатывать все и вся (с рекурсивным вхождением)'
            first_options_f='-L'
        fi
    else
        final_options_f='-maxdepth 1 -type f -printf %f\\n\\r'
        if [[ "$symlinks_c" = '' ]]
        then
            type_of_scan='Обрабатывать только файлы + явно заданные в аргументе файлы-symlink-и (без рекурсивного вхождения)'
            first_options_f=''
        else
            type_of_scan='Обрабатывать только файлы и файлы-symlink-и (без рекурсивного вхождения)'
            first_options_f='-L'
        fi
    fi

if [[ "$progress" = "TRUE" ]]; then
    tmp='0'
    log_file="--log=$HOME/clamavscan_log_file.txt"
    file_c=0
    for i in "$@"
    do
        if [[ -f "$i" ]]
            then file_c="$[file_c+1]"
            else
                file_c="$[file_c+$(echo -e "$(find $first_options_f "$i" $final_options_f)" | wc -l)]"
                tmp="$[tmp+1]"
        fi
    done
    if [[ "$recursive" = '' && "$tmp" -ne '0' ]]; then file_c="$[file_c-tmp]"; fi
    clear; echo "Текущая версия антивируса:"; freshclam -V
    echo -e "\nТип сканирования: \n$type_of_scan\n\nПримерное количество файлов для сканирования: $file_c"
    clamscan $log_file $remove $recursive $symlinks_c "$@" | awk -F: '$2 ~ /OK/ || /FOUND/ {ok++} {printf "Примерное количество проверенных файлов: %d\r", ok}'
    cat ${log_file#--log=}
    rm ${log_file#--log=}
else
    clear; echo "Текущая версия антивируса:"; freshclam -V
    echo -e "\nТип сканирования: \n$type_of_scan\n"
    echo; clamscan -o $remove $recursive $symlinks_c "$@"
fi

echo; read -p 'Сканирование завершено, нажатие Enter закроет окно! '; exit
