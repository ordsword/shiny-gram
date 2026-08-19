FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git build-base

WORKDIR /app

COPY main.go ./

# Создаем модуль и автоматически скачиваем актуальные зависимости
RUN go mod init shiny-gram && \
    go get github.com/gotd/td@v0.100.0 && \
    go build -o tgserver main.go

FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /root/

COPY --from=builder /app/tgserver .

EXPOSE 443

CMD ["./tgserver"]
