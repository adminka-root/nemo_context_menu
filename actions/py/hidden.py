#!/usr/bin/python3

# недостатки скрипта:
#  1. считает, что к файлу .hidden всегда есть право для записи
#     и не выводит сообщения об ошибке в gui окне, если это ни так
#  2. нет кодов возврата, если никаких действий не было


import sys
import os.path


def basename_of_argv(argv_list):
    basename = []
    for i in range(1, len(argv_list)):
        basename.append(argv_list[i][argv_list[i].rfind('/') + 1:])
    return sorted(basename)


def get_the_true_lines_of_the_hidden_file(main_dir, argv_list):
    hidden_f = main_dir + ".hidden"
    c_lines_h = 0
    if os.path.isfile(hidden_f):
        basename_h = []
        hidden = open(hidden_f, 'r')
        for line in hidden:
            c_lines_h += 1
            if os.path.exists(str(main_dir + line[0:-1])) \
                    and line[0:-1] != "":
                basename_h.append(line[0:-1])
        hidden.close()
        return sorted(basename_h), c_lines_h
    else:
        return [], c_lines_h


def compare(basename, basename_h, c_lines_h):
    if basename == basename_h:
        if len(basename_h) != c_lines_h:
            return basename_h
        else:
            return []
    else:
        basename_all = sorted(tuple(set(basename + basename_h)))
        if basename_all != basename_h:
            return basename_all
        elif len(basename_h) != c_lines_h:
            return basename_h
        else:
            return []


def write_to_h(basename_all, main_dir):
    hidden_f = main_dir + ".hidden"
    hidden = open(hidden_f, 'w')
    for element in basename_all:
        hidden.write(element + '\n')
    hidden.close()
    return "Success"


def main_logic(argv_list):
    # получаем название раб. директории; первый переданный парам (путь)
    # от 0 до номера первого встретившегося '/', включая '/'
    main_dir = sys.argv[1][0:sys.argv[1].rfind('/') + 1]

    # получение названий файлов, сортировка
    basename = basename_of_argv(argv_list)

    # чтение .hidden файла в main_dir, проверка корректности строк
    # (сущ-т все еще файлы или нет), запоминание содержимого, sort
    basename_h, c_lines_h = \
        get_the_true_lines_of_the_hidden_file(main_dir, argv_list)

    # сравнение массива имен, полученных в результате анализа аргумен-
    # тов, с массивом из файла .hidded., возврат уникальных значений
    basename_all = compare(basename, basename_h, c_lines_h)
    # запись получившего массива в файл
    if basename_all:
        print(write_to_h(basename_all, main_dir))


main_logic(sys.argv)
