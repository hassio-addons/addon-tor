#!/usr/bin/with-contenv bashio
# ==============================================================================
# Community Hass.io Add-ons: Tor
# Displays the onion hostname for Tor
# ==============================================================================

readonly hostname_file='/ssl/tor/hidden_service/hostname'
if bashio::config.true 'hidden_services'; then
    bashio::log.info 'Starting Tor temporarly...'

    exec 3< <(tor)

    until bashio::fs.file_exists "${hostname_file}"; do
        sleep 1
    done

    grep -m 1 "Bootstrapped 100%: Done" <&3 >/dev/null 2>&1

    kill "$(pgrep tor)" >/dev/null 2>&1

    bashio::log.info '---------------------------------------------------------'
    bashio::log.info 'Your Home Assistant instance is available on Tor!'

    if bashio::config.true 'stealth'; then
        bashio::log.info 'Addresses & Auth cookies:'
        while read -r line; do
            bashio::log.info "${line}"
        done <"${hostname_file}"
    else
        bashio::log.info "Address: $(<"${hostname_file}")"
    fi

    bashio::log.info '---------------------------------------------------------'
fi
