## Задание 05 - Исследование файловой системы
### Задание
Напиши bash-скрипт. Скрипт запускается с одним параметром.\
Параметр — это абсолютный или относительный путь до какой-либо директории. Параметр должен заканчиваться знаком '/', например:
```script05.sh /var/log/```

Скрипт должен выводить следующую информацию о каталоге, указанном в параметре:

- Общее число папок, включая вложенные;
- Топ-5 папок с самым большим весом в порядке убывания (путь и размер);
- Общее число файлов;
- Число конфигурационных файлов (с расширением .conf), текстовых файлов, исполняемых файлов, логов (файлов с расширением .log), архивов, символических ссылок;
- Топ-10 файлов с самым большим весом в порядке убывания (путь, размер и тип);
- Топ-10 исполняемых файлов с самым большим весом в порядке убывания (путь, размер и хеш);
- Время выполнения скрипта.
Скрипт должен вывести на экран информацию в виде:
```
Total number of folders (including all nested ones) = 6  
TOP 5 folders of maximum size arranged in descending order (path and size):  
1 - /var/log/one/, 100 GB  
2 - /var/log/two/, 100 MB  
etc up to 5
Total number of files = 30
Number of:  
Configuration files (with the .conf extension) = 1 
Text files = 10  
Executable files = 5
Log files (with the extension .log) = 2  
Archive files = 3  
Symbolic links = 4  
TOP 10 files of maximum size arranged in descending order (path, size and type):  
1 - /var/log/one/one.exe, 10 GB, exe  
2 - /var/log/two/two.log, 10 MB, log  
etc up to 10  
TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):  
1 - /var/log/one/one.exe, 10 GB, 3abb17b66815bc7946cefe727737d295  
2 - /var/log/two/two.exe, 9 MB, 53c8fdfcbb60cf8e1a1ee90601cc8fe2  
etc up to 10  
Script execution time (in seconds) = 1.5
```
### Использование
```
chmod +x main.sh /home/lorenvro/
./main.sh
```
Пример вывода:

![Пример](image.png)
