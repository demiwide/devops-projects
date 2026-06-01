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

function print_info {
cat << EOF
HOSTNAME = $HOSTNAME
TIMEZONE = $TIMEZONE UTC $UTC
USER = $USER
OS = $OS
DATE = $DATE
UPTIME = $UPTIME
UPTIME_SEC = $UPTIME_SEC
IP = $IP
MASK = $MASK
GATEWAY = $GATEWAY
RAM_TOTAL = $RAM_TOTAL
RAM_USED = $RAM_USED
RAM_FREE = $RAM_FREE
SPACE_ROOT = $SPACE_ROOT
SPACE_ROOT_USED = $SPACE_ROOT_USED
SPACE_ROOT_FREE = $SPACE_ROOT_FREE
EOF

}