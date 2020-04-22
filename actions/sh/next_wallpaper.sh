#!/bin/bash

if [[ "$(which dbus-send)" = "" || "$(which gsettings)" = "" ]]; then
    if [[ "$(which zenity)" != "" ]]; then
        zenity --error --width=250 --title="Установите зависимости" --text="Пожалуйста, выполните в терминале:\nsudo apt install dbus libglib2.0-bin"
    fi
    echo -e '\nИмеются неудовлетворенные зависимости!\nПожалуйста, выполните в терминале:\n\nsudo apt install dbus libglib2.0-bin'
    exit 1
fi

function change_w {
    while [[ "$picture_uri" = "$(gsettings get org.cinnamon.desktop.background picture-uri)" && $while_max -lt 5 ]]; do
        while_max=$(( $while_max+1 ))
        #echo -e "\n\nwhile_max=$while_max\n$picture_uri=$(gsettings get org.cinnamon.desktop.background picture-uri)"
        gsettings set org.cinnamon.desktop.background.slideshow slideshow-enabled true
        gsettings set org.cinnamon.desktop.background.slideshow slideshow-enabled false
        sleep 1
        #echo -e "$picture_uri=$(gsettings get org.cinnamon.desktop.background picture-uri)"
    done
}

if [[ "$(gsettings get org.cinnamon.desktop.background.slideshow slideshow-enabled)" = "true" ]]; then
    dbus-send --print-reply --dest=org.Cinnamon.Slideshow /org/Cinnamon/Slideshow org.Cinnamon.Slideshow.getNextImage
else
    picture_uri="$(gsettings get org.cinnamon.desktop.background picture-uri)"
    while_max=0
    if [[ "$(gsettings get org.cinnamon.desktop.background.slideshow random-order)" = "false" ]]; then
        gsettings set org.cinnamon.desktop.background.slideshow random-order true
        sleep 1
        change_w
        gsettings set org.cinnamon.desktop.background.slideshow random-order false
    else
        change_w
    fi
fi

