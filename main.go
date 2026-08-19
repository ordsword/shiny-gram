package main

import (
	"context"
	"crypto/rand"
	"crypto/rsa"
	"log"
	"net"
	"os"
	"os/signal"

	"github.com/gotd/td/session"
	"github.com/gotd/td/telegram"
	"github.com/gotd/td/telegram/dcs"
	"github.com/gotd/td/tg"
)

func main() {
	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()

	key, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		log.Fatalf("failed to generate key: %v", err)
	}

	dispatcher := tg.NewUpdateDispatcher()

	server := telegram.NewServer(key, dispatcher, telegram.ServerOptions{
		Storage: session.StorageMemory(),
	})

	listener, err := net.Listen("tcp", "0.0.0.0:443")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	defer listener.Close()

	log.Println("Telegram server listening on :443")

	go func() {
		if err := server.Serve(ctx, dcs.Split(listener)); err != nil {
			log.Printf("server error: %v", err)
		}
	}()

	<-ctx.Done()
	log.Println("Shutting down...")
}

