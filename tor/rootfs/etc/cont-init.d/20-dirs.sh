#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Tor
# Ensures necessary directories exists
# ==============================================================================
mkdir -p \
    /ssl/tor/hidden_service/authorized_clients \
    /ssl/tor/hidden_service/clients \
    || bashio::exit.nok 'Could not create tor data directory'

chmod -R 0700 /ssl/tor
