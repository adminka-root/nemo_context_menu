#!/bin/bash

# -------------------------------------- 23.05.21 -------------------------------------
# Автор скрипта - https://github.com/adminka-root
# Зависимости: yad libnotify-bin  cryptsetup   parted   udisks2 libblockdev-crypto2   grep  gawk  file   mount   coreutils
# Команды:     yad  notify-send   cryptsetup  partprobe     udisksctl                 grep  awk   file  losetup
#
# Рекомендации к улучшению:
# Функция - получение/использование ключа для luks
# 1) Опция -k = не предлагать указание пути к ключевому файлу для luks
# 2) Файл, хранящий строки вида <контейнер> <путь к ключю разблокировки>
# 3) Внести в качестве зависимости libblockdev-crypto2 для исправления бага
#    udisk2 (подробности - https://github.com/pop-os/pop/issues/163)
# Добавить больше типов контейнеров
#
# Потенциальные ошибки скрипта:
# 1) Если система сразу же забывает пароль от sudo (timeout=0), то скрипт поломается (допущение)
#    а она не будет запоминать, если скрипт запущен НЕ в окне терминала (ошибка sudo или фича, хз)
#    Собственно, суть проблемы в том, что я хз, как передать сначала пароль sudo, а после - парольную
#    фразу в cryptsetup. Не получилось завести. Поэтому необходимо, чтобы система помнила пароль
#    после первого вызова sudo -v
#    Чтобы окно терминала не мазолило глаза, можно установить sudo apt-get install xvfb xterm, а после
#    открывать виртуальные иксы для команды запуска. Что-то типа
#    xvfb-run xterm -e "DISPLAY=:0.0 "$HOME/.local/share/nemo/actions/sh/mounting_containers.sh" -g -f %F"  # строка из nemo_action
#    Сам терминал будет запущен в виртуалке, а скрипт - на первом мониторе. После завершения скрипта
#    вирт. искы убиваются. В качестве альтернативы что-то типо
#       Xvfb :99 -screen 0 640x480x24 -fbdir /tmp &
#       PID=$!
#       sleep 5
#       DISPLAY=:99 xterm -e "DISPLAY=:0 "$HOME/.local/share/nemo/actions/sh/mounting_containers.sh" -g -f "$1""
#       kill $PID
# 2) Если сущ. петля, созданная от имени root, для контейнера, что хотим смонтировать, то функция
#    clean_loops будет вызывать в графике окно с требованием ввести пароль для удаления дубликата
#    старой петли, но по факту удаление (для Luks - точно), не произойдет. Это вина/баг udisk2.
# -------------------------------------------------------------------------------------

usage() { # подсказка
    echo -e "\n\033[0;1mСкрипт для файлов-контейнеров, содержащих файловые системы\033[0m\n"
    echo "Использование: $0 [ -f путь_до_контейнера ] [ -d директория_монтирования] [ -t тип_фс ] [ -p ] [ -g ]"
    echo
    echo "   -f   Указать путь до файла-контейнера (обязательная опция)."
    echo
    echo "   -d   Указать директорию монтирования (потребуются root-права)."
    echo
    echo "   -t   Тип файловой системы. Если не указано, пытается определить сам."
    echo "        Поддерживаемые типы: auto, LUKS."
    echo
    echo "   -p   Информировать ОС об изменении таблицы разделов (потребуются root-права)."
    echo
    echo "   -g   Включить графический режим"
    echo
}

exit_abnormal() { # функция экстренного выхода вследствии ошибки
    if [[ ! -z "$@" ]]; then
        echo -e "\n$@" >&2;
        if [[ $graphics_mode -eq 0 ]]; then
            notify-send -t 10000 -i "dialog-warning" "${0##*/}" "$@"
        fi
    fi

    usage
    exit 1
}

out_type_message() {  # вывод сообщений; $1 иконка для notify-send; все остальное - сообщение
    if [[ ! -z "$@" ]]; then
        if [[ $graphics_mode -eq 0 ]]; then
            icon_n="$1"
            shift
            notify-send -t 10000 -i "$icon_n" "${0##*/}" "$@"
        else
            shift
        fi

        echo -e "\n$@" >&2;
    fi
}

f_getopts () { # получение правильных опций и переключение флагов
    while getopts ":f:d:t:pg" options; do
        case "${options}" in
            f) container_name="${OPTARG}";;
            :) exit_abnormal "Ошибка: -${OPTARG} требует аргумента.";;

            d) mount_dir="${OPTARG}";;
            :) exit_abnormal "Ошибка: -${OPTARG} требует аргумента.";;

            t) fs_type="${OPTARG,,}";;  # запоминаем в нижнем регистре
            :) exit_abnormal "Ошибка: -${OPTARG} требует аргумента.";;

            p) partprobe_mode=0;;
            g)  if [[ ! -z "$DISPLAY" ]]; then
                    graphics_mode=0
                else
                    exit_abnormal "Ошибка: запрошен граф. режим, но вы не используете графику!"
                fi
                ;;
            *)
                if [[ "${OPTARG}" != "h" ]]; then
                    exit_abnormal "Ошибка: неверный ключ «-${OPTARG}»."
                fi
                exit_abnormal
                ;;
        esac
    done
}

option_analysis() {  # анализ опций на совместимость и корректность
    error_output=""  # переменная для сбора ошибок

    # не был указан файл контейнер
    if [[ -z "$container_name" ]]; then
        if [[ $graphics_mode -eq 1 ]]; then  # фактически, запуск без -f
            error_output+="Ошибка: не указана опция -f! Что монтировать?!\n"
        elif [[ $yad_launched_before -eq 0 ]]; then  # графика вкл и yad запускался ранее
            error_output+="Ошибка: не указан контейнер для монтирования!\n"
        fi
    # был указан файл-контейнер, но НЕ [сущ-т]/[явл-ся файлом] или не читаем (-f)
    elif [[ ! -f "$container_name" || ! -r "$container_name" ]]; then
        # граф. режим включен и yad НЕ запускался ранее
        if [[ $graphics_mode -eq 0 && $yad_launched_before -eq 1 ]]; then
            container_name=""  # обнуляем (укажем при первом вызове yad)
        else  # граф. режим ВЫКЛ или yad запускался ранее
            error_output+="Ошибка: контейнер \"$container_name\" не существует или не доступен для чтения!\n"
        fi
    fi

    # была указана директория, но таковой не явл-ся (-d)
    if [[ ! -z "$mount_dir" && ! -d "$mount_dir" ]]; then
        # граф. режим включен и yad НЕ запускался ранее
        if [[ $graphics_mode -eq 0 && $yad_launched_before -eq 1 ]]; then
            mount_dir=""
        else
            error_output+="Ошибка: директория \"$mount_dir\" не существует или нет доступа!\n"
        fi
    fi

    # если указали тип ФС (-t) и yad ранее не запускался (если запускался,
    # подразумевается, что yad передает корректный ответ)
    if [[ ! -z "$fs_type" && $yad_launched_before -eq 1 ]]; then
        check_fs_type=1  # временная переменная для проверки вхождения в условие
        for current_fs in "${all_fs_types[@]}"; do
            if [[ "$current_fs" = "$fs_type" ]]; then  # указанная ФС есть в списке корректных?
                check_fs_type=0
                break
            fi
        done

        if [[ $check_fs_type -eq 1 ]]; then  # указанная ФС - неверна
            if [[ $graphics_mode -eq 1 ]]; then
                error_output+="Ошибка: \"$fs_type\" не поддерживается опцией -t!\n"
            else
                fs_type="auto"
            fi
        fi
    fi

    # если получили ошибки, выводим, выходим
    if [[ ! -z "$error_output" ]]; then
        exit_abnormal "$error_output"
    fi
}

yad_getopts () {  # получение опций через yad графику

    # --------------- ФОРМИРУЕМ ПОЛЕ "ТИП КОНТЕЙНЕРА" ДЛЯ YAD ----------------
    fs_type_yad=""
    for type in "${all_fs_types[@]}"; do
        if [[ "$type" != "$fs_type" ]]; then
            fs_type_yad+="$type|"
        else
            fs_type_yad+="^$type|"
        fi
    done
    fs_type_yad="${fs_type_yad:0:-1}"
    # ------------------------------------------------------------------------

    # ----------------------- ПЕРЕОПРЕДЕЛЯЕМ ЧЕКБОКСЫ ------------------------
    partprobe_mode_yad='FALSE'
    if [[ $partprobe_mode -eq 0 ]]; then
        partprobe_mode_yad='TRUE'
    fi
    # ------------------------------------------------------------------------

    # ------------------- ВЫЗЫВАЕМ YAD ОКНО, ПОЛУЧАЕМ ОТВЕТ ------------------
    # Мы вынуждены не указывать тип для 2-го поля (хотя по логике должен быть
    # DIR), поскольку yad постоянно его заполняет как $PWD, а значит,
    # не возможно оставить его пустым. Поэтому ввод директории - ручками
    dialog_getopts=$(yad --title="Монтирование файлов-контейнеров" --height=200 --width=555 --text-align=fill \
                         --scroll --window-icon="zip" --form --item-separator="|" --separator="ꔷ" \
            --field="<b>Путь к контейнеру</b>:FL" "$container_name" \
            --field="<b>Куда монтировать</b>\n<small>(необязательно, если используется udisk2)</small>:" "$mount_dir" \
            --field="Тип контейнера:CB" "$fs_type_yad" \
            --field="Информировать ОС об изменении таблицы разделов (потребуются root-права):CHK" "$partprobe_mode_yad")

    if [[ -z "$dialog_getopts" ]]; then  # если не получили ответ
        exit_abnormal "Да будет так: операция отменена!"
    fi
    # ------------------------------------------------------------------------

    # ---------------------------- ЗАПОЛНЯЕМ ОПЦИИ ----------------------------
    # разбор ответа
    IFS="ꔷ"  # меняем разделитель полей
    mas_yad_getopts=($(echo "$dialog_getopts"))  # получаем ответ в массив
    IFS=$old_IFS  # возвращаем разделитель полей

    # заполнение ответа из массива
    container_name="${mas_yad_getopts[0]}"
    mount_dir="${mas_yad_getopts[1]}"
    fs_type="${mas_yad_getopts[2]}"
    if [[ "${mas_yad_getopts[3]}" = "FALSE" ]]; then partprobe_mode=1; else partprobe_mode=0; fi
    # ------------------------------------------------------------------------

    yad_launched_before=0  # запускался ли yad раньше - ДА!
}

check_container_type () {  # пытается определить тип контейнера (auto-mode)
    type_container="$(file "$container_name" | awk -F "," '{print $1}')"
    case "$type_container" in
        "$container_name: LUKS encrypted file") fs_type="luks";;
        *) exit_abnormal "Ошибка: не удалось определить тип контейнера!";;
    esac
    control_f_mount  # вызываем гл. функцию с определенным fs_type
}

control_f_mount () {  # смотрит тип монтирования и вызывает соотв-ю ф-ю монтирования
    case "$fs_type" in
        "auto"|"") check_container_type;;
        "luks") luks_mount;;
        *) exit_abnormal "Ошибка в главной функции монтирования!";;
    esac
}

clean_loops() {  # функция зачистки петель
    # получаем список "активных" петель для контейнера
    losetup_p="$(losetup --list --output=NAME,BACK-FILE -n | grep "$container_name$" | awk '{print $1}')"
    if [[ "$losetup_p" != "" ]]; then  # если таковые имеются
        # удаляем лишние неактивные (не разблокированные (СВ-ВО udisk2)) петли для контейнера
        for i in $losetup_p; do udisksctl loop-delete -b "$i"; done

        # получаем новый список "активных" петель для контейнера
        losetup_p_n="$(losetup --list --output=NAME,BACK-FILE -n | grep "$container_name$" | awk '{print $1}')"
        if [[ "$losetup_p_n" = "$losetup_p" ]]; then  # ничего не было удалено
            out_type_message "gtk-cancel" "Ошибка: устройство уже смонтировано и открыто!"
            exit 1
        elif [[ "$losetup_p_n" = "" ]]; then # "$losetup_p_n" != "$losetup_p"
            out_type_message "dialog-ok" "Лишние петли были удалены! Перехожу к монтированию!"
        else  # $losetup_p_n" != ""; вывод изменился, но "$losetup_p_n" != "$losetup_p"
            out_type_message "gtk-cancel" "Лишние петли были удалены! Но, кажется, устройство уже смонтировано и открыто!"
            exit 1
        fi
    fi
}

yad_get_passwd() {  # ф-я для получения пароля
    # это отменит требование ввода пароля, если скрипт запущен с sudo
    # или в sudoers указано что-то типо NOPASSWD:ALL
    # или мы просто недавно вводили sudo и он еще не слетел
    (echo "" | sudo -S sudo -v) && return 0  # sudo -v лучше

    receive_pass=""  # переменная для хранения пароля
    while :; do  # бесконечный цикл
        if [[ ! -z "$receive_pass" ]]; then
            (echo "$receive_pass" | sudo -S sudo -v) && break
            out_type_message "dialog-error" "Ошибка: неверный пароль! Попробуйте еще раз или отмените операцию!"
        fi

        receive_pass="$(yad --title="Монтирование контейнеров" --window-icon="lock" --width=400 --entry --entry-label="Введите пароль для sudo" --hide-text)"
        if [[ $? -eq 1 ]]; then  # нажата отмена?
            exit_abnormal "Выход: монтирование отменено пользователем!"
        fi
    done
    # unset luks_pass  # удаление переменной (возможно, это слишком)
}

# определяет разделы у контейнера после команды partprobe, появились они или нет
# и в зависимости от наличия $mount_dir, монтирующая в нужное место
mount_part () {
    # $1 - устройство, которое смотрим
    block_dev="$1"

    # $2 - директория по умолчанию, если не задана $mount_dir
    new_mount_dir="${mount_dir:-$2}"

    # получаем названия разделов в контейнере
    IFS=$'\n' # только переводы строк считаются разделителем
    name_part=($(lsblk -P "$block_dev" | awk -F '=|"' '{print $3}' | tail -n +2))
    old_IFS=$IFS

    local mount_success=""  # переменная для сбора успешного монтирования
    local mount_error=""  # переменная для сбора ошибок монтирования

    if [[ ${#name_part[@]} -gt 0 ]]; then  # действительно в контейнере были разделы
        for ((i=0; i<${#name_part[@]}; i++)); do
            md="$new_mount_dir/${name_part[$i]##*/}"
            sudo mkdir -p "$md"
            # проверяем успех выполнения команды монтирования
            if sudo mount "${block_dev%/*}/${name_part[$i]}" "$md"; then
                sudo chown "$USER":"$USER" "$md"
                mount_success+="${block_dev%/*}/${name_part[$i]} - \"$md\"\n"
            else
                mount_error+="${block_dev%/*}/${name_part[$i]} - \"$md\"\n"
            fi
        done
    else
        out_type_message "dialog-warning" "Предупреждение: была запрошена операция обновления таблицы разделов, но разделы не были обнаружены!"
        sudo mkdir -p "$new_mount_dir"
        # проверяем успех выполнения команды монтирования
        if sudo mount "$block_dev" "$new_mount_dir"; then
            sudo chown "$USER":"$USER" "$new_mount_dir"
            mount_success+="$block_dev - \"$new_mount_dir\""
        else
            mount_error+="$block_dev - \"$new_mount_dir\""
        fi
    fi

    # вывод результата
    if [[ -z "$mount_error" ]]; then
        out_type_message "dialog-ok" "Успешное монтирование всех устройств:\n$mount_success"
    elif [[ -z "$mount_success" ]]; then
        out_type_message "dialog-error" "Ошибка: не удалось смонтировать все устройства:\n$mount_error"
        return 1
    else
        out_type_message "dialog-warning" "Успешное монтирование:\n$mount_success\nНе удалось смонтировать:\n$mount_error"
    fi
}

# ----------------------------------------------- LUKS функции -----------------------------------------------
# получение уникального имени для устр-ва /dev/mapper
dm_user_name_f() {  # получаем уникальное имя; $1 - путь устройства; $2 - container_name
    local dm_user_name="${2##*/}"  # имя контейнера
    if [[ -a "$1/$dm_user_name" ]]; then
        dm_us_c=0  # счетчик
        while [[ -a "$1/$dm_user_name"_"$dm_us_c" ]]; do
            dm_us_c=$[dm_us_c+1]  # увеличиваем индекс
        done
        dm_user_name="$dm_user_name"_"$dm_us_c"
    fi
    echo "$dm_user_name"  # возвращаемое значение функции
}

luks_mount () {  # монтирование контейнеров luks

    clean_loops  # зачищаем петли, если надо

    # нужно смонтир. в определенную директорию ИЛИ сообщить ядру об изменении таблицы разделов
    if [[ ! -z "$mount_dir" || $partprobe_mode -eq 0 ]]; then
        # если вкл. граф. режим, получить пароль
        if [[ $graphics_mode -eq 0 ]]; then yad_get_passwd; fi

        dm_user_name="$(dm_user_name_f "$dev_map" "$container_name")" # уник. имя для устр-ва /dev/mapper

        # разблокирования контейнера (ф-я для графики)
        if [[ $graphics_mode -eq 0 ]]; then
            yad_get_passwd_luks "$dm_user_name"
        else  # если графики нет
             sudo cryptsetup luksOpen "$container_name" "$dm_user_name"
        fi

        if [[ $partprobe_mode -eq 0 ]]; then  # если нужно обновить таблицу
            if sudo partprobe "$dev_map/$dm_user_name"; then
                # монтирование для partprobe
                if ! (mount_part "$dev_map/$dm_user_name" "/media/$USER/$dm_user_name"); then
                    sudo cryptsetup close "$dm_user_name"  # попытка закрытия контейнера, если монтирование не удалось
                    exit 1
                fi
            else
                exit_abnormal "Не удалось информировать ОС об изменении таблицы разделов. partprobe Err: $?"
            fi
        else  # монтировать в определенную директорию
            if sudo mount "$dev_map/$dm_user_name" "$mount_dir"; then
                sudo chown "$USER":"$USER" "$mount_dir"
                out_type_message "dialog-ok" "Успешное монтирование:\n$dev_map/$dm_user_name - \"$mount_dir\""
            else
                sudo cryptsetup close "$dm_user_name"  # попытка закрытия контейнера, если монтирование не удалось
                out_type_message "dialog-error" "Ошибка: не удалось смонтировать:\n$dev_map/$dm_user_name - \"$mount_dir\""
                exit 1
            fi
        fi

    else
        get_loop="$(losetup -L --find)"  # получаем номер свободной петли

        # создает петлю, в графике сразу предлагает ввод пароля
        if udisksctl loop-setup --no-user-interaction --file "$container_name"; then
            if [[ $graphics_mode -eq 1 ]]; then  # если графический режим выключен
                # get_dm="$(udisksctl unlock --block-device "$get_loop")"  # Unlocked /dev/loop5 as /dev/dm-2.
                # get_dm=($get_dm)  # формируем массив
                # get_dm="${get_dm[3]:0:-1}"  # извлекаем 3 элемент без последнего символа
                #                    ИЛИ тоже самое
                # во время выполнения этой команды можно получить вечно весящий "Passphrase"
                # или ошибку, если скрипт запущен в графике без граф. опции и введен пароль через графику
                if udisksctl unlock --no-user-interaction --block-device "$get_loop"; then
                    get_dm="$(echo $(ls -r /dev/dm*) | awk '{print $1}')"

                    if udisksctl mount --block-device "$get_dm"; then
                        out_type_message "dialog-ok" "Успешное монтирование!"
                    fi
                else
                    exit_abnormal "Не удалось разблокировать устройство!"
                fi
            fi
        else
            exit_abnormal "Ошибка: не удалось создать петлевое устройство!"
        fi
    fi
}

# ф-я для получения пароля luks и открытия контейнера (cryptsetup)
yad_get_passwd_luks() {  # принимает $1 - название устройства в /dev/mapper/
    if [[ -z "$1" ]]; then return 1; fi
    local luks_pass=""
    while :; do
        echo "$receive_pass" | sudo -S sudo -v  # обновляем на всякий timeouts sudo
        if [[ ! -z "$luks_pass" ]]; then
            # получим ошибку, если sudo не запоминает пароль
            (echo -n "$luks_pass" | sudo cryptsetup luksOpen "$container_name" "$1" -d -) && break
            case $? in
                1) out_type_message "dialog-error" "Ошибка: неверный пароль! Попробуйте еще раз или отмените операцию!";;
                *) out_type_message "dialog-error" "Ошибка: cryptsetup завершился с кодом ошибки $?";;
            esac
        fi

        luks_pass="$(yad --title="Монтирование контейнеров" --window-icon="lock" --width=400 --entry --entry-label="Введите пароль от контейнера \"${container_name##*/}\"" --hide-text)"
        if [[ $? -eq 1 ]]; then  # нажата отмена?
            exit_abnormal "Выход: монтирование отменено пользователем!"
        fi
    done
    unset luks_pass  # удаление переменной (возможно, это слишком)
}

# -----------------------------------------------------------------------------------------------------------

main_f () {  # главная функция, инициализирует, все и вся
    #---------------------------ПЕРВАЯ ПАЧКА ПЕРЕМЕННЫХ ПО-УМОЛЧАНИЮ---------------------
    old_IFS=$IFS
    container_name=""  # полный путь до контейнера
    mount_dir=""  # директория монтирования
    fs_type=""  # тип фс
    partprobe_mode=1  # 1 - выключен, 0 - включен
    graphics_mode=1  # 1 - выключен, 0 - включен

    all_fs_types=("auto" "luks")  # тех. массив, содержащий поддерживаемые типы ФС
    yad_launched_before=1  # запускался ли yad раньше для получения опций; 1 - нет, 0 - да

    dev_map="/dev/mapper"  # константа, где cryptsetup создает контейнеры (не должен оканч. на слэш)
    receive_pass=""  # переменная для хранения пароля системы
    #------------------------------------------------------------------------------------

    f_getopts "$@" # получаем опции
    option_analysis # проверяем корректность ввода опций
    if [[ $graphics_mode -eq 0 ]]; then  # если нужно запустить в граф. режиме
        yad_getopts  # получаем опции от yad
        option_analysis  # анализируем опции еще раз
    fi
    control_f_mount  # монтируем
    unset receive_pass
}

main_f "$@"
