FROM docker.io/caddy:builder AS builder

RUN apk add --no-cache gcc musl-dev

ENV CGO_ENABLED=1

RUN xcaddy build \
    --output /usr/bin/caddy \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/fvbommel/caddy-combine-ip-ranges \
    --with github.com/plutoploy/caddy-container

FROM docker.io/caddy:alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
