#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tor
# Displays the onion hostname for Tor
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

readonly hostname_file='/ssl/tor/hidden_service/hostname'

if hass.config.true 'hidden_services'; then

    hass.log.debug 'Starting Tor temporarly...'

    exec 3< <(tor)
    
    until hass.file_exists "${hostname_file}"; do
        sleep 1
    done
    
    grep -m 1 "Bootstrapped 100%: Done" <&3 >/dev/null 2>&1

    kill "$(pgrep tor)" >/dev/null 2>&1

    hass.log.info '-----------------------------------------------------------'
    hass.log.info 'Your Home Assistant instance is available on Tor!'

    if hass.config.true 'stealth'; then
        hass.log.info 'Addresses & Auth cookies:'
        while read -r line; do
            hass.log.info "${line}"
        done <"${hostname_file}"
    else
        hass.log.info "Address: $(<"${hostname_file}")"
    fi

    hass.log.info '-----------------------------------------------------------'
fi