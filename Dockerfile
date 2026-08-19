FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git build-base

WORKDIR /src
RUN git clone --depth 1 https://github.com/gotd/td.git .

# Собираем официальный бинарник Telegram-сервера из cmd/gotd-server
RUN go build -o /app/tgserver ./cmd/gotd-server

FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /root/

COPY --from=builder /app/tgserver .

EXPOSE 443

CMD ["./tgserver", "-addr", "0.0.0.0:443"]
