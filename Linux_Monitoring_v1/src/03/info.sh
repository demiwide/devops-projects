#!/bin/bash

HOSTNAME=$(hostname)
TIMEZONE=$(cat /etc/timezone)
UTC=$(date "+%:z")
USER=$(whoami)
OS=$(hostnamectl | awk '/Operating System/ {print $3, $4, $5}')
DATE=$(date "+%d %b %Y %H:%M:%S")
UPTIME=$(uptime -p | awk '{print $2, $3, $4, $5}')
UPTIME_SEC=$(cat /proc/uptime | awk '{print $1}')
IP=$(ip -4 a show eth0 | grep 'inet' | awk '{print $2}')
MASK=$(ipcalc $IP | awk /Netmask/'{print $2}')
GATEWAY=$(ip route | awk '/default/{print $3}')
RAM_TOTAL=$(free -m | awk '/Mem:/ {printf "%.3f GB\n", ($2/1024)}')
RAM_USED=$(free -m | awk '/Mem:/ {printf "%.3f GB\n", ($3/1024)}')
RAM_FREE=$(free -m | awk '/Mem:/ {printf "%.3f GB\n", ($7/1024)}')
SPACE_ROOT=$(df -k / | awk '$NF=="/"{printf "%.2f MB\n", ($2/1024)}')
SPACE_ROOT_USED=$(df -k / | awk '$NF=="/"{printf "%.2f MB\n", ($3/1024)}')
SPACE_ROOT_FREE=$(df -k / | awk '$NF=="/"{printf "%.2f MB\n", ($4/1024)}')


#Добавить цвета (1 — white, 2 — red, 3 — green, 4 — blue, 5 – purple, 6 — black)

# Функция для получения цвета текста по номеру
function get_text_color() {
    case $1 in
        1) echo "37" ;;  # white
        2) echo "31" ;;  # red
        3) echo "32" ;;  # green
        4) echo "34" ;;  # blue
        5) echo "35" ;;  # purple
        6) echo "30" ;;  # black
    esac
}

# Функция для получения цвета фона по номеру
function get_bg_color() {
    case $1 in
        1) echo "47" ;;  # white
        2) echo "41" ;;  # red
        3) echo "42" ;;  # green
        4) echo "44" ;;  # blue
        5) echo "45" ;;  # purple
        6) echo "40" ;;  # black
    esac
}

function print_info() {
local RESET='\033[0m' # сброс цвета
local BG_LABEL=$(get_bg_color $bg_label)
local TEXT_LABEL=$(get_text_color $text_label)
local BG_VALUE=$(get_bg_color $bg_value)
local TEXT_VALUE=$(get_text_color $text_value)

# Формирование строк форматирования
local LABEL_COLOR="\033[${BG_LABEL};${TEXT_LABEL}m"
local VALUE_COLOR="\033[${BG_VALUE};${TEXT_VALUE}m"

# Вывод информации с цветами
echo -e "${LABEL_COLOR}HOSTNAME${RESET} = ${VALUE_COLOR}${HOSTNAME}${RESET}"
echo -e "${LABEL_COLOR}TIMEZONE${RESET} = ${VALUE_COLOR}${TIMEZONE} UTC ${UTC}${RESET}"
echo -e "${LABEL_COLOR}USER${RESET} = ${VALUE_COLOR}${USER}${RESET}"
echo -e "${LABEL_COLOR}OS${RESET} = ${VALUE_COLOR}${OS}${RESET}"
echo -e "${LABEL_COLOR}DATE${RESET} = ${VALUE_COLOR}${DATE}${RESET}"
echo -e "${LABEL_COLOR}UPTIME${RESET} = ${VALUE_COLOR}${UPTIME}${RESET}"
echo -e "${LABEL_COLOR}UPTIME_SEC${RESET} = ${VALUE_COLOR}${UPTIME_SEC}${RESET}"
echo -e "${LABEL_COLOR}IP${RESET} = ${VALUE_COLOR}${IP}${RESET}"
echo -e "${LABEL_COLOR}MASK${RESET} = ${VALUE_COLOR}${MASK}${RESET}"
echo -e "${LABEL_COLOR}GATEWAY${RESET} = ${VALUE_COLOR}${GATEWAY}${RESET}"
echo -e "${LABEL_COLOR}RAM_TOTAL${RESET} = ${VALUE_COLOR}${RAM_TOTAL}${RESET}"
echo -e "${LABEL_COLOR}RAM_USED${RESET} = ${VALUE_COLOR}${RAM_USED}${RESET}"
echo -e "${LABEL_COLOR}RAM_FREE${RESET} = ${VALUE_COLOR}${RAM_FREE}${RESET}"
echo -e "${LABEL_COLOR}SPACE_ROOT${RESET} = ${VALUE_COLOR}${SPACE_ROOT}${RESET}"
echo -e "${LABEL_COLOR}SPACE_ROOT_USED${RESET} = ${VALUE_COLOR}${SPACE_ROOT_USED}${RESET}"
echo -e "${LABEL_COLOR}SPACE_ROOT_FREE${RESET} = ${VALUE_COLOR}${SPACE_ROOT_FREE}${RESET}"
}