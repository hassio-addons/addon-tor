ARG BUILD_FROM=ghcr.io/hassio-addons/base:15.0.9
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

# Setup base
RUN apk add --no-cache \
        coreutils=9.4-r2 \
        openssl=3.1.5-r0 \
        tor=0.4.8.11-r0 \
        go=1.21.10-r0 \
        git=2.43.4-r0 \
        ca-certificates=20240226-r0 \
        libcap=2.69-r1

# Install obfs4proxy
ARG OBFS_VERSION=obfs4proxy-0.0.14
WORKDIR /go/obfs4
RUN git clone -b ${OBFS_VERSION} --single-branch --depth 1 https://github.com/Yawning/obfs4.git . \
    && go build -o /usr/local/bin/obfs4proxy ./obfs4proxy

# Install snowflake
ARG SNOWFLAKE_VERSION=v2.9.2
WORKDIR /go/snowflake
RUN git clone -b ${SNOWFLAKE_VERSION} --single-branch --depth 1 https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git . \
    && cd client \
    && go get \
    && go build -o /usr/local/bin/snowflake

# Install webtunnel client
ARG WEBTUNNEL_VERSION=c6e11b4fc27bb36d38a3dd903aaa1c5deb66ff0b
WORKDIR /go/webtunnel
RUN git clone --single-branch --depth 1 https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/webtunnel.git . \
    && git reset --hard ${WEBTUNNEL_VERSION} \
    && cd main/client \
    && go build -ldflags="-s -w" -o /usr/local/bin/webtunnel

WORKDIR /

# Give tranposrts clients the capability to bind privileged port.
RUN setcap \
    'cap_net_bind_service=+ep' /usr/local/bin/obfs4proxy \
    'cap_net_bind_service=+ep' /usr/local/bin/snowflake \
    'cap_net_bind_service=+ep' /usr/local/bin/webtunnel

HEALTHCHECK \
    --start-period=60m \
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
