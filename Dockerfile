FROM golang:1.22-alpine AS builder
RUN apk add --no-cache git build-base
WORKDIR /app
RUN git clone https://github.com/gram-server/gramsrv.git .
RUN go build -o gramsrv ./cmd/gramsrv

FROM alpine:latest
RUN apk add --no-cache ca-certificates
WORKDIR /root/
COPY --from=builder /app/gramsrv .
COPY config.yaml .
EXPOSE 443
CMD ["./gramsrv", "-config", "config.yaml"]

