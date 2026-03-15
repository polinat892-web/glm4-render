# Используем Go 1.24 для сборки
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Устанавливаем git (нужен для клонирования)
RUN apk add --no-cache git

# Клонируем ВАШ ФОРК с исправленным кодом
# ВАЖНО: замените polinat892-web на ваш логин, если нужно
# Клонируем ВАШ ФОРК и переключаемся на main (убедитесь, что используете ваш)
RUN git clone https://github.com/polinat892-web/ZtoApi.git . && \
    git checkout main

# Скачиваем зависимости
RUN go mod download

# Собираем приложение
RUN go build -o ztoapi main.go

# Финальный образ
FROM alpine:latest

WORKDIR /app

# Копируем собранное приложение
COPY --from=builder /app/ztoapi .

# Явно указываем слушать все интерфейсы и порт 10001
ENV HOST=0.0.0.0
ENV PORT=10001

# ✅ ДОБАВЛЯЕМ ПРАВИЛЬНЫЙ UPSTREAM URL
ENV UPSTREAM_URL=https://api.z.ai/api/paas/v4/chat/completions
ENV ZAI_TOKEN=80eae8679213455ab3814b7989b27f1b

# Отключаем анонимный режим принудительно
ENV ANON_TOKEN_ENABLED=false

# Запускаем в анонимном режиме без ключей
CMD ["./ztoapi", "-host", "0.0.0.0", "-port", "10001", "-anonymous"]
