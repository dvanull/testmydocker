FROM ubuntu:20.04

RUN apt update && \
	touch 1 && \
	echo "1" > 1 && \
	apt install golang-go -y < 1 && \
	go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
	~/go/bin/xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive && \
	rm -rf /var/lib/apt/lists/*
	
ADD Caddyfile ./Caddyfile

RUN ./caddy start
