FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git build-base

WORKDIR /app

# Скачиваем официальный легковесный тестовый сервер Telegram от gotd
RUN git clone https://github.com/gotd/td.git .
WORKDIR /app/example/server

RUN go build -o /app/tgserver .

FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /root/

COPY --from=builder /app/tgserver .
COPY config.yaml .

EXPOSE 443

CMD ["./tgserver"]
