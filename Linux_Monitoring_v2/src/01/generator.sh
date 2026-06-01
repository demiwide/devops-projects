#!/bin/bash

generate_base_name() {
    local letters="$1"
    local name="$letters"
    local last_char="${letters: -1}"

    while [[ ${#name} -lt 4 ]]; do
        name+="$last_char"
    done

    echo "$name"
}

generate_name() {
    local letters="$1"
    local index="$2"
    local base_name
    local date_part

    base_name=$(generate_base_name "$letters")
    date_part=$(date +%d%m%y)

    if (( index > 1 )); then
        local extra=$((index - 1))
        local last_char="${letters: -1}"
        for ((i=1; i<=extra; i++)); do
            base_name+="$last_char"
        done
    fi

    echo "${base_name}_${date_part}"
}

check_free_space() {
    local free_kb
    free_kb=$(df -k / | awk 'NR==2 {print $4}')

    if (( free_kb <= 1048576 )); then
        echo "Остановка: на разделе / осталось 1 ГБ или меньше"
        exit 0
    fi
}

CREATED_FOLDERS=0
CREATED_FILES=0

generate() {
    local file_name_part="${FILE_LETTERS%.*}"
    local file_ext="${FILE_LETTERS#*.}"
    local file_size_kb="${FILE_SIZE%kb}"
    local log_file="$BASE_PATH/log_$(date +%d%m%y_%H%M%S).log"
    local current_path="$BASE_PATH"

    touch "$log_file"

    for ((dir_i=1; dir_i<=DIR_NUMBER; dir_i++)); do
        check_free_space

        dir_name=$(generate_name "$DIR_LETTERS" "$dir_i")
        current_path="$current_path/$dir_name"

        mkdir "$current_path"
        echo "$current_path | $(date '+%Y-%m-%d %H:%M:%S')" >> "$log_file"
        ((CREATED_FOLDERS++))

        for ((file_i=1; file_i<=FILES_NUMBER; file_i++)); do
            check_free_space

            file_name=$(generate_name "$file_name_part" "$file_i")
            full_file_path="$current_path/$file_name.$file_ext"

            dd if=/dev/zero of="$full_file_path" bs=1K count="$file_size_kb" status=none
            ((CREATED_FILES++))
            echo "$full_file_path | $(date '+%Y-%m-%d %H:%M:%S') | ${file_size_kb}KB" >> "$log_file"
        done
    done

    echo "Готово"
    echo "Лог-файл: $log_file"
    echo "Создано папок: $CREATED_FOLDERS"
    echo "Создано файлов: $CREATED_FILES"
}