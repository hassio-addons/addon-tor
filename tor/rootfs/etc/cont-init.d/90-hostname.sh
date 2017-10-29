#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tor
# Displays the onion hostname for Tor
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly hostname_file='/ssl/tor/hidden_service/hostname'
declare tor_pid

if hass.config.true 'hidden_services'; then

    if ! hass.file_exists "${hostname_file}"; then

        hass.log.debug 'Tor hostname has not been generated yet.'
        hass.log.debug 'Starting Tor temporarly...'

        tor &
        tor_pid=$!

        until hass.file_exists "${hostname_file}"; do
            sleep 1
        done

        kill "${tor_pid}" >/dev/null 2>&1
    fi

    hass.log.info '-----------------------------------------------------------'
    hass.log.info 'Your Home Assistant instance is available on Tor!'
    hass.log.info "Address: $(<"${hostname_file}")"
    hass.log.info '-----------------------------------------------------------'
fi