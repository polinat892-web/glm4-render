FROM golang:1.24-alpine AS builder

WORKDIR /app

# Клонируем репозиторий
RUN apk add --no-cache git
RUN git clone https://github.com/libaxuan/ZtoApi.git .
RUN go mod download
RUN go build -o ztoapi main.go

FROM alpine:latest

WORKDIR /app

# Копируем бинарный файл
COPY --from=builder /app/ztoapi .

# Явно указываем: НИКАКИХ токенов, только анонимный режим
ENV ANONYMOUS_MODE=true
ENV HOST=0.0.0.0
ENV PORT=10001

# Критически важно: удаляем все возможные следы токена
ENV ZAI_TOKEN=""

# Запускаем с максимально явными параметрами
CMD ["./ztoapi", "-host", "0.0.0.0", "-port", "10001", "-anonymous", "-token", ""]
