
FROM docker.io/caddy:builder AS builder

RUN apt-get update && apt-get install -y --no-install-recommends gcc musl-dev build-base go git

ENV CGO_ENABLED=1
ENV PATH="/root/go/bin:${PATH}"

RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest

RUN xcaddy build \
    --output /usr/bin/caddy \
    --with github.com/caddy-dns/cloudflare \
    --with github.com/WeidiDeng/caddy-cloudflare-ip \
    --with github.com/fvbommel/caddy-combine-ip-ranges \
    --with github.com/plutoploy/caddy-container


FROM docker.io/caddy:latest

# Copy the custom-built Caddy binary
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
