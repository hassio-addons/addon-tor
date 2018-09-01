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

torrc='/etc/tor/torrc'

if hass.config.true 'hidden_services'; then
    echo 'HiddenServiceDir /ssl/tor/hidden_service' >> "$torrc"
    for entry in $(hass.config.get 'hosts|keys[]'); do
        host=$(hass.config.get "hosts[${entry}].host")
        port=$(hass.config.get "hosts[${entry}].port")
        if [[ "${port}" = *':'* ]]; then
            virtual_port="${port%%:*}"
            target_port="${port#*:}"
        else
            virtual_port="${port}"
            target_port="${port}"
        fi
        echo "HiddenServicePort ${target_port} ${host}:${virtual_port}" \
            >> "$torrc"
    done

    if hass.config.true 'stealth'; then
        mapfile -t client_names < <(hass.config.get 'client_names')
        IFS=','
        echo "HiddenServiceAuthorizeClient stealth ${client_names[*]}" \
            >> "$torrc"
    fi

    echo 'HiddenServiceAllowUnknownPorts 0' >> "$torrc"
fi
