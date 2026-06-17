# Build stage
FROM docker.io/caddy:alpine AS builder

RUN apk add --no-cache gcc musl-dev build-base go git

ENV CGO_ENABLED=1
ENV PATH="/root/go/bin:${PATH}"

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build \
    --output /usr/bin/caddy \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/fvbommel/caddy-combine-ip-ranges \
    --with github.com/plutoploy/caddy-container

# Final stage
FROM docker.io/caddy:alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
