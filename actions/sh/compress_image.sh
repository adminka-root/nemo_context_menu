#!/bin/bash
#sudo apt install jpegoptim optipng advancecomp mat

set -e
set -u

if [[ ! -x /usr/bin/optipng ]]; then
    echo "Пожалуйста, установите пакет \"optipng\"." >&2
    exit 1
fi

if [[ ! -x /usr/bin/advdef ]]; then
    echo "Пожалуйста, установите пакет \"advancecomp\" package." >&2
    exit 1
fi

if [[ ! -x /usr/bin/mat ]]; then
    echo "Пожалуйста, установите пакет \"mat\" package." >&2
    exit 1
fi

if [[ ! -x /usr/bin/jpegoptim ]]; then
    echo "Пожалуйста, установите пакет \"jpegoptim\" package." >&2
    exit 1
fi


bad_i=""
for image in "${@}" ; do
    if [[ ! -f "${image}" || ! -w "${image}" ]]; then bad_i="$bad_i\n${image##*/}"; continue; fi
    t_m="${image##*.}"
    if [[ "${t_m,,}" = "png" ]]; then
        optipng -o6 "${image}"
        advdef -z3 "${image}"
        mat "${image}"
    elif [[ "${t_m,,}" = "jpg" || "${t_m,,}" = "jpeg" || "${t_m,,}" = "jpe" ]]; then
        jpegoptim "${image}"
        mat "${image}"
    else
        bad_i="$bad_i\n${image##*/}"
    fi
done

if [[ "$bad_i" != "" ]]; then
    bad_i="\nПропущены следущие проблемные файлы:$bad_i\n"
    echo -e "$bad_i"
    
fi

if [[ -x /usr/bin/notify-send ]]; then
    notify-send -t 10000 -i "gtk-ok" "Завершено" "<b>Оптимизация изображений завершена!</b>$bad_i"
elif [[ -x /usr/bin/zenity ]]; then
    zenity --info --width=500 --title="Завершено" --text="<b>Оптимизация изображений завершена!</b>$bad_i"
fi

