#!/bin/bash

# Скрипт для интеграции файлов репозитория в систему, а также для обратной операции (удаления)
# Главная цель создания - тренировка в написании sh скриптов (хотя на данный момент это выглядет далеко от идеала),
# второстепенная - снизить до минимума необходимость править соответствующие инструкции в файле README.md, а также
# повысить удобство интеграции/удаления для заинтересованного пользователя.
#
# Подробности видны чуть ниже в функции usage
#
# Среди недоставков хочется отметить, что интеграция, как и удаление, происходит на уровне файлов локального
# репозитория, но не учитывает установленные/неустановленные в системе ЗАВИСИМОСТИ. Кроме того, нельзя выбрать
# точечно, какие КМ должны быть установлены, а какие - нет: все свалино в 1 кучу: либо мы все интегрируем, либо
# мы все удаляем. Иными словами, скрипт малофункционален, односторонен.

# удаление из системы удаленного из репозитория после обнов


#--------------------------------------ФУНКЦИИ---------------------------------------------
usage() { # подсказка
    echo -e "\n\033[0;1mСкрипт для интеграции файлов репозитория в систему, а также для обратной операции (удаления)\033[0m\n"
    echo "Использование: $0 [ -g путь_до_репозитория ] [ -p ] [ -u ] [ -l ]"
    echo
    echo "   -g    Указать путь до репозитория. Если не указан, используется путь по умолчанию:"
    echo "         $way_rep"
    echo
    echo "   -p    Удаление. Без разрешения функция ничего не удаляет! Сначала смотрит, какие файлы находиться"
    echo "         в локальном git репозитории и проверяет их наличие в системе. Если файл с аналогичным"
    echo "         ИМЕНЕМ есть в системе, то добавляет его в список. По окончанию работы выводит список вида:"
    echo "         rm [полный путь до файла из системы]"
    echo "         и спрашивает, нужно ли удалить эти файлы. По умолчанию ответ - нет."
    echo
    echo "   -u    Обновление уже интегрированных в систему файлов. Функция отображает команды для обновления"
    echo "         локального репозитория и просит пользователя ввести их самому. Самой последней из них"
                    # Это требуется, чтобы избежать вероятных ошибок во время выполнения, если данный
                    # скрипт будет заменен новой версией (bash не загружает полностью в память, а считывает
                    # содержимое скрипта "по мере надобности").
                    # более пользователи опытные, что умышлено вносили в него свои изменения, имеют возможность
                    # самостоятельно выполнить обновление со слиянием (вероятно им придется, да и жеский ресет
                    # может быть нежелателен).
    echo "         будет предложена команда для повторного запуска скрипта. При повторном запуске скрипт"
    echo "         спросит, был ли обновен локальный репозиторий: \"Вы выполнили указанные команды?\""
    echo "         В случаи положительного ответа - запустится механизм анализа изменений, измененные файлы"
    echo "         попадут в список, который появится наряду с вопросом: \"Действительно ли вы хотите обновить"
    echo "         файлы?\" Если \"Да\", то обновления из репозитория перекочуют в систему."
    echo
    echo "         ДЛЯ НЕВНИМАТЕЛЬНЫХ: Эта функция НЕ добавляет в систему новые КМ! Она лишь обновляет уже"
    echo "         имеющиеся в системе. Её лучше использовать совместно с опцией -l, поскольку иначе, если"
    echo "         у обновленного файла появились новые зависимости, они не будут добавлены автоматически!"
    echo "         Для \"полномоштабного\" обновления используйте с опцией -l:"
    echo "         $0 -u -l"
    echo
    echo "   -l    Создание жестких ссылок. Функция анализирует, каких файлов из git репозитория не хватает"
    echo "         в системе, выводит список вида:"
    echo "         ln [путь до файла из репы] [путь до папки, в которую нужно его добавить]"
    echo "         и спрашивает, нужно ли их интергировать. По умолчанию ответ - да."
    echo
}
exit_abnormal() { # функция экстренного выхода вследствии ошибки
  usage
  exit 1
}

user_dialog () { # типичная функция диалога с пользователем
    user_answer="321"
    while [[  "$user_answer" != "" && "$user_answer" != "y" && "$user_answer" != "yes" && "$user_answer" != "да" && "$user_answer" != "д" \
    && "$user_answer" != "" && "$user_answer" != "n" && "$user_answer" != "no" && "$user_answer" != "нет" && "$user_answer" != "н" ]]; do
        read -p "$2" user_answer # отображает вопрос, записывает ответ
        user_answer="${user_answer,,}" # переводим все символы в нижний регистр

        if [[ "$user_answer" = "y" || "$user_answer" = "yes" || "$user_answer" = "да" || "$user_answer" = "д" ]]; then
            return 0
        elif [[ "$user_answer" = "n" || "$user_answer" = "no" || "$user_answer" = "нет" || "$user_answer" = "н" ]]; then
            return 1
        elif [[ "$user_answer" = "" ]]; then # если пустой ввод, смотрим, что именно передали в качестве ответа по-умолчанию (yes или no)
            if [[ "$1" -eq 0 ]]; then return 0; else return 1; fi
        else
            echo "Некорректный ввод! Повторите попытку!"; echo
        fi
    done
}

f_getopts () { # получение правильных опций и переключение флагов
    while getopts ":g:plu" options; do
        case "${options}" in
            g)
                if [[ -d "${OPTARG}" ]]; then
                    way_rep="${OPTARG}"
                    # если путь не заканчивается на слэш, добавить его
                    if [[ "$(echo "$way_rep" | cut -c ${#way_rep})" != "/" ]]; then way_rep+="/"; fi
                else
                    echo "Ошибка: директории \"${OPTARG}\" не существует."
                    exit_abnormal
                fi
                ;;
            :)
                echo "Ошибка: -${OPTARG} требует аргумента."
                exit_abnormal
                ;;
            p) opts_delete="yes";;
            l) opts_ln="yes";;
            u) opts_update="yes";;
            *)
                if [[ "${OPTARG}" != "h" ]]; then
                    echo "Ошибка: неверный ключ «-${OPTARG}»."
                fi
                exit_abnormal
                ;;
        esac
    done
}
assistant_with_options() { # что делать, если скрипт запущен без парамметров
    echo
    echo "Чего ты хочешь, смертный?"
    echo "1 - установите в систему все (или добавьте, что отсутствует), старые файлы не заменять!"
    echo "2 - обновите локальный репозиторий и замените измененные файлы в системе"
    echo "3 - \"полномоштабное\" обновление - сочетание 1 и 2-го пунктов (рекомендуется)"
    echo "4 - удалите все, что установили в системе"
    echo "5 - покажите help"
    echo "q - выход"
    while [[ "$opts_delete" = "no" && "$opts_ln" = "no" && "$opts_update" = "no" ]]; do
        read -p "Ввод: " user_answer # отображает вопрос, записывает ответ
        case "$user_answer" in
            1) opts_ln="yes";;
            2) opts_update="yes";;
            3) opts_ln="yes"; opts_update="yes";;
            4) opts_delete="yes";;
            5) usage; exit 0;;
            q|Q|Й|й) exit 0;;
        esac
    done
}
option_analysis() { # анализ опций на совместимость и корректность
    if [[ "$opts_delete" = "no" && "$opts_ln" = "no" && "$opts_update" = "no" ]]; then
        echo "Ошибка: не указана ни одна смысловая опция!"
        assistant_with_options
    elif [[ "$opts_delete" = "yes" && "$opts_update" = "yes" ]]; then # p+u
        echo "Ошибка! Что вы хотели этим добиться?"
        echo -e "\tОбновление затрагивает только существующие файлы! Если вы их удалите, то нет смысла что-либо обновлять!"
        echo -e "\tОбратная ситуация также бессмыслена: зачем что-то обновлять, а затем удалять?!"
        exit_abnormal
    elif [[ "$opts_delete" = "yes" && "$opts_ln" = "yes" ]]; then # p+l
        echo "Ошибка! Что вы хотели этим добиться?"
        echo -e "\tЗачем удалять все, а затем заново создавать? Если вы хотите обновить файлы в системе, запустите:\n\t$0 -u -l"
        echo -e "\tОбратная ситуация: нет смысла что-либо создавать, а после - тут же удалять."
        exit_abnormal
    fi
}

dumping_base_arrays() {  # сброс значений для массивов f_in_repo и f_in_system
    f_in_repo=()
    f_in_system=()
    repo_sys_i=0

    # создает доп слой связи между различными директориями и их путями
    f_in_contact=("0")
    contact_i=1
}
filling_in_base_arrays() { # заполнение массивов f_in_repo и f_in_system
    for ((i=0; i<${#git_dirs[@]}; i++)); do
        list_of_all_paths[$i]=$(find -H "${git_dirs[$i]}/" -type f)
        wc_result="$(echo "${list_of_all_paths[$i]}" | wc -l)"
        if [[ $wc_result -gt 0 ]]; then
            f_in_contact[$contact_i]=$[wc_result+${f_in_contact[$contact_i-1]}]
            contact_i=$[contact_i+1]
            for ((y=1; y<=wc_result; y++)); do
                current_path=$(echo "${list_of_all_paths[$i]}" | sed -n "$y""p")
                f_in_repo[$repo_sys_i]="$way_rep$current_path"
                f_in_system[$repo_sys_i]="${systems_dirs[$i]}$current_path"
                repo_sys_i=$[repo_sys_i+1]
            done
        fi
    done
    r_s_count=${#f_in_repo[@]} # число элементов в массиве f_in_repo/f_in_system
}
initialization_in_general_arrays() { # инициализация базовых и второстепенных массивов
    dumping_base_arrays  # создание массивов f_in_repo и f_in_system
    filling_in_base_arrays # заполнение массивов f_in_repo и f_in_system
}

# для "$opts_delete" = "yes"
create_array_delete() {
    paths_for_del=()
    del_i=0
    for ((i=0; i<$r_s_count; i++)); do
        if [[ -f "${f_in_system[$i]}" ]]; then
            paths_for_del[$del_i]="${f_in_system[$i]}"
            del_i=$[del_i+1]
        fi
    done
}
output_results_delete_all() {
    if [[ ${#paths_for_del[@]} -ne 0 ]]; then # точно будет нулевым, когда [opts_delete="no"]
        echo -e "\n${COLOR_REB}Обнаружены интегрированные в систему файлы. Будут использованы следующие команды удаления:${NORMAL}"
        for ((i=0; i<${#paths_for_del[@]}; i++)); do
            echo "rm \"${paths_for_del[$i]}\""
        done
        confirmation_of_delete # запрос на удаление + удаление, если нужно

    elif [[ "$opts_delete" = "yes" ]]; then # если 0, но мы хотели их удалить
        echo -e "\nФайлы для удаления не найдены.\n"
    fi
}
confirmation_of_delete() {
    if user_dialog "1" "Вы действительно хотите удалить интегрированные файлы ? (y/N): "; then
        for ((i=0; i<${#paths_for_del[@]}; i++)); do
            rm "${paths_for_del[$i]}"
        done
        echo -e "Ответ - ДА. Очистка завершена.\n"
    else
        echo -e "Ответ - НЕТ. Операция отменена.\n"
    fi
}

# для $opts_update" = "yes"
update_local_repo(){ # обновление локального репозитория
    tmp_file="/tmp/oHY96dqbd7MrscMk3h5R5edGX9KCPA"
    if [[ ! -a "$tmp_file" ]]; then
        touch "$tmp_file"
        echo "Пингую гитхаб..."
        if [[ ! $(ping -c 5 github.com) ]]; then # нет соединения
            echo "Ошибка! Обновление невозможно, т.к. нет соединения с интернетом!";
            rm "$tmp_file"
            exit 1
        else
            # т.к. bash часто вызывает ошибки, если скрипт изменяется
            # по ходу выполнения своих команд (а после обновления репозитория
            # он может быть заменен новой версией), здесь вынужденно приходится
            # просить пользователя самому выполнить обновления, а затем заново
            # запустить скрипт
            echo "Успешно!"
            echo
            echo "ВНИМАНИЕ! Для обновления репозитория введите вручную следующие команды:"
            echo "cd \"$way_rep\""
            echo "git reset --hard master && sleep 2"
            echo "git pull origin && sleep 2"

            mes_tmp="$0 -u"
            if [[ "$opts_ln" = "yes" ]]; then mes_tmp+=" -l"; fi
            if [[ "$way_rep" != "$HOME/.local/share/nemo_context_menu/" ]]; then
                mes_tmp+=" -g \"$way_rep\""
            fi
            echo "$mes_tmp"
            exit 0
        fi
    else
        if [[ "$(cat "$tmp_file")" = "" ]]; then rm "$tmp_file"; else echo "\"$tmp_file\" не пуст, что странно :)"; exit 1; fi
        if user_dialog "0" "Вы выполнили указанные команды? (Y/n): "; then
            create_array_update
            output_results_update
        else
            update_local_repo
        fi
    fi
    # мне было лень создавать отдельную опцию под это дело, поэтому я создаю файл
    # $tmp_file, дабы отследить, выполнялся этот цикл раньше или нет
}

create_array_update() {
    paths_for_update=()
    update_i=0
    for ((i=0; i<$r_s_count; i++)); do
        if [[ -f "${f_in_system[$i]}" ]]; then # если файл есть в системе
            md5sum_1="$(md5sum "${f_in_repo[$i]}" | awk '{print $1}')"
            md5sum_2="$(md5sum "${f_in_system[$i]}" | awk '{print $1}')"
            if [[ "$md5sum_1" != "$md5sum_2" ]]; then
                paths_for_update[$update_i]="${f_in_repo[$i]}" # нечетные - пути репа
                paths_for_update[$update_i+1]="${f_in_system[$i]}" # четные - системные
                update_i=$[update_i+2]
            fi
        fi
    done
}
output_results_update() {
    if [[ ${#paths_for_update[@]} -ne 0 ]]; then # точно будет нулевым, когда opts_delete="no"
        echo -e "\n${COLOR_REB}Будут обновлены следующие файлы:${NORMAL}"
        for ((i=0; i<${#paths_for_update[@]}; i=$[i+2])); do
            echo -e "\"${paths_for_update[$i]}\" -----> \"${paths_for_update[$i+1]}\""
        done
        confirmation_of_update
    fi
}
confirmation_of_update() {
    if user_dialog "0" "Вы действительно обновить файлы ? (Y/n): "; then
        for ((i=0; i<${#paths_for_update[@]}; i=$[i+2])); do
            rm "${paths_for_update[$i+1]}"
            ln "${paths_for_update[$i]}" "${paths_for_update[$i+1]%/*}"
        done
        echo -e "Ответ - ДА. Обновление завершено.\n"
    else # иначе - нет
        echo -e "Ответ - НЕТ. Операция отменена.\n"
    fi
}

# для "$opts_ln" = "yes"
create_array_ln() {
    paths_of_ln=()
    ln_i=0
    for ((i=0; i<$r_s_count; i++)); do
        if [[ ! -f "${f_in_system[$i]}" ]]; then # если файл есть в системе
            paths_of_ln[$ln_i]="${f_in_repo[$i]}"
            paths_of_ln[$ln_i+1]="${f_in_system[$i]%/*}/"
            ln_i=$[ln_i+2]
        fi
    done
}
output_results_ln() {
    if [[ ${#paths_of_ln[@]} -eq 0 ]]; then # точно будет нулевым, когда "$opts_ln" = "no"
        if [[ "$opts_ln" = "yes" ]]; then
            echo -e "\nФайлы для интеграции не найдены. Скорее всего, они уже есть в системе.\n"
        fi
    else
        echo -e "\n${COLOR_BLUE}Обнаружены файлы, которые есть в локальном репозитории, но не интергированы в систему!${NORMAL}\n${COLOR_BLUE}Будут использованы следующие команды интеграции:${NORMAL}"
        output_results_mkdir # вывод mkdir -p ....
        for ((i=0; i<${#paths_of_ln[@]}; i=$[i+2])); do
            echo "ln \"${paths_of_ln[$i]}\" \"${paths_of_ln[$i+1]}\""
        done
        confirmation_of_mkdir_ln # подтвержение операции
    fi
}
output_results_mkdir() { # выводит mkdir -p <че-то_там>, если необходимо
    list_of_mkdir=""
    # Забиваем в переменную list_of_mkdir все возможные пути директорий
    for ((i=0; i<${#git_dirs[@]}; i++)); do
        list_of_mkdir+=$(find -H "${git_dirs[$i]}/" -type d) # добавляем к list_of_mkdir очередную пачку путей
        list_of_mkdir+="\n"
    done
    #------

    # Забили эти пути в массив paths_for_mkdir
    wc_result="$[$(echo -e "$list_of_mkdir" | wc -l)-1]"
    paths_for_mkdir=()
    for ((y=1; y<=wc_result; y++)); do
        paths_for_mkdir[$y-1]=$(echo -e "$list_of_mkdir" | sed -n "$y""p")
        if [[ "$(echo "${paths_for_mkdir[$y-1]}" | cut -c ${#paths_for_mkdir[$y-1]})" != "/" ]]; then
            paths_for_mkdir[$y-1]="${paths_for_mkdir[$y-1]}/" # все пути обязаны заканчивается слэшем!
        fi
    done #-----

    # Вырезаем совпадающие пути (работа со строками, в систему не заглядываем)
    for ((i=0; i<$[wc_result-1]; i++)); do # или по логике - $[${#paths_for_mkdir[@]}-1], но так не хочет работать
        while [[ ${#paths_for_mkdir[$i]} -eq 0 && $i -lt $[wc_result-1] ]]; do
            i=$[i+1]
        done
        if [[ $i -eq $[wc_result-1] ]]; then break; fi
        characters_i=${#paths_for_mkdir[$i]}
        for ((y=$[i+1]; y<$wc_result; y++)); do
            characters_y=${#paths_for_mkdir[$y]}
            if [[ $characters_y -gt 0 ]]; then
                if [[ $characters_i -gt $characters_y ]]; then
                    if [[ "$(echo "${paths_for_mkdir[$i]}" | cut -c 1-$characters_y)" =  "${paths_for_mkdir[$y]}" ]]; then
                        unset paths_for_mkdir[$y]
                    fi
                elif [[ $characters_i -lt $characters_y ]]; then
                    if [[ "${paths_for_mkdir[$i]}" =  "$(echo "${paths_for_mkdir[$y]}" | cut -c 1-$characters_i)" ]]; then
                        unset paths_for_mkdir[$i]
                        break
                    fi
                else
                    if [[ "${paths_for_mkdir[$i]}" = "${paths_for_mkdir[$y]}" ]]; then
                        unset paths_for_mkdir[$y]
                    fi
                fi
            fi
        done
    done #-----

    paths_for_mkdir_real=()
    mkdir_real_i=0
    for i in "${paths_for_mkdir[@]}"; do
        for ((y=0; y<${#git_dirs[@]}; y++)); do
            characters_i=${#git_dirs[$y]}
            characters_y=${#i}
            if [[ $characters_i -lt $characters_y ]]; then
                if [[ "${git_dirs[$y]}" =  "$(echo "$i" | cut -c 1-$characters_i)" ]]; then
                    if [[ ! -a "${systems_dirs[$y]}$i" ]]; then
                        paths_for_mkdir_real[$mkdir_real_i]="${systems_dirs[$y]}$i"
                        echo "mkdir -p \"${paths_for_mkdir_real[$mkdir_real_i]}\""
                        mkdir_real_i=$[mkdir_real_i+1]
                    fi
                    break
                fi
            elif [[ "${git_dirs[$y]}" = "$i" ]]; then
                if [[ ! -a "${systems_dirs[$y]}$i" ]]; then
                    paths_for_mkdir_real[$mkdir_real_i]="${systems_dirs[$y]}$i"
                    echo "mkdir -p \"${paths_for_mkdir_real[$mkdir_real_i]}\""
                    mkdir_real_i=$[mkdir_real_i+1]
                fi
                break
            fi
        done
    done
}
confirmation_of_mkdir_ln() {
    if [[ "${#paths_for_mkdir_real[@]}" -ne 0 ]]; then
        message_ln_dir="Вы действительно хотите интегрировать необходимые жесткие ссылки и папки? (Y/n): "
    else
        message_ln_dir="Вы действительно хотите интегрировать необходимые жесткие ссылки? (Y/n): "
    fi

    if user_dialog "0" "$message_ln_dir"; then
        for ((i=0; i<${#paths_for_mkdir_real[@]}; i++)); do
            mkdir -p "${paths_for_mkdir_real[$i]}"
        done
        for ((i=0; i<${#paths_of_ln[@]}; i=$[i+2])); do
            ln "${paths_of_ln[$i]}" "${paths_of_ln[$i+1]}"
        done
        echo -e "Ответ - ДА. Действия выполнены.\n"
    else
        echo -e "Ответ - НЕТ. Операция отменена.\n"
    fi
}

# mha() { # mission: heart attack
#     # можно было бы вставить во все "НЕТ. Операция отменена"
#     # но, пожалуй, перебор
#     if [[ "$opts_delete" = "no" && "$opts_ln" = "no" && "$opts_update" = "no" ]]; then
#         main_f; exit $? # здесь главная цель - вызов функции assistant_with_options...
#     fi
# }
# #-----------------------------------ФУНКЦИИ-END-------------------------------------------

main_f() { # главная функция, инициализирует, все и вся
    #---------------------------ПЕРВАЯ ПАЧКА ПЕРЕМЕННЫХ ПО-УМОЛЧАНИЮ---------------------
    way_rep="$HOME/.local/share/nemo_context_menu/" # где наш реп, должен оканчиваться на слэш
    opts_delete="no" # переменная, отвечающая за опцию -p
    opts_ln="no" # переменная, отвечающая за опцию -l
    opts_update="no" # переменная, отвечающая за опцию -u
    #------------------------------------------------------------------------------------
    f_getopts "$@" # получаем опции
    option_analysis # проверяем корректность ввода опций

    #---------------------------ВТОРАЯ ПАЧКА ПЕРЕМЕННЫХ ПО-УМОЛЧАНИЮ---------------------
    git_dirs=("actions" "icons") # не должно оканчиваться на слэш
    systems_dirs=("$HOME/.local/share/nemo/" "$HOME/.local/share/") # должны оканчиваться на слэш

    NORMAL='\033[0m' # ${NORMAL} - нормальный цвет шрифта
    COLOR_REB='\033[31;47m' # ${COLOR_REB} - красный
    COLOR_BLUE='\033[35;47m' #${COLOR_BLUE} - голубой
    #------------------------------------------------------------------------------------

    cd "$way_rep" # переходим в реп
    initialization_in_general_arrays # инициализация главных массивов

    if [[ "$opts_delete" = "yes" ]]; then create_array_delete; output_results_delete_all
    else
        if [[ "$opts_update" = "yes"  ]]; then update_local_repo; fi
        if [[ "$opts_ln" = "yes" ]]; then create_array_ln; output_results_ln; fi
    fi
}

main_f "$@"
