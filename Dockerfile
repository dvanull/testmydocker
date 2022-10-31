FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
ARG cert_location=/usr/local/share/ca-certificates
ENV TZ=Asia/Shanghai
RUN apt update && apt install ca-certificates openssl -y && \
	openssl s_client -showcerts -connect github.com:443 </dev/null 2>/dev/null|openssl x509 -outform PEM > ${cert_location}/github.crt && \
	openssl s_client -showcerts -connect proxy.golang.org:443 </dev/null 2>/dev/null|openssl x509 -outform PEM >  ${cert_location}/proxy.golang.crt && \
	update-ca-certificates

RUN apt install tzdata -y && \
	apt install golang-go -y && \
	go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
	~/go/bin/xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive && \
	rm -rf /var/lib/apt/lists/*
	
ADD Caddyfile ./Caddyfile

RUN ./caddy start
