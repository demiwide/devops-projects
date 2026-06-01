#!/bin/bash

#подключение библиотеки
source "./info.sh"

#чтение файла
CONFIG_FILE="./config.conf"

if [[ -f "$CONFIG_FILE" ]]
then
source "$CONFIG_FILE"
else
echo "Ошибка чтения конфиг файла"
exit 1
fi

#цвета по умолчанию
DEFAULT_BG_LABEL=6
DEFAULT_FG_LABEL=1
DEFAULT_BG_VALUE=2
DEFAULT_FG_VALUE=4

#объявление цветов
bg_label=${column1_background:-"default"}
text_label=${column1_font_color:-"default"}
bg_value=${column2_background:-"default"}
text_value=${column2_font_color:-"default"}

default_colors=0
#проверка диапазона цветов
if ! [[ $bg_label =~ ^[1-6]$ ]] || ! [[ $text_label =~ ^[1-6]$ ]] || ! [[ $bg_value =~ ^[1-6]$ ]] || ! [[ $text_value =~ ^[1-6]$ ]]
then
bg_label=$DEFAULT_BG_LABEL
text_label=$DEFAULT_FG_LABEL
bg_value=$DEFAULT_BG_VALUE
text_value=$DEFAULT_FG_VALUE
default_colors=1
fi

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
echo ""
#вывод цветов
if [[ $default_colors = 0 ]]
then
echo "Column 1 background = $bg_label ($(get_color_name $bg_label))"
echo "Column 1 font color = $text_label ($(get_color_name $text_label))"
echo "Column 2 background = $bg_value ($(get_color_name $bg_value))"
echo "Column 2 font color = $text_value ($(get_color_name $text_value))"
else
echo "Column 1 background = default ($(get_color_name $bg_label))"
echo "Column 1 font color = default ($(get_color_name $text_label))"
echo "Column 2 background = default ($(get_color_name $bg_value))"
echo "Column 2 font color = default ($(get_color_name $text_value))"
fi