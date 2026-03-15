# Используем Go 1.24 для сборки
FROM golang:1.24-alpine AS builder

WORKDIR /app

# Устанавливаем git (нужен для клонирования)
RUN apk add --no-cache git

# Клонируем ВАШ ФОРК с исправленным кодом
# ВАЖНО: замените polinat892-web на ваш логин, если нужно
RUN git clone https://github.com/polinat892-web/ZtoApi.git .

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

# Запускаем в анонимном режиме без ключей
CMD ["./ztoapi", "-host", "0.0.0.0", "-port", "10001", "-anonymous"]
