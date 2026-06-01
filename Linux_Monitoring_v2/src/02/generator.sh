#!/bin/bash

START_TS=$(date +%s)
START_HUMAN=$(date '+%Y-%m-%d %H:%M:%S')
DATE_SUFFIX=$(date +%d%m%y)
LOG_FILE="$(pwd)/creation_$(date +%d%m%y_%H%M%S).log"

touch "$LOG_FILE" || {
    echo "Ошибка: не удалось создать лог-файл"
    exit 1
}

echo "Start: $START_HUMAN" >> "$LOG_FILE"
echo >> "$LOG_FILE"

check_free_space() {
    local avail_h
    local avail_kb

    avail_h=$(LC_ALL=C df -h / | awk 'NR==2 {print $4}')
    avail_kb=$(df -k / | awk 'NR==2 {print $4}')

    if [[ -z "$avail_h" || -z "$avail_kb" ]]; then
        echo "Ошибка: не удалось определить свободное место"
        exit 1
    fi

    if (( avail_kb <= 1048576 )); then
        echo "Остановка: на разделе / осталось 1 ГБ или меньше"
        echo "Stopped because free space on / is $avail_h" >> "$LOG_FILE"
        finish_script
    fi
}

generate_base_name() {
    local letters="$1"
    local min_len="$2"
    local name="$letters"
    local last_char="${letters: -1}"

    while [[ ${#name} -lt $min_len ]]; do
        name+="$last_char"
    done

    echo "$name"
}

generate_name_by_index() {
    local letters="$1"
    local min_len="$2"
    local index="$3"
    local name
    local last_char="${letters: -1}"

    name=$(generate_base_name "$letters" "$min_len")

    if (( index > 1 )); then
        for ((i=1; i<index; i++)); do
            name+="$last_char"
        done
    fi

    echo "${name}_${DATE_SUFFIX}"
}

format_duration() {
    local total="$1"
    local h=$((total / 3600))
    local m=$(((total % 3600) / 60))
    local s=$((total % 60))
    printf "%02d:%02d:%02d" "$h" "$m" "$s"
}

finish_script() {
    local end_ts
    local end_human
    local duration

    end_ts=$(date +%s)
    end_human=$(date '+%Y-%m-%d %H:%M:%S')
    duration=$((end_ts - START_TS))

    echo >> "$LOG_FILE"
    echo "Finish: $end_human" >> "$LOG_FILE"
    echo "Duration: $(format_duration "$duration")" >> "$LOG_FILE"

    echo "Время начала: $START_HUMAN"
    echo "Время окончания: $end_human"
    echo "Общее время работы: $(format_duration "$duration")"
    echo "Лог-файл: $LOG_FILE"

    exit 0
}

create_file() {
    local dir_path="$1"
    local file_index="$2"
    local file_name
    local file_path

    check_free_space

    file_name=$(generate_name_by_index "$FILE_NAME_LETTERS" 5 "$file_index")
    file_path="$dir_path/$file_name.$FILE_EXT_LETTERS"

    dd if=/dev/zero of="$file_path" bs=1M count="$FILE_SIZE_MB" status=none || exit 1

    echo "FILE | $file_path | $(date '+%Y-%m-%d %H:%M:%S') | ${FILE_SIZE_MB}MB" >> "$LOG_FILE"
}

create_random_files_in_dir() {
    local dir_path="$1"
    local files_count=$((RANDOM % 20 + 1))

    for ((f=1; f<=files_count; f++)); do
        create_file "$dir_path" "$f"
    done
}

collect_base_paths() {
    find / \
        \( -path "*/bin/*" -o -path "*/sbin/*" -o -path "*/bin" -o -path "*/sbin" \) -prune \
        -o -type d -writable 2>/dev/null
}

main_generate() {
    local depth=$((RANDOM % 100 + 1))
    local dir_counter=1
    local parent_path
    local dir_name
    local new_dir
    local candidates=()

    #попробовать этот вариант
    mapfile -t candidates < <(collect_base_paths)

    (( ${#candidates[@]} > 0 )) || {
        echo "Ошибка: не найдено доступных директорий для создания"
        exit 1
    }

    parent_path="${candidates[$((RANDOM % ${#candidates[@]}))]}"

    for ((d=1; d<=depth; d++)); do
        check_free_space

        dir_name=$(generate_name_by_index "$DIR_LETTERS" 5 "$dir_counter")
        new_dir="$parent_path/$dir_name"

        mkdir "$new_dir" 2>/dev/null || break

        echo "DIR  | $new_dir | $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"

        create_random_files_in_dir "$new_dir"

        parent_path="$new_dir"
        ((dir_counter++))
    done

    finish_script
}

main_generate