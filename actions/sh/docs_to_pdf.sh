#!/bin/bash
for file in "$@"
do
    output=$output"\n"$file
    path=${file%/*}
    expansion=${file##*.}
    if [ "$expansion" = "xls" ] || [ "$expansion" = "xsls" ] || [ "$expansion" = "ods" ]
        then
            localc --convert-to pdf "$file" --outdir "$path"
        else
            if [ "$expansion" = "odp" ] || [ "$expansion" = "pptx" ] || [ $expansion = "ppt" ]
                then
                    loimpress --convert-to pdf "$file" --outdir "$path"
                else                
                    if [ "$expansion" = "doc" ] || [ "$expansion" = "docx" ] || [ "$expansion" = "odt" ] || [ "$expansion" = "rtf" ] || [ "$expansion" = "txt" ]
                        then
                            lowriter --convert-to pdf "$file" --outdir "$path"
                    fi
            fi
    fi
done
notify-send -t 10000 -i "gtk-ok" "Завершено" "Преобразование в PDF документов:$output"
