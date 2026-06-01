#!/bin/bash

if [ $# -ne 1 ] || [[ ! "$1" =~ /$ ]]; then
    echo "Использование: $0 /path/to/dir/"
    exit 1
fi

DIR="$1"
start_time=$(date +%s.%N)

total_folders=$(find "$DIR" -type d | wc -l)
echo "Total number of folders (including all nested ones) = $total_folders"

echo "TOP 5 folders of maximum size arranged in descending order (path and size):"
du -sh "$DIR"* 2>/dev/null | sort -hr | head -5 | awk '{print NR " - " $2 ", " $1}'

total_files=$(find "$DIR" -type f | wc -l)
echo "Total number of files = $total_files"

echo "Number of:"
conf_files=$(find "$DIR" -type f -name "*.conf" | wc -l)
echo "Configuration files (with the .conf extension) = $conf_files"
text_files=$(find "$DIR" -type f \( -name "*.txt" -o -name "*.text" \) | wc -l)
echo "Text files = $text_files"
exec_files=$(find "$DIR" -type f -executable | wc -l)
echo "Executable files = $exec_files"
log_files=$(find "$DIR" -type f -name "*.log" | wc -l)
echo "Log files (with the extension .log) = $log_files"
archive_files=$(find "$DIR" -type f \( -name "*.zip" -o -name "*.tar*" -o -name "*.gz" -o -name "*.bz2" -o -name "*.7z" -o -name "*.rar" \) | wc -l)
echo "Archive files = $archive_files"
symlinks=$(find "$DIR" -type l | wc -l)
echo "Symbolic links = $symlinks"

# Функция для форматирования размера
format_size_awk='
function format_size(size) {
    if (size >= 1073741824)
        return sprintf("%.1f GB", size/1073741824)
    else if (size >= 1048576)
        return sprintf("%.1f MB", size/1048576)
    else if (size >= 1024)
        return sprintf("%.1f KB", size/1024)
    else
        return sprintf("%d B", size)
}
'
echo "TOP 10 files of maximum size arranged in descending order (path, size and type):"
find "$1" -type f 2>/dev/null -exec du -b {} + 2>/dev/null | sort -rn | head -10 | awk "$format_size_awk"'{
    size=$1
    path=$2
    for(i=3; i<=NF; i++) path=path " " $i
    
    # Определяем тип файла
    if (path ~ /\.conf$/) ftype="conf"
    else if (path ~ /\.log$/) ftype="log"
    else if (path ~ /\.exe$/) ftype="exe"
    else if (path ~ /\.(zip|tar|gz|rar|7z|tgz|bz2|xz)$/) ftype="archive"
    else ftype="data"
    
    printf "%d - %s, %s, %s\n", NR, path, format_size(size), ftype
}'

echo "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):"
find "$1" -type f -executable 2>/dev/null -exec du -b {} + 2>/dev/null | sort -rn | head -10 | while IFS= read -r line; do
    size=$(echo "$line" | awk '{print $1}')
    path=$(echo "$line" | cut -f2-)
    
    # Вычисляем MD5-хеш
    if command -v md5sum &> /dev/null; then
        md5hash=$(md5sum "$path" 2>/dev/null | cut -d' ' -f1)
    elif command -v md5 &> /dev/null; then
        md5hash=$(md5 -q "$path" 2>/dev/null)
    else
        md5hash="N/A"
    fi
    
    echo "$size|$path|$md5hash"
done | awk -F'|' "$format_size_awk"'{
    printf "%d - %s, %s, %s\n", NR, $2, format_size($1), $3
}'

end_time=$(date +%s.%N)
execution_time=$(echo "scale=1; $end_time - $start_time" | bc -l)
echo "Script execution time (in seconds) = $execution_time"