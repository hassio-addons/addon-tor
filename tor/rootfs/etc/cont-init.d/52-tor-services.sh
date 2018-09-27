#!/usr/bin/with-contenv bash
# ==============================================================================
# Community Hass.io Add-ons: Tor
# Configures the hidden services
# ==============================================================================
# shellcheck disable=SC1091
source /usr/lib/hassio-addons/base.sh

declare virtual_port
declare target_port
declare port
declare host
declare -a client_names

readonly torrc='/etc/tor/torrc'

if hass.config.true 'hidden_services'; then
    echo 'HiddenServiceDir /ssl/tor/hidden_service' >> "$torrc"
    for port in $(hass.config.get 'ports'); do
        count=$(echo "${port}" | sed 's/[^:]//g'| awk '{ print length }')
        if [[ "${count}" == 0 ]]; then
            host='homeassistant'
            virtual_port="${port}"
            target_port="${port}"
        elif [[ "${count}" == 1 ]]; then
            # Check if format is hostname/ip:port or port:port
            first=$(echo "${port}" | cut -f1 -d:)
            if [[ "${first}" =~ ^([0-9]{1,4}|[1-5][0-9]{4}|6[0-4][0-9]{3}|65[0-4][0-9]{2}|655[0-2][0-9]|6553[0-5]) ]]; then
                host='homeassistant'
                virtual_port=$(echo "${port}" | cut -f1 -d:)
                target_port=$(echo "${port}" | cut -f2 -d:)
            else
                host=$(echo "${port}" | cut -f1 -d:)
                virtual_port=$(echo "${port}" | cut -f2 -d:)
                target_port=$(echo "${port}" | cut -f2 -d:)
            fi
        elif [[ "${count}" == 2 ]]; then
            host=$(echo "${port}" | cut -f1 -d:)
            virtual_port=$(echo "${port}" | cut -f2 -d:)
            target_port=$(echo "${port}" | cut -f3 -d:)
        else
            hass.log.warning "$port Are not correct format, skipping..."
        fi
        if [[ "${count}" -le 2 ]]; then
            echo "HiddenServicePort ${target_port} ${host}:${virtual_port}" \
                >> "$torrc"
        fi
    done

    if hass.config.true 'stealth'; then
        mapfile -t client_names < <(hass.config.get 'client_names')
        IFS=','
        echo "HiddenServiceAuthorizeClient stealth ${client_names[*]}" \
            >> "$torrc"
    fi

    echo 'HiddenServiceAllowUnknownPorts 0' >> "$torrc"
fi
