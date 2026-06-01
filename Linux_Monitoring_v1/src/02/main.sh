#!/bin/bash

#подключение библиотеки
source "./info.sh"

#вызов функции
print_info

#запись в файл
read -p "Сохранить информацию в файл? (yes/no): " answer
if  [[ $answer = "yes" ]]
then
FILENAME=$(date "+%d_%m_%y_%H_%M_%S").status
print_info > $FILENAME
echo "Информация сохранена в файл $FILENAME"
fi