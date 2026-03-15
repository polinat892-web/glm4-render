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

# ВНИМАНИЕ: НИКАКИХ ENV ZAI_TOKEN! Вообще никаких переменных с токеном
# Только базовая информация
ENV HOST=0.0.0.0
ENV PORT=10001

# Запускаем с флагами, которые гарантируют анонимный режим
# -anonymous = анонимный режим
# -token = пустой токен (но мы НЕ устанавливаем переменную ZAI_TOKEN!)
CMD ["./ztoapi", "-host", "0.0.0.0", "-port", "10001", "-anonymous"]
