#!/bin/bash

#подключение библиотеки
source "./info.sh"

if [[ $# -ne 4 ]]
then
echo "Ошибка: требуется 4 числовых параметра"
echo "Пример: $0 1 2 3 4"
exit 1
fi

if ! [[ $1 =~ ^[1-6]$ ]] || ! [[ $2 =~ ^[1-6]$ ]] || ! [[ $3 =~ ^[1-6]$ ]] || ! [[ $4 =~ ^[1-6]$ ]]
then
echo "Ошибка: все параметры должны быть числами от 1 до 6"
echo "1=white, 2=red, 3=green, 4=blue, 5=purple, 6=black"
exit 1
fi

bg_label=$1
text_label=$2
bg_value=$3
text_value=$4

if [[ $bg_label = $text_label ]]
then
echo "Ошибка: цвет фона и шрифта названий не должны совпадать"
exit 1
fi

if [[ $bg_value = $text_value ]]
then
echo "Ошибка: цвет фона и шрифта значения не должны совпадать"
exit 1
fi

print_info