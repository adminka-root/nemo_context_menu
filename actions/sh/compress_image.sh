#!/bin/bash
# sudo apt install jpegoptim optipng advancecomp mat zenity libnotify-bin
# last update: 16.05.21

# ------------------ ПЕРЕМЕННЫЕ ДЛЯ УВЕДОМЛЕНИЙ --------------------
notify_title="Оптимизация изображений"
notify_err_ico="gtk-cancel"
notify_success_ico="gtk-ok"
# -----------------------------------------------------------------

# --------------------- ПРОВЕРКА ЗАВИСИМОСТЕЙ ---------------------
get_error=""  # переменная для сбора ошибок
if [[ ! -x "/usr/bin/optipng" ]]; then get_error="optipng "; fi
if [[ ! -x "/usr/bin/advdef" ]]; then get_error="$get_error""advancecomp "; fi
if [[ ! -x "/usr/bin/jpegoptim" ]]; then get_error="$get_error""jpegoptim "; fi
if [[ ! -x "/usr/bin/notify-send" ]]; then get_error="$get_error""libnotify-bin "; fi

# особая обработка для mat
if [[ ! -x "/usr/bin/mat" ]]; then
    if [[ ! -x "/usr/bin/mat2" ]]; then  # с 20-й версией LM поставляется исполняемый файл наз-ся mat2 
        get_error="$get_error""mat "
    else
        mat () { mat2 --inplace "$@"; }  # инициализировали новую функцию для mat2
    fi
fi

# особая обработка для zenity
if [[ ! -x "/usr/bin/zenity" ]]; then
    get_error="$get_error""zenity "
    if [[ ! -x "/usr/bin/notify-send" ]]; then
        echo -e "Ошибка: отсутствуют необходимые зависимости:\n$get_error" >&2
    else
        notify-send -t 10000 -i "$notify_err_ico" "$notify_title" \
        "<b>Ошибка: отсутствуют необходимые зависимости:</b>\n$get_error"
    fi
    exit 1
elif [[ ! -z "$get_error" ]]; then
    zenity --error --width=500 --title="$notify_title" --text="<b>Ошибка: отсутствуют необходимые зависимости:</b>\n$get_error"
    exit 1
fi
# -----------------------------------------------------------------

# ---------- ПРОВЕРКА КОРРЕКТНОСТИ ПОЛУЧЕННЫХ ПАРАМЕТРОВ ----------
declare -a good_img_png
declare -a good_img_jpg
declare -a bad_img

for image in "${@}"; do  # для всех полученных аргументов (путей)
    if [[ ! -f "${image}" || ! -w "${image}" ]]; then  # это НЕ файл или его НЕЛЬЗЯ перезаписать?
        bad_img[${#bad_img[@]}]="${image##*/}"  # заносим в массив
        continue  # продолжаем цикл
    fi

    get_ext="${image##*.}"  # получаем расширение в переменную
    if [[ "${get_ext,,}" = "png" ]]; then  # файл имеет расширение png?
        good_img_png[${#good_img_png[@]}]="${image}"  # заносим в массив
    elif [[ "${get_ext,,}" = "jpg" || "${get_ext,,}" = "jpeg" || "${get_ext,,}" = "jpe" ]]; then
        good_img_jpg[${#good_img_jpg[@]}]="${image}"  # заносим в массив
    else  # файл не имеет указанных расширений?
        bad_img[${#bad_img[@]}]="${image##*/}"  # заносим в массив
    fi
done

count_f=$[${#good_img_jpg[@]} + ${#good_img_png[@]}]  # общее кол-во jpg и png файлов
if [[ $count_f -gt 0 ]]; then  # если есть корректные файлы для оптимизации
    # формируем сообщение об ошибке для некорректных файлов
    if [[ ${#bad_img[@]} -gt 0 ]]; then
        for b_img in "${bad_img[@]}"; do
            bad_message="$bad_message\n""$b_img"
        done
        notify-send -t 10000 -i "$notify_err_ico" "$notify_title" "<b>Внимание: указанные ниже файлы были пропущены</b>$bad_message"
    fi
else  # выходим
    notify-send -t 10000 -i "$notify_err_ico" "$notify_title" "<b>Ошибка: </b>нет корректных файлов для оптимизации!"
    exit 1
fi
# -----------------------------------------------------------------

# ------------------ ОПТИМИЗАЦИЯ И ПРОГРЕСС-БАР -------------------
progress_data_echo() {  # ф-я, выводящая информацию в прогресс-бар
    name="$(echo ${1##*/})"
    echo $progress
    echo "# Оптимизирую --> $name\nОбработано $counter из $count_f..."
}

# изм-е значений для очередного шага
progress_data_next() { counter=$[counter + 1]; progress=$[progress + procent]; }

# перенаправляем поток в zenity --progress
(procent=$[100/count_f]  # сколько % составляет 1 шаг
counter=0  # текущий шаг = 0
progress=0  # текущий прогресс = 0%
name=""  # имя обрабатываемого файла

for image in "${good_img_png[@]}"; do  # оптимизируем png-файлы
    progress_data_echo "$image"
    optipng -o6 "${image}"
    advdef -z3 "${image}"
    mat "${image}"
    progress_data_next
done

for image in "${good_img_jpg[@]}"; do  # оптимизируем jpg-файлы
    progress_data_echo "$image"
    jpegoptim "${image}"
    mat "${image}"
    progress_data_next
done)|zenity --window-icon="$HOME/.local/share/icons/compress-image.svg" --progress --title="$notify_title" --auto-close --auto-kill --no-cancel --width=350
# -----------------------------------------------------------------

