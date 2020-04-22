#!/bin/bash

#Получаем имя файла без расширения; имя файла с расширением -> имя файла без расширения
namenoext="${1%%.*}" && namenoext="${namenoext##*/}"
#Получаем расширение
ext="${1##*.}"

AAA=`yad --borders=10 --window-icon=extension --width=350 --title="Объединить изображения" --text="Введите параметры" --form --item-separator="|" --separator="," --field=":LBL" --field="Направление:CB" --field="Отступ" --field="Имя файла" "" "^вертикально|горизонтально" "0" " $namenoext"_montage."$ext"`

if [[ -z "$AAA" ]]; then 
    #yad --image="dialog-warning" --text="Операция отменена!" --title="Отмена" --button=gtk-ok --text-align=center
    echo "Операция отменена!"; exit
fi

#Направление
direction="$(echo $AAA | awk -F ',' '{print $2}')"
#Отступ
space="$(echo $AAA | awk -F ',' '{print $3}')"
#Путь до родительской директории/имя файла, заданное в yad
newname="${1%/*}/$(echo $AAA | awk -F ',' '{print $4}')"

if [[ "$direction" = "вертикально" ]]; then
    montage "$@" -geometry +0+$space -tile 1x$# "$newname"
else
    montage "$@" -geometry +$space+0 -tile $#x1 "$newname"
fi

