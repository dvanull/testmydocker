FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

RUN apt update && \
	apt install tzdata -y && \
	apt install golang-go -y && \
	go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
	~/go/bin/xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive && \
	rm -rf /var/lib/apt/lists/*
	
ADD Caddyfile ./Caddyfile

RUN ./caddy start
