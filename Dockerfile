FROM golang:1.22-alpine AS builder

# Установка инструментов для сборки
RUN apk add --no-cache git build-base

# Скачиваем исходный код shiny-gram
WORKDIR /app
RUN git clone https://github.com/shinygrams/server.git .

# Собираем программу
RUN go mod download
RUN go build -o shiny-gram ./cmd/server

# Финальный этап (создаем легкий образ)
FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /root/

# Копируем собранный файл и конфиг
COPY --from=builder /app/shiny-gram .
COPY config.yaml .

EXPOSE 443
CMD ["./shiny-gram", "-config", "config.yaml"]
