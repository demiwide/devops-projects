# Simple Docker

## Part 1. Готовый докер

Загрузка официального образа nginx командой `docker pull nginx`:
![pull nging](ngingpull.png)

Проверка наличия образа командой `docker images`:
![docker images](dockerls.png)

Запуск docker образа через `docker run -d nginx`:
![docker run -d](image.png)

Проверка запуска контейнера через `docker ps`:
![docker ps](image-1.png)

Просмотр информации о контейнере через `docker inspect [container_id]`:
![docker inspect](image-2.png)

Размер контейнера:
![size](image-3.png)

Список замапленных портов:
![portbindings](image-4.png)

IP контейнера:
![ip adress](image-5.png)

Остановка контейнера через `docker stop [container_id]`:
![docker stop](image-6.png)

Проверка остановки контейнера через `docker ps`:
![docker ps](image-7.png)

Запуск docker с маппингом портов 80 и 443 через `docker run -d -p 80:80 -p 443:443 nginx`:
![docker run](image-8.png)

Проверка доступности страницы nginx по адресу localhost:80:
![nginx 80](image-9.png)

Перезапуск контейнера через `docker restart [container_id]`:
![alt text](image-10.png)

Проверка работы контейнера через `docker ps`:
![alt text](image-11.png)

## Part 2. Операции с контейнером

Чтение конфигурационного файла nginx.conf внутри контейнера через `docker exec [container_id] cat /etc/nginx/nginx.conf`:
![docker exec](image-13.png)

Блок `server` находится по пути /etc/nginx/conf.d/default.conf

```bash
# Копируем на локальную машину default.conf > nginx.conf
docker exec [container_id] cat /etc/nginx/conf.d/default.conf > nginx.conf

# Добавляем отдачу статуса сервера по пути /status 
location /status {
    stub_status on;
}
```

Содержимое локального файла nginx.conf с настройкой отдачи /status:
![/status](image-14.png)

```bash
# Копируем отредактированный конфиг в конфиг контейнера
docker cp nginx.conf [container_id]:/etc/nginx/conf.d/default.conf

# Перезапускаем nginx
docker exec [container_id] nginx -s reload
```
![restart](image-15.png)

Проверка доступности страницы статуса по адресу localhost:80/status:
![localhost/status](image-16.png)

Экспорт контейнера в файл container.tar через `docker export [container_id] > container.tar`:
![docker export](image-17.png)

Остановка контейнера через `docker stop [container_id]`:
![docker stop](image-18.png)

Удаление образа через `docker rmi nginx`:

Удаление контейнера через `docker rm [container_id]`:
![docker rm](image-19.png)

Импорт контейнера через `docker import container.tar nginx:imported`:
![alt text](image-20.png)

Запуск импортированного контейнера через `docker run -d -p 80:80 nginx:imported nginx -g "daemon off;"`:
![run](image-21.png)

Проверка доступности страницы статуса по адресу localhost:80/status:
![localhost/status](image-22.png)
