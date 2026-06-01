#!/bin/bash

generate_ip() {
    echo "$((RANDOM % 223 + 1)).$((RANDOM % 256)).$((RANDOM % 256)).$((RANDOM % 256))"
}

random_element() {
    local arr=("$@")
    echo "${arr[RANDOM % ${#arr[@]}]}"
}

for day in {0..4}; do
    current_date=$(date -d "5 days ago + $day days" +%Y-%m-%d)
    current_date_h=$(date -d "5 days ago + $day days" +%d_%m_%Y)
    log_file="nginx_${current_date_h}.log"

    num_records=$((RANDOM % 901 + 100))

    echo "Генерация $num_records записей для $current_date_h..."

    start_time=$(date -d "$current_date 00:00:00" +%s)
    end_time=$(date -d "$current_date 23:59:59" +%s)
    current_time=$start_time

    time_step=$(( (end_time - start_time) / num_records ))

    > "$log_file"

    for ((i=0; i<num_records; i++)); do
        formatted_date=$(date -d "@$current_time" +"%d/%b/%Y:%H:%M:%S %z")

        ip=$(generate_ip)
        method=$(random_element "${METHODS[@]}")
        url=$(random_element "${URLS[@]}")
        code=$(random_element "${RESPONSE_CODES[@]}")
        bytes=$((RANDOM % 10000 + 200))
        agent=$(random_element "${AGENTS[@]}")
        referer="http://example.com$(random_element "${URLS[@]}")"

        echo "$ip - - [$formatted_date] \"$method $url HTTP/1.1\" $code $bytes \"$referer\" \"$agent\"" >> "$log_file"

        next_time=$((current_time + time_step + RANDOM % (time_step / 2 + 1)))

        if [[ $next_time -gt $end_time ]]; then
            current_time=$end_time
        else
            current_time=$next_time
        fi
    done

    echo "Создан файл: $log_file"
done

echo "Генерация завершена! Создано 5 файлов логов."