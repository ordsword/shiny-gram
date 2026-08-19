FROM gotd/td:latest

EXPOSE 443

CMD ["server", "--addr", "0.0.0.0:443"]
