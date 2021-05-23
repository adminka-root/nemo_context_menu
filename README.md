

# Контекстное меню файлового менеджера Nemo

Любые совершаемые вами действия - зона вашей ответственности, а не моей. Этот репозиторий не дает мне никаких "преференций", я даже на это не рассчитываю. Любая размещенная здесь информация предоставляется "как есть", я вас ни к чему не призываю и не заставляю что-либо делать. Поэтому без обид, если что-то пойдет не так и приведет к негативным последствиям, ведь я вас предупредил. И вообще, напишите на листочке фразу "*никому нельзя доверять*", приклейте на монитор и возьмите в привычку докапываться до сути тех или иных команд, действий на столько, на сколько это возможно, вместо того, чтобы верить на слово. Также могу порекомендовать [Timeshift](https://teejeetech.in/timeshift/) для бэкапа системы.

С любыми вопросами, предложениями, пожеланиями, связанными с данным репозиторием, вы можете обратиться по адресу электронной почты [artyom-5555@ya.ru](mailto:artyom-5555@ya.ru) . Особенно приветствуются сообщения о возможных багах! В теме (названии) письма обязательно должна присутствовать фраза: **`[NEMO ACTIONS]`**, в противном случае могу и не заметить.

## Содержание:

> 1. Что нового
>    1. [Обновление 23.05.21](https://github.com/adminka-root/nemo_context_menu#11-обновление-230521-to_top)
> 2. Вводная информация для новичков
>    1. [Вступление](https://github.com/adminka-root/nemo_context_menu#21-вступление-to_top)
>    2. [А вы знаете, что...](https://github.com/adminka-root/nemo_context_menu#22-а-вы-знаете-что-to_top)
>       1. [Nemo расширения](https://github.com/adminka-root/nemo_context_menu#221-nemo-расширения-to_top)
>       2. [Сценарии (scripts)](https://github.com/adminka-root/nemo_context_menu#222-сценарии-scripts-to_top)
>       3. [Действия (actions)](https://github.com/adminka-root/nemo_context_menu#223-действия-actions-to_top)
> 3. Этот репозиторий
>    1. [Установка всех КМ](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top)
>    2. [Обновление всех КМ](https://github.com/adminka-root/nemo_context_menu#32-Обновление-всех-КМ-to_top)
>    3. [Описание и установка конкретных КМ](https://github.com/adminka-root/nemo_context_menu#33-описание-и-установка-конкретных-км)
>       1. [Сканирование на вирусы Clamav](https://github.com/adminka-root/nemo_context_menu#сканирование-на-вирусы-clamav-to_top)
>       2. [Конвертирование документов MS Office, LibreOffice и txt в pdf](https://github.com/adminka-root/nemo_context_menu#конвертирование-документов-ms-office-libreoffice-и-txt-в-pdf-to_top)
>       3. [Xed от root](https://github.com/adminka-root/nemo_context_menu#xed-от-root-to_top)
>       4. [Объединение 2 и более изображений в одно](https://github.com/adminka-root/nemo_context_menu#объединение-2-и-более-изображений-в-одно-to_top)
>       5. [Загрузка изображений на imgur.com](https://github.com/adminka-root/nemo_context_menu#загрузка-изображений-на-imgurcom-to_top)
>       6. [Скопировать полный путь](https://github.com/adminka-root/nemo_context_menu#скопировать-полный-путь-to_top)
>       7. [Терминальная сортировка папок и файлов по размеру](https://github.com/adminka-root/nemo_context_menu#терминальная-сортировка-папок-и-файлов-по-размеру-to_top)
>       8. [Сменить обои рабочего стола](https://github.com/adminka-root/nemo_context_menu#сменить-обои-рабочего-стола-to_top)
>       9. [Оптимизация изображений png/jpg](https://github.com/adminka-root/nemo_context_menu#оптимизация-изображений-pngjpg-to_top)
>       10. [Вычисление хеш-сумм](https://github.com/adminka-root/nemo_context_menu#вычисление-хеш-сумм-to_top)
>       11. [Монтирование торрент-файлов](https://github.com/adminka-root/nemo_context_menu#монтирование-торрент-файлов-to_top)
>       12. [Скрыть папки/файлы](https://github.com/adminka-root/nemo_context_menu#скрыть-папкифайлы-to_top)
>       13. [Поворот видео-файлов](https://github.com/adminka-root/nemo_context_menu#поворот-видео-файлов-to_top)
>       14. [Монтирование LUKS-контейнеров](https://github.com/adminka-root/nemo_context_menu#монтирование-luks-контейнеров-to_top)
>    4. [Удаление всех КМ](https://github.com/adminka-root/nemo_context_menu#34-Удаление-всех-КМ-to_top)

---
## 1. Что нового
### 1.1 Обновление 23.05.21 **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

>Добавлено:
>
>- [Скрыть папки/файлы](https://github.com/adminka-root/nemo_context_menu#скрыть-папкифайлы-to_top)
>- [Поворот видео-файлов](https://github.com/adminka-root/nemo_context_menu#поворот-видео-файлов-to_top)
>- [Монтирование LUKS-контейнеров](https://github.com/adminka-root/nemo_context_menu#монтирование-luks-контейнеров-to_top)
>
> Изменены:
>
>- [compress_image.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/compress_image.sh ""): добавлен прогресс-бар; исправлен баг, связанный с изменением названия исполняемого файла в новых версиях mat; незначительные правки в коде проверки зависимостей.
>- [docs_to_pdf.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/docs_to_pdf.sh ""): выводить сообщение об ошибке для файлов, которые не могут быть прочитаны или чья папка (выходная для pdf файлов) не доступна для записи.
>
>Удалено:
>
>- Загрузка файлов на Firefox Send, т.к. сервис [был закрыт](https://blog.mozilla.org/blog/2020/09/17/update-on-firefox-send-and-firefox-notes/ "").
>- Сканирование на вирусы Dr.Web, т.к. я разочаровался в данном антивирусе и никому не рекомендую его использовать.
>
___

## 2. Вводная информация для новичков
### 2.1 Вступление **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

***Контекстным*** называют всплывающее ***меню***, которое появляется при нажатии правой кнопки мыши в любой навигационной области экрана. Оно находится всегда "*под рукой*" во многих программах, где его реализация оправдана, (например в LibreOffice, Gimp, VLC и т.д.) и содержит в себе сценарии для решения наиболее часто возникающих у пользователя задач, что в свою очередь положительно сказывается на скорости работы и удобстве использования. Ниже пойдет речь о контекстном меню файлового менеджера Nemo (далее - *КМ ФМ Nemo*), созданного командой разработчиков Linux Mint и поставляемого в соответствующем дистрибутиве, начиная с 14-й версии, с окружением Cinnamon.
___
### 2.2 А вы знаете, что... **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**
Nemo использует несколько подходов для отображения КМ.
#### 2.2.1 Nemo расширения **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**
Краткая информация о некоторых интересных расширениях nemo, которые доступны из стандартного репозитория. Не все они, но большинство, интегрируются в КМ.

Установить любое из них можно, выполнив в терминале: `apt install название_пакета`
Получить подробную информацию: `apt show название_пакета`
* **`nemo-image-converter`** - добавляет два КМ: "Масштабировать изображения" и "Вращать изображения".
* **`nemo-compare`** - КМ "Сравнить". Использует [meld](https://ru.bmstu.wiki/Meld "") для сравнения файлов и папок.
* **`nemo-pastebin`** - позволяет через соответствующее КМ быстро отправить текст на [pastebin](https://pastebin.com/ "").
* **`nemo-seahorse`** - КМ "Зашифровать" и "Подпись". Позволяет зашифровать и дешифровать файлы [OpenPGP](https://www.openpgp.org/about/ "") с помощью [GnuPG](https://ru.wikipedia.org/wiki/GnuPG "").
* **`nemo-filename-repairer`** - КМ для восстановления кодировки в названии каталогов

* **`nemo-owncloud`** - добавляет интеграцию с [ownCloud](https://owncloud.org/ "")
* **`nemo-dropbox`** - добавляет интеграцию с [dropbox](https://www.dropbox.com/ "")
* **`nemo-media-columns`** - вывод информации о [метаданных](https://ru.wikipedia.org/wiki/Метафайл "") музыки/EXIF и PDF при отображении файлов списком (Ctrl+2)
* **`nemo-gtkhash`** - добавляет вкладку "[Хэши](https://ru.wikipedia.org/wiki/Хеш-функция "")" (ПКМ по файлу --> Свойства).
* **`nemo-audio-tab`** - добавляет вкладку "Звук" (ПКМ по файлу --> Свойства). Позволяет посмотреть [метаданные](https://ru.wikipedia.org/wiki/Метафайл "") аудиофайла.

#### 2.2.2 Сценарии (scripts) **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**
Сценарии - обычные скрипты, хранящиеся в директории  **~/.local/share/nemo/scripts/**
Для сценариев нельзя задать условия появления: они отображаются в КМ всегда (но фоновый клик в nemo не передаст в скрипт путь открытой папки). См. подробнее - `cat /usr/share/nemo/script-info.md `

#### 2.2.3 Действия (actions) **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**
Действия главным образом характеризуют файлы с расширением **.nemo_action**. Если ввести команду `apt content nemo-data | grep /usr/share/nemo/actions/`, то можно увидеть список предустановленных в Linux Mint КМ.

> <u>*Примечание*</u>: Если вы заинтересованы в создании собственных КМ, скорее всего, вам будет интересен находящийся рядом файл **/usr/share/nemo/actions/sample.nemo_action**, который содержит описание всевозможных параметров, применяемых в .nemo_action. Для тех, кто плохо дружит с английским - руссифицированная версия [SAMPLE_RUS.html](https://github.com/adminka-root/nemo_context_menu/blob/master/SAMPLE_RUS.html) с моими дополнениями. Для ее просмотра **после** [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "") откройте файл `~/.local/share/nemo_context_menu/SAMPLE_RUS.html` в Nemo и запустите двойным кликом. Или через терминал:
>
> ```bash
> x-www-browser "$HOME/.local/share/nemo_context_menu/SAMPLE_RUS.html" &
> disown "%x-www-browser"
> ```
>
>*Первая команда откроет файл в браузере, переместив процесс в фоновый режим. А вторая - не даст автоматически закрыться окну браузера после закрытия родительского терминала.*
>
>В итоге, вам будет доступна текстовая версия шаблона, выглядящая следующим образом:
>
>![](https://i.imgur.com/QXISt9c.png)
>
>Чтобы спустя время, не потерять и не искать, где же находится файл шаблона `~/.local/share/nemo_context_menu/SAMPLE_RUS.html`, вы можете сразу после открытия добавить его в закладки браузера (для этого нажмите **Ctrl+D** и сохраните).
>
>> <u>Совет</u>: прежде чем создавать КМ, вы должны учесть 2 вещи:
> >
> > 1. Многие программы способны принимать передаваемые параметры сразу.
> > 2. Помимо этого репозитория, есть масса уже готовых решений, необязательно изобретать велосипед.
> >    * [https://github.com/thioshp/nemo_scripts](https://github.com/thioshp/nemo_scripts "")
> >    * [https://github.com/smurphos/nemo_actions_and_cinnamon_scripts](https://github.com/smurphos/nemo_actions_and_cinnamon_scripts "")
> >    * [https://github.com/damko/nemo_actions](https://github.com/damko/nemo_actions "")
> >    * [https://github.com/demonlibra/nemo-actions](https://github.com/demonlibra/nemo-actions "")

 Итак, есть 2 директории, где хранят файлы действия:
 локальная  **~/.local/share/nemo/actions**
 и глобальная **/usr/share/nemo/actions**

___

## 3. Этот репозиторий

### 3.1 Установка всех КМ **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

Первым делом установите git:

```bash
sudo apt install git
```

Затем **клонируйте** этот репозиторий:

```bash
cd "$HOME/.local/share" && git clone https://github.com/adminka-root/nemo_context_menu.git
```

*Выполнив это, вы сможете установить все сразу или обратиться к [пункту 2.3 для установки каких-то **конкретных** КМ](https://github.com/adminka-root/nemo_context_menu#33-описание-и-установка-конкретных-км).*

Установка всех nemo actions:

1. Создайте жесткие ссылки для .nemo_action файлов, sh скриптов и иконок (скопируйте и вставьте в терминал весь "код" **целиком**):

```bash
cd "$HOME/.local/share/nemo_context_menu/"
./install_purge_update_all.sh -l
```
Скрипт высветит подобное сообщение:

![](https://i.imgur.com/Tamoac5.png)

И потребует подтверждение операции: *Вы действительно хотите интегрировать необходимые жесткие ссылки? (Y/n)*. Нажмите Enter, если согласны.

> Запомните на будущее: если в скобках одна из букв - заглавная, а другая - нет, то предполагается, что первая - ответ по-умолчанию, т.е. тот, что будет принят автоматически, если пользователь не станет ничего писать, а просто нажмет клавишу Enter. В данном случаи написано «Y/n», подразумевается «YES» или «no»,  «Y» - заглавная, значит, чтобы подтвердить операцию вам достаточно нажать Enter. А вот для случая отказа ответ придется писать ручками: «no» или «нет», или вообще сокращения «n или «н».

```bash
cd "$HOME/.local/share/nemo_context_menu/"
sudo cp -f "./polkit-1/org.gnome.xed.policy" /usr/share/polkit-1/actions/
```

2. Установите используемые в действиях/сценариях зависимости.

Пакеты, которые у вас, *вероятно*, **есть** (скопируйте и вставьте в терминал весь "код" **целиком**):

```bash
sudo apt install sed gawk coreutils xed \
dbus libglib2.0-bin libreoffice-impress \
libreoffice-calc libreoffice-writer curl \
zenity findutils python3 file grep mount \
libblockdev-crypto2 libnotify-bin parted \
cryptsetup udisks2 findutils psmisc
```

Пакеты, которых у вас, *вероятно*, **нет** (скопируйте и вставьте в терминал весь "код" **целиком**):

```bash
sudo apt install clamav clamav-daemon yad \
graphicsmagick-imagemagick-compat xclip ncdu \
jpegoptim optipng advancecomp mat btfs ffmpeg \
xvfb xterm
```

Если планируете пользоваться КМ "[Сканирование на вирусы Clamav](https://github.com/adminka-root/nemo_context_menu#сканирование-на-вирусы-clamav-to_top)", то после установки обновите вручную антивирусные сигнатуры (скопируйте и вставьте в терминал команды **по одной за раз**):
```bash
sudo service clamav-freshclam stop
sudo freshclam
sudo service clamav-freshclam start
```

**Внимание!** *Для каждого .nemo_action указан раздел **Dependencies**. Поэтому если каких-либо зависимостей не будет хватать, КМ даже не появится.*

[comment]: # "(если, конечно, речь идет не о скриптах; тогда после запуска вы увидите сообщение об отсутствующих зависимостях)."

3. Откройте Nemo > Alt+P (или Правка > Плагины ) > и **отключите ненужные** вам действия/сценарии:

   ![](https://i.imgur.com/DoWVTFD.png)

### 3.2 Обновление всех КМ **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

Перейдите в директорию, куда клонировали репозиторий, и запустите скрипт для обновления (скопируйте и вставьте в терминал весь "код" **целиком**):

```bash
cd "$HOME"/.local/share/nemo_context_menu/
./install_purge_update_all.sh -u -l
```

Следуйте инструкциям из скрипта...

![](https://i.imgur.com/Jmpztqj.png)

### 3.3 Описание и установка конкретных КМ

#### Сканирование на вирусы [Clamav](https://www.clamav.net/) **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

> **Внимание!** *Установленный Clamav значительно увеличивает время загрузки системы. Особенно это заметно на слабых машинах. Перед инсталляцией подумайте, действительно ли он вам нужен!*
>
> Установите зависимости:
>
> ```bash
> sudo apt install clamav clamav-daemon yad findutils gawk
> ```
>
> Обновите антивирусные сигнатуры (скопируйте и вставьте в терминал команды **по одной за раз**):
>
> ```bash
> sudo service clamav-freshclam stop
> sudo freshclam
> sudo service clamav-freshclam start
> ```
>
> После [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
> ```bash
> n_act="clamav.nemo_action" && n_sh="clamav.sh" && \
> n_i="clamav.svg" && \
> cd "$HOME/.local/share/nemo_context_menu/" && \
> ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
> mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
> ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh" && \
> ln ./icons/"$n_i" "$HOME/.local/share/icons"
> ```
>
> Демонстрация (gif-ка): ![](https://i.imgur.com/r7Ye2HU.gif)
>
> [clamav.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/clamav.nemo_action "")
>
> [clamav.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/clamav.sh "")

#### Конвертирование документов MS Office, LibreOffice и txt в pdf **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

> Установите:
>
> ```bash
> sudo apt install libreoffice-impress libreoffice-calc libreoffice-writer
> ```
>
> После [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
> ```bash
> n_act="docs_to_pdf.nemo_action" && n_sh="docs_to_pdf.sh" && \
> n_i="nemo-pdf.png" && \
> cd "$HOME/.local/share/nemo_context_menu/" && \
> ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
> mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
> ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh" && \
> ln ./icons/"$n_i" "$HOME/.local/share/icons"
> ```
>
> Демонстрация (gif-ка):
>
>  ![](https://i.imgur.com/OBuIGHN.gif)
>
> [docs_to_pdf.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/docs_to_pdf.nemo_action "")
>
> [docs_to_pdf.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/docs_to_pdf.sh "")

#### Xed от root **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

> Установите:
>
> ```bash
> sudo apt install xed
> ```
>
> После [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
> ```bash
> n_act="open_xed_as_root.nemo_action" && n_sh="open_xed_root.sh" && \
> n_i="xed.svg" && \
> cd "$HOME/.local/share/nemo_context_menu/" && \
> ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
> mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
> ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh" && \
> ln ./icons/"$n_i" "$HOME/.local/share/icons"
> ```
>
> и
>
> ```bash
> sudo cp -f "./polkit-1/org.gnome.xed.policy" /usr/share/polkit-1/actions/
> ```
>
> Демонстрация (gif-ка):
>
> ![](https://i.imgur.com/m82HiRV.gif)
>
> [open_xed_as_root.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/open_xed_as_root.nemo_action "")
>
> [open_xed_root.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/open_xed_root.sh "")
>
> [org.gnome.xed.policy](https://github.com/adminka-root/nemo_context_menu/blob/master/polkit-1/org.gnome.xed.policy "")

#### Объединение 2 и более изображений в одно **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

> Установите:
>
> ```bash
> sudo apt install graphicsmagick-imagemagick-compat yad
> ```
>
> После [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
> ```bash
> n_act="image_montage.nemo_action" && n_sh="image_montage.sh" && \
> n_i="extension.png" && \
> cd "$HOME/.local/share/nemo_context_menu/" && \
> ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
> mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
> ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh" && \
>ln ./icons/"$n_i" "$HOME/.local/share/icons"
> ```
>
> Демонстрация (gif-ка):
>
> ![](https://i.imgur.com/nyTjJlc.gif)
>
> [image_montage.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/image_montage.nemo_action "")
>
> [image_montage.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/image_montage.sh "")

#### Загрузка изображений на [imgur.com](https://imgur.com/) **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

> Установите:
>
> ```bash
> sudo apt install zenity curl gawk
> ```
>
> После [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
> ```bash
> n_act="upload_to_imgur.nemo_action" && n_sh="upload_to_imgur.sh" && \
> n_i="imgur.png" && \
> cd "$HOME/.local/share/nemo_context_menu/" && \
> ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
> mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
> ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh" && \
> ln ./icons/"$n_i" "$HOME/.local/share/icons"
> ```
>
> Демонстрация (gif-ка):
>
> ![](https://i.imgur.com/xDZ5QK7.gif)
>
> [upload_to_imgur.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/upload_to_imgur.nemo_action "")
>
> [upload_to_imgur.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/upload_to_imgur.sh "")

#### Скопировать полный путь **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

> Установите:
>
> ```bash
> sudo apt install xclip
> ```
>
> После [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
> ```bash
> n_act="copy_full_path.nemo_action" && \
> n_i="copy_full_path.png" && \
> cd "$HOME/.local/share/nemo_context_menu/" && \
> ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
> ln ./icons/"$n_i" "$HOME/.local/share/icons"
> ```
>
> Демонстрация (gif-ка):
>
> ![](https://i.imgur.com/Xdmavnm.gif)
>
> [copy_full_path.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/copy_full_path.nemo_action "")

#### Терминальная сортировка папок и файлов по размеру **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

> *Примечание 1: в общем случаи можно обойтись и без Nemo action, а отправлять объекты через меню "открыть с помощью" в соответствующий ярлык или меню "сценарии" в соответствующий скрипт (предварительно запихав его в ~/.local/share/nemo/scripts). Но в таком формате невозможно передать в качестве параметра уже открытую папку (ведь при фоновом клике "открыть с помощью" не появляется, а в сценарии, как уже было замечено ранее, nemo не передает путь открытой папки). Поэтому я предпочитаю отдельное КМ.*
>
> Установите:
>
> ```bash
> sudo apt install ncdu
> ```
>
> После [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top) (скопируйте и вставьте в терминал весь "код" **целиком**):
>
> ```bash
> n_act="ncdu.nemo_action" && \
> n_i="sort.png" && \
> cd "$HOME/.local/share/nemo_context_menu/" && \
> ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
> ln ./icons/"$n_i" "$HOME/.local/share/icons"
> ```
>
> *Примечание 2: в последних версиях nemo в некоторых случаях может "затупить" и сразу не отобразить данное КМ. Чтобы заставить его это сделать, достаточно нажать кнопку F5 или Ctrl+R (или соответствующий функционал в меню вид -> обновить). С чем связано, понятия не имею :)*
>
> Демонстрация (gif-ка):
>
> ![](https://i.imgur.com/mOosMbR.gif)
>
> [ncdu.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/ncdu.nemo_action "")

#### Сменить обои рабочего стола **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

> Это КМ работает только для изображений, которые подготовлены для слайдшоу в `cinnamon-settings backgrounds` . Слайдшоу при этом необязательно должно быть включено.
>
> ![](https://i.imgur.com/yorn4ni.png)
>
> Установите:
>
> ```bash
> sudo apt install dbus libglib2.0-bin
> ```
>
> Далее после [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
> ```bash
> n_act="next_wallpaper.nemo_action" && n_sh="next_wallpaper.sh" && \
> cd "$HOME/.local/share/nemo_context_menu/" && \
> ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
> mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
> ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh"
> ```
>
> Демонстрация (gif-ка):
>
> ![](https://i.imgur.com/AjL5S1W.gif)
>
> [next_wallpaper.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/next_wallpaper.nemo_action "")
>
> [next_wallpaper.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/next_wallpaper.sh "")

#### Оптимизация изображений png/jpg **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

> Cжимает изображения png/jpg до меньшего размера без потерь качества (оптимизация) + пытается очистить метаданные.
>
> Для работы требуются [jpegoptim](https://github.com/tjko/jpegoptim "") - для jpg, [[optipng](http://optipng.sourceforge.net/ ""), [advancecomp](http://www.advancemame.it/ "")] - для png, [mat](https://mat.boum.org/ "") - для очистки метаданных. Установите:
>
> ```bash
> sudo apt install jpegoptim optipng advancecomp mat
> ```
>
> Далее после [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
> ```bash
> n_act="compress_image.nemo_action" && n_sh="compress_image.sh" && \
> n_i="compress-image.svg" && \
> cd "$HOME/.local/share/nemo_context_menu/" && \
> ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
> mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
> ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh" && \
> ln ./icons/"$n_i" "$HOME/.local/share/icons"
> ```
>
> [compress_image.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/compress_image.nemo_action "")
>
> [compress_image.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/compress_image.sh "")

#### Вычисление хеш-сумм **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

> Работает со всеми типами файлов, а не только с iso, и вычисляет не только *sha256*, как это делает КМ из коробки (/usr/share/nemo/actions/mint-sha256sum.nemo_action).
>
> Установите:
>
> ```bash
> sudo apt install zenity coreutils
> ```
>
> Далее после [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
> ```bash
> n_act="hash_sum.nemo_action" && n_sh="hash_sum.sh" && \
> cd "$HOME/.local/share/nemo_context_menu/" && \
> ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
> mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
> ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh"
> ```
>
> Демонстрация (gif-ка):
>
> ![](https://i.imgur.com/sveYNjB.gif)
>
> [hash_sum.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/hash_sum.nemo_action "")
>
> [hash_sum.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/hash_sum.sh "")

#### Монтирование торрент-файлов **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

>Это возможно, благодаря btfs. Если интересны подробности, то welcome на [страницу проекта](https://github.com/johang/btfs).
>
>Установите:
>
>```bash
>sudo apt install btfs zenity gawk sed coreutils
>```
>
>Далее после [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
>```bash
>n_act="btfs_mount.nemo_action" && n_sh="btfs.sh" && \
>n_act_2="btfs_umount.nemo_action" && \
>cd "$HOME/.local/share/nemo_context_menu/" && \
>ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
>ln "./actions/$n_act_2" "$HOME/.local/share/nemo/actions" && \
>mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
>ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh"
>```
>
>Демонстрация (gif-ка):
>
>![](https://i.imgur.com/lLJzk1U.gif)
>
>По итогу мы имеем 2 КМ: одно - для монтирования (доступно при одиночном или множественном выборе файлов с расширением **.torrent**), другое - для отмонтирования (доступно при фоновом клике); и скрипт,  который выполняет всю грязную работу. Сразу оговорюсь, КМ работает только с папками, которые вам (вашему пользователю) **доступны для записи**, а монтирование, как известно, возможно только в **пустую папку**.
>
>[btfs_mount.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/btfs_mount.nemo_action "")
>
>[btfs_umount.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/btfs_umount.nemo_action "")
>
>[btfs.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/btfs.sh "")

#### Скрыть папки/файлы **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

>Любые файлы, начинающиеся с точки, считаются скрытыми для ФМ. Но Nemo поддерживает еще один весьма удобный способ скрытия: когда в открытой директории присутствует текстовый файл **.hidden**, ФМ считывает строки из него. Затем, если в директории присутствует файл, название которого совпадает с текущей считанной строкой, Nemo считает файл скрытым и не показывает его пользователю. Чтобы скрывать файлы без лишних телодвижений, я написал скрипт, который сам при необходимости создаст файл **.hidden** и добавит переданные названия файлов.
>
>Итак, установите:
>
>```bash
>sudo apt install python3
>```
>
>Далее после [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
>```bash
>n_act="hidden.nemo_action" && n_py="hidden.py" && \
>cd "$HOME/.local/share/nemo_context_menu/" && \
>ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
>mkdir -p "$HOME/.local/share/nemo/actions/py" && \
>ln ./actions/py/"$n_py" "$HOME/.local/share/nemo/actions/py"
>```
>
>Демонстрация (gif-ка):
>
>![](https://i.imgur.com/NwHTlFd.gif)
>
>Примечание: если вам кажется, что КМ не работает, нажмите **F5** или **Ctrl + R**, чтобы Nemo заново считал содержимое открытой директории (включая появившийся после работы КМ файл - **.hidden**) или закройте ФМ и откройте вновь в том же самом месте. Если и это не сработает, возможно, в настройках Nemo включено отображение скрытых файлов. Чтобы его отключить, нажмите **Ctrl + H**.
>
>[hidden.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/hidden.nemo_action "")
>
>[hidden.py](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/py/hidden.py "")

#### Поворот видео-файлов **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

>При воспроизведении видео-файлов, записанных на телефоне, может оказаться, что они перевернуты "вверх ногами" или на 90°. Не беда: с помощью данного КМ можно легко повернуть видео так, как вам хочется.
>
>Установите:
>
>```bash
>sudo apt install ffmpeg libnotify-bin yad findutils procps psmisc
>```
>
>Далее после [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
>```bash
>n_act="rotate_video.nemo_action" && n_sh="rotate_video.sh" && \
>cd "$HOME/.local/share/nemo_context_menu/" && \
>ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
>mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
>ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh"
>```
>
>Демонстрация (gif-ка):
>
>![](https://i.imgur.com/hc7V5ZN.gif)
>
>*Примечание 1: [rotate_video.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/rotate_video.sh "") более функционален в терминале, чем при использовании в составе КМ. Это было сделано умышлено: чем меньше вопросов - тем лучше. Nemo передает ему список путей к файлам, скрипт спрашивает, как перевернуть и размещает рядом преобразованные видео. Но базово он также поддерживает опции -d и -u. Первая служит для указания директории, где хранятся видео файлы, а вторая - для директории выходных файлов.*
>
>*Примечание 2: если исходные видео находятся в директории, недоступной для записи, или банально на разделе нет места для выходных файлов, вы можете создать [симлинки](https://ru.wikipedia.org/wiki/Символическая_ссылка "Символическая ссылка"). Для этого выделите видео, наведите курсор на одно из них, удерживая Ctrl+Shift, зажмите ЛКМ (левую кнопку мыши) и перетащите в желаемую директорию. Примените КМ на симлинки, после работы симлинки можно удалить.*
>
>*Примечание 3: если вы передумали конвертировать **текущее видео** (то, что обрабатывается в данный момент), нажмите кнопку "Отменить для этого файла". Если - **все**, но хотите **успешно закончить конвертацию текущего видео**, нажмите "Отменить следующие". Для отмены **всех, включая текущее**, нажмите кнопку "Отменить для этого файла", дождитесь сообщения об удалении, в течении 3 секунд нажмите "Отменить следующие".*
>
>[rotate_video.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/rotate_video.nemo_action "")
>
>[rotate_video.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/rotate_video.sh "")

#### Монтирование LUKS-контейнеров **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

>**Внимание!** *Скрипт, выполняющий монтирование, тестировался в LM 18.x и 19.x. Работоспособность в иных ОС не гарантируется, ввиду большого количества нюансов!*
>
>Установите:
>
>```bash
>sudo apt install yad libnotify-bin cryptsetup parted udisks2 libblockdev-crypto2 grep gawk file mount coreutils xvfb xterm
>```
>
>Далее после [клонирования репозитория](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top "3.1 Установка Nemo Action") (скопируйте и вставьте в терминал весь "код" **целиком**):
>
>```bash
>n_act="mounting_luks_containers.nemo_action" && n_sh="mounting_containers.sh" && \
>cd "$HOME/.local/share/nemo_context_menu/" && \
>ln "./actions/$n_act" "$HOME/.local/share/nemo/actions" && \
>mkdir -p "$HOME/.local/share/nemo/actions/sh" && \
>ln ./actions/sh/"$n_sh" "$HOME/.local/share/nemo/actions/sh"
>```
>
>*Примечание 1:  чтобы "не загромождать" список, по-умолчанию КМ появляется для контейнеров с расширение .luks. Если вас не устраивает данное поведение и вы хотите отображать при выделении любых файлов, выполните команду `sed -i 's/Extensions=luks;/Extensions=nodirs;/' "$HOME/.local/share/nemo/actions/mounting_luks_containers.nemo_action"`*
>
>Демонстрация (gif-ка):
>
>![](https://i.imgur.com/DviVrp8.gif)
>
>*Примечание 2: простые контейнеры можно и нужно монтировать без указания директории монтирования, а также опции для обновления таблицы разделов внутри контейнера. В противном случаи, вам потребуется ввод пароля администратора.*
>
>[mounting_luks_containers.nemo_action](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/mounting_luks_containers.nemo_action "")
>
>[mounting_containers.sh](https://github.com/adminka-root/nemo_context_menu/blob/master/actions/sh/mounting_containers.sh "")
>

### 3.4 Удаление всех КМ **[[to_top]](https://github.com/adminka-root/nemo_context_menu#содержание "вернуться к содержанию")**

Удалять файлы ***.nemo_action**, их **скрипты** и используемые ими **иконки**, бессмысленно: объем, занимаемого ими пространства на диске, скорее всего, меньше, чем объем изображения, установленного у вас в качестве заставки рабочего стола. Однако, если вам это действительно нужно, то выполните (скопируйте и вставьте в терминал весь "код" **целиком**):

```bash
cd "$HOME/.local/share/nemo_context_menu/"
./install_purge_update_all.sh -p
```

![](https://i.imgur.com/WGTcSiK.png)

Затем подтвердите операцию удаления, напечатав «**Yes**» и нажав **Enter**. Готово!

Другое дело - их **зависимости**. Но когда дело касается зависимостей, важно понимать, **что** вы удаляете и быть готовыми к возможному восстановлению системы. Иначе - не миновать беды. В разделе [3.1 Установка Nemo Action](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top) я целенаправленно делю зависимости на: "пакеты, которые у вас, *вероятно*, **есть**" и которых - **нет**. **Удаление пакетов из первого списка** (в частности, акцентирую внимание на *sed, coreutils, dbus, libglib2.0-bin, findutils*) с высокой долей вероятности **приведет к печальным последствиям**. Впрочем, apt вас предупредит:

![](https://i.imgur.com/M4OlaHE.png)

**Удаление пакетов из второго списка** более **безопасно**. Но опять же, если не брать в расчет зависимости антивируса Clamav, то оставшиеся - кушать не просят и, если речь идет о LMC (Linux Mint Cinamon), занимают места не больше 100 мб. Стоят ли эти 100 мб возможных рисков, если можно просто **отключить неугодные КМ** (Nemo > Alt+P (или Правка > Плагины ) > убрать галочки для ненужных КМ)?

![](https://i.imgur.com/DoWVTFD.png)

Решать вам. Я лишь приведу команду для удаления Clamav в качестве единственно рекомендуемого действия:

```bash
sudo apt remove clamav clamav-daemon
```

> Если хотите удалить другие зависимости (те самые >100 мб), то скопируйте команду из раздела [3.1 Установка Nemo Action](https://github.com/adminka-root/nemo_context_menu#31-Установка-всех-КМ-to_top) для установки пакетов второго списка (Пакеты, которых у вас, *вероятно*, **нет**) и замените `install` на `remove` ( т.е. `sudo apt remove названия_пакетов...`, вместо `sudo apt install названия_пакетов...` ).
>

Для удаления **локального репозитория** введите:

```bash
rm -rf "$HOME/.local/share/nemo_context_menu/"
```
