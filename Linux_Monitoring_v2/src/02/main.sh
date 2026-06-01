#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Ошибка: нужно 3 параметра"
    echo "Использование: $0 <буквы_папок> <буквы_файлов.расширение> <размер>"
    echo "Пример: $0 az az.az 3Mb"
    exit 1
fi

DIR_LETTERS="$1"
FILE_MASK="$2"
FILE_SIZE="$3"

[[ "$DIR_LETTERS" =~ ^[a-zA-Z]{1,7}$ ]] || {
    echo "Ошибка: параметр 1 должен содержать только английские буквы, не более 7"
    exit 1
}

[[ "$FILE_MASK" =~ ^[a-zA-Z]{1,7}\.[a-zA-Z]{1,3}$ ]] || {
    echo "Ошибка: параметр 2 должен быть в формате name.ext"
    exit 1
}

[[ "$FILE_SIZE" =~ ^([1-9][0-9]?|100)Mb$ ]] || {
    echo "Ошибка: параметр 3 должен быть от 1 до 100Mb"
    exit 1
}

FILE_NAME_LETTERS="${FILE_MASK%.*}"
FILE_EXT_LETTERS="${FILE_MASK#*.}"
FILE_SIZE_MB="${FILE_SIZE%Mb}"

source "./generator.sh"