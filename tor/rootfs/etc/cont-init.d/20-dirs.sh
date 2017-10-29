#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tor
# Ensures necessary directories exists
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

if ! hass.directory_exists '/ssl/tor'; then
    mkdir -p /ssl/tor/hidden_service || hass.die 'Could not create tor data directory'
    chmod -R 0700 /ssl/tor
fi
