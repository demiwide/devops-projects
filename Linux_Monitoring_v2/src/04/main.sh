#!/bin/bash

# HTTP коды ответа:
# 200 OK - Успешный запрос
# 201 Created - Ресурс создан
# 400 Bad Request - Некорректный запрос
# 401 Unauthorized - Требуется аутентификация
# 403 Forbidden - Доступ запрещён
# 404 Not Found - Ресурс не найден
# 500 Internal Server Error - Ошибка сервера
# 501 Not Implemented - Не реализовано
# 502 Bad Gateway - Ошибка шлюза
# 503 Service Unavailable - Сервис недоступен

RESPONSE_CODES=(
    200 201 400 401 403
    404 500 501 502 503
)

METHODS=(
    GET POST PUT PATCH DELETE
)

URLS=(
    "/"
    "/admin"
    "/login"
    "/register"
    "/profile"
    "/search"
    "/about"
    "/images/image.png"
)

AGENTS=(
    "Mozilla"
    "Google Chrome"
    "Opera"
    "Safari"
    "Internet Explorer"
    "Microsoft Edge"
    "Crawler and bot"
    "Library and net tool"
)

source "./generator.sh"