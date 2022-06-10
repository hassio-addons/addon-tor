#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Tor
# Ensures necessary directories exists
# ==============================================================================
if ! bashio::fs.directory_exists '/ssl/tor'; then
    mkdir -p /ssl/tor/hidden_service \
        || bashio::exit.nok 'Could not create tor data directory'
    chmod -R 0700 /ssl/tor
fi
