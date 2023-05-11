ARG BUILD_FROM=ghcr.io/hassio-addons/base:13.2.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Setup base
RUN \
    apk add --no-cache \
        coreutils=9.1-r0 \
        openssl=3.0.8-r4 \
        tor=0.4.7.13-r1

# Install Go for building obfs4proxy.
RUN apk add go git ca-certificates libcap
RUN mkdir -p /go/src /go/bin
RUN chmod -R 644 /go
ENV GOPATH /go
ENV PATH /go/bin:$PATH
WORKDIR /go

# Remove cache to reduce image size.
RUN rm -rf /var/cache/apk/*

# Install obfs4proxy
RUN git clone https://github.com/Yawning/obfs4.git
WORKDIR /go/obfs4/
RUN go build -o obfs4proxy/obfs4proxy ./obfs4proxy
RUN mv obfs4proxy/obfs4proxy /usr/local/bin/obfs4proxy

# Give obfs4proxy the capability to bind port 80. This line isn't necessary if
# you use a high (unprivileged) port.
RUN setcap 'cap_net_bind_service=+ep' /usr/local/bin/obfs4proxy

WORKDIR /

HEALTHCHECK \
    --start-period=5m \
    --interval=60s \
    --timeout=30s \
    CMD curl \
        --silent \
        --location \
        --socks5-hostname localhost:9050 \
        https://check.torproject.org/?lang=en_US \
        | grep -qm1 Congratulations

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="Home Assistant Community Add-ons" \
    org.opencontainers.image.authors="Franck Nijhof <frenck@addons.community>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://addons.community" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
