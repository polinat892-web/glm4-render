FROM golang:1.24-alpine AS builder

WORKDIR /app

# Клонируем официальный репозиторий ZtoApi
RUN apk add --no-cache git
RUN git clone https://github.com/libaxuan/ZtoApi.git .
RUN go mod download
RUN go build -o ztoapi main.go

FROM alpine:latest

WORKDIR /app

# Копируем скомпилированный бинарный файл
COPY --from=builder /app/ztoapi .

# Явно указываем переменные окружения
ENV HOST=0.0.0.0
ENV PORT=10001
ENV ANONYMOUS_MODE=true
ENV UPSTREAM_URL=https://chat.z.ai/api/chat/completions
ENV MODEL=GLM-4.7

# Важно: запускаем с принудительным указанием хоста и порта
CMD ["./ztoapi", "-host", "0.0.0.0", "-port", "10001", "-anonymous", "-token", ""]
