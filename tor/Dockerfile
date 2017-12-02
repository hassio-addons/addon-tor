ARG BUILD_FROM=hassioaddons/base-amd64:1.2.0
FROM ${BUILD_FROM}

# Copy root filesystem
COPY rootfs /

# Setup base
RUN apk add --no-cache tor

# Build arugments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_REF
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="Tor" \
    io.hass.description="Protect your privacy and access Home Assistant via Tor" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Franck Nijhof <frenck@addons.community>" \
    org.label-schema.description="Protect your privacy and access Home Assistant via Tor" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.name="Tor" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://community.home-assistant.io/t/community-hass-io-add-on-tor/33822?u=frenck" \
    org.label-schema.usage="https://github.com/hassio-addons/addon-tor/tree/master/README.md" \
    org.label-schema.vcs-ref=${BUILD_REF} \
    org.label-schema.vcs-url="https://github.com/hassio-addons/addon-tor" \
    org.label-schema.vendor="Community Hass.io Add-ons"
