FROM nginx:stable

RUN apt-get update && apt-get install -y \
    gcc \
    libfcgi-dev \
    spawn-fcgi \
    nginx \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY server.c /app/server.c
COPY nginx/nginx.conf /etc/nginx/nginx.conf

RUN gcc /app/server.c -o /app/hello -lfcgi


RUN useradd -m -u 1000 -s /bin/bash appuser && \
    chown -R appuser:appuser /app && \
    chown -R appuser:appuser /var/cache/nginx && \
    chown -R appuser:appuser /var/log/nginx && \
    chown -R appuser:appuser /etc/nginx && \
    touch /var/run/nginx.pid && \
    chown -R appuser:appuser /var/run/nginx.pid

# Переключение на непривилегированного dпользователя
USER appuser

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:81/ || exit 1

CMD ["sh", "-c", "spawn-fcgi -p 8080 /app/hello && exec nginx -g 'daemon off;'"]

