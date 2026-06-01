#!/bin/bash

delete_by_log() {
    read -rp "Введите путь к лог-файлу: " LOG_FILE

    [[ -f "$LOG_FILE" ]] || {
        echo "Ошибка: лог-файл не найден"
        exit 1
    }

    while IFS= read -r line; do
        path=$(echo "$line" | awk -F' \\| ' '{print $2}')

        if [[ -n "$path" && -e "$path" ]]; then
            rm -rf "$path"
            echo "Удалено: $path"
        fi
    done < <(grep -E '^(DIR|FILE) \|' "$LOG_FILE")
}

delete_by_time() {
    read -rp "Введите дату запуска лога (DDMMYY): " LOG_DATE
    read -rp "Введите время запуска лога (HHMMSS): " LOG_TIME

    [[ "$LOG_DATE" =~ ^[0-9]{6}$ ]] || {
        echo "Ошибка: дата должна быть в формате DDMMYY"
        exit 1
    }

    [[ "$LOG_TIME" =~ ^[0-9]{6}$ ]] || {
        echo "Ошибка: время должно быть в формате HHMMSS"
        exit 1
    }

    LOG_NAME="creation_${LOG_DATE}_${LOG_TIME}.log"

    LOG_FILE=$(find / \
        \( -path "*/bin/*" -o -path "*/sbin/*" -o -path "*/bin" -o -path "*/sbin" \) -prune \
        -o -type f -name "$LOG_NAME" -print -quit 2>/dev/null)

    [[ -n "$LOG_FILE" ]] || {
        echo "Ошибка: лог $LOG_NAME не найден"
        exit 1
    }

    echo "Найден лог: $LOG_FILE"

    while IFS= read -r line; do
        path=$(echo "$line" | awk -F' \\| ' '{print $2}')

        if [[ -n "$path" && -e "$path" ]]; then
            rm -rf "$path"
            echo "Удалено: $path"
        fi
    done < <(grep -E '^(DIR|FILE) \|' "$LOG_FILE")
}


delete_by_mask() {
    read -rp "Введите маску в формате letters_DDMMYY, например cv_220426: " MASK

    [[ "$MASK" =~ ^[a-zA-Z]+_[0-9]{6}$ ]] || {
        echo "Ошибка: маска должна быть в формате letters_DDMMYY"
        exit 1
    }

    NAME_PREFIX="${MASK%_*}"
    FILE_DATE="${MASK#*_}"
    SEARCH_MASK="${NAME_PREFIX}*_${FILE_DATE}.*"

    echo "Ищем файлы по маске: $SEARCH_MASK"

    mapfile -t FOUND_FILES < <(
        find / \
            \( -path "*/bin/*" -o -path "*/sbin/*" -o -path "*/bin" -o -path "*/sbin" \) -prune \
            -o -type f -name "$SEARCH_MASK" -print 2>/dev/null
    )

    [[ ${#FOUND_FILES[@]} -gt 0 ]] || {
        echo "Ничего не найдено по маске $MASK"
        exit 1
    }

    DIRS_TO_CHECK=()

    for file in "${FOUND_FILES[@]}"; do
        [[ -e "$file" ]] || continue
        parent_dir=$(dirname "$file")
        DIRS_TO_CHECK+=("$parent_dir")
        rm -f "$file"
        echo "Удален файл: $file"
    done

    mapfile -t UNIQUE_DIRS < <(
        printf "%s\n" "${DIRS_TO_CHECK[@]}" | awk '!seen[$0]++' | awk '{ print length, $0 }' | sort -rn | cut -d" " -f2-
    )

    for dir in "${UNIQUE_DIRS[@]}"; do
        while [[ "$dir" != "/" ]]; do
            if [[ -d "$dir" ]] && [[ -z "$(find "$dir" -mindepth 1 -maxdepth 1 2>/dev/null)" ]]; then
                rmdir "$dir" 2>/dev/null && echo "Удалена папка: $dir"
                dir=$(dirname "$dir")
            else
                break
            fi
        done
    done
}

case "$MODE" in
    1) delete_by_log ;;
    2) delete_by_time ;;
    3) delete_by_mask ;;
esac