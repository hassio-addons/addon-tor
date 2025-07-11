ARG BUILD_FROM=ghcr.io/hassio-addons/base:18.0.2
# hadolint ignore=DL3006
FROM ${BUILD_FROM}

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy root filesystem
COPY rootfs /

ARG OBFS_VERSION=obfs4proxy-0.0.14
ARG SNOWFLAKE_VERSION=v2.10.1
ARG WEBTUNNEL_VERSION=v0.0.2

# Setup base
RUN \
    apk add --no-cache \
        coreutils=9.7-r1 \
        openssl=3.5.1-r0 \
        tor=0.4.8.17-r0 \
    && apk add --no-cache --virtual .build-dependencies \
        go=1.24.4-r0 \
        git=2.49.1-r0 \
    && git clone -b "${OBFS_VERSION}" --single-branch --depth 1 \
        https://github.com/Yawning/obfs4.git /tmp/obfs4 \
    && go build -C /tmp/obfs4 -ldflags '-extldflags "-static" -s -w' -o /usr/local/bin/obfs4proxy ./obfs4proxy \
    && git clone -b "${SNOWFLAKE_VERSION}" --single-branch --depth 1 \
        https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/snowflake.git /tmp/snowflake \
    && go build -C /tmp/snowflake/client -ldflags '-extldflags "-static" -s -w' -o /usr/local/bin/snowflake \
    && git clone -b "${WEBTUNNEL_VERSION}" --single-branch --depth 1 \
        https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/webtunnel.git /tmp/webtunnel \
    && go build -C /tmp/webtunnel/main/client -ldflags='-extldflags "-static" -s -w' -o /usr/local/bin/webtunnel \
    && apk del --no-cache --purge .build-dependencies \
    && rm -rf /tmp/*

HEALTHCHECK \
    --start-period=15m \
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
