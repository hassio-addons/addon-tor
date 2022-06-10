#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: Tor
# Displays the onion hostname for Tor
# ==============================================================================

readonly hostname_file='/ssl/tor/hidden_service/hostname'
if bashio::config.true 'hidden_services'; then
    bashio::log.info 'Starting Tor temporarly...'

    exec 3< <(tor)

    until bashio::fs.file_exists "${hostname_file}"; do
        bashio::log.info "Waiting for service to start..."
        sleep 1
    done

    grep -m 1 "Bootstrapped 100% (done): Done" <&3 >/dev/null 2>&1

    kill "$(pgrep tor)" >/dev/null 2>&1

    bashio::log.info '---------------------------------------------------------'
    bashio::log.info 'Your Home Assistant instance is available on Tor!'
    bashio::log.info "Address: $(<"${hostname_file}")"
    bashio::log.info '---------------------------------------------------------'
fi
