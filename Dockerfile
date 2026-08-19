FROM golang:1.22-alpine AS builder

RUN apk add --no-cache git build-base

WORKDIR /app

COPY go.mod ./
RUN go mod download || true

COPY main.go ./
RUN go mod tidy
RUN go build -o tgserver main.go

FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /root/

COPY --from=builder /app/tgserver .

EXPOSE 443

CMD ["./tgserver"]
