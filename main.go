package main

import (
	"context"
	"crypto/rand"
	"crypto/rsa"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"

	"github.com/gotd/td/server"
	"github.com/gotd/td/tg"
)

func main() {
	ctx, stop := signal.NotifyContext(context.Background(), os.Interrupt, syscall.SIGTERM)
	defer stop()

	key, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		log.Fatalf("failed to generate key: %v", err)
	}

	dispatcher := tg.NewUpdateDispatcher()

	srv := server.New(key, server.Options{
		Handler: dispatcher,
	})

	listener, err := net.Listen("tcp", "0.0.0.0:443")
	if err != nil {
		log.Fatalf("failed to listen on :443: %v", err)
	}
	defer listener.Close()

	log.Println("Telegram MTProto Server successfully started on :443")

	go func() {
		if err := srv.Serve(ctx, server.NetListener(listener)); err != nil {
			log.Printf("server stopped with error: %v", err)
		}
	}()

	<-ctx.Done()
	log.Println("Shutting down server gracefully...")
}

