#!/bin/bash

LOG_FILES=(../04/nginx_*.log)

case "$MODE" in
    1)
        awk '{print $9, $0}' "${LOG_FILES[@]}" | sort -n | cut -d' ' -f2-
        ;;
    2)
        awk '{print $1}' "${LOG_FILES[@]}" | sort -u
        ;;
    3)
        awk '$9 >= 400 && $9 <= 599' "${LOG_FILES[@]}"
        ;;
    4)
        awk '$9 >= 400 && $9 <= 599 {print $1}' "${LOG_FILES[@]}" | sort -u
        ;;
esac