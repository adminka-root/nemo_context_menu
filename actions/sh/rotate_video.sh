#!/bin/bash

# -------------------------------------- 16.05.21 -------------------------------------
# Автор скрипта - https://github.com/adminka-root
# Зависимости: libnotify-bin yad ffmpeg findutils procps psmisc
# Команды:     notify-send   yad ffmpeg   find    kill  killall
# -------------------------------------------------------------------------------------

usage() { # подсказка
    echo -e "\n\033[0;1mСкрипт для изменения ориентации видео: поворот на 90° по/против часовой стрелки, а также для поворота на 180°\033[0m\n"
    echo "Использование: $0 [ -d путь_к_исходной_папке ] [-u путь_куда_сохранять]"
    echo "                          или"
    echo "               $0 [файл_1] [файл_2] [файл_3] [etc...] [-u путь_куда_сохранять]"
    echo
    echo "   -d   Предложить выбор для всех файлов в указанной папке"
    echo "   -u   Куда сохранять файлы. Если не указано, сохраняет рядом с исходными"
    echo
}

exit_abnormal() { # функция экстренного выхода вследствии ошибки
    if [[ ! -z "$@" ]]; then echo -e "\n$@" >&2; notify-send -t 10000 -i "dialog-warning" "${0##*/}" "$@"; fi
    usage
    exit 1
}

out_message() {  # вывод сообщений
    if [[ ! -z "$@" ]]; then echo -e "$@"; fi
}

out_mas() {  # вывод массива
    for str_m in "$@"; do echo "\"$str_m\""; done
}

f_getopts () { # получение правильных опций и переключение флагов
    until [[ -z "$1" ]]; do
        if [[ "$1" != "-d" && "$1" != "-u" ]]; then
            mas_files[${#mas_files[@]}]="$1"  # запоминаем
        elif [[ "$1" = "-d" ]]; then
            shift
            if [[ -d "$1" && -r "$1" ]]; then
                main_dir="$1"
            else
                exit_abnormal "Ошибка: папка \"$1\" не существует или не доступна для чтения."
            fi
        else  # "$1" = "-u"
            shift
            if [[ -d "$1" && -w "$1" ]]; then
                out_dir="$1"
            else
                exit_abnormal "Ошибка: папка \"$1\" не существует или не доступна для записи."
            fi
        fi
        shift
    done
}

option_analysis() { # анализ опций на совместимость и корректность

    # эта же логика обрабатывается сразу при получении опций (в f_getopts)
        # если есть выход. директория и она не доступна для записи
        # if [[ ! -z "$out_dir" && ! -w "$out_dir" ]]; then
        #     exit_abnormal "Ошибка: папка \"$1\" не доступна для записи."
        # fi

    if [[ ! -z "$main_dir" && ${#mas_files[@]} -ne 0 ]]; then # "тупорылый" случай
        exit_abnormal "Ошибка: укажите или путь к папке, или конкретные файлы!"
    elif [[ -z "$main_dir" && ${#mas_files[@]} -eq 0 ]]; then  # "тупорылый" случай
        exit_abnormal "Ошибка: не указаны [входная папка] или [список файлов]! С чем работать?"
    # если указана только исходная директория (и по логике ${#mas_files[@]} -eq 0)
    elif [[ ! -z "$main_dir" ]]; then
        # если НЕ указ-а выходная директория, а входная не доступна для записи
        if [[ -z "$out_dir" && ! -w "$main_dir" ]]; then
            exit_abnormal "Ошибка: папка \"$main_dir\" не доступна для записи.\nИспользуйте совместно с опцией -u."
        fi
        # иначе мы точно знаем, что входная директория доступна для чтения; а также, что
        # ЛИБО она, ЛИБО выходная директория доступна для записи
    # значит указан список файлов (по логике -z "$main_dir" && ${#mas_files[@]} -ne 0)
    # и если выходная папка не указана, мы должны проверить доступ на запись для всех случаев
    elif [[ -z "$out_dir" ]]; then
        validation_dir_and_exist_files  # проверка сущ. файлов и прав на запись в их директорию
    fi
}

get_files() {  # ф-я получения списка файлов
    # если массив с наз-ями пуст, заполним его
    if [[ ${#mas_files[@]} -eq 0 ]]; then
        IFS=$'\n' # только переводы строк считаются разделителем
        mas_files=($(find "$main_dir" -maxdepth 1 -type f))  # | awk -F './' '{print $2}'))

        if [[ ${#mas_files[@]} -eq 0 ]]; then
            exit_abnormal "Ошибка: папка \"$main_dir\" пуста."
        fi
        # IFS=$old_IFS
    fi
}

validation_dir_and_exist_files() {  # проверка сущ. файлов и прав на запись в их директорию
    declare -a mas_files_temp
    declare -a dir_err
    declare -a exist_err


    for ((i=0; i<${#mas_files[@]}; i++)); do  # пробегаемся по получ. списку
        if [[ ! -f "${mas_files[$i]}" ]]; then  # если это не файл
            exist_err[${#exist_err[@]}]="${mas_files[$i]}"  # запоминаем
        elif [[ ! -w "${mas_files[$i]%/*}" ]]; then  # директория, где хранится файл доступна для записи?
            dir_err[${#dir_err[@]}]="${mas_files[$i]}"  # запоминаем
        else  # все хорошо
            mas_files_temp[${#mas_files_temp[@]}]="${mas_files[$i]}"  # запоминаем
        fi
    done

    if [[ ${#exist_err[@]} -ne 0 ]]; then  # выводим исключенные из списка файлы
        out_message "\nПеречисленные ниже файлы проигнорированы, т.к. не существуют или не доступны для чтения:"
        out_mas "${exist_err[@]}"; echo
    fi

    if [[ ${#dir_err[@]} -ne 0 ]]; then  # выводим исключенные из списка файлы
        out_message "\nПеречисленные ниже файлы проигнорированы, т.к. директория, в которой они хранятся, не доступна для записи:"
        out_mas "${dir_err[@]}"; echo
    fi

    if [[ ${#mas_files_temp[@]} -ne 0 ]]; then  # если получили хоть 1 файл
        mas_files=("${mas_files_temp[@]}")  # заносим изм-я в основной массив
    else
        exit_abnormal "Ошибка: все файлы не валлидны."
    fi
}

validation_ext_files() {  # фильтрация файлов по расширению
    # check manually => $ ffmpeg -formats | less
    valid_ext=("mp4" "m4v" "mkv" "avi" "3gp" "flv" "webm" \
               "mpeg"  "mov" "3g2" "mj2")

    declare -a mas_files_temp
    declare -a mas_files_errors  # массив для запоминания проигнорированных файлов

    for ((i=0; i<${#mas_files[@]}; i++)); do  # пробегаемся по получ. списку
            file_ext="${mas_files[$i]##*.}"  # получаем расширение
            file_ext="${file_ext,,}"  # переводим в нижний регистр
        for ((g=0; g<${#valid_ext[@]}; g++)); do  # пробег-ся по списку расширений
            if [[ "$file_ext" = "${valid_ext[$g]}" ]]; then  # файл подпадет под очеред. расширение?
                mas_files_temp[${#mas_files_temp[@]}]="${mas_files[$i]}"  # запоминаем
                break  # выходим
            elif [[ $[g+1] -eq ${#valid_ext[@]} ]]; then  # если это последний шаг цикла
                mas_files_errors[${#mas_files_errors[@]}]="${mas_files[$i]}"  # запоминаем "плохой" файл
            fi
        done
    done

    if [[ ${#mas_files_errors[@]} -ne 0 ]]; then  # выводим исключенные из списка файлы
        out_message "\nПеречисленные ниже файлы проигнорированы, т.к. не поддерживаются ffmpeg:"
        out_mas "${mas_files_errors[@]}"; echo
    fi

    if [[ ${#mas_files_temp[@]} -ne 0 ]]; then  # если получили хоть 1 файл
        mas_files=("${mas_files_temp[@]}")  # заносим изм-я в основной массив
    else
        exit_abnormal "Ошибка: все файлы не валлидны."
    fi
}

get_the_answer  () {  # вывод yad окна с выбором действий, получение ответа в массив
    yad_dialog="yad --title="\"$yad_title\"" --window-icon=gtk-refresh --width=250 --form --item-separator='|' --separator=',' "
    for (( i=0; i<${#mas_files[@]}; i++)); do
        yad_dialog="$yad_dialog""--field='${mas_files[$i]}:CB' '$opt_none|$opt_clock|$opt_uclock|$opt_two_clock' "
    done

    # вызываем окно с вопросом, что делать
    temp_f=$(bash -c "$(echo $yad_dialog)")  # получаем ответ в переменную

    if [[ -z "$temp_f" ]]; then  # если мы не получили ответ
        # out_message "Операция отменена!"  # этот вариант предпочтительнее
        exit_abnormal "Операция отменена!"  # необязательно, но пусть будет
    fi

    IFS=','  # --separator=","
    user_answer=($(echo "$temp_f"))  # разбиваем ответ на части, занося в массив
    IFS=$old_IFS
}

action_f_go() {  # здесь выполняется основное действие ffmpeg; $1 - исходный файл; $2 - режим повота
    full_path="$1"  # /home/user/videos/1.mp4
    if [[ ! -z "$out_dir" ]]; then  # директория, куда сохраняем файл
        dir_file="$out_dir"  # /home/user/123
    else
        dir_file="${full_path%/*}"  # /home/user/videos
    fi

    file_name="${full_path##*/}"  # 1.mp4
    file_only_name="${file_name%.*}"  # 1
    file_only_ext="${file_name##*.}"  # mp4
    new_file_name="$dir_file/$file_only_name" # /home/user/videos/1
    while [[ 1 -ne 0 ]]; do  # бесконечный цикл
        # если в целевой директории уже сущ-т файл /home/user/videos/1.mp4
        if [[ -f "$new_file_name.$file_only_ext" ]]; then
            new_file_name="$new_file_name""$file_postfix"  # добавим еще один постфикс
        else  # файла не существует
            new_file_name="$new_file_name"".$file_only_ext"  # добавляем расширение; получаем имя нового ф.
            break  # стопаем цикл
        fi
    done

    sleep 3  # вероятно, не для всех очевидный костыль ;)
    case "$2" in
        "1") ffmpeg -i "$full_path" -vf "transpose=1" "$new_file_name";;  # по часовой на 90
        "2") ffmpeg -i "$full_path" -vf "transpose=2" "$new_file_name";;  # против часовой на 90
        "3") ffmpeg -i "$full_path" -vf "transpose=2,transpose=2" "$new_file_name";; # на 180
        *) out_message "критическая action_f_go = $2";;
    esac

    # Актуально только для кнопки "Отменить для этого файла"
    if [[ $? -ne 0 ]]; then  # если ffmpeg завершился со статусом, отличным от 0
        # mv "$new_file_name" "$new_file_name"'.[bad]'  # добавим .[bad] в окончание наз-я файла
        # notify-send -t 10000 -i "gtk-cancel" "Внимание" "Файл \"${new_file_name##*/}\" переименован в \"${new_file_name##*/}.[bad]\""
        rm "$new_file_name" && notify-send -t 10000 -i \
        "gtk-cancel" "Внимание" "Файл \"${new_file_name##*/}\" удален, поскольку ffmpeg завершился неудачей!"
    fi
}

action_f() {  # здесь происходит обработка ответа + обработка yad-прогресса с вызовом ф-и action_f_go

    # ----------------------- УДАЛЯЕМ ИЗ МАССИВОВ ПРОПУЩЕННЫЕ ФАЙЛЫ -----------------------
    declare -a mas_files_temp  # массив для норм путей
    declare -a user_answer_temp  # массив для норм ответов
    declare -a files_skip  # массив пропущенных файлов
    for (( i=0; i<${#user_answer[@]}; i++)); do  # для всех ответов
        if [[ "${user_answer[$i]}" = "$opt_none" ]]; then  # если ответ - пропуск
            files_skip[${#files_skip[@]}]="${mas_files[$i]}"  # запоминаем
        else
            mas_files_temp[${#mas_files_temp[@]}]="${mas_files[$i]}"  # запоминаем
            user_answer_temp[${#user_answer_temp[@]}]="${user_answer[$i]}"  # запоминаем
        fi
    done

    if [[ ${#dir_err[@]} -ne 0 ]]; then  # выводим исключенные из списка файлы
        out_message "\nПеречисленные ниже файлы проигнорированы пользователем:"
        out_mas "${files_skip[@]}"; echo
    fi

    if [[ ${#mas_files_temp[@]} -ne 0 ]]; then  # если получили хоть 1 файл
        mas_files=("${mas_files_temp[@]}")  # заносим изм-я в основной массив
        user_answer=("${user_answer_temp[@]}")  # заносим изм-я в массив ответов
    else
        exit_abnormal "Все файлы были проигнорированы пользователем."
    fi
    # -------------------------------------------------------------------------------------

    # ----------------- РЕАЛИЗАЦИЯ прогресса и вызов функции для поворота -----------------
    count_f=${#mas_files[@]}  # кол-во тактов = кол-во всех файлов
    procent=$[100/count_f]  # сколько процентов составляет 1 такт
    counter=0  # текущий такт
    progress=0  # смещение на линии (заполненность линии)

    (for (( i=0; i<${#user_answer[@]}; i++)); do
        echo $progress
        echo "# Обработка ${mas_files[$i]}\nОбработано $counter из $count_f..."

        case "${user_answer[$i]}" in
            "$opt_clock") action_f_go "${mas_files[$i]}" "1";;  # повернуть на 90 по
            "$opt_uclock") action_f_go "${mas_files[$i]}" "2";;  # повернуть на 90 против
            "$opt_two_clock") action_f_go "${mas_files[$i]}" "3";;  # повернуть на 180
            *) echo "критическая ошибка! выход!"; exit;;
        esac
        counter=$[counter + 1]  # такт + 1
        progress=$[progress + procent]  # смещение для 1 такта

    done)|yad --title="\"$yad_title\"" --window-icon=gtk-refresh --width=400 --center --auto-close --progress --progress-text='Работаю...' --button='Отменить для этого файла!gtk-close!Данная команда убьет все открытые процессы ffmpeg у текущего пользователя:'"killall --user $USER --ignore-case --signal SIGTERM  ffmpeg" --button='Отменить следующие!media-skip-forward!Данная команда убьет скрипт, но текущий открытый ffmpeg в теории должен проигнорировать обрыв терминальной линии (на свой страх и риск крч):'"killall "${0##*/}""
    notify-send -t 10000 -i "gtk-ok" "${0##*/}" "Работа скрипта завершена!"
}

main_f () {  # главная функция, инициализирует, все и вся
    #---------------------------ПЕРВАЯ ПАЧКА ПЕРЕМЕННЫХ ПО-УМОЛЧАНИЮ---------------------
    main_dir=""  # директория, где работаем (опция -d)
    out_dir=""  # директория, куда сохраняем
    declare -a mas_files  # массив с наз-ями видео-файлов
    #------------------------------------------------------------------------------------
    f_getopts "$@" # получаем опции
    option_analysis # проверяем корректность ввода опций

    #---------------------------ВТОРАЯ ПАЧКА ПЕРЕМЕННЫХ ПО-УМОЛЧАНИЮ---------------------
    old_IFS=$IFS # запоминаем старый разделитель полей (корректная запись, кавычки не нужны)
    file_postfix="_new"  # постфикс для результирующего файла, если в исходной папке уже сущ-т файл с таким же названием

        # ------ Yad options -------
        yad_title="Повернуть видео-файлы"

        # здесь не должны использоваться запятые
        opt_none="пропустить файл"
        opt_clock="повернуть на 90° по ЧС"
        opt_uclock="повернуть на 90° против ЧС"
        opt_two_clock="повернуть на 180°"
        # --------------------------
    #------------------------------------------------------------------------------------

    get_files  # получаем список файлов (если нужно)
    validation_ext_files  # отсекаем мусор, что не подходит под расширение
    get_the_answer  # спрашиваем пользователя, что делать
    action_f  # выполняем действие
}

main_f "$@"

