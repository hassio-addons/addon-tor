#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Tor
# Ensures necessary directories exists
# ==============================================================================
if ! bashio::fs.directory_exists '/ssl/tor'; then
    mkdir -p /ssl/tor/hidden_service \
        || bashio::exit.nok 'Could not create tor data directory'
    chmod -R 0700 /ssl/tor
fi
