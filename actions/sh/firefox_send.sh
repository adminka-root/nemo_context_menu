#!/bin/bash
#https://send.firefox.com/
#Зависимости: xclip и yad
#
# ИЗВЕСТНЫЕ ПРОБЛЕМЫ: ffsend не обработает одиночный пустой текстовик, а вызовит ошибку. -> Написать соответствующее предупреждение
#
# ИДЕИ:
# 1) Добавить возможность отключения функции, не позволяющей отправить файл с несовместимыми с Windows и Mas OS символами
# 2) Реализовать полноценную (рекурсивную) файлов, к которым нет доступа
# 3) Оптимизировать скрипт, переписав с использованием функций
# 4) Сейчас 19.03.19, ffsend пока в альфе, наверни-ка со временем будут добавлены новые функции. Можно будет добавить их
# 5) Поддержка разных форматов архивов (а не только zip)
# 6) Вынос переменных с текстом в начала скрипта (для перевода и послед-го размещения в англ-м сегменте)
# 7) Чекбокс - удалить архив после успешной загрузки

#-----------------------------ФУНКЦИИ-----------------------------#
function yad_operation_cancel {
    yad --title="Да будет так!" --width=270 --window-icon=dialog-info --image=dialog-info --text="Операция отменена." --text-align=center --button=gtk-ok:0 --buttons-layout=center --fixed
    #notify-send -t 10000 -i "gtk-cancel" "Операция отменена!";
    exit
}
#-----------------------------------------------------------------#

#--------1. ПОЛУЧАЕМ МАССИВЫ ДОСТУПНЫХ И НЕДОСТУПНЫХ ФАЙЛОВ-------#
# file_c - число доступных для добаления в архив файлов
# dir_c - число доступных для добавления в архив папок
# missed - массив с недоступными для добавления файлами и папками
# can_add - массив с доступными для добавления файлами и папками
# can_add_zip - массив can_add с относительными путями вида ./*
# missed_i - индекс массив missed
# can_add_i - индекс массива can_add и can_add_zip

file_c=0
dir_c=0
declare -a missed
declare -a can_add
declare -a can_add_zip
missed_i=0
can_add_i=0

for i in "$@"
do
    if [[ -r "$i" && -f "$i" ]]; then
        file_c="$[file_c+1]"
        can_add[$can_add_i]="$i";
        can_add_zip[$can_add_i]="./${i##*/}"
        can_add_i="$[can_add_i+1]"
    elif [[ -r "$i" && -d "$i" && -x "$i" ]]; then
        dir_c="$[dir_c+1]"
        can_add[$can_add_i]="$i"
        can_add_i="$[can_add_i+1]"
        can_add_zip[$can_add_i]="./${i##*/}"
    else
        missed[$missed_i]="$i"
        missed_i="$[missed_i+1]"
    fi
done
#------------------------------END-1------------------------------#

#---------2. ДИАЛОГ С ПОЛЬЗОВАТЕЛЕМ ПОСЛЕ ВЫПОЛНЕНИЯ ЦИКЛА--------#
if [[ $missed_i > 0 && $can_add_i > 0 ]]; then
    yad --width=500 --height=200 --title="Пропустить файлы?" --text="Некоторые файлы и/или директории не могут быть добавлены!" \
        --image=gtk-dialog-warning-panel --window-icon=dialog-warning-symbolic \
        --form --field="Файлы, которые будут пропущены::TXT" "$(printf "%s\n" "${missed[@]}")" \
        --field="Файлы, которые будут добавлены::TXT" "$(printf "%s\n" "${can_add[@]}")"
    if [[ $? = 1 ]]; then
        yad_operation_cancel
    fi
else
    if [[ $can_add_i = 0 ]]; then
        yad --title="Что-то пошло ни так!" --height=90 --width=340 --window-icon=apport --image=apport --text="Ни один из файлов не может быть добавлен! \nЛибо к ним нет доступа, либо это баги скрипта" --button=Exit:1 --buttons-layout=center --fixed
        exit
    fi
fi
# Выходя отсюда, мы знаем, что:
# can_add_i>0
#------------------------------END-2------------------------------#

if [[ $can_add_i > 1 || $dir_c > 0 ]]; then

    #2.1. ДИАЛОГОВОЕ ОКНО СОЗДАНИЯ АРХИВА "ВЫ ЖЕЛАЕТЕ СОЗДАТЬ АРХИВ?"#
    if [[ $dir_c > 0 && $file_c > 0 ]]; then text_archive="Выбрано $file_c файл(а/ов) и $dir_c папк(а/и/ок). Вы желаете создать архив?"
    elif [[ $dir_c > 0 ]]; then text_archive="Выбрано $dir_c папк(а/и/ок). Вы желаете создать архив?"
    else text_archive="Выбрано $file_c файл(а/ов) . Вы желаете создать архив?"
    fi
    yad --window-icon=dialog-question --image "dialog-question" --title "Создать архив?" --button=gtk-no:1 --button=gtk-yes:0 --text "$text_archive"

    if [[ $? = 0 ]]; then
        #-----------------------------END-2.1-----------------------------#

        #--2.2. ДИАЛОГ ФОРМИРОВАНИЯ ПАРОЛЯ И ПРАВИЛЬНОГО ИМЕНИ ZIP-АРХИВА-#
        # $dialog_archive - техническая переменная для извлечения след-х 3-х:
        # $name_archive - будущее имя архива
        # $pass_archive - будущий пароль
        # $r_pass_archive - переменная для подтверждения пароля

        # 1) Убрали имя файла у первого элемента массива can_add
        # 2) Переместились в его род. папку (для формирования относит. путей в zip)
        # 3) Урезали путь до названия одной лишь род. папки (для формир. в будущем названия архива)
        name_archive="${can_add[0]%/*}"; cd "$name_archive"; name_archive="${name_archive##*/}"

        while [[ "$name_archive" == *['~"#%&*:<>?/\{|}']* ]] || [[ "$name_archive" == '' ]] \
            || [[ "$dialog_archive" == '' ]] \
            || [[ "$pass_archive" != "$r_pass_archive" ]]
        do
            if [[ ! -z $dialog_archive ]]; then notify-send -t 10000 -i "gtk-cancel" "Ошибка!" 'Задано неверное имя файла ИЛИ пароли не совпадают!\n\nДля справки: в названии архива недопустимы символы:\n<b><i>\~ \" \# \% \& \* \: \< \> \? \/ \\ \{ \| \}</i></b>'; fi

            dialog_archive=$(yad --title="Вы желаете создать zip-архив?" --height=255 --width=515 --text-align=fill --scroll --window-icon=application-zip --form --item-separator="|" --separator="ꔷ" \
                    --text='<span foreground="green"><b><big>Выбрано несколько файлов. Будет создан zip-архив.\nВы можете задать некоторые параметры или сразу продолжить.</big></b></span>' \
                    --field="<b>Название архива</b>" "$name_archive" \
                    --field='<span foreground="red">Внимание:</span> не используйте символы <b>\~ &quot; \# \% &amp; \* \: &lt; &gt; \? \/ \\ \{ \| \}</b>\n:LBL' "" \
                    --field="<b>Пароль</b>:H" "$pass_archive" \
                    --field="<b>Подтверждение пароля</b>:H" "$r_pass_archive" \
                --field="Если вам не нужен пароль для архива, оставьте данные поля пустыми:LBL")

            if [[ -z $dialog_archive ]]; then
                yad_operation_cancel
            fi
            name_archive="$(echo "$dialog_archive" | awk -F 'ꔷꔷ' '{print $1}')"
            pass_archive="$(echo "$dialog_archive" | awk -F 'ꔷꔷ' '{print $2}' | awk -F 'ꔷ' '{print $1}')"
            r_pass_archive="$(echo "$dialog_archive" | awk -F 'ꔷꔷ' '{print $2}' | awk -F 'ꔷ' '{print $2}')"
        done
        #-----------------------------END-2.2-----------------------------#

        #------------------------2.3. СОЗДАЕМ АРХИВ-----------------------#
        file_name_d="$name_archive.zip"
        if [[ -z "$pass_archive" ]]
        then zip -r "$file_name_d" "${can_add_zip[@]}"
        else zip -r -P "$pass_archive" "$file_name_d" "${can_add_zip[@]}"
        fi

        if [[ $? = 1 ]]; then yad --title="Что-то пошло ни так!" --width=320 --window-icon=apport --image=apport --text="Ошибка архивирования." --text-align=center --button=gtk-ok:1 --buttons-layout=center --fixed; fi
        #-----------------------------END-2.3-----------------------------#

    else
        yad_operation_cancel
    fi
else
    file_name_d="${can_add[0]}"
    if [[ "$(basename "$file_name_d")" == *['~"#%&*:<>?/\{|}']* ]]; then
        yad --title="Некорректное имя файла!" --width=320 --window-icon=apport --image=apport --text="Переименуйте файл. В названии не должно быть недопустимых символов:\n<b><i>\~ &quot; \# \% &amp; \* \: &lt; &gt; \? \/ \\ \{ \| \}</i></b>" --text-align=center --button=gtk-ok:1 --buttons-layout=center --fixed
        exit
    fi
fi

#-----3. ЗАДАЕМ ПАРОЛЬ И ЗАГРУЖАЕМ НА СЕРВЕР СРЕДСТВАМИ FFSEND----#
while [[ "$pass_ffsend" != "$r_pass_ffsend" ]] || [[ -z "$dialog_ffsend" ]]; do
    if [[ ! -z "$dialog_ffsend" ]]; then notify-send -t 10000 -i "gtk-cancel" "Пароли не совпадают!"; fi
    dialog_ffsend=$(yad --title='Вы желаете задать пароль через ffsend?' --height=138 --width=465 --scroll --window-icon=firefox-symbolic \
            --form --item-separator="|" --separator="ꔷ" --align=right \
            --button=gtk-ok:0 --buttons-layout=center \
            --field="<b>Пароль на сервере\nsend.firefox.com</b>:H" "$pass_ffsend" \
            --field="<b>Подтверждение    \nпароля</b>:H" "$r_pass_ffsend" \
        --field="Если вам не нужен пароль, оставьте данные поля пустыми:LBL" "")
    pass_ffsend="$(echo "$dialog_ffsend" | awk -F 'ꔷ' '{print $1}')"
    r_pass_ffsend="$(echo "$dialog_ffsend" | awk -F 'ꔷ' '{print $2}')"
    if [[ -z "$pass_ffsend" && -z "$r_pass_ffsend" ]]; then break; fi
done

if [[ -z "$dialog_ffsend" ]]; then yad_operation_cancel; fi

if [[ ! -z "$pass_ffsend" ]]
then link=$(ffsend -q upload "$file_name_d" --password="$pass_ffsend")
else link=$(ffsend -q upload "$file_name_d"); fi
#------------------------------END-3------------------------------#

#---------------4. КОПИРУЕМ В БУФЕР, ЕСЛИ ВСЕ УДАЧНО--------------#
if [[ $? = 0 ]]; then
    echo -n "$link" | xclip -i -selection clipboard
    yad --title="Ура!" --width=270 --window-icon=dialog-info --image=dialog-info --text="Загрузка завершена. В буфер обмена скопирована ссылка:\n<a href=\"$link\">$link</a>" --text-align=left --button=gtk-ok:0 --buttons-layout=center --fixed
    #notify-send -t 10000 -i "gtk-ok" "Загрузка завершена" "Ссылка скопирована в буфер обмена:\n$link"
else
    yad --title="Что-то пошло ни так!" --width=320 --window-icon=apport --image=apport --text="Ошибка загрузки файла \n\"<b>$file_name_d</b>\"" --text-align=center --button=gtk-ok:1 --buttons-layout=center --fixed
fi
#------------------------------END-4------------------------------#
