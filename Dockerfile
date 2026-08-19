FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git build-base

WORKDIR /app

# Скачиваем и собираем готовый тестовый Telegram-сервер напрямую из официального пакета gotd
RUN go install -v github.com/gotd/td/example/server@latest

FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /root/

# Забираем скомпилированный бинарник
COPY --from=builder /go/bin/server /root/tgserver

EXPOSE 443

CMD ["/root/tgserver", "-addr", "0.0.0.0:443"]
